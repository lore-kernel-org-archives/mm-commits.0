From: akpm@linux-foundation.org
Subject: + fs-dlm-configc-choose-better-identifiers.patch added to -mm tree
Date: Tue, 02 Sep 2008 21:40:59 -0700
Message-ID: <200809030454.m834sYwX030095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751219AbYICEyv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 00:54:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ccaulfie@redhat.com, teigland@redhat.com


The patch titled
     fs/dlm/config.c: choose better identifiers
has been added to the -mm tree.  Its filename is
     fs-dlm-configc-choose-better-identifiers.patch

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
Subject: fs/dlm/config.c: choose better identifiers
From: Andrew Morton <akpm@linux-foundation.org>

sparc32:

fs/dlm/config.c:397: error: expected identifier or '(' before '{' token
fs/dlm/config.c: In function 'drop_node':
fs/dlm/config.c:589: warning: initialization from incompatible pointer type
fs/dlm/config.c:589: warning: initialization from incompatible pointer type
fs/dlm/config.c: In function 'release_node':
fs/dlm/config.c:601: warning: initialization from incompatible pointer type
fs/dlm/config.c:601: warning: initialization from incompatible pointer type
fs/dlm/config.c: In function 'show_node':
fs/dlm/config.c:717: warning: initialization from incompatible pointer type
fs/dlm/config.c:717: warning: initialization from incompatible pointer type
fs/dlm/config.c: In function 'store_node':
fs/dlm/config.c:726: warning: initialization from incompatible pointer type
fs/dlm/config.c:726: warning: initialization from incompatible pointer type

Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/config.c |   44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff -puN fs/dlm/config.c~fs-dlm-configc-choose-better-identifiers fs/dlm/config.c
--- a/fs/dlm/config.c~fs-dlm-configc-choose-better-identifiers
+++ a/fs/dlm/config.c
@@ -377,24 +377,24 @@ static struct config_item_type node_type
 	.ct_owner = THIS_MODULE,
 };
 
-static struct dlm_cluster *to_cluster(struct config_item *i)
+static struct dlm_cluster *config_item_to_cluster(struct config_item *i)
 {
 	return i ? container_of(to_config_group(i), struct dlm_cluster, group) :
 		   NULL;
 }
 
-static struct dlm_space *to_space(struct config_item *i)
+static struct dlm_space *config_item_to_space(struct config_item *i)
 {
 	return i ? container_of(to_config_group(i), struct dlm_space, group) :
 		   NULL;
 }
 
-static struct dlm_comm *to_comm(struct config_item *i)
+static struct dlm_comm *config_item_to_comm(struct config_item *i)
 {
 	return i ? container_of(i, struct dlm_comm, item) : NULL;
 }
 
-static struct dlm_node *to_node(struct config_item *i)
+static struct dlm_node *config_item_to_node(struct config_item *i)
 {
 	return i ? container_of(i, struct dlm_node, item) : NULL;
 }
@@ -450,7 +450,7 @@ static struct config_group *make_cluster
 
 static void drop_cluster(struct config_group *g, struct config_item *i)
 {
-	struct dlm_cluster *cl = to_cluster(i);
+	struct dlm_cluster *cl = config_item_to_cluster(i);
 	struct config_item *tmp;
 	int j;
 
@@ -468,7 +468,7 @@ static void drop_cluster(struct config_g
 
 static void release_cluster(struct config_item *i)
 {
-	struct dlm_cluster *cl = to_cluster(i);
+	struct dlm_cluster *cl = config_item_to_cluster(i);
 	kfree(cl->group.default_groups);
 	kfree(cl);
 }
@@ -507,7 +507,7 @@ static struct config_group *make_space(s
 
 static void drop_space(struct config_group *g, struct config_item *i)
 {
-	struct dlm_space *sp = to_space(i);
+	struct dlm_space *sp = config_item_to_space(i);
 	struct config_item *tmp;
 	int j;
 
@@ -524,7 +524,7 @@ static void drop_space(struct config_gro
 
 static void release_space(struct config_item *i)
 {
-	struct dlm_space *sp = to_space(i);
+	struct dlm_space *sp = config_item_to_space(i);
 	kfree(sp->group.default_groups);
 	kfree(sp);
 }
@@ -546,7 +546,7 @@ static struct config_item *make_comm(str
 
 static void drop_comm(struct config_group *g, struct config_item *i)
 {
-	struct dlm_comm *cm = to_comm(i);
+	struct dlm_comm *cm = config_item_to_comm(i);
 	if (local_comm == cm)
 		local_comm = NULL;
 	dlm_lowcomms_close(cm->nodeid);
@@ -557,13 +557,13 @@ static void drop_comm(struct config_grou
 
 static void release_comm(struct config_item *i)
 {
-	struct dlm_comm *cm = to_comm(i);
+	struct dlm_comm *cm = config_item_to_comm(i);
 	kfree(cm);
 }
 
 static struct config_item *make_node(struct config_group *g, const char *name)
 {
-	struct dlm_space *sp = to_space(g->cg_item.ci_parent);
+	struct dlm_space *sp = config_item_to_space(g->cg_item.ci_parent);
 	struct dlm_node *nd;
 
 	nd = kzalloc(sizeof(struct dlm_node), GFP_KERNEL);
@@ -585,8 +585,8 @@ static struct config_item *make_node(str
 
 static void drop_node(struct config_group *g, struct config_item *i)
 {
-	struct dlm_space *sp = to_space(g->cg_item.ci_parent);
-	struct dlm_node *nd = to_node(i);
+	struct dlm_space *sp = config_item_to_space(g->cg_item.ci_parent);
+	struct dlm_node *nd = config_item_to_node(i);
 
 	mutex_lock(&sp->members_lock);
 	list_del(&nd->list);
@@ -598,7 +598,7 @@ static void drop_node(struct config_grou
 
 static void release_node(struct config_item *i)
 {
-	struct dlm_node *nd = to_node(i);
+	struct dlm_node *nd = config_item_to_node(i);
 	kfree(nd);
 }
 
@@ -632,7 +632,7 @@ void dlm_config_exit(void)
 static ssize_t show_cluster(struct config_item *i, struct configfs_attribute *a,
 			    char *buf)
 {
-	struct dlm_cluster *cl = to_cluster(i);
+	struct dlm_cluster *cl = config_item_to_cluster(i);
 	struct cluster_attribute *cla =
 			container_of(a, struct cluster_attribute, attr);
 	return cla->show ? cla->show(cl, buf) : 0;
@@ -642,7 +642,7 @@ static ssize_t store_cluster(struct conf
 			     struct configfs_attribute *a,
 			     const char *buf, size_t len)
 {
-	struct dlm_cluster *cl = to_cluster(i);
+	struct dlm_cluster *cl = config_item_to_cluster(i);
 	struct cluster_attribute *cla =
 		container_of(a, struct cluster_attribute, attr);
 	return cla->store ? cla->store(cl, buf, len) : -EINVAL;
@@ -651,7 +651,7 @@ static ssize_t store_cluster(struct conf
 static ssize_t show_comm(struct config_item *i, struct configfs_attribute *a,
 			 char *buf)
 {
-	struct dlm_comm *cm = to_comm(i);
+	struct dlm_comm *cm = config_item_to_comm(i);
 	struct comm_attribute *cma =
 			container_of(a, struct comm_attribute, attr);
 	return cma->show ? cma->show(cm, buf) : 0;
@@ -660,7 +660,7 @@ static ssize_t show_comm(struct config_i
 static ssize_t store_comm(struct config_item *i, struct configfs_attribute *a,
 			  const char *buf, size_t len)
 {
-	struct dlm_comm *cm = to_comm(i);
+	struct dlm_comm *cm = config_item_to_comm(i);
 	struct comm_attribute *cma =
 		container_of(a, struct comm_attribute, attr);
 	return cma->store ? cma->store(cm, buf, len) : -EINVAL;
@@ -714,7 +714,7 @@ static ssize_t comm_addr_write(struct dl
 static ssize_t show_node(struct config_item *i, struct configfs_attribute *a,
 			 char *buf)
 {
-	struct dlm_node *nd = to_node(i);
+	struct dlm_node *nd = config_item_to_node(i);
 	struct node_attribute *nda =
 			container_of(a, struct node_attribute, attr);
 	return nda->show ? nda->show(nd, buf) : 0;
@@ -723,7 +723,7 @@ static ssize_t show_node(struct config_i
 static ssize_t store_node(struct config_item *i, struct configfs_attribute *a,
 			  const char *buf, size_t len)
 {
-	struct dlm_node *nd = to_node(i);
+	struct dlm_node *nd = config_item_to_node(i);
 	struct node_attribute *nda =
 		container_of(a, struct node_attribute, attr);
 	return nda->store ? nda->store(nd, buf, len) : -EINVAL;
@@ -768,7 +768,7 @@ static struct dlm_space *get_space(char 
 	i = config_group_find_item(space_list, name);
 	mutex_unlock(&space_list->cg_subsys->su_mutex);
 
-	return to_space(i);
+	return config_item_to_space(i);
 }
 
 static void put_space(struct dlm_space *sp)
@@ -788,7 +788,7 @@ static struct dlm_comm *get_comm(int nod
 	mutex_lock(&clusters_root.subsys.su_mutex);
 
 	list_for_each_entry(i, &comm_list->cg_children, ci_entry) {
-		cm = to_comm(i);
+		cm = config_item_to_comm(i);
 
 		if (nodeid) {
 			if (cm->nodeid != nodeid)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

vfs-fix-dio-write-returning-eio-when-try_to_release_page-fails.patch
acer-wmi-remove-debugfs-entries-upon-unloading.patch
drivers-char-randomc-fix-a-race-which-can-lead-to-a-bogus-bug.patch
linux-next.patch
next-remove-localversion.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable.patch
linux-next-git-rejects.patch
acpi-ec-dont-degrade-to-poll-mode-at-storm-automatically-cleanup.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix.patch
toshiba_acpi-add-support-for-bluetooth-toggling-through-rfkill-v7-fix-fix.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
x86-make-poll_idle-behave-more-like-the-other-idle-methods-checkpatch-fixes.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
fs-sysfs-dirc-remove-unused-__sysfs_get_dentry.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
git-jg-misc.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver-fix.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-checkpatch-fixes.patch
e1000e-avoid-duplicated-output-of-device-name-in-kernel-warning-fix.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2-checkpatch-fixes.patch
pci-tidy-pme-support-messages-checkpatch-fixes.patch
scsi-gdthc-use-unaligned-access-helpers.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
git-xtensa.patch
modules-remove-stop_machine-during-module-load-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
e1000e-prevent-corruption-of-eeprom-nvm.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix.patch
fix-a-race-condtion-of-oops_in_progress-fix.patch
vsprintf-use-new-vsprintf-symbolic-function-pointer-format-cleanup.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
gru-driver-minor-updates-fix.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
nilfs2-continuous-snapshotting-file-system-fix.patch
nilfs2-continuous-snapshotting-file-system-fix-fix-2.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch
fs-dlm-configc-choose-better-identifiers.patch

