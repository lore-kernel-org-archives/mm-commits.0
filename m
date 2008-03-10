From: akpm@linux-foundation.org
Subject: - devscontrol-avoid-magic-constants-in-drivers-base-mapc.patch removed from -mm tree
Date: Mon, 10 Mar 2008 12:38:20 -0700
Message-ID: <200803101938.m2AJcKFn001939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859AbYCJToR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:44:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, menage@google.com, serue@us.ibm.com, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     devscontrol: avoid magic constants in drivers/base/map.c
has been removed from the -mm tree.  Its filename was
     devscontrol-avoid-magic-constants-in-drivers-base-mapc.patch

This patch was dropped because of bunfight

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devscontrol: avoid magic constants in drivers/base/map.c
From: Pavel Emelyanov <xemul@openvz.org>

Devices accessibility control group

This controller allows to tune the devices accessibility by tasks, i.e.  grant
full access for /dev/null, /dev/zero etc, grant read-only access to IDE
devices and completely hide SCSI disks.

Tasks still can call mknod to create device files, regardless of whether the
particular device is visible or accessible, but they may not be able to open
it later.

This one hides under CONFIG_CGROUP_DEVS option.

To play with it - run a standard procedure:

 # mount -t container none /cont/devs -o devices
 # mkdir /cont/devs/0
 # echo -n $$ > /cont/devs/0/tasks

and tune device permissions.

The only configuration file called devices.permissions accepts strings like
'[cb] <major>:(<minor>|*) [r-][w-]' to provide read, write or read-write
access to a particular device.  Asterisk as the minor means "all devices with
a given major".

This will be described in Documentation/controllers/devices.txt
file in more details.



This patch:

The number of chains in the kobj_map structure is hard-coded with a magic
constant of 255.  Make a named one instead.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/map.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/base/map.c~devscontrol-avoid-magic-constants-in-drivers-base-mapc drivers/base/map.c
--- a/drivers/base/map.c~devscontrol-avoid-magic-constants-in-drivers-base-mapc
+++ a/drivers/base/map.c
@@ -16,6 +16,8 @@
 #include <linux/kobject.h>
 #include <linux/kobj_map.h>
 
+#define KOBJ_MAP_PROBES	255
+
 struct kobj_map {
 	struct probe {
 		struct probe *next;
@@ -25,7 +27,7 @@ struct kobj_map {
 		kobj_probe_t *get;
 		int (*lock)(dev_t, void *);
 		void *data;
-	} *probes[255];
+	} *probes[KOBJ_MAP_PROBES];
 	struct mutex *lock;
 };
 
@@ -38,8 +40,8 @@ int kobj_map(struct kobj_map *domain, de
 	unsigned i;
 	struct probe *p;
 
-	if (n > 255)
-		n = 255;
+	if (n > KOBJ_MAP_PROBES)
+		n = KOBJ_MAP_PROBES;
 
 	p = kmalloc(sizeof(struct probe) * n, GFP_KERNEL);
 
@@ -56,7 +58,7 @@ int kobj_map(struct kobj_map *domain, de
 	}
 	mutex_lock(domain->lock);
 	for (i = 0, p -= n; i < n; i++, p++, index++) {
-		struct probe **s = &domain->probes[index % 255];
+		struct probe **s = &domain->probes[index % KOBJ_MAP_PROBES];
 		while (*s && (*s)->range < range)
 			s = &(*s)->next;
 		p->next = *s;
@@ -73,13 +75,14 @@ void kobj_unmap(struct kobj_map *domain,
 	unsigned i;
 	struct probe *found = NULL;
 
-	if (n > 255)
-		n = 255;
+	if (n > KOBJ_MAP_PROBES)
+		n = KOBJ_MAP_PROBES;
 
 	mutex_lock(domain->lock);
 	for (i = 0; i < n; i++, index++) {
 		struct probe **s;
-		for (s = &domain->probes[index % 255]; *s; s = &(*s)->next) {
+		for (s = &domain->probes[index % KOBJ_MAP_PROBES];
+				*s; s = &(*s)->next) {
 			struct probe *p = *s;
 			if (p->dev == dev && p->range == range) {
 				*s = p->next;
@@ -101,7 +104,7 @@ struct kobject *kobj_lookup(struct kobj_
 
 retry:
 	mutex_lock(domain->lock);
-	for (p = domain->probes[MAJOR(dev) % 255]; p; p = p->next) {
+	for (p = domain->probes[MAJOR(dev) % KOBJ_MAP_PROBES]; p; p = p->next) {
 		struct kobject *(*probe)(dev_t, int *, void *);
 		struct module *owner;
 		void *data;
@@ -148,7 +151,7 @@ struct kobj_map *kobj_map_init(kobj_prob
 	base->dev = 1;
 	base->range = ~0;
 	base->get = base_probe;
-	for (i = 0; i < 255; i++)
+	for (i = 0; i < KOBJ_MAP_PROBES; i++)
 		p->probes[i] = base;
 	p->lock = lock;
 	return p;
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

