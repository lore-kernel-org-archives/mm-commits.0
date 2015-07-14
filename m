From: akpm@linux-foundation.org
Subject: + capabilities-ambient-capabilities.patch added to -mm tree
Date: Tue, 14 Jul 2015 13:33:25 -0700
Message-ID: <55a57215.9wEy3bap8R1vX7AX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbbGNUd1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 16:33:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, aaronmdjones@gmail.com, ahferroin7@gmail.com, cl@linux.com, corbet@lwn.net, james.l.morris@oracle.com, jarkko.sakkinen@linux.intel.com, keescook@chromium.org, morgan@kernel.org, msa@moth.iki.fi, mtk.manpages@gmail.com, serge.hallyn@ubuntu.com, tytso@mit.edu, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: capabilities: ambient capabilities
has been added to the -mm tree.  Its filename is
     capabilities-ambient-capabilities.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/capabilities-ambient-capabilities.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/capabilities-ambient-capabilities.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: capabilities: ambient capabilities

Credit where credit is due: this idea comes from Christoph Lameter
with a lot of valuable input from Serge Hallyn.  This patch is
heavily based on Christoph's patch.

===== The status quo =====

On Linux, there are a number of capabilities defined by the kernel.
To perform various privileged tasks, processes can wield
capabilities that they hold.

Each task has four capability masks: effective (pE), permitted (pP),
inheritable (pI), and a bounding set (X).  When the kernel checks
for a capability, it checks pE.  The other capability masks serve to
modify what capabilities can be in pE.

Any task can remove capabilities from pE, pP, or pI at any time.  If
a task has a capability in pP, it can add that capability to pE
and/or pI.  If a task has CAP_SETPCAP, then it can add any
capability to pI, and it can remove capabilities from X.

Tasks are not the only things that can have capabilities; files can
also have capabilities.  A file can have no capabilty information at
all [1].  If a file has capability information, then it has a
permitted mask (fP) and an inheritable mask (fI) as well as a single
effective bit (fE) [2].  File capabilities modify the capabilities
of tasks that execve(2) them.

A task that successfully calls execve has its capabilities modified
for the file ultimately being excecuted (i.e. the binary itself if
that binary is ELF or for the interpreter if the binary is a
script.) [3] In the capability evolution rules, for each mask Z, pZ
represents the old value and pZ' represents the new value.  The
rules are:

  pP' = (X & fP) | (pI & fI)
  pI' = pI
  pE' = (fE ? pP' : 0)
  X is unchanged

For setuid binaries, fP, fI, and fE are modified by a moderately
complicated set of rules that emulate POSIX behavior.  Similarly, if
euid == 0 or ruid == 0, then fP, fI, and fE are modified differently
(primary, fP and fI usually end up being the full set).  For nonroot
users executing binaries with neither setuid nor file caps, fI and
fP are empty and fE is false.

As an extra complication, if you execute a process as nonroot and fE
is set, then the "secure exec" rules are in effect: AT_SECURE gets
set, LD_PRELOAD doesn't work, etc.

This is rather messy.  We've learned that making any changes is
dangerous, though: if a new kernel version allows an unprivileged
program to change its security state in a way that persists cross
execution of a setuid program or a program with file caps, this
persistent state is surprisingly likely to allow setuid or
file-capped programs to be exploited for privilege escalation.

===== The problem =====

Capability inheritance is basically useless.

If you aren't root and you execute an ordinary binary, fI is zero,
so your capabilities have no effect whatsoever on pP'.  This means
that you can't usefully execute a helper process or a shell command
with elevated capabilities if you aren't root.

On current kernels, you can sort of work around this by setting fI
to the full set for most or all non-setuid executable files.  This
causes pP' = pI for nonroot, and inheritance works.  No one does
this because it's a PITA and it isn't even supported on most
filesystems.

If you try this, you'll discover that every nonroot program ends up
with secure exec rules, breaking many things.

This is a problem that has bitten many people who have tried to use
capabilities for anything useful.

===== The proposed change =====

This patch adds a fifth capability mask called the ambient mask
(pA).  pA does what most people expect pI to do.

pA obeys the invariant that no bit can ever be set in pA if it is
not set in both pP and pI.  Dropping a bit from pP or pI drops that
bit from pA.  This ensures that existing programs that try to drop
capabilities still do so, with a complication.  Because capability
inheritance is so broken, setting KEEPCAPS, using setresuid to
switch to nonroot uids, and then calling execve effectively drops
capabilities.  Therefore, setresuid from root to nonroot
conditionally clears pA unless SECBIT_NO_SETUID_FIXUP is set.
Processes that don't like this can re-add bits to pA afterwards.

The capability evolution rules are changed:

  pA' = (file caps or setuid or setgid ? 0 : pA)
  pP' = (X & fP) | (pI & fI) | pA'
  pI' = pI
  pE' = (fE ? pP' : pA')
  X is unchanged

If you are nonroot but you have a capability, you can add it to pA.
If you do so, your children get that capability in pA, pP, and pE.
For example, you can set pA = CAP_NET_BIND_SERVICE, and your
children can automatically bind low-numbered ports.  Hallelujah!

Unprivileged users can create user namespaces, map themselves to a
nonzero uid, and create both privileged (relative to their
namespace) and unprivileged process trees.  This is currently more
or less impossible.  Hallelujah!

You cannot use pA to try to subvert a setuid, setgid, or file-capped
program: if you execute any such program, pA gets cleared and the
resulting evolution rules are unchanged by this patch.

Users with nonzero pA are unlikely to unintentionally leak that
capability.  If they run programs that try to drop privileges,
dropping privileges will still work.

It's worth noting that the degree of paranoia in this patch could
possibly be reduced without causing serious problems.  Specifically,
if we allowed pA to persist across executing non-pA-aware setuid
binaries and across setresuid, then, naively, the only capabilities
that could leak as a result would be the capabilities in pA, and any
attacker *already* has those capabilities.  This would make me
nervous, though -- setuid binaries that tried to privilege-separate
might fail to do so, and putting CAP_DAC_READ_SEARCH or
CAP_DAC_OVERRIDE into pA could have unexpected side effects.
(Whether these unexpected side effects would be exploitable is an
open question.)  I've therefore taken the more paranoid route.  We
can revisit this later.

An alternative would be to require PR_SET_NO_NEW_PRIVS before
setting ambient capabilities.  I think that this would be annoying
and would make granting otherwise unprivileged users minor ambient
capabilities (CAP_NET_BIND_SERVICE or CAP_NET_RAW for example) much
less useful than it is with this patch.

===== Footnotes =====

[1] Files that are missing the "security.capability" xattr or that
have unrecognized values for that xattr end up with has_cap set to
false.  The code that does that appears to be complicated for no
good reason.

[2] The libcap capability mask parsers and formatters are
dangerously misleading and the documentation is flat-out wrong.  fE
is *not* a mask; it's a single bit.  This has probably confused
every single person who has tried to use file capabilities.

[3] Linux very confusingly processes both the script and the
interpreter if applicable, for reasons that elude me.  The results
from thinking about a script's file capabilities and/or setuid bits
are mostly discarded.

Preliminary userspace code is here, but it needs updating:
https://git.kernel.org/cgit/linux/kernel/git/luto/util-linux-playground.git/commit/?h=cap_ambient&id=7f5afbd175d2

Signed-off-by: Christoph Lameter <cl@linux.com> # Original author
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Aaron Jones <aaronmdjones@gmail.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Andrew G. Morgan <morgan@kernel.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Markku Savela <msa@moth.iki.fi>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: James Morris <james.l.morris@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c              |    5 +
 include/linux/cred.h         |    8 ++
 include/uapi/linux/prctl.h   |    7 ++
 kernel/user_namespace.c      |    1 
 security/commoncap.c         |  102 +++++++++++++++++++++++++++++----
 security/keys/process_keys.c |    1 
 6 files changed, 113 insertions(+), 11 deletions(-)

diff -puN fs/proc/array.c~capabilities-ambient-capabilities fs/proc/array.c
--- a/fs/proc/array.c~capabilities-ambient-capabilities
+++ a/fs/proc/array.c
@@ -308,7 +308,8 @@ static void render_cap_t(struct seq_file
 static inline void task_cap(struct seq_file *m, struct task_struct *p)
 {
 	const struct cred *cred;
-	kernel_cap_t cap_inheritable, cap_permitted, cap_effective, cap_bset;
+	kernel_cap_t cap_inheritable, cap_permitted, cap_effective,
+			cap_bset, cap_ambient;
 
 	rcu_read_lock();
 	cred = __task_cred(p);
@@ -316,12 +317,14 @@ static inline void task_cap(struct seq_f
 	cap_permitted	= cred->cap_permitted;
 	cap_effective	= cred->cap_effective;
 	cap_bset	= cred->cap_bset;
+	cap_ambient	= cred->cap_ambient;
 	rcu_read_unlock();
 
 	render_cap_t(m, "CapInh:\t", &cap_inheritable);
 	render_cap_t(m, "CapPrm:\t", &cap_permitted);
 	render_cap_t(m, "CapEff:\t", &cap_effective);
 	render_cap_t(m, "CapBnd:\t", &cap_bset);
+	render_cap_t(m, "CapAmb:\t", &cap_ambient);
 }
 
 static inline void task_seccomp(struct seq_file *m, struct task_struct *p)
diff -puN include/linux/cred.h~capabilities-ambient-capabilities include/linux/cred.h
--- a/include/linux/cred.h~capabilities-ambient-capabilities
+++ a/include/linux/cred.h
@@ -137,6 +137,7 @@ struct cred {
 	kernel_cap_t	cap_permitted;	/* caps we're permitted */
 	kernel_cap_t	cap_effective;	/* caps we can actually use */
 	kernel_cap_t	cap_bset;	/* capability bounding set */
+	kernel_cap_t	cap_ambient;	/* Ambient capability set */
 #ifdef CONFIG_KEYS
 	unsigned char	jit_keyring;	/* default keyring to attach requested
 					 * keys to */
@@ -212,6 +213,13 @@ static inline void validate_process_cred
 }
 #endif
 
+static inline bool cap_ambient_invariant_ok(const struct cred *cred)
+{
+	return cap_issubset(cred->cap_ambient,
+			    cap_intersect(cred->cap_permitted,
+					  cred->cap_inheritable));
+}
+
 /**
  * get_new_cred - Get a reference on a new set of credentials
  * @cred: The new credentials to reference
diff -puN include/uapi/linux/prctl.h~capabilities-ambient-capabilities include/uapi/linux/prctl.h
--- a/include/uapi/linux/prctl.h~capabilities-ambient-capabilities
+++ a/include/uapi/linux/prctl.h
@@ -190,4 +190,11 @@ struct prctl_mm_map {
 # define PR_FP_MODE_FR		(1 << 0)	/* 64b FP registers */
 # define PR_FP_MODE_FRE		(1 << 1)	/* 32b compatibility */
 
+/* Control the ambient capability set */
+#define PR_CAP_AMBIENT			47
+# define PR_CAP_AMBIENT_IS_SET		1
+# define PR_CAP_AMBIENT_RAISE		2
+# define PR_CAP_AMBIENT_LOWER		3
+# define PR_CAP_AMBIENT_CLEAR_ALL	4
+
 #endif /* _LINUX_PRCTL_H */
diff -puN kernel/user_namespace.c~capabilities-ambient-capabilities kernel/user_namespace.c
--- a/kernel/user_namespace.c~capabilities-ambient-capabilities
+++ a/kernel/user_namespace.c
@@ -39,6 +39,7 @@ static void set_cred_user_ns(struct cred
 	cred->cap_inheritable = CAP_EMPTY_SET;
 	cred->cap_permitted = CAP_FULL_SET;
 	cred->cap_effective = CAP_FULL_SET;
+	cred->cap_ambient = CAP_EMPTY_SET;
 	cred->cap_bset = CAP_FULL_SET;
 #ifdef CONFIG_KEYS
 	key_put(cred->request_key_auth);
diff -puN security/commoncap.c~capabilities-ambient-capabilities security/commoncap.c
--- a/security/commoncap.c~capabilities-ambient-capabilities
+++ a/security/commoncap.c
@@ -267,6 +267,16 @@ int cap_capset(struct cred *new,
 	new->cap_effective   = *effective;
 	new->cap_inheritable = *inheritable;
 	new->cap_permitted   = *permitted;
+
+	/*
+	 * Mask off ambient bits that are no longer both permitted and
+	 * inheritable.
+	 */
+	new->cap_ambient = cap_intersect(new->cap_ambient,
+					 cap_intersect(*permitted,
+						       *inheritable));
+	if (WARN_ON(!cap_ambient_invariant_ok(new)))
+		return -EINVAL;
 	return 0;
 }
 
@@ -347,6 +357,7 @@ static inline int bprm_caps_from_vfs_cap
 
 		/*
 		 * pP' = (X & fP) | (pI & fI)
+		 * The addition of pA' is handled later.
 		 */
 		new->cap_permitted.cap[i] =
 			(new->cap_bset.cap[i] & permitted) |
@@ -474,10 +485,13 @@ int cap_bprm_set_creds(struct linux_binp
 {
 	const struct cred *old = current_cred();
 	struct cred *new = bprm->cred;
-	bool effective, has_cap = false;
+	bool effective, has_cap = false, is_setid;
 	int ret;
 	kuid_t root_uid;
 
+	if (WARN_ON(!cap_ambient_invariant_ok(old)))
+		return -EPERM;
+
 	effective = false;
 	ret = get_file_caps(bprm, &effective, &has_cap);
 	if (ret < 0)
@@ -522,8 +536,9 @@ skip:
 	 *
 	 * In addition, if NO_NEW_PRIVS, then ensure we get no new privs.
 	 */
-	if ((!uid_eq(new->euid, old->uid) ||
-	     !gid_eq(new->egid, old->gid) ||
+	is_setid = !uid_eq(new->euid, old->uid) || !gid_eq(new->egid, old->gid);
+
+	if ((is_setid ||
 	     !cap_issubset(new->cap_permitted, old->cap_permitted)) &&
 	    bprm->unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
 		/* downgrade; they get no more than they had, and maybe less */
@@ -539,10 +554,28 @@ skip:
 	new->suid = new->fsuid = new->euid;
 	new->sgid = new->fsgid = new->egid;
 
+	/* File caps or setid cancels ambient. */
+	if (has_cap || is_setid)
+		cap_clear(new->cap_ambient);
+
+	/*
+	 * Now that we've computed pA', update pP' to give:
+	 *   pP' = (X & fP) | (pI & fI) | pA'
+	 */
+	new->cap_permitted = cap_combine(new->cap_permitted, new->cap_ambient);
+
+	/*
+	 * Set pE' = (fE ? pP' : pA').  Because pA' is zero if fE is set,
+	 * this is the same as pE' = (fE ? pP' : 0) | pA'.
+	 */
 	if (effective)
 		new->cap_effective = new->cap_permitted;
 	else
-		cap_clear(new->cap_effective);
+		new->cap_effective = new->cap_ambient;
+
+	if (WARN_ON(!cap_ambient_invariant_ok(new)))
+		return -EPERM;
+
 	bprm->cap_effective = effective;
 
 	/*
@@ -557,7 +590,7 @@ skip:
 	 * Number 1 above might fail if you don't have a full bset, but I think
 	 * that is interesting information to audit.
 	 */
-	if (!cap_isclear(new->cap_effective)) {
+	if (!cap_issubset(new->cap_effective, new->cap_ambient)) {
 		if (!cap_issubset(CAP_FULL_SET, new->cap_effective) ||
 		    !uid_eq(new->euid, root_uid) || !uid_eq(new->uid, root_uid) ||
 		    issecure(SECURE_NOROOT)) {
@@ -568,6 +601,10 @@ skip:
 	}
 
 	new->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
+
+	if (WARN_ON(!cap_ambient_invariant_ok(new)))
+		return -EPERM;
+
 	return 0;
 }
 
@@ -589,7 +626,7 @@ int cap_bprm_secureexec(struct linux_bin
 	if (!uid_eq(cred->uid, root_uid)) {
 		if (bprm->cap_effective)
 			return 1;
-		if (!cap_isclear(cred->cap_permitted))
+		if (!cap_issubset(cred->cap_permitted, cred->cap_ambient))
 			return 1;
 	}
 
@@ -691,10 +728,18 @@ static inline void cap_emulate_setxuid(s
 	     uid_eq(old->suid, root_uid)) &&
 	    (!uid_eq(new->uid, root_uid) &&
 	     !uid_eq(new->euid, root_uid) &&
-	     !uid_eq(new->suid, root_uid)) &&
-	    !issecure(SECURE_KEEP_CAPS)) {
-		cap_clear(new->cap_permitted);
-		cap_clear(new->cap_effective);
+	     !uid_eq(new->suid, root_uid))) {
+		if (!issecure(SECURE_KEEP_CAPS)) {
+			cap_clear(new->cap_permitted);
+			cap_clear(new->cap_effective);
+		}
+
+		/*
+		 * Pre-ambient programs expect setresuid to nonroot followed
+		 * by exec to drop capabilities.  We should make sure that
+		 * this remains the case.
+		 */
+		cap_clear(new->cap_ambient);
 	}
 	if (uid_eq(old->euid, root_uid) && !uid_eq(new->euid, root_uid))
 		cap_clear(new->cap_effective);
@@ -924,6 +969,43 @@ int cap_task_prctl(int option, unsigned
 			new->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
 		return commit_creds(new);
 
+	case PR_CAP_AMBIENT:
+		if (arg2 == PR_CAP_AMBIENT_CLEAR_ALL) {
+			if (arg3 | arg4 | arg5)
+				return -EINVAL;
+
+			new = prepare_creds();
+			if (!new)
+				return -ENOMEM;
+			cap_clear(new->cap_ambient);
+			return commit_creds(new);
+		}
+
+		if (((!cap_valid(arg3)) | arg4 | arg5))
+			return -EINVAL;
+
+		if (arg2 == PR_CAP_AMBIENT_IS_SET) {
+			return !!cap_raised(current_cred()->cap_ambient, arg3);
+		} else if (arg2 != PR_CAP_AMBIENT_RAISE &&
+			   arg2 != PR_CAP_AMBIENT_LOWER) {
+			return -EINVAL;
+		} else {
+			if (arg2 == PR_CAP_AMBIENT_RAISE &&
+			    (!cap_raised(current_cred()->cap_permitted, arg3) ||
+			     !cap_raised(current_cred()->cap_inheritable,
+					 arg3)))
+				return -EPERM;
+
+			new = prepare_creds();
+			if (!new)
+				return -ENOMEM;
+			if (arg2 == PR_CAP_AMBIENT_RAISE)
+				cap_raise(new->cap_ambient, arg3);
+			else
+				cap_lower(new->cap_ambient, arg3);
+			return commit_creds(new);
+		}
+
 	default:
 		/* No functionality available - continue with default */
 		return -ENOSYS;
diff -puN security/keys/process_keys.c~capabilities-ambient-capabilities security/keys/process_keys.c
--- a/security/keys/process_keys.c~capabilities-ambient-capabilities
+++ a/security/keys/process_keys.c
@@ -848,6 +848,7 @@ void key_change_session_keyring(struct c
 	new->cap_inheritable	= old->cap_inheritable;
 	new->cap_permitted	= old->cap_permitted;
 	new->cap_effective	= old->cap_effective;
+	new->cap_ambient	= old->cap_ambient;
 	new->cap_bset		= old->cap_bset;
 
 	new->jit_keyring	= old->jit_keyring;
_

Patches currently in -mm which might be from luto@kernel.org are

capabilities-ambient-capabilities.patch
capabilities-add-a-securebit-to-disable-pr_cap_ambient_raise.patch
mm-introduce-vma_is_anonymousvma-helper.patch
mmap-fix-the-usage-of-vm_pgoff-in-special_mapping-paths.patch
mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch
linux-next.patch

