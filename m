From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-add-call_usermodehelper_cleanup.patch removed from -mm tree
Date: Wed, 10 Mar 2010 12:29:51 -0800
Message-ID: <201003102029.o2AKTpNT001923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755630Ab0CJUaR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 15:30:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, ebiederm@xmission.com, paulmck@us.ibm.com, rmk+lkml@arm.linux.org.uk, rusty@rustcorp.com.au, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     sysctl: add call_usermodehelper_cleanup()
has been removed from the -mm tree.  Its filename was
     sysctl-add-call_usermodehelper_cleanup.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: add call_usermodehelper_cleanup()
From: Andi Kleen <andi@firstfloor.org>

This is the same as call_usermodehelper(), but with an cleanup callback. 
Needed for some of the followon proc_rcu_string() users.

This avoids open coding this.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmod.h |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN include/linux/kmod.h~sysctl-add-call_usermodehelper_cleanup include/linux/kmod.h
--- a/include/linux/kmod.h~sysctl-add-call_usermodehelper_cleanup
+++ a/include/linux/kmod.h
@@ -72,7 +72,8 @@ int call_usermodehelper_exec(struct subp
 void call_usermodehelper_freeinfo(struct subprocess_info *info);
 
 static inline int
-call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
+call_usermodehelper_cleanup(char *path, char **argv, char **envp, enum umh_wait wait,
+			    void (*cleanup)(char **, char **))
 {
 	struct subprocess_info *info;
 	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
@@ -80,10 +81,18 @@ call_usermodehelper(char *path, char **a
 	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
 	if (info == NULL)
 		return -ENOMEM;
+	if (cleanup)
+		call_usermodehelper_setcleanup(info, cleanup);
 	return call_usermodehelper_exec(info, wait);
 }
 
 static inline int
+call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
+{
+	return call_usermodehelper_cleanup(path, argv, envp, wait, NULL);
+}
+
+static inline int
 call_usermodehelper_keys(char *path, char **argv, char **envp,
 			 struct key *session_keyring, enum umh_wait wait)
 {
_

Patches currently in -mm which might be from andi@firstfloor.org are

mm-introduce-dump_page-and-print-symbolic-flag-names.patch
linux-next.patch
hardware-latency-detector-remove-default-m.patch
modpost-support-objects-with-more-than-64k-sections.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch
sysctl-add-call_usermodehelper_cleanup.patch
sysctl-convert-modprobe_path-to-proc_rcu_string.patch
sysctl-convert-poweroff_command-to-proc_rcu_string.patch
sysctl-convert-hotplug-helper-string-to-proc_rcu_string.patch
sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch
sysctl-fix-up-remaining-references-to-uevent_helper.patch
sysctl-fix-up-remaining-references-to-uevent_helper-fix.patch

