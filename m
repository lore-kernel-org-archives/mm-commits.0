From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 07/54] kernel/sysctl: support setting sysctl
 parameters from kernel command line
Date: Sun, 07 Jun 2020 21:40:24 -0700
Message-ID: <20200608044024.wV814XBlP%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHEk0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:40:26 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, christian.brauner@ubuntu.com, ebiederm@xmission.com, gpiccoli@canonical.com, gregkh@linuxfoundation.org, ivan.teterevkov@nutanix.com, keescook@chromium.org, linux-mm@kvack.org, mcgrof@kernel.org, mhiramat@kernel.org, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com, tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org, yzaikin@google.com

From: Vlastimil Babka <vbabka@suse.cz>
Subject: kernel/sysctl: support setting sysctl parameters from kernel command line

Patch series "support setting sysctl parameters from kernel command line", v3.

This series adds support for something that seems like many people always
wanted but nobody added it yet, so here's the ability to set sysctl
parameters via kernel command line options in the form of
sysctl.vm.something=1

The important part is Patch 1.  The second, not so important part is an
attempt to clean up legacy one-off parameters that do the same thing as a
sysctl.  I don't want to remove them completely for compatibility reasons,
but with generic sysctl support the idea is to remove the one-off param
handlers and treat the parameters as aliases for the sysctl variants.

I have identified several parameters that mention sysctl counterparts in
Documentation/admin-guide/kernel-parameters.txt but there might be more. 
The conversion also has varying level of success:

- numa_zonelist_order is converted in Patch 2 together with adding the
  necessary infrastructure. It's easy as it doesn't really do anything but warn
  on deprecated value these days.
- hung_task_panic is converted in Patch 3, but there's a downside that now it
  only accepts 0 and 1, while previously it was any integer value
- nmi_watchdog maps to two sysctls nmi_watchdog and hardlockup_panic, so
  there's no straighforward conversion possible
- traceoff_on_warning is a flag without value and it would be required to
  handle that somehow in the conversion infractructure, which seems pointless
  for a single flag


This patch (of 5):

A recently proposed patch to add vm_swappiness command line parameter in
addition to existing sysctl [1] made me wonder why we don't have a general
support for passing sysctl parameters via command line.  Googling found
only somebody else wondering the same [2], but I haven't found any prior
discussion with reasons why not to do this.

Settings the vm_swappiness issue aside (the underlying issue might be
solved in a different way), quick search of kernel-parameters.txt shows
there are already some that exist as both sysctl and kernel parameter -
hung_task_panic, nmi_watchdog, numa_zonelist_order, traceoff_on_warning. 
A general mechanism would remove the need to add more of those one-offs
and might be handy in situations where configuration by e.g. 
/etc/sysctl.d/ is impractical.

Hence, this patch adds a new parse_args() pass that looks for parameters
prefixed by 'sysctl.' and tries to interpret them as writes to the
corresponding sys/ files using an temporary in-kernel procfs mount.  This
mechanism was suggested by Eric W.  Biederman [3], as it handles all
dynamically registered sysctl tables, even though we don't handle modular
sysctls.  Errors due to e.g.  invalid parameter name or value are reported
in the kernel log.

The processing is hooked right before the init process is loaded, as some
handlers might be more complicated than simple setters and might need some
subsystems to be initialized.  At the moment the init process can be
started and eventually execute a process writing to /proc/sys/ then it
should be also fine to do that from the kernel.

Sysctls registered later on module load time are not set by this mechanism
- it's expected that in such scenarios, setting sysctl values from
userspace is practical enough.

[1] https://lore.kernel.org/r/BL0PR02MB560167492CA4094C91589930E9FC0@BL0PR02MB5601.namprd02.prod.outlook.com/
[2] https://unix.stackexchange.com/questions/558802/how-to-set-sysctl-using-kernel-command-line-parameter
[3] https://lore.kernel.org/r/87bloj2skm.fsf@x220.int.ebiederm.org/

Link: http://lkml.kernel.org/r/20200427180433.7029-1-vbabka@suse.cz
Link: http://lkml.kernel.org/r/20200427180433.7029-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Ivan Teterevkov <ivan.teterevkov@nutanix.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: "Guilherme G . Piccoli" <gpiccoli@canonical.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    9 +
 fs/proc/proc_sysctl.c                           |  107 ++++++++++++++
 include/linux/sysctl.h                          |    4 
 init/main.c                                     |    2 
 4 files changed, 122 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.txt~kernel-sysctl-support-setting-sysctl-parameters-from-kernel-command-line
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -4969,6 +4969,15 @@
 
 	switches=	[HW,M68k]
 
+	sysctl.*=	[KNL]
+			Set a sysctl parameter, right before loading the init
+			process, as if the value was written to the respective
+			/proc/sys/... file. Both '.' and '/' are recognized as
+			separators. Unrecognized parameters and invalid values
+			are reported in the kernel log. Sysctls registered
+			later by a loaded module cannot be set this way.
+			Example: sysctl.vm.swappiness=40
+
 	sysfs.deprecated=0|1 [KNL]
 			Enable/disable old style sysfs layout for old udev
 			on older distributions. When this option is enabled
--- a/fs/proc/proc_sysctl.c~kernel-sysctl-support-setting-sysctl-parameters-from-kernel-command-line
+++ a/fs/proc/proc_sysctl.c
@@ -14,6 +14,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/bpf-cgroup.h>
+#include <linux/mount.h>
 #include "internal.h"
 
 static const struct dentry_operations proc_sys_dentry_operations;
@@ -1703,3 +1704,109 @@ int __init proc_sys_init(void)
 
 	return sysctl_init();
 }
+
+/* Set sysctl value passed on kernel command line. */
+static int process_sysctl_arg(char *param, char *val,
+			       const char *unused, void *arg)
+{
+	char *path;
+	struct vfsmount **proc_mnt = arg;
+	struct file_system_type *proc_fs_type;
+	struct file *file;
+	int len;
+	int err;
+	loff_t pos = 0;
+	ssize_t wret;
+
+	if (strncmp(param, "sysctl", sizeof("sysctl") - 1))
+		return 0;
+
+	param += sizeof("sysctl") - 1;
+
+	if (param[0] != '/' && param[0] != '.')
+		return 0;
+
+	param++;
+
+	/*
+	 * To set sysctl options, we use a temporary mount of proc, look up the
+	 * respective sys/ file and write to it. To avoid mounting it when no
+	 * options were given, we mount it only when the first sysctl option is
+	 * found. Why not a persistent mount? There are problems with a
+	 * persistent mount of proc in that it forces userspace not to use any
+	 * proc mount options.
+	 */
+	if (!*proc_mnt) {
+		proc_fs_type = get_fs_type("proc");
+		if (!proc_fs_type) {
+			pr_err("Failed to find procfs to set sysctl from command line\n");
+			return 0;
+		}
+		*proc_mnt = kern_mount(proc_fs_type);
+		put_filesystem(proc_fs_type);
+		if (IS_ERR(*proc_mnt)) {
+			pr_err("Failed to mount procfs to set sysctl from command line\n");
+			return 0;
+		}
+	}
+
+	path = kasprintf(GFP_KERNEL, "sys/%s", param);
+	if (!path)
+		panic("%s: Failed to allocate path for %s\n", __func__, param);
+	strreplace(path, '.', '/');
+
+	file = file_open_root((*proc_mnt)->mnt_root, *proc_mnt, path, O_WRONLY, 0);
+	if (IS_ERR(file)) {
+		err = PTR_ERR(file);
+		if (err == -ENOENT)
+			pr_err("Failed to set sysctl parameter '%s=%s': parameter not found\n",
+				param, val);
+		else if (err == -EACCES)
+			pr_err("Failed to set sysctl parameter '%s=%s': permission denied (read-only?)\n",
+				param, val);
+		else
+			pr_err("Error %pe opening proc file to set sysctl parameter '%s=%s'\n",
+				file, param, val);
+		goto out;
+	}
+	len = strlen(val);
+	wret = kernel_write(file, val, len, &pos);
+	if (wret < 0) {
+		err = wret;
+		if (err == -EINVAL)
+			pr_err("Failed to set sysctl parameter '%s=%s': invalid value\n",
+				param, val);
+		else
+			pr_err("Error %pe writing to proc file to set sysctl parameter '%s=%s'\n",
+				ERR_PTR(err), param, val);
+	} else if (wret != len) {
+		pr_err("Wrote only %zd bytes of %d writing to proc file %s to set sysctl parameter '%s=%s\n",
+			wret, len, path, param, val);
+	}
+
+	err = filp_close(file, NULL);
+	if (err)
+		pr_err("Error %pe closing proc file to set sysctl parameter '%s=%s\n",
+			ERR_PTR(err), param, val);
+out:
+	kfree(path);
+	return 0;
+}
+
+void do_sysctl_args(void)
+{
+	char *command_line;
+	struct vfsmount *proc_mnt = NULL;
+
+	command_line = kstrdup(saved_command_line, GFP_KERNEL);
+	if (!command_line)
+		panic("%s: Failed to allocate copy of command line\n", __func__);
+
+	parse_args("Setting sysctl args", command_line,
+		   NULL, 0, -1, -1, &proc_mnt, process_sysctl_arg);
+
+	if (proc_mnt)
+		kern_unmount(proc_mnt);
+
+	kfree(command_line);
+}
--- a/include/linux/sysctl.h~kernel-sysctl-support-setting-sysctl-parameters-from-kernel-command-line
+++ a/include/linux/sysctl.h
@@ -197,6 +197,7 @@ struct ctl_table_header *register_sysctl
 void unregister_sysctl_table(struct ctl_table_header * table);
 
 extern int sysctl_init(void);
+void do_sysctl_args(void);
 
 extern int pwrsw_enabled;
 extern int unaligned_enabled;
@@ -235,6 +236,9 @@ static inline void setup_sysctl_set(stru
 {
 }
 
+static inline void do_sysctl_args(void)
+{
+}
 #endif /* CONFIG_SYSCTL */
 
 int sysctl_max_threads(struct ctl_table *table, int write, void *buffer,
--- a/init/main.c~kernel-sysctl-support-setting-sysctl-parameters-from-kernel-command-line
+++ a/init/main.c
@@ -1412,6 +1412,8 @@ static int __ref kernel_init(void *unuse
 
 	rcu_end_inkernel_boot();
 
+	do_sysctl_args();
+
 	if (ramdisk_execute_command) {
 		ret = run_init_process(ramdisk_execute_command);
 		if (!ret)
_
