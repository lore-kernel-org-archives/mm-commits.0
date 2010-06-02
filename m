From: akpm@linux-foundation.org
Subject: + sys_personality-change-sys_personality-to-accept-unsigned-int-instead-of-u_long.patch added to -mm tree
Date: Tue, 01 Jun 2010 23:03:07 -0700
Message-ID: <201006020603.o526347E008188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112Ab0FBGDS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 02:03:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, hpa@zytor.com, torvalds@linux-foundation.org, wezhang@redhat.com


The patch titled
     sys_personality: change sys_personality() to accept "unsigned int" instead of u_long
has been added to the -mm tree.  Its filename is
     sys_personality-change-sys_personality-to-accept-unsigned-int-instead-of-u_long.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_personality: change sys_personality() to accept "unsigned int" instead of u_long
From: Oleg Nesterov <oleg@redhat.com>

task_struct->pesonality is "unsigned int", but sys_personality() paths use
"unsigned long pesonality".  This means that every assignment or
comparison is not right.  In particular, if this argument does not fit
into "unsigned int" __set_personality() changes the caller's personality
and then sys_personality() returns -EINVAL.

Turn this argument into "unsigned int" and avoid overflows.  Obviously,
this is the user-visible change, we just ignore the upper bits.  But this
can't break the sane application.

There is another thing which can confuse the poorly written applications. 
User-space thinks that this syscall returns int, not long.  This means
that the returned value can be negative and look like the error code.  But
note that libc won't be confused and thus errno won't be set, and with
this patch the user-space can never get -1 unless sys_personality() really
fails.  And, most importantly, the negative RET != -1 is only possible if
that app previously called personality(RET).

Pointed-out-by: Wenming Zhang <wezhang@redhat.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/personality.h |    2 +-
 include/linux/syscalls.h    |    2 +-
 kernel/exec_domain.c        |   18 +++++++++---------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff -puN include/linux/personality.h~sys_personality-change-sys_personality-to-accept-unsigned-int-instead-of-u_long include/linux/personality.h
--- a/include/linux/personality.h~sys_personality-change-sys_personality-to-accept-unsigned-int-instead-of-u_long
+++ a/include/linux/personality.h
@@ -12,7 +12,7 @@ struct pt_regs;
 
 extern int		register_exec_domain(struct exec_domain *);
 extern int		unregister_exec_domain(struct exec_domain *);
-extern int		__set_personality(unsigned long);
+extern int		__set_personality(unsigned int);
 
 #endif /* __KERNEL__ */
 
diff -puN include/linux/syscalls.h~sys_personality-change-sys_personality-to-accept-unsigned-int-instead-of-u_long include/linux/syscalls.h
--- a/include/linux/syscalls.h~sys_personality-change-sys_personality-to-accept-unsigned-int-instead-of-u_long
+++ a/include/linux/syscalls.h
@@ -289,7 +289,7 @@ asmlinkage long sys_capget(cap_user_head
 				cap_user_data_t dataptr);
 asmlinkage long sys_capset(cap_user_header_t header,
 				const cap_user_data_t data);
-asmlinkage long sys_personality(u_long personality);
+asmlinkage long sys_personality(unsigned int personality);
 
 asmlinkage long sys_sigpending(old_sigset_t __user *set);
 asmlinkage long sys_sigprocmask(int how, old_sigset_t __user *set,
diff -puN kernel/exec_domain.c~sys_personality-change-sys_personality-to-accept-unsigned-int-instead-of-u_long kernel/exec_domain.c
--- a/kernel/exec_domain.c~sys_personality-change-sys_personality-to-accept-unsigned-int-instead-of-u_long
+++ a/kernel/exec_domain.c
@@ -27,7 +27,7 @@ static struct exec_domain *exec_domains 
 static DEFINE_RWLOCK(exec_domains_lock);
 
 
-static u_long ident_map[32] = {
+static unsigned long ident_map[32] = {
 	0,	1,	2,	3,	4,	5,	6,	7,
 	8,	9,	10,	11,	12,	13,	14,	15,
 	16,	17,	18,	19,	20,	21,	22,	23,
@@ -56,10 +56,10 @@ default_handler(int segment, struct pt_r
 }
 
 static struct exec_domain *
-lookup_exec_domain(u_long personality)
+lookup_exec_domain(unsigned int personality)
 {
-	struct exec_domain *	ep;
-	u_long			pers = personality(personality);
+	unsigned int pers = personality(personality);
+	struct exec_domain *ep;
 
 	read_lock(&exec_domains_lock);
 	for (ep = exec_domains; ep; ep = ep->next) {
@@ -70,7 +70,7 @@ lookup_exec_domain(u_long personality)
 
 #ifdef CONFIG_MODULES
 	read_unlock(&exec_domains_lock);
-	request_module("personality-%ld", pers);
+	request_module("personality-%d", pers);
 	read_lock(&exec_domains_lock);
 
 	for (ep = exec_domains; ep; ep = ep->next) {
@@ -135,7 +135,7 @@ unregister:
 }
 
 int
-__set_personality(u_long personality)
+__set_personality(unsigned int personality)
 {
 	struct exec_domain	*ep, *oep;
 
@@ -188,9 +188,9 @@ static int __init proc_execdomains_init(
 module_init(proc_execdomains_init);
 #endif
 
-SYSCALL_DEFINE1(personality, u_long, personality)
+SYSCALL_DEFINE1(personality, unsigned int, personality)
 {
-	u_long old = current->personality;
+	unsigned int old = current->personality;
 
 	if (personality != 0xffffffff) {
 		set_personality(personality);
@@ -198,7 +198,7 @@ SYSCALL_DEFINE1(personality, u_long, per
 			return -EINVAL;
 	}
 
-	return (long)old;
+	return old;
 }
 
 
_

Patches currently in -mm which might be from oleg@redhat.com are

sys_personality-change-sys_personality-to-accept-unsigned-int-instead-of-u_long.patch
remove-the-bogus-checks-in-sys_personality-__set_personality-path.patch

