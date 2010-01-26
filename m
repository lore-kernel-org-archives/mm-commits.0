From: akpm@linux-foundation.org
Subject: + exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0.patch added to -mm tree
Date: Tue, 26 Jan 2010 15:54:11 -0800
Message-ID: <201001262354.o0QNsBiM029772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754473Ab0AZXz6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 18:55:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com, abelay@mit.edu, benh@kernel.crashing.org, drbd-dev@lists.linbit.com, gregkh@suse.de, jmoskovc@redhat.com, menage@google.com, mfasheh@suse.com, mingo@redhat.com, neilb@suse.de, oleg@redhat.com, shemminger@linux-foundation.org, spock@gentoo.org, t.sailer@alumni.ethz.ch, takedakn@nttdata.co.jp, viro@zeniv.linux.org.uk


The patch titled
     exec: allow core_pipe recursion check to look for a value of 1 rather than 0
has been added to the -mm tree.  Its filename is
     exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0.patch

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
Subject: exec: allow core_pipe recursion check to look for a value of 1 rather than 0
From: Neil Horman <nhorman@tuxdriver.com>

About 6 months ago, I made a set of changes to how the core-dump-to-a-pipe
feature in the kernel works.  We had reports of several races, including
some reports of apps bypassing our recursion check so that a process that
was forked as part of a core_pattern setup could infinitely crash and
refork until the system crashed.

We fixed those by improving our recursion checks.  The new check basically
refuses to fork a process if its core limit is zero, which works well.

Unfortunately, I've been getting grief from maintainer of user space
programs that are inserted as the forked process of core_pattern.  They
contend that in order for their programs (such as abrt and apport) to
work, all the running processes in a system must have their core limits
set to a non-zero value, to which I say 'yes'.  I did this by design, and
think thats the right way to do things.

But I've been asked to ease this burden on user space enough times that I
thought I would take a look at it.  The first suggestion was to make the
recursion check fail on a non-zero 'special' number, like one.  That way
the core collector process could set its core size ulimit to 1, and enable
the kernel's recursion detection.  This isn't a bad idea on the surface,
but I don't like it since its opt-in, in that if a program like abrt or
apport has a bug and fails to set such a core limit, we're left with a
recursively crashing system again.

So I've come up with this.  What I've done is modify the
call_usermodehelper() api such that an extra parameter is added, a
function pointer which will be called by the user helper task, after it
forks, but before it execs the required process.  This will give the
caller the opportunity to get a callback in the process's context,
allowing it to do whatever it needs to to the process in the kernel prior
to execing the userspace code.  In the case of do_coredump(), this
callback is used to set the core ulimit of the helper process to 1.  This
eliminates the opt-in problem that I had above, as it allows the ulimit
for core sizes to be set to the value of 1, which is what the recursion
check looks for in do_coredump.

This patch has been tested successfully by some of the Abrt maintainers in
fedora, with good results.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Tested-by: Jiri Moskovcak <jmoskovc@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: <drbd-dev@lists.linbit.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Thomas Sailer <t.sailer@alumni.ethz.ch>
Cc: Adam Belay <abelay@mit.edu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Michal Januszewski <spock@gentoo.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Neil Brown <neilb@suse.de>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Paul Menage <menage@google.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mcheck/mce.c       |    2 +-
 drivers/block/drbd/drbd_nl.c           |    2 +-
 drivers/macintosh/therm_pm72.c         |    2 +-
 drivers/macintosh/windfarm_core.c      |    2 +-
 drivers/net/hamradio/baycom_epp.c      |    2 +-
 drivers/pnp/pnpbios/core.c             |    2 +-
 drivers/staging/rtl8187se/r8180_core.c |    2 +-
 drivers/video/uvesafb.c                |    2 +-
 fs/exec.c                              |   18 +++++++++++++++---
 fs/nfs/cache_lib.c                     |    2 +-
 fs/ocfs2/stackglue.c                   |    2 +-
 include/linux/kmod.h                   |   16 ++++++++++------
 kernel/cgroup.c                        |    2 +-
 kernel/kmod.c                          |   17 +++++++++++++----
 kernel/sys.c                           |    2 +-
 lib/kobject_uevent.c                   |    2 +-
 net/bridge/br_stp_if.c                 |    4 ++--
 security/keys/request_key.c            |    2 +-
 security/tomoyo/common.c               |    2 +-
 19 files changed, 55 insertions(+), 30 deletions(-)

diff -puN arch/x86/kernel/cpu/mcheck/mce.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0 arch/x86/kernel/cpu/mcheck/mce.c
--- a/arch/x86/kernel/cpu/mcheck/mce.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0
+++ a/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1174,7 +1174,7 @@ static void mce_start_timer(unsigned lon
 
 static void mce_do_trigger(struct work_struct *work)
 {
-	call_usermodehelper(mce_helper, mce_helper_argv, NULL, UMH_NO_WAIT);
+	call_usermodehelper(mce_helper, mce_helper_argv, NULL, NULL, UMH_NO_WAIT);
 }
 
 static DECLARE_WORK(mce_trigger_work, mce_do_trigger);
diff -puN drivers/block/drbd/drbd_nl.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0 drivers/block/drbd/drbd_nl.c
--- a/drivers/block/drbd/drbd_nl.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0
+++ a/drivers/block/drbd/drbd_nl.c
@@ -172,7 +172,7 @@ int drbd_khelper(struct drbd_conf *mdev,
 	dev_info(DEV, "helper command: %s %s %s\n", usermode_helper, cmd, mb);
 
 	drbd_bcast_ev_helper(mdev, cmd);
-	ret = call_usermodehelper(usermode_helper, argv, envp, 1);
+	ret = call_usermodehelper(usermode_helper, argv, envp, NULL, 1);
 	if (ret)
 		dev_warn(DEV, "helper command: %s %s %s exit code %u (0x%x)\n",
 				usermode_helper, cmd, mb,
diff -puN drivers/macintosh/therm_pm72.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0 drivers/macintosh/therm_pm72.c
--- a/drivers/macintosh/therm_pm72.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0
+++ a/drivers/macintosh/therm_pm72.c
@@ -1763,7 +1763,7 @@ static int call_critical_overtemp(void)
 				NULL };
 
 	return call_usermodehelper(critical_overtemp_path,
-				   argv, envp, UMH_WAIT_EXEC);
+				   argv, envp, NULL, UMH_WAIT_EXEC);
 }
 
 
diff -puN drivers/macintosh/windfarm_core.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0 drivers/macintosh/windfarm_core.c
--- a/drivers/macintosh/windfarm_core.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0
+++ a/drivers/macintosh/windfarm_core.c
@@ -81,7 +81,7 @@ int wf_critical_overtemp(void)
 				NULL };
 
 	return call_usermodehelper(critical_overtemp_path,
-				   argv, envp, UMH_WAIT_EXEC);
+				   argv, envp, NULL, UMH_WAIT_EXEC);
 }
 EXPORT_SYMBOL_GPL(wf_critical_overtemp);
 
diff -puN drivers/net/hamradio/baycom_epp.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0 drivers/net/hamradio/baycom_epp.c
--- a/drivers/net/hamradio/baycom_epp.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0
+++ a/drivers/net/hamradio/baycom_epp.c
@@ -320,7 +320,7 @@ static int eppconfig(struct baycom_state
 	sprintf(portarg, "%ld", bc->pdev->port->base);
 	printk(KERN_DEBUG "%s: %s -s -p %s -m %s\n", bc_drvname, eppconfig_path, portarg, modearg);
 
-	return call_usermodehelper(eppconfig_path, argv, envp, UMH_WAIT_PROC);
+	return call_usermodehelper(eppconfig_path, argv, envp, NULL, UMH_WAIT_PROC);
 }
 
 /* ---------------------------------------------------------------------- */
diff -puN drivers/pnp/pnpbios/core.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0 drivers/pnp/pnpbios/core.c
--- a/drivers/pnp/pnpbios/core.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0
+++ a/drivers/pnp/pnpbios/core.c
@@ -142,7 +142,7 @@ static int pnp_dock_event(int dock, stru
 			   info->location_id, info->serial, info->capabilities);
 	envp[i] = NULL;
 
-	value = call_usermodehelper(argv [0], argv, envp, UMH_WAIT_EXEC);
+	value = call_usermodehelper(argv [0], argv, envp, NULL, UMH_WAIT_EXEC);
 	kfree(buf);
 	kfree(envp);
 	return 0;
diff -puN drivers/staging/rtl8187se/r8180_core.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0 drivers/staging/rtl8187se/r8180_core.c
--- a/drivers/staging/rtl8187se/r8180_core.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0
+++ a/drivers/staging/rtl8187se/r8180_core.c
@@ -4287,7 +4287,7 @@ void GPIOChangeRFWorkItemCallBack(struct
                                 argv[0] = RadioPowerPath;
                                 argv[2] = NULL;
 
-                                call_usermodehelper(RadioPowerPath,argv,envp,1);
+                                call_usermodehelper(RadioPowerPath,argv,envp,NULL,1);
 			}
 		}
 }
diff -puN drivers/video/uvesafb.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0 drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0
+++ a/drivers/video/uvesafb.c
@@ -120,7 +120,7 @@ static int uvesafb_helper_start(void)
 		NULL,
 	};
 
-	return call_usermodehelper(v86d_path, argv, envp, 1);
+	return call_usermodehelper(v86d_path, argv, envp, NULL, 1);
 }
 
 /*
diff -puN fs/exec.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0 fs/exec.c
--- a/fs/exec.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0
+++ a/fs/exec.c
@@ -1761,6 +1761,18 @@ static void wait_for_dump_helpers(struct
 
 }
 
+/*
+ * This is used as a helper to set up the task that execs
+ * our user space core collector application
+ * Its called in the context of the task thats going to
+ * exec itself to be the helper, so we can modify current here
+ */
+void core_pipe_setup(void)
+{
+	task_lock(current->group_leader);
+	current->signal->rlim[RLIMIT_CORE].rlim_cur = 1;
+	task_unlock(current->group_leader);
+}
 
 void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 {
@@ -1849,7 +1861,7 @@ void do_coredump(long signr, int exit_co
 		goto fail_unlock;
 
  	if (ispipe) {
-		if (cprm.limit == 0) {
+		if (cprm.limit == 1) {
 			/*
 			 * Normally core limits are irrelevant to pipes, since
 			 * we're not writing to the file system, but we use
@@ -1865,7 +1877,7 @@ void do_coredump(long signr, int exit_co
 			 * core_pattern process dies.
 			 */
 			printk(KERN_WARNING
-				"Process %d(%s) has RLIMIT_CORE set to 0\n",
+				"Process %d(%s) has RLIMIT_CORE set to 1\n",
 				task_tgid_vnr(current), current->comm);
 			printk(KERN_WARNING "Aborting core\n");
 			goto fail_unlock;
@@ -1890,7 +1902,7 @@ void do_coredump(long signr, int exit_co
 
 		/* SIGPIPE can happen, but it's just never processed */
 		if (call_usermodehelper_pipe(helper_argv[0], helper_argv, NULL,
-				&cprm.file)) {
+				&cprm.file, core_pipe_setup)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
 			goto fail_dropcount;
diff -puN fs/nfs/cache_lib.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0 fs/nfs/cache_lib.c
--- a/fs/nfs/cache_lib.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0
+++ a/fs/nfs/cache_lib.c
@@ -46,7 +46,7 @@ int nfs_cache_upcall(struct cache_detail
 
 	if (nfs_cache_getent_prog[0] == '\0')
 		goto out;
-	ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
+	ret = call_usermodehelper(argv[0], argv, envp, NULL, UMH_WAIT_EXEC);
 	/*
 	 * Disable the upcall mechanism if we're getting an ENOENT or
 	 * EACCES error. The admin can re-enable it on the fly by using
diff -puN fs/ocfs2/stackglue.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0 fs/ocfs2/stackglue.c
--- a/fs/ocfs2/stackglue.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0
+++ a/fs/ocfs2/stackglue.c
@@ -407,7 +407,7 @@ static void ocfs2_leave_group(const char
 	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
 	envp[2] = NULL;
 
-	ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC);
+	ret = call_usermodehelper(argv[0], argv, envp, NULL, UMH_WAIT_PROC);
 	if (ret < 0) {
 		printk(KERN_ERR
 		       "ocfs2: Error %d running user helper "
diff -puN include/linux/kmod.h~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0 include/linux/kmod.h
--- a/include/linux/kmod.h~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0
+++ a/include/linux/kmod.h
@@ -48,7 +48,9 @@ struct subprocess_info;
 
 /* Allocate a subprocess_info structure */
 struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
-						  char **envp, gfp_t gfp_mask);
+						  char **envp,
+						  void (*finit)(void),
+						  gfp_t gfp_mask);
 
 /* Set various pieces of state into the subprocess_info structure */
 void call_usermodehelper_setkeys(struct subprocess_info *info,
@@ -72,12 +74,13 @@ int call_usermodehelper_exec(struct subp
 void call_usermodehelper_freeinfo(struct subprocess_info *info);
 
 static inline int
-call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
+call_usermodehelper(char *path, char **argv, char **envp,
+		    void (*finit)(void), enum umh_wait wait)
 {
 	struct subprocess_info *info;
 	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
 
-	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
+	info = call_usermodehelper_setup(path, argv, envp, finit, gfp_mask);
 	if (info == NULL)
 		return -ENOMEM;
 	return call_usermodehelper_exec(info, wait);
@@ -85,12 +88,13 @@ call_usermodehelper(char *path, char **a
 
 static inline int
 call_usermodehelper_keys(char *path, char **argv, char **envp,
-			 struct key *session_keyring, enum umh_wait wait)
+			 struct key *session_keyring,
+			 void (*finit)(void), enum umh_wait wait)
 {
 	struct subprocess_info *info;
 	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
 
-	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
+	info = call_usermodehelper_setup(path, argv, envp, finit, gfp_mask);
 	if (info == NULL)
 		return -ENOMEM;
 
@@ -102,7 +106,7 @@ extern void usermodehelper_init(void);
 
 struct file;
 extern int call_usermodehelper_pipe(char *path, char *argv[], char *envp[],
-				    struct file **filp);
+				    struct file **filp, void (*finit)(void));
 
 extern int usermodehelper_disable(void);
 extern void usermodehelper_enable(void);
diff -puN kernel/cgroup.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0 kernel/cgroup.c
--- a/kernel/cgroup.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0
+++ a/kernel/cgroup.c
@@ -3780,7 +3780,7 @@ static void cgroup_release_agent(struct 
 		 * since the exec could involve hitting disk and hence
 		 * be a slow process */
 		mutex_unlock(&cgroup_mutex);
-		call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
+		call_usermodehelper(argv[0], argv, envp, NULL, UMH_WAIT_EXEC);
 		mutex_lock(&cgroup_mutex);
  continue_free:
 		kfree(pathbuf);
diff -puN kernel/kmod.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0 kernel/kmod.c
--- a/kernel/kmod.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0
+++ a/kernel/kmod.c
@@ -35,6 +35,7 @@
 #include <linux/resource.h>
 #include <linux/notifier.h>
 #include <linux/suspend.h>
+#include <linux/gfp.h>
 #include <asm/uaccess.h>
 
 #include <trace/events/module.h>
@@ -117,7 +118,7 @@ int __request_module(bool wait, const ch
 	trace_module_request(module_name, wait, _RET_IP_);
 
 	ret = call_usermodehelper(modprobe_path, argv, envp,
-			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
+			NULL, wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
 	atomic_dec(&kmod_concurrent);
 	return ret;
 }
@@ -134,6 +135,7 @@ struct subprocess_info {
 	enum umh_wait wait;
 	int retval;
 	struct file *stdin;
+	void (*finit)(void);
 	void (*cleanup)(char **argv, char **envp);
 };
 
@@ -184,6 +186,9 @@ static int ____call_usermodehelper(void 
 	 */
 	set_user_nice(current, 0);
 
+	if (sub_info->finit)
+		sub_info->finit();
+
 	retval = kernel_execve(sub_info->path, sub_info->argv, sub_info->envp);
 
 	/* Exec failed? */
@@ -365,7 +370,9 @@ static inline void helper_unlock(void) {
  * exec the process and free the structure.
  */
 struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
-						  char **envp, gfp_t gfp_mask)
+						  char **envp,
+						  void (*finit)(void),
+						  gfp_t gfp_mask)
 {
 	struct subprocess_info *sub_info;
 	sub_info = kzalloc(sizeof(struct subprocess_info), gfp_mask);
@@ -381,6 +388,7 @@ struct subprocess_info *call_usermodehel
 		kfree(sub_info);
 		return NULL;
 	}
+	sub_info->finit = finit;
 
   out:
 	return sub_info;
@@ -510,12 +518,13 @@ EXPORT_SYMBOL(call_usermodehelper_exec);
  * lower-level call_usermodehelper_* functions.
  */
 int call_usermodehelper_pipe(char *path, char **argv, char **envp,
-			     struct file **filp)
+			     struct file **filp,
+			     void (*finit)(void))
 {
 	struct subprocess_info *sub_info;
 	int ret;
 
-	sub_info = call_usermodehelper_setup(path, argv, envp, GFP_KERNEL);
+	sub_info = call_usermodehelper_setup(path, argv, envp, finit, GFP_KERNEL);
 	if (sub_info == NULL)
 		return -ENOMEM;
 
diff -puN kernel/sys.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0 kernel/sys.c
--- a/kernel/sys.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0
+++ a/kernel/sys.c
@@ -1758,7 +1758,7 @@ int orderly_poweroff(bool force)
 		goto out;
 	}
 
-	info = call_usermodehelper_setup(argv[0], argv, envp, GFP_ATOMIC);
+	info = call_usermodehelper_setup(argv[0], argv, envp, NULL, GFP_ATOMIC);
 	if (info == NULL) {
 		argv_free(argv);
 		goto out;
diff -puN lib/kobject_uevent.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0 lib/kobject_uevent.c
--- a/lib/kobject_uevent.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0
+++ a/lib/kobject_uevent.c
@@ -258,7 +258,7 @@ int kobject_uevent_env(struct kobject *k
 			goto exit;
 
 		retval = call_usermodehelper(argv[0], argv,
-					     env->envp, UMH_WAIT_EXEC);
+					     env->envp, NULL, UMH_WAIT_EXEC);
 	}
 
 exit:
diff -puN net/bridge/br_stp_if.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0 net/bridge/br_stp_if.c
--- a/net/bridge/br_stp_if.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0
+++ a/net/bridge/br_stp_if.c
@@ -123,7 +123,7 @@ static void br_stp_start(struct net_brid
 	char *argv[] = { BR_STP_PROG, br->dev->name, "start", NULL };
 	char *envp[] = { NULL };
 
-	r = call_usermodehelper(BR_STP_PROG, argv, envp, UMH_WAIT_PROC);
+	r = call_usermodehelper(BR_STP_PROG, argv, envp, NULL, UMH_WAIT_PROC);
 	if (r == 0) {
 		br->stp_enabled = BR_USER_STP;
 		printk(KERN_INFO "%s: userspace STP started\n", br->dev->name);
@@ -146,7 +146,7 @@ static void br_stp_stop(struct net_bridg
 	char *envp[] = { NULL };
 
 	if (br->stp_enabled == BR_USER_STP) {
-		r = call_usermodehelper(BR_STP_PROG, argv, envp, 1);
+		r = call_usermodehelper(BR_STP_PROG, argv, envp, NULL, 1);
 		printk(KERN_INFO "%s: userspace STP stopped, return code %d\n",
 			br->dev->name, r);
 
diff -puN security/keys/request_key.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0 security/keys/request_key.c
--- a/security/keys/request_key.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0
+++ a/security/keys/request_key.c
@@ -139,7 +139,7 @@ static int call_sbin_request_key(struct 
 
 	/* do it */
 	ret = call_usermodehelper_keys(argv[0], argv, envp, keyring,
-				       UMH_WAIT_PROC);
+				       NULL, UMH_WAIT_PROC);
 	kdebug("usermode -> 0x%x", ret);
 	if (ret >= 0) {
 		/* ret is the exit/wait code */
diff -puN security/tomoyo/common.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0 security/tomoyo/common.c
--- a/security/tomoyo/common.c~exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0
+++ a/security/tomoyo/common.c
@@ -1865,7 +1865,7 @@ void tomoyo_load_policy(const char *file
 	envp[0] = "HOME=/";
 	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
 	envp[2] = NULL;
-	call_usermodehelper(argv[0], argv, envp, 1);
+	call_usermodehelper(argv[0], argv, envp, NULL, 1);
 
 	printk(KERN_INFO "TOMOYO: 2.2.0   2009/04/01\n");
 	printk(KERN_INFO "Mandatory Access Control activated.\n");
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

origin.patch
linux-next.patch
exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0.patch
exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0-checkpatch-fixes.patch
exec-allow-core_pipe-recursion-check-to-look-for-a-value-of-1-rather-than-0-checkpatch-fixes-fix.patch

