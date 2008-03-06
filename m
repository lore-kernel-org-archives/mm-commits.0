From: akpm@linux-foundation.org
Subject: + devscontrol-add-a-mode-on-the-struct-probe.patch added to -mm tree
Date: Wed, 05 Mar 2008 17:16:31 -0800
Message-ID: <200803060116.m261GWg6001537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932168AbYCFBRW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 20:17:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, greg@kroah.com, kay.sievers@vrfy.org, menage@google.com, serue@us.ibm.com, sukadev@us.ibm.com


The patch titled
     devscontrol: add a mode on the struct probe
has been added to the -mm tree.  Its filename is
     devscontrol-add-a-mode-on-the-struct-probe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devscontrol: add a mode on the struct probe
From: Pavel Emelyanov <xemul@openvz.org>

The idea of the patchset is to make the dev_t to struct kobj mapping be
per-cgroup, and to provide a permission for this mapping.  This mode mask will
operate with FMODE_xxx modes.

To achieve this, I add the mode_t mode on the struct probe, which sets this
mapping, and move the locked part of the kobj_map() into a separate function,
which also accepts the mode to be set on the probe.

By default all the modes are provided for a map.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/map.c |   31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff -puN drivers/base/map.c~devscontrol-add-a-mode-on-the-struct-probe drivers/base/map.c
--- a/drivers/base/map.c~devscontrol-add-a-mode-on-the-struct-probe
+++ a/drivers/base/map.c
@@ -15,6 +15,7 @@
 #include <linux/kdev_t.h>
 #include <linux/kobject.h>
 #include <linux/kobj_map.h>
+#include <linux/fs.h>
 
 #define KOBJ_MAP_PROBES	255
 
@@ -22,6 +23,7 @@ struct kobj_map {
 	struct probe {
 		struct probe *next;
 		dev_t dev;
+		mode_t mode;
 		unsigned long range;
 		struct module *owner;
 		kobj_probe_t *get;
@@ -31,9 +33,9 @@ struct kobj_map {
 	struct mutex *lock;
 };
 
-int kobj_map(struct kobj_map *domain, dev_t dev, unsigned long range,
-	     struct module *module, kobj_probe_t *probe,
-	     int (*lock)(dev_t, void *), void *data)
+static int __kobj_map(struct kobj_map *domain, dev_t dev, mode_t mode,
+		unsigned long range, struct module *module,
+		kobj_probe_t *probe, int (*lock)(dev_t, void *), void *data)
 {
 	unsigned n = MAJOR(dev + range - 1) - MAJOR(dev) + 1;
 	unsigned index = MAJOR(dev);
@@ -55,8 +57,15 @@ int kobj_map(struct kobj_map *domain, de
 		p->dev = dev;
 		p->range = range;
 		p->data = data;
+		/*
+		 * When opening a device we want to (dis)allow only
+		 * read or write. But sys_open() can provide more
+		 * modes like lseek or pread. So, these FMODE-s are
+		 * always 'on'.
+		 */
+		p->mode = mode | FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
 	}
-	mutex_lock(domain->lock);
+
 	for (i = 0, p -= n; i < n; i++, p++, index++) {
 		struct probe **s = &domain->probes[index % KOBJ_MAP_PROBES];
 		while (*s && (*s)->range < range)
@@ -64,10 +73,22 @@ int kobj_map(struct kobj_map *domain, de
 		p->next = *s;
 		*s = p;
 	}
-	mutex_unlock(domain->lock);
 	return 0;
 }
 
+int kobj_map(struct kobj_map *domain, dev_t dev, unsigned long range,
+	     struct module *module, kobj_probe_t *probe,
+	     int (*lock)(dev_t, void *), void *data)
+{
+	int err;
+
+	mutex_lock(domain->lock);
+	err = __kobj_map(domain, dev, FMODE_READ | FMODE_WRITE, range,
+			module, probe, lock, data);
+	mutex_unlock(domain->lock);
+	return err;
+}
+
 void kobj_unmap(struct kobj_map *domain, dev_t dev, unsigned long range)
 {
 	unsigned n = MAJOR(dev + range - 1) - MAJOR(dev) + 1;
_

Patches currently in -mm which might be from xemul@openvz.org are

use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
git-udf.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
devscontrol-avoid-magic-constants-in-drivers-base-mapc.patch
devscontrol-clean-up-get_gendisk-a-bit.patch
devscontrol-add-a-mode-on-the-struct-probe.patch
devscontrol-make-kobj_lookup-return-the-mappings-permissions.patch
devscontrol-make-use-of-permissions-returned-by-kobj_lookup.patch
devscontrol-extend-the-drivers-base-mapc-functionality.patch
devscontrol-provide-functions-to-manipulate-char-device-mappings.patch
devscontrol-provide-functions-to-manipulate-block-device-mappings.patch
devscontrol-devices-accessibility-control-group-itself.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
deprecate-find_task_by_pid-warning-fix.patch
pidns-make-pid-level-and-pid_ns-level-unsigned.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

