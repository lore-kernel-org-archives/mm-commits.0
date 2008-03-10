From: akpm@linux-foundation.org
Subject: - devscontrol-extend-the-drivers-base-mapc-functionality.patch removed from -mm tree
Date: Mon, 10 Mar 2008 12:38:35 -0700
Message-ID: <200803101938.m2AJcZ1B001961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752241AbYCJTjk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:39:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, greg@kroah.com, kay.sievers@vrfy.org, menage@google.com, serue@us.ibm.com, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     devscontrol: extend the drivers/base/map.c functionality
has been removed from the -mm tree.  Its filename was
     devscontrol-extend-the-drivers-base-mapc-functionality.patch

This patch was dropped because of bunfight

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devscontrol: extend the drivers/base/map.c functionality
From: Pavel Emelyanov <xemul@openvz.org>

This includes the following functions:

1. kobj_remap - this one will change the mapping's permissions
   or add a new one if required.

2. kobj_map_iterate will walk the map, calling the callback
   on each element.

3. kobj_map_fini is a rollback for kobj_map_finid - cleans all
   the mappings.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/map.c       |   84 +++++++++++++++++++++++++++++++++++++
 include/linux/kobj_map.h |    6 ++
 2 files changed, 90 insertions(+)

diff -puN drivers/base/map.c~devscontrol-extend-the-drivers-base-mapc-functionality drivers/base/map.c
--- a/drivers/base/map.c~devscontrol-extend-the-drivers-base-mapc-functionality
+++ a/drivers/base/map.c
@@ -181,3 +181,87 @@ struct kobj_map *kobj_map_init(kobj_prob
 	p->lock = lock;
 	return p;
 }
+
+#ifdef CONFIG_CGROUP_DEVS
+int kobj_remap(struct kobj_map *domain, dev_t dev, mode_t mode,
+		unsigned long range, struct module *module,
+		kobj_probe_t *probe, int (*lock)(dev_t, void *), void *data)
+{
+	unsigned n = MAJOR(dev + range - 1) - MAJOR(dev) + 1;
+	unsigned index = MAJOR(dev);
+	unsigned i;
+	int err = -ESRCH;
+
+	if (n > KOBJ_MAP_PROBES)
+		n = KOBJ_MAP_PROBES;
+
+	mutex_lock(domain->lock);
+	for (i = 0; i < n; i++, index++) {
+		struct probe **s;
+		for (s = &domain->probes[index % KOBJ_MAP_PROBES];
+				*s; s = &(*s)->next) {
+			struct probe *p = *s;
+			if (p->dev == dev) {
+				p->mode = mode | FMODE_LSEEK |
+					FMODE_PREAD | FMODE_PWRITE;
+				err = 0;
+				break;
+			}
+		}
+	}
+
+	if (err)
+		err = __kobj_map(domain, dev, mode, range, module,
+				probe, lock, data);
+	mutex_unlock(domain->lock);
+	return err;
+}
+
+void kobj_map_iterate(struct kobj_map *domain,
+		int (*fn)(dev_t, int, mode_t, void *), void *arg)
+{
+	int i;
+	struct probe *p;
+	dev_t skip = MKDEV(0, 0);
+
+	mutex_lock(domain->lock);
+	for (i = 0; i < KOBJ_MAP_PROBES; i++) {
+		p = domain->probes[i];
+		while (p != NULL) {
+			if (p->dev == skip)
+				goto next;
+			/*
+			 * this 'device' is special - see the kobj_map_init why
+			 */
+			if (p->dev == 1)
+				goto next;
+
+			skip = p->dev;
+			if (fn(p->dev, p->range, p->mode, arg))
+				goto done;
+next:
+			p = p->next;
+		}
+	}
+done:
+	mutex_unlock(domain->lock);
+}
+
+void kobj_map_fini(struct kobj_map *map)
+{
+	int i;
+	struct probe *p, *next;
+
+	for (i = 0; i < KOBJ_MAP_PROBES; i++) {
+		p = map->probes[i];
+		while (p->next != NULL) {
+			next = p->next;
+			kfree(p);
+			p = next;
+		}
+	}
+
+	kfree(p);
+	kfree(map);
+}
+#endif
diff -puN include/linux/kobj_map.h~devscontrol-extend-the-drivers-base-mapc-functionality include/linux/kobj_map.h
--- a/include/linux/kobj_map.h~devscontrol-extend-the-drivers-base-mapc-functionality
+++ a/include/linux/kobj_map.h
@@ -11,4 +11,10 @@ void kobj_unmap(struct kobj_map *, dev_t
 struct kobject *kobj_lookup(struct kobj_map *, dev_t, mode_t *, int *);
 struct kobj_map *kobj_map_init(kobj_probe_t *, struct mutex *);
 
+void kobj_map_iterate(struct kobj_map *, int (*fn)(dev_t, int, mode_t, void *),
+		void *);
+int kobj_remap(struct kobj_map *, dev_t, mode_t, unsigned long, struct module *,
+	     kobj_probe_t *, int (*)(dev_t, void *), void *);
+void kobj_map_fini(struct kobj_map *);
+
 #endif
_

Patches currently in -mm which might be from xemul@openvz.org are

git-kgdb-light.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-getpid-and-set_tid_address-fast-system-calls-for-pid-namespaces.patch
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
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch
memory-controller-make-memory-resource-control-aware-of-boot-options.patch
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
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
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

