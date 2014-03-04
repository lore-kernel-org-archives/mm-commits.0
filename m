From: akpm@linux-foundation.org
Subject: +
 drivers-net-ethernet-tile-__get_cpu_var-call-introduced-in-314.patch added
 to -mm tree
Date: Tue, 04 Mar 2014 14:27:23 -0800
Message-ID: <5316534b.BFaOEKCfByfZq13/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719AbaCDW1Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, davem@davemloft.net, cmetcalf@tilera.com, cl@linux.com

Subject: + drivers-net-ethernet-tile-__get_cpu_var-call-introduced-in-314.patch added to -mm tree
To: cl@linux.com,cmetcalf@tilera.com,davem@davemloft.net,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:23 -0800


The patch titled
     Subject: drivers/net/ethernet/tile: __get_cpu_var call introduced in 3.14
has been added to the -mm tree.  Its filename is
     drivers-net-ethernet-tile-__get_cpu_var-call-introduced-in-314.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-net-ethernet-tile-__get_cpu_var-call-introduced-in-314.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-net-ethernet-tile-__get_cpu_var-call-introduced-in-314.patch

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
Subject: drivers/net/ethernet/tile: __get_cpu_var call introduced in 3.14

Another case was merged for 3.14-rc1

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: David Miller <davem@davemloft.net>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/tile/tilegx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/ethernet/tile/tilegx.c~drivers-net-ethernet-tile-__get_cpu_var-call-introduced-in-314 drivers/net/ethernet/tile/tilegx.c
--- a/drivers/net/ethernet/tile/tilegx.c~drivers-net-ethernet-tile-__get_cpu_var-call-introduced-in-314
+++ a/drivers/net/ethernet/tile/tilegx.c
@@ -551,7 +551,7 @@ static inline bool filter_packet(struct
 static void tile_net_receive_skb(struct net_device *dev, struct sk_buff *skb,
 				 gxio_mpipe_idesc_t *idesc, unsigned long len)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	struct tile_net_priv *priv = netdev_priv(dev);
 	int instance = priv->instance;
 
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

