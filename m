From: akpm@linux-foundation.org
Subject: +
 drivers-net-ethernet-tile-replace-__get_cpu_var-uses-for-address-calculation.patch added to -mm tree
Date: Tue, 04 Mar 2014 14:27:22 -0800
Message-ID: <5316534a.khz4gzWBM84XOLKD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757718AbaCDW1X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, davem@davemloft.net, cmetcalf@tilera.com, cl@linux.com

Subject: + drivers-net-ethernet-tile-replace-__get_cpu_var-uses-for-address-calculation.patch added to -mm tree
To: cl@linux.com,cmetcalf@tilera.com,davem@davemloft.net,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:22 -0800


The patch titled
     Subject: drivers/net/ethernet/tile: replace __get_cpu_var uses for address calculation
has been added to the -mm tree.  Its filename is
     drivers-net-ethernet-tile-replace-__get_cpu_var-uses-for-address-calculation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-net-ethernet-tile-replace-__get_cpu_var-uses-for-address-calculation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-net-ethernet-tile-replace-__get_cpu_var-uses-for-address-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: drivers/net/ethernet/tile: replace __get_cpu_var uses for address calculation

Replace with this_cpu_ptr.

Signed-off-by: Christoph Lameter <cl@linux.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: David Miller <davem@davemloft.net>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/tile/tilegx.c  |   18 +++++++++---------
 drivers/net/ethernet/tile/tilepro.c |    8 ++++----
 2 files changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/net/ethernet/tile/tilegx.c~drivers-net-ethernet-tile-replace-__get_cpu_var-uses-for-address-calculation drivers/net/ethernet/tile/tilegx.c
--- a/drivers/net/ethernet/tile/tilegx.c~drivers-net-ethernet-tile-replace-__get_cpu_var-uses-for-address-calculation
+++ a/drivers/net/ethernet/tile/tilegx.c
@@ -423,7 +423,7 @@ static void tile_net_pop_all_buffers(int
 /* Provide linux buffers to mPIPE. */
 static void tile_net_provide_needed_buffers(void)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	int instance, kind;
 	for (instance = 0; instance < NR_MPIPE_MAX &&
 		     info->mpipe[instance].has_iqueue; instance++)	{
@@ -585,7 +585,7 @@ static void tile_net_receive_skb(struct
 /* Handle a packet.  Return true if "processed", false if "filtered". */
 static bool tile_net_handle_packet(int instance, gxio_mpipe_idesc_t *idesc)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	struct mpipe_data *md = &mpipe_data[instance];
 	struct net_device *dev = md->tile_net_devs_for_channel[idesc->channel];
 	uint8_t l2_offset;
@@ -651,7 +651,7 @@ drop:
  */
 static int tile_net_poll(struct napi_struct *napi, int budget)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	unsigned int work = 0;
 	gxio_mpipe_idesc_t *idesc;
 	int instance, i, n;
@@ -697,7 +697,7 @@ done:
 /* Handle an ingress interrupt from an instance on the current cpu. */
 static irqreturn_t tile_net_handle_ingress_irq(int irq, void *id)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	napi_schedule(&info->mpipe[(uint64_t)id].napi);
 	return IRQ_HANDLED;
 }
@@ -760,7 +760,7 @@ static enum hrtimer_restart tile_net_han
 /* Make sure the egress timer is scheduled. */
 static void tile_net_schedule_egress_timer(void)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 
 	if (!info->egress_timer_scheduled) {
 		hrtimer_start(&info->egress_timer,
@@ -777,7 +777,7 @@ static void tile_net_schedule_egress_tim
  */
 static enum hrtimer_restart tile_net_handle_egress_timer(struct hrtimer *t)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	unsigned long irqflags;
 	bool pending = false;
 	int i, instance;
@@ -1992,7 +1992,7 @@ static unsigned int tile_net_tx_frags(st
 /* Help the kernel transmit a packet. */
 static int tile_net_tx(struct sk_buff *skb, struct net_device *dev)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	struct tile_net_priv *priv = netdev_priv(dev);
 	int instance = priv->instance;
 	struct mpipe_data *md = &mpipe_data[instance];
@@ -2134,7 +2134,7 @@ static int tile_net_set_mac_address(stru
 static void tile_net_netpoll(struct net_device *dev)
 {
 	int instance = mpipe_instance(dev);
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	struct mpipe_data *md = &mpipe_data[instance];
 
 	disable_percpu_irq(md->ingress_irq);
@@ -2241,7 +2241,7 @@ static void tile_net_dev_init(const char
 /* Per-cpu module initialization. */
 static void tile_net_init_module_percpu(void *unused)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	int my_cpu = smp_processor_id();
 	int instance;
 
diff -puN drivers/net/ethernet/tile/tilepro.c~drivers-net-ethernet-tile-replace-__get_cpu_var-uses-for-address-calculation drivers/net/ethernet/tile/tilepro.c
--- a/drivers/net/ethernet/tile/tilepro.c~drivers-net-ethernet-tile-replace-__get_cpu_var-uses-for-address-calculation
+++ a/drivers/net/ethernet/tile/tilepro.c
@@ -993,13 +993,13 @@ static void tile_net_register(void *dev_
 	PDEBUG("tile_net_register(queue_id %d)\n", queue_id);
 
 	if (!strcmp(dev->name, "xgbe0"))
-		info = &__get_cpu_var(hv_xgbe0);
+		info = this_cpu_ptr(&hv_xgbe0);
 	else if (!strcmp(dev->name, "xgbe1"))
-		info = &__get_cpu_var(hv_xgbe1);
+		info = this_cpu_ptr(&hv_xgbe1);
 	else if (!strcmp(dev->name, "gbe0"))
-		info = &__get_cpu_var(hv_gbe0);
+		info = this_cpu_ptr(&hv_gbe0);
 	else if (!strcmp(dev->name, "gbe1"))
-		info = &__get_cpu_var(hv_gbe1);
+		info = this_cpu_ptr(&hv_gbe1);
 	else
 		BUG();
 
_

Patches currently in -mm which might be from cl@linux.com are

mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
kthread-ensure-locality-of-task_struct-allocations.patch
mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
kobject-dont-block-for-each-kobject_uevent.patch
kobject-dont-block-for-each-kobject_uevent-v2.patch
slub-do-not-drop-slab_mutex-for-sysfs_slab_add.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
percpu-add-raw_cpu_ops.patch
mm-use-raw_cpu-ops-for-determining-current-numa-node.patch
modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch
net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch
percpu-add-preemption-checks-to-__this_cpu-ops.patch
mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
tracing-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
percpu-replace-__get_cpu_var-with-this_cpu_ptr.patch
kernel-misc-replace-__get_cpu_var-uses.patch
drivers-char-random-replace-__get_cpu_var-uses.patch
drivers-cpuidle-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-oprofile-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-leds-replace-__get_cpu_var-use-through-this_cpu_ptr.patch
drivers-clocksource-replace-__get_cpu_var-used-for-address-calculation.patch
parisc-replace-__get_cpu_var-uses-for-address-calculation.patch
metag-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-net-ethernet-tile-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-net-ethernet-tile-__get_cpu_var-call-introduced-in-314.patch
tilegx-another-case-of-get_cpu_var.patch
time-replace-__get_cpu_var-uses.patch
scheduler-replace-__get_cpu_var-with-this_cpu_ptr.patch
tick-sched-fix-two-new-uses-of-__get_cpu_ptr.patch
block-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
rcu-replace-__this_cpu_ptr-uses-with-raw_cpu_ptr.patch
watchdog-replace-__raw_get_cpu_var-uses.patch
net-replace-get_cpu_var-through-this_cpu_ptr.patch
md-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
irqchips-replace-__this_cpu_ptr-uses.patch
x86-replace-__get_cpu_var-uses.patch
x86-change-__get_cpu_var-calls-introduced-in-314.patch
uv-replace-__get_cpu_var.patch
arm-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
mips-replace-__get_cpu_var-uses-in-fpu-emulator.patch
mips-replace-__get_cpu_var-uses.patch
s390-rename-__this_cpu_ptr-to-raw_cpu_ptr.patch
s390-replace-__get_cpu_var-uses.patch
s390-handle-new-__get_cpu_var-calls-added-in-314.patch
ia64-replace-__get_cpu_var-uses.patch
powerpc-replace-__get_cpu_var-uses.patch
powerpc-handle-new-__get_cpu_var-calls-in-314.patch
sparc-replace-__get_cpu_var-uses.patch
tile-replace-__get_cpu_var-uses.patch
blackfin-replace-__get_cpu_var-uses.patch
avr32-replace-__get_cpu_var-with-__this_cpu_write.patch
alpha-replace-__get_cpu_var.patch
sh-replace-__get_cpu_var-uses.patch

