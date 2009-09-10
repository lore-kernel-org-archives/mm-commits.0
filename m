From: akpm@linux-foundation.org
Subject: + hugetlb-add-per-node-hstate-attributes-fix.patch added to -mm tree
Date: Thu, 10 Sep 2009 16:32:49 -0700
Message-ID: <200909102332.n8ANWnBg007687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470AbZIJXdu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Sep 2009 19:33:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, agl@us.ibm.com, andi@firstfloor.org, apw@canonical.com, cl@linux-foundation.org, lee.schermerhorn@hp.com, mel@csn.ul.ie, nacc@us.ibm.com, rientjes@google.com


The patch titled
     hugetlb-add-per-node-hstate-attributes-fix
has been added to the -mm tree.  Its filename is
     hugetlb-add-per-node-hstate-attributes-fix.patch

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
Subject: hugetlb-add-per-node-hstate-attributes-fix
From: Andrew Morton <akpm@linux-foundation.org>

be more conventional with typedefs

Cc: Adam Litke <agl@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c  |   14 +++++++-------
 include/linux/node.h |   10 +++++-----
 2 files changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/base/node.c~hugetlb-add-per-node-hstate-attributes-fix drivers/base/node.c
--- a/drivers/base/node.c~hugetlb-add-per-node-hstate-attributes-fix
+++ a/drivers/base/node.c
@@ -180,14 +180,14 @@ static SYSDEV_ATTR(distance, S_IRUGO, no
 /*
  * hugetlbfs per node attributes registration interface:
  * When/if hugetlb[fs] subsystem initializes [sometime after this module],
- * it will register it's per node attributes for all nodes on-line at that
- * point.  It will also call register_hugetlbfs_with_node(), below, to
- * register it's attribute registration functions with this node driver.
+ * it will register its per node attributes for all nodes online at that
+ * time.  It will also call register_hugetlbfs_with_node(), below, to
+ * register its attribute registration functions with this node driver.
  * Once these hooks have been initialized, the node driver will call into
  * the hugetlb module to [un]register attributes for hot-plugged nodes.
  */
-NODE_REGISTRATION_FUNC __hugetlb_register_node;
-NODE_REGISTRATION_FUNC __hugetlb_unregister_node;
+static node_registration_func_t __hugetlb_register_node;
+static node_registration_func_t __hugetlb_unregister_node;
 
 static inline void hugetlb_register_node(struct node *node)
 {
@@ -201,8 +201,8 @@ static inline void hugetlb_unregister_no
 		__hugetlb_unregister_node(node);
 }
 
-void register_hugetlbfs_with_node(NODE_REGISTRATION_FUNC doregister,
-				  NODE_REGISTRATION_FUNC unregister)
+void register_hugetlbfs_with_node(node_registration_func_t doregister,
+				  node_registration_func_t unregister)
 {
 	__hugetlb_register_node   = doregister;
 	__hugetlb_unregister_node = unregister;
diff -puN include/linux/node.h~hugetlb-add-per-node-hstate-attributes-fix include/linux/node.h
--- a/include/linux/node.h~hugetlb-add-per-node-hstate-attributes-fix
+++ a/include/linux/node.h
@@ -28,7 +28,7 @@ struct node {
 
 struct memory_block;
 extern struct node node_devices[];
-typedef  void (*NODE_REGISTRATION_FUNC)(struct node *);
+typedef  void (*node_registration_func_t)(struct node *);
 
 extern int register_node(struct node *, int, struct node *);
 extern void unregister_node(struct node *node);
@@ -40,8 +40,8 @@ extern int unregister_cpu_under_node(uns
 extern int register_mem_sect_under_node(struct memory_block *mem_blk,
 						int nid);
 extern int unregister_mem_sect_under_nodes(struct memory_block *mem_blk);
-extern void register_hugetlbfs_with_node(NODE_REGISTRATION_FUNC doregister,
-					 NODE_REGISTRATION_FUNC unregister);
+extern void register_hugetlbfs_with_node(node_registration_func_t doregister,
+					 node_registration_func_t unregister);
 #else
 static inline int register_one_node(int nid)
 {
@@ -69,8 +69,8 @@ static inline int unregister_mem_sect_un
 	return 0;
 }
 
-static inline void register_hugetlbfs_with_node(NODE_REGISTRATION_FUNC reg,
-						NODE_REGISTRATION_FUNC unreg)
+static inline void register_hugetlbfs_with_node(node_registration_func_t reg,
+						node_registration_func_t unreg)
 {
 }
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-make-sure-data-stored-into-inode-is-properly-seen-before-unlocking-new-inode-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
hwmon-driver-for-acpi-40-power-meters-fix.patch
hwmon-driver-for-acpi-40-power-meters-fix-2.patch
video-initial-support-for-adv7180-update-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
checkincludespl-add-option-to-remove-duplicates-in-place.patch
zorro8390-fix-read-buffer-overflow-in-zorro8390_init_one-checkpatch-fixes.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
serial167-fix-read-buffer-overflow.patch
waitqueues-give-waitqueue-spinlocks-their-own-lockdep-classes-checkpatch-fixes.patch
st-fix-test-of-value-range-in-st_set_options-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls.patch
vfs-optimize-touch_time-too.patch
fs-improve-remountro-vs-buffercache-coherency-fix.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
revert-hugetlb-restore-interleaving-of-bootmem-huge-pages-2631.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
revert-proc-kcore-work-around-a-bug.patch
arches-drop-superfluous-casts-in-nr_free_pages-callers-checkpatch-fixes.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix.patch
page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp-checkpatch-fixes.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy-fix.patch
hugetlb-add-per-node-hstate-attributes-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
kernel-smpc-relocate-some-code.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support-cleanup.patch
sdio-add-mmc_quirk_lenient_fn0-fix.patch
at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver-checkpatch-fixes.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
kcore-register-vmemmap-range-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
drivers-video-add-kmalloc-null-tests-fix.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch
page-types-add-feature-for-walking-process-address-space-checkpatch-fixes.patch
cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

