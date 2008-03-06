From: akpm@linux-foundation.org
Subject: + devscontrol-provide-functions-to-manipulate-char-device-mappings.patch added to -mm tree
Date: Wed, 05 Mar 2008 17:16:39 -0800
Message-ID: <200803060116.m261GeSg001553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765733AbYCFBRL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 20:17:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, greg@kroah.com, kay.sievers@vrfy.org, menage@google.com, serue@us.ibm.com, sukadev@us.ibm.com


The patch titled
     devscontrol: provide functions to manipulate char device mappings
has been added to the -mm tree.  Its filename is
     devscontrol-provide-functions-to-manipulate-char-device-mappings.patch

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
Subject: devscontrol: provide functions to manipulate char device mappings
From: Pavel Emelyanov <xemul@openvz.org>

The character devices currently have a global map for devices and their own
locks and callbacks for device probing.  So here are the functions that
provide the way to play with character devices maps.

They are cdev_map_init/cdev_map_fini to create/destroy one,
cdev_add_to_map/cdev_del_from_map to map/unmap devices, and cdev_iterate_map
for uniformity.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/char_dev.c        |   63 +++++++++++++++++++++++++++++++++++++++++
 include/linux/cdev.h |    7 ++++
 2 files changed, 70 insertions(+)

diff -puN fs/char_dev.c~devscontrol-provide-functions-to-manipulate-char-device-mappings fs/char_dev.c
--- a/fs/char_dev.c~devscontrol-provide-functions-to-manipulate-char-device-mappings
+++ a/fs/char_dev.c
@@ -476,6 +476,69 @@ int cdev_add(struct cdev *p, dev_t dev, 
 	return kobj_map(cdev_map, dev, count, NULL, exact_match, exact_lock, p);
 }
 
+#ifdef CONFIG_CGROUP_DEVS
+int cdev_add_to_map(struct kobj_map *map, dev_t dev, int all, mode_t mode)
+{
+	int tmp;
+	struct kobject *k;
+	struct cdev *c;
+
+	k = kobj_lookup(cdev_map, dev, NULL, &tmp);
+	if (k == NULL)
+		return -ENODEV;
+
+	c = container_of(k, struct cdev, kobj);
+	tmp = kobj_remap(map, dev, mode, all ? MINORMASK : 1, NULL,
+			exact_match, exact_lock, c);
+	if (tmp < 0) {
+		cdev_put(c);
+		return tmp;
+	}
+
+	return 0;
+}
+
+int cdev_del_from_map(struct kobj_map *map, dev_t dev, int all)
+{
+	int tmp;
+	struct kobject *k;
+	struct cdev *c;
+
+	k = kobj_lookup(map, dev, NULL, &tmp);
+	if (k == NULL)
+		return -ENODEV;
+
+	c = container_of(k, struct cdev, kobj);
+	kobj_unmap(map, dev, all ? MINORMASK : 1);
+
+	/*
+	 * one put for the kobj_lookup above and one for
+	 * the kobj_lookup in cdev_add_to_map
+	 */
+	cdev_put(c);
+	cdev_put(c);
+	return 0;
+}
+
+void cdev_iterate_map(struct kobj_map *map,
+		int (*fn)(dev_t, int, mode_t, void *), void *x)
+{
+	kobj_map_iterate(map, fn, x);
+}
+
+static struct kobject *base_probe(dev_t dev, int *part, void *data);
+
+struct kobj_map *cdev_map_init(void)
+{
+	return kobj_map_init(base_probe, &chrdevs_lock);
+}
+
+void cdev_map_fini(struct kobj_map *map)
+{
+	kobj_map_fini(map);
+}
+#endif
+
 static void cdev_unmap(dev_t dev, unsigned count)
 {
 	kobj_unmap(cdev_map, dev, count);
diff -puN include/linux/cdev.h~devscontrol-provide-functions-to-manipulate-char-device-mappings include/linux/cdev.h
--- a/include/linux/cdev.h~devscontrol-provide-functions-to-manipulate-char-device-mappings
+++ a/include/linux/cdev.h
@@ -33,5 +33,12 @@ void cd_forget(struct inode *);
 
 extern struct backing_dev_info directly_mappable_cdev_bdi;
 
+struct kobj_map;
+int cdev_add_to_map(struct kobj_map *map, dev_t dev, int all, mode_t mode);
+int cdev_del_from_map(struct kobj_map *map, dev_t dev, int all);
+struct kobj_map *cdev_map_init(void);
+void cdev_map_fini(struct kobj_map *map);
+void cdev_iterate_map(struct kobj_map *,
+		int (*fn)(dev_t, int, mode_t, void *), void *);
 #endif
 #endif
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

