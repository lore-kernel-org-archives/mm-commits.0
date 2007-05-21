From: akpm@linux-foundation.org
Subject: - tidy-up-usermode-helper-waiting-a-bit.patch removed from -mm tree
Date: Mon, 21 May 2007 16:17:57 -0700
Message-ID: <200705212317.l4LNHuVA022516@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44605 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756930AbXEUXdI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 19:33:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, James.Bottomley@HansenPartnership.com, ak@suse.de, bjorn.helgaas@hp.com, hch@infradead.org, jeremy@xensource.com, joel.becker@oracle.com, johannes@sipsolutions.net, kay.sievers@vrfy.org, oleg@tv-sign.ru, paulus@samba.org, ralf@linux-mips.org, randy.dunlap@oracle.com, tony.luck@intel.com, vatsa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     tidy up usermode helper waiting a bit
has been removed from the -mm tree.  Its filename was
     tidy-up-usermode-helper-waiting-a-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tidy up usermode helper waiting a bit
From: Jeremy Fitzhardinge <jeremy@goop.org>

Rather than using a tri-state integer for the wait flag in
call_usermodehelper_exec, define a proper enum, and use that.  I've preserved
the integer values so that any callers I've missed should still work OK.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mach-voyager/voyager_thread.c |    2 -
 arch/x86_64/kernel/mce.c                |    3 +-
 drivers/macintosh/therm_pm72.c          |    3 +-
 drivers/macintosh/windfarm_core.c       |    3 +-
 drivers/net/hamradio/baycom_epp.c       |    2 -
 drivers/pnp/pnpbios/core.c              |    2 -
 fs/ocfs2/heartbeat.c                    |    2 -
 include/linux/kmod.h                    |   12 ++++++---
 kernel/cpuset.c                         |    2 -
 kernel/kmod.c                           |   29 ++++++++++++----------
 kernel/sys.c                            |    2 -
 lib/kobject_uevent.c                    |    2 -
 net/bridge/br_stp_if.c                  |    2 -
 security/keys/request_key.c             |    3 +-
 14 files changed, 42 insertions(+), 27 deletions(-)

diff -puN arch/i386/mach-voyager/voyager_thread.c~tidy-up-usermode-helper-waiting-a-bit arch/i386/mach-voyager/voyager_thread.c
--- a/arch/i386/mach-voyager/voyager_thread.c~tidy-up-usermode-helper-waiting-a-bit
+++ a/arch/i386/mach-voyager/voyager_thread.c
@@ -52,7 +52,7 @@ execute(const char *string)
 		NULL,
 	};
 
-	if ((ret = call_usermodehelper(argv[0], argv, envp, 1)) != 0) {
+	if ((ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC)) != 0) {
 		printk(KERN_ERR "Voyager failed to run \"%s\": %i\n",
 		       string, ret);
 	}
diff -puN arch/x86_64/kernel/mce.c~tidy-up-usermode-helper-waiting-a-bit arch/x86_64/kernel/mce.c
--- a/arch/x86_64/kernel/mce.c~tidy-up-usermode-helper-waiting-a-bit
+++ a/arch/x86_64/kernel/mce.c
@@ -398,7 +398,8 @@ int mce_notify_user(void)
 	if (test_and_clear_bit(0, &notify_user)) {
 		wake_up_interruptible(&mce_wait);
 		if (trigger[0])
-			call_usermodehelper(trigger, trigger_argv, NULL, -1);
+			call_usermodehelper(trigger, trigger_argv, NULL,
+					UMH_NO_WAIT);
 		do_printk = 1;
 		retval = 1;
 	}
diff -puN drivers/macintosh/therm_pm72.c~tidy-up-usermode-helper-waiting-a-bit drivers/macintosh/therm_pm72.c
--- a/drivers/macintosh/therm_pm72.c~tidy-up-usermode-helper-waiting-a-bit
+++ a/drivers/macintosh/therm_pm72.c
@@ -1770,7 +1770,8 @@ static int call_critical_overtemp(void)
 				"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
 				NULL };
 
-	return call_usermodehelper(critical_overtemp_path, argv, envp, 0);
+	return call_usermodehelper(critical_overtemp_path,
+				   argv, envp, UMH_WAIT_EXEC);
 }
 
 
diff -puN drivers/macintosh/windfarm_core.c~tidy-up-usermode-helper-waiting-a-bit drivers/macintosh/windfarm_core.c
--- a/drivers/macintosh/windfarm_core.c~tidy-up-usermode-helper-waiting-a-bit
+++ a/drivers/macintosh/windfarm_core.c
@@ -80,7 +80,8 @@ int wf_critical_overtemp(void)
 				"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
 				NULL };
 
-	return call_usermodehelper(critical_overtemp_path, argv, envp, 0);
+	return call_usermodehelper(critical_overtemp_path,
+				   argv, envp, UMH_WAIT_EXEC);
 }
 EXPORT_SYMBOL_GPL(wf_critical_overtemp);
 
diff -puN drivers/net/hamradio/baycom_epp.c~tidy-up-usermode-helper-waiting-a-bit drivers/net/hamradio/baycom_epp.c
--- a/drivers/net/hamradio/baycom_epp.c~tidy-up-usermode-helper-waiting-a-bit
+++ a/drivers/net/hamradio/baycom_epp.c
@@ -320,7 +320,7 @@ static int eppconfig(struct baycom_state
 	sprintf(portarg, "%ld", bc->pdev->port->base);
 	printk(KERN_DEBUG "%s: %s -s -p %s -m %s\n", bc_drvname, eppconfig_path, portarg, modearg);
 
-	return call_usermodehelper(eppconfig_path, argv, envp, 1);
+	return call_usermodehelper(eppconfig_path, argv, envp, UMH_WAIT_PROC);
 }
 
 /* ---------------------------------------------------------------------- */
diff -puN drivers/pnp/pnpbios/core.c~tidy-up-usermode-helper-waiting-a-bit drivers/pnp/pnpbios/core.c
--- a/drivers/pnp/pnpbios/core.c~tidy-up-usermode-helper-waiting-a-bit
+++ a/drivers/pnp/pnpbios/core.c
@@ -147,7 +147,7 @@ static int pnp_dock_event(int dock, stru
 		info->location_id, info->serial, info->capabilities);
 	envp[i] = NULL;
 	
-	value = call_usermodehelper (argv [0], argv, envp, 0);
+	value = call_usermodehelper (argv [0], argv, envp, UMH_WAIT_EXEC);
 	kfree (buf);
 	kfree (envp);
 	return 0;
diff -puN fs/ocfs2/heartbeat.c~tidy-up-usermode-helper-waiting-a-bit fs/ocfs2/heartbeat.c
--- a/fs/ocfs2/heartbeat.c~tidy-up-usermode-helper-waiting-a-bit
+++ a/fs/ocfs2/heartbeat.c
@@ -209,7 +209,7 @@ void ocfs2_stop_heartbeat(struct ocfs2_s
 	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
 	envp[2] = NULL;
 
-	ret = call_usermodehelper(argv[0], argv, envp, 1);
+	ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC);
 	if (ret < 0)
 		mlog_errno(ret);
 }
diff -puN include/linux/kmod.h~tidy-up-usermode-helper-waiting-a-bit include/linux/kmod.h
--- a/include/linux/kmod.h~tidy-up-usermode-helper-waiting-a-bit
+++ a/include/linux/kmod.h
@@ -51,15 +51,21 @@ int call_usermodehelper_stdinpipe(struct
 void call_usermodehelper_setcleanup(struct subprocess_info *info,
 				    void (*cleanup)(char **argv, char **envp));
 
+enum umh_wait {
+	UMH_NO_WAIT = -1,	/* don't wait at all */
+	UMH_WAIT_EXEC = 0,	/* wait for the exec, but not the process */
+	UMH_WAIT_PROC = 1,	/* wait for the process to complete */
+};
+
 /* Actually execute the sub-process */
-int call_usermodehelper_exec(struct subprocess_info *info, int wait);
+int call_usermodehelper_exec(struct subprocess_info *info, enum umh_wait wait);
 
 /* Free the subprocess_info. This is only needed if you're not going
    to call call_usermodehelper_exec */
 void call_usermodehelper_freeinfo(struct subprocess_info *info);
 
 static inline int
-call_usermodehelper(char *path, char **argv, char **envp, int wait)
+call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
 {
 	struct subprocess_info *info;
 
@@ -71,7 +77,7 @@ call_usermodehelper(char *path, char **a
 
 static inline int
 call_usermodehelper_keys(char *path, char **argv, char **envp,
-			 struct key *session_keyring, int wait)
+			 struct key *session_keyring, enum umh_wait wait)
 {
 	struct subprocess_info *info;
 
diff -puN kernel/cpuset.c~tidy-up-usermode-helper-waiting-a-bit kernel/cpuset.c
--- a/kernel/cpuset.c~tidy-up-usermode-helper-waiting-a-bit
+++ a/kernel/cpuset.c
@@ -516,7 +516,7 @@ static void cpuset_release_agent(const c
 	envp[i++] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
 	envp[i] = NULL;
 
-	call_usermodehelper(argv[0], argv, envp, 0);
+	call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
 	kfree(pathbuf);
 }
 
diff -puN kernel/kmod.c~tidy-up-usermode-helper-waiting-a-bit kernel/kmod.c
--- a/kernel/kmod.c~tidy-up-usermode-helper-waiting-a-bit
+++ a/kernel/kmod.c
@@ -119,7 +119,7 @@ struct subprocess_info {
 	char **argv;
 	char **envp;
 	struct key *ring;
-	int wait;
+	enum umh_wait wait;
 	int retval;
 	struct file *stdin;
 	void (*cleanup)(char **argv, char **envp);
@@ -225,7 +225,7 @@ static int wait_for_helper(void *data)
 			sub_info->retval = ret;
 	}
 
-	if (sub_info->wait < 0)
+	if (sub_info->wait == UMH_NO_WAIT)
 		call_usermodehelper_freeinfo(sub_info);
 	else
 		complete(sub_info->complete);
@@ -238,26 +238,31 @@ static void __call_usermodehelper(struct
 	struct subprocess_info *sub_info =
 		container_of(work, struct subprocess_info, work);
 	pid_t pid;
-	int wait = sub_info->wait;
+	enum umh_wait wait = sub_info->wait;
 
 	/* CLONE_VFORK: wait until the usermode helper has execve'd
 	 * successfully We need the data structures to stay around
 	 * until that is done.  */
-	if (wait)
+	if (wait == UMH_WAIT_PROC)
 		pid = kernel_thread(wait_for_helper, sub_info,
 				    CLONE_FS | CLONE_FILES | SIGCHLD);
 	else
 		pid = kernel_thread(____call_usermodehelper, sub_info,
 				    CLONE_VFORK | SIGCHLD);
 
-	if (wait < 0)
-		return;
-
-	if (pid < 0) {
+	switch(wait) {
+	case UMH_NO_WAIT:
+		break;
+
+	case UMH_WAIT_PROC:
+		if (pid > 0)
+			break;
 		sub_info->retval = pid;
+		/* FALLTHROUGH */
+
+	case UMH_WAIT_EXEC:
 		complete(sub_info->complete);
-	} else if (!wait)
-		complete(sub_info->complete);
+	}
 }
 
 /**
@@ -359,7 +364,7 @@ EXPORT_SYMBOL(call_usermodehelper_stdinp
  * (ie. it runs with full root capabilities).
  */
 int call_usermodehelper_exec(struct subprocess_info *sub_info,
-			     int wait)
+			     enum umh_wait wait)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval;
@@ -378,7 +383,7 @@ int call_usermodehelper_exec(struct subp
 	sub_info->wait = wait;
 
 	queue_work(khelper_wq, &sub_info->work);
-	if (wait < 0) /* task has freed sub_info */
+	if (wait == UMH_NO_WAIT) /* task has freed sub_info */
 		return 0;
 	wait_for_completion(&done);
 	retval = sub_info->retval;
diff -puN kernel/sys.c~tidy-up-usermode-helper-waiting-a-bit kernel/sys.c
--- a/kernel/sys.c~tidy-up-usermode-helper-waiting-a-bit
+++ a/kernel/sys.c
@@ -2318,7 +2318,7 @@ int orderly_poweroff(bool force)
 
 	call_usermodehelper_setcleanup(info, argv_cleanup);
 
-	ret = call_usermodehelper_exec(info, -1);
+	ret = call_usermodehelper_exec(info, UMH_NO_WAIT);
 
   out:
 	if (ret && force) {
diff -puN lib/kobject_uevent.c~tidy-up-usermode-helper-waiting-a-bit lib/kobject_uevent.c
--- a/lib/kobject_uevent.c~tidy-up-usermode-helper-waiting-a-bit
+++ a/lib/kobject_uevent.c
@@ -208,7 +208,7 @@ int kobject_uevent_env(struct kobject *k
 		argv [0] = uevent_helper;
 		argv [1] = (char *)subsystem;
 		argv [2] = NULL;
-		call_usermodehelper (argv[0], argv, envp, 0);
+		call_usermodehelper (argv[0], argv, envp, UMH_WAIT_EXEC);
 	}
 
 exit:
diff -puN net/bridge/br_stp_if.c~tidy-up-usermode-helper-waiting-a-bit net/bridge/br_stp_if.c
--- a/net/bridge/br_stp_if.c~tidy-up-usermode-helper-waiting-a-bit
+++ a/net/bridge/br_stp_if.c
@@ -125,7 +125,7 @@ static void br_stp_start(struct net_brid
 	char *argv[] = { BR_STP_PROG, br->dev->name, "start", NULL };
 	char *envp[] = { NULL };
 
-	r = call_usermodehelper(BR_STP_PROG, argv, envp, 1);
+	r = call_usermodehelper(BR_STP_PROG, argv, envp, UMH_WAIT_PROC);
 	if (r == 0) {
 		br->stp_enabled = BR_USER_STP;
 		printk(KERN_INFO "%s: userspace STP started\n", br->dev->name);
diff -puN security/keys/request_key.c~tidy-up-usermode-helper-waiting-a-bit security/keys/request_key.c
--- a/security/keys/request_key.c~tidy-up-usermode-helper-waiting-a-bit
+++ a/security/keys/request_key.c
@@ -108,7 +108,8 @@ static int call_sbin_request_key(struct 
 	argv[i] = NULL;
 
 	/* do it */
-	ret = call_usermodehelper_keys(argv[0], argv, envp, keyring, 1);
+	ret = call_usermodehelper_keys(argv[0], argv, envp, keyring,
+				       UMH_WAIT_PROC);
 
 error_link:
 	key_put(keyring);
_

Patches currently in -mm which might be from jeremy@goop.org are

add-kstrndup-fix.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
tidy-up-usermode-helper-waiting-a-bit-fix.patch
lguest-the-guest-code.patch
