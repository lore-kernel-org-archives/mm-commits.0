From: akpm@linux-foundation.org
Subject: + pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch added to -mm tree
Date: Thu, 02 Feb 2012 16:10:54 -0800
Message-ID: <20120203001054.83C47A00AA@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:49657 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab2BCAK5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2012 19:10:57 -0500
Received: by wgbds12 with SMTP id ds12so98778wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 02 Feb 2012 16:10:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.lezcano@free.fr, ebiederm@xmission.com, mtk.manpages@gmail.com, oleg@redhat.com, serge.hallyn@canonical.com, tj@kernel.org


The patch titled
     Subject: pidns: add reboot_pid_ns() to handle the reboot syscall
has been added to the -mm tree.  Its filename is
     pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Lezcano <daniel.lezcano@free.fr>
Subject: pidns: add reboot_pid_ns() to handle the reboot syscall

In the case of a child pid namespace, rebooting the system does not really
makes sense.  When the pid namespace is used in conjunction with the other
namespaces in order to create a linux container, the reboot syscall leads
to some problems.

A container can reboot the host.  That can be fixed by dropping the
sys_reboot capability but we are unable to correctly to poweroff/
halt/reboot a container and the container stays stuck at the shutdown time
with the container's init process waiting indefinitively.

After several attempts, no solution from userspace was found to reliabily
handle the shutdown from a container.

This patch propose to make the init process of the child pid namespace to
exit with a signal status set to : SIGINT if the child pid namespace
called "halt/poweroff" and SIGHUP if the child pid namespace called
"reboot".  When the reboot syscall is called and we are not in the initial
pid namespace, we kill the pid namespace for "HALT", "POWEROFF",
"RESTART", and "RESTART2".  Otherwise we return EINVAL.

Returning EINVAL is also an easy way to check if this feature is supported
by the kernel when invoking another 'reboot' option like CAD.

By this way the parent process of the child pid namespace knows if it
rebooted or not and can take the right decision.

Test case:
==========

#include <alloca.h>
#include <stdio.h>
#include <sched.h>
#include <unistd.h>
#include <signal.h>
#include <sys/reboot.h>
#include <sys/types.h>
#include <sys/wait.h>

#include <linux/reboot.h>

static int do_reboot(void *arg)
{
        int *cmd = arg;

        if (reboot(*cmd))
                printf("failed to reboot(%d): %m\n", *cmd);
}

int test_reboot(int cmd, int sig)
{
        long stack_size = 4096;
        void *stack = alloca(stack_size) + stack_size;
        int status;
        pid_t ret;

        ret = clone(do_reboot, stack, CLONE_NEWPID | SIGCHLD, &cmd);
        if (ret < 0) {
                printf("failed to clone: %m\n");
                return -1;
        }

        if (wait(&status) < 0) {
                printf("unexpected wait error: %m\n");
                return -1;
        }

        if (!WIFSIGNALED(status)) {
                printf("child process exited but was not signaled\n");
                return -1;
        }

        if (WTERMSIG(status) != sig) {
                printf("signal termination is not the one expected\n");
                return -1;
        }

        return 0;
}

int main(int argc, char *argv[])
{
        int status;

        status = test_reboot(LINUX_REBOOT_CMD_RESTART, SIGHUP);
        if (status < 0)
                return 1;
        printf("reboot(LINUX_REBOOT_CMD_RESTART) succeed\n");

        status = test_reboot(LINUX_REBOOT_CMD_RESTART2, SIGHUP);
        if (status < 0)
                return 1;
        printf("reboot(LINUX_REBOOT_CMD_RESTART2) succeed\n");

        status = test_reboot(LINUX_REBOOT_CMD_HALT, SIGINT);
        if (status < 0)
                return 1;
        printf("reboot(LINUX_REBOOT_CMD_HALT) succeed\n");

        status = test_reboot(LINUX_REBOOT_CMD_POWER_OFF, SIGINT);
        if (status < 0)
                return 1;
        printf("reboot(LINUX_REBOOT_CMD_POWERR_OFF) succeed\n");

        status = test_reboot(LINUX_REBOOT_CMD_CAD_ON, -1);
        if (status >= 0) {
                printf("reboot(LINUX_REBOOT_CMD_CAD_ON) should have failed\n");
                return 1;
        }
        printf("reboot(LINUX_REBOOT_CMD_CAD_ON) has failed as expected\n");

        return 0;
}

Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Tested-by: Serge Hallyn <serge.hallyn@canonical.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid_namespace.h |    8 ++++++-
 kernel/pid_namespace.c        |   33 ++++++++++++++++++++++++++++++++
 kernel/sys.c                  |    8 +++++++
 3 files changed, 48 insertions(+), 1 deletion(-)

diff -puN include/linux/pid_namespace.h~pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall
+++ a/include/linux/pid_namespace.h
@@ -32,6 +32,7 @@ struct pid_namespace {
 #endif
 	gid_t pid_gid;
 	int hide_pid;
+	int reboot;
 };
 
 extern struct pid_namespace init_pid_ns;
@@ -47,6 +48,7 @@ static inline struct pid_namespace *get_
 extern struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *ns);
 extern void free_pid_ns(struct kref *kref);
 extern void zap_pid_ns_processes(struct pid_namespace *pid_ns);
+extern int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd);
 
 static inline void put_pid_ns(struct pid_namespace *ns)
 {
@@ -74,11 +76,15 @@ static inline void put_pid_ns(struct pid
 {
 }
 
-
 static inline void zap_pid_ns_processes(struct pid_namespace *ns)
 {
 	BUG();
 }
+
+static inline int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd)
+{
+	return 0;
+}
 #endif /* CONFIG_PID_NS */
 
 extern struct pid_namespace *task_active_pid_ns(struct task_struct *tsk);
diff -puN kernel/pid_namespace.c~pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall
+++ a/kernel/pid_namespace.c
@@ -15,6 +15,7 @@
 #include <linux/acct.h>
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
+#include <linux/reboot.h>
 
 #define BITS_PER_PAGE		(PAGE_SIZE*8)
 
@@ -187,6 +188,9 @@ void zap_pid_ns_processes(struct pid_nam
 		rc = sys_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 
+	if (pid_ns->reboot)
+		current->signal->group_exit_code = pid_ns->reboot;
+
 	acct_exit_ns(pid_ns);
 	return;
 }
@@ -221,6 +225,35 @@ static struct ctl_table pid_ns_ctl_table
 
 static struct ctl_path kern_path[] = { { .procname = "kernel", }, { } };
 
+int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd)
+{
+	if (pid_ns == &init_pid_ns)
+		return 0;
+
+	switch(cmd) {
+	case LINUX_REBOOT_CMD_RESTART2:
+	case LINUX_REBOOT_CMD_RESTART:
+		pid_ns->reboot = SIGHUP;
+		break;
+
+	case LINUX_REBOOT_CMD_POWER_OFF:
+	case LINUX_REBOOT_CMD_HALT:
+		pid_ns->reboot = SIGINT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	read_lock(&tasklist_lock);
+	force_sig(SIGKILL, pid_ns->child_reaper);
+	read_unlock(&tasklist_lock);
+
+	do_exit(0);
+
+	/* Not reached */
+	return 0;
+}
+
 static __init int pid_namespaces_init(void)
 {
 	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
diff -puN kernel/sys.c~pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall kernel/sys.c
--- a/kernel/sys.c~pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall
+++ a/kernel/sys.c
@@ -444,6 +444,14 @@ SYSCALL_DEFINE4(reboot, int, magic1, int
 	                magic2 != LINUX_REBOOT_MAGIC2C))
 		return -EINVAL;
 
+	/* In case the pid namespaces are enabled, the current task is in a
+	 * child pid_namespace and the command is handled by 'reboot_pid_ns',
+	 * this one will invoke 'do_exit'.
+	 */
+	ret = reboot_pid_ns(task_active_pid_ns(current), cmd);
+	if (ret)
+		return ret;
+
 	/* Instead of trying to make the power_off code look like
 	 * halt when pm_power_off is not set do it the easy way.
 	 */
_
Subject: Subject: pidns: add reboot_pid_ns() to handle the reboot syscall

Patches currently in -mm which might be from daniel.lezcano@free.fr are

pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch

