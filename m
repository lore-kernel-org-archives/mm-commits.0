From: akpm@linux-foundation.org
Subject: + git-wireless-vs-git-net.patch added to -mm tree
Date: Thu, 29 Mar 2007 18:20:48 -0700
Message-ID: <200703300122.l2U1MunA017231@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45159 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934382AbXC3BXi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 21:23:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davem@davemloft.net, linville@tuxdriver.com


The patch titled
     git-wireless vs git-net
has been added to the -mm tree.  Its filename is
     git-wireless-vs-git-net.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-wireless vs git-net
From: Andrew Morton <akpm@linux-foundation.org>

net/mac80211/ieee80211.c: In function 'ieee80211_subif_start_xmit':
net/mac80211/ieee80211.c:1467: error: 'struct sk_buff' has no member named 'nh'
net/mac80211/ieee80211.c:1468: error: 'struct sk_buff' has no member named 'h'
net/mac80211/ieee80211.c:1605: error: 'struct sk_buff' has no member named 'mac'
net/mac80211/ieee80211.c:1606: error: 'struct sk_buff' has no member named 'nh'
net/mac80211/ieee80211.c:1607: error: 'struct sk_buff' has no member named 'h'
net/mac80211/ieee80211.c: In function 'header_parse_80211':
net/mac80211/ieee80211.c:2452: error: 'struct sk_buff' has no member named 'mac'
net/mac80211/ieee80211.c:2452: error: 'struct sk_buff' has no member named 'mac'
net/mac80211/ieee80211.c: In function 'ieee80211_rx_h_data':
net/mac80211/ieee80211.c:2628: error: 'struct sk_buff' has no member named 'mac'
net/mac80211/ieee80211.c:2628: error: 'struct sk_buff' has no member named 'nh'
net/mac80211/ieee80211.c: In function 'ieee80211_rx_mgmt':
net/mac80211/ieee80211.c:2756: error: 'struct sk_buff' has no member named 'mac'
net/mac80211/ieee80211.c: In function 'ieee80211_rx_monitor':
net/mac80211/ieee80211.c:2792: error: 'struct sk_buff' has no member named 'mac'

net/mac80211/ieee80211_sta.c: In function 'ieee80211_sta_tx':
net/mac80211/ieee80211_sta.c:409: error: 'struct sk_buff' has no member named 'mac'
net/mac80211/ieee80211_sta.c:409: error: 'struct sk_buff' has no member named 'nh'
net/mac80211/ieee80211_sta.c:409: error: 'struct sk_buff' has no member named 'h'

Hope I got this right.  Perhaps we should be using skb_reset_foo(skb) instead
of skb_set_foo(skb, 0)?


Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/ieee80211.c     |   19 ++++++++++---------
 net/mac80211/ieee80211_sta.c |    4 +++-
 2 files changed, 13 insertions(+), 10 deletions(-)

diff -puN net/mac80211/ieee80211.c~git-wireless-vs-git-net net/mac80211/ieee80211.c
--- a/net/mac80211/ieee80211.c~git-wireless-vs-git-net
+++ a/net/mac80211/ieee80211.c
@@ -1464,8 +1464,8 @@ static int ieee80211_subif_start_xmit(st
 		goto fail;
 	}
 
-	nh_pos = skb->nh.raw - skb->data;
-	h_pos = skb->h.raw - skb->data;
+	nh_pos = skb_network_header(skb) - skb->data;
+	h_pos = skb_transport_header(skb) - skb->data;
 
 	/* convert Ethernet header to proper 802.11 header (based on
 	 * operation mode) */
@@ -1602,9 +1602,9 @@ static int ieee80211_subif_start_xmit(st
 	/* Update skb pointers to various headers since this modified frame
 	 * is going to go through Linux networking code that may potentially
 	 * need things like pointer to IP header. */
-	skb->mac.raw = skb->data;
-	skb->nh.raw = skb->data + nh_pos;
-	skb->h.raw = skb->data + h_pos;
+	skb_set_mac_header(skb, 0);
+	skb_set_network_header(skb, nh_pos);
+	skb_set_transport_header(skb, h_pos);
 
 	dev->trans_start = jiffies;
 	dev_queue_xmit(skb);
@@ -2449,7 +2449,7 @@ static int ieee80211_stop(struct net_dev
 
 static int header_parse_80211(struct sk_buff *skb, unsigned char *haddr)
 {
-	memcpy(haddr, skb->mac.raw + 10, ETH_ALEN); /* addr2 */
+	memcpy(haddr, skb_mac_header(skb), ETH_ALEN); /* addr2 */
 	return ETH_ALEN;
 }
 
@@ -2625,7 +2625,8 @@ ieee80211_rx_h_data(struct ieee80211_txr
 	if (skb2) {
 		/* send to wireless media */
 		skb2->protocol = __constant_htons(ETH_P_802_3);
-		skb2->mac.raw = skb2->nh.raw = skb2->data;
+		skb_set_network_header(skb2, 0);
+		skb_set_mac_header(skb2, 0);
 		dev_queue_xmit(skb2);
 	}
 
@@ -2753,7 +2754,7 @@ ieee80211_rx_mgmt(struct ieee80211_local
 	sdata->stats.rx_packets++;
 	sdata->stats.rx_bytes += skb->len;
 
-	skb->mac.raw = skb->data;
+	skb_set_mac_header(skb, 0);
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 	skb->pkt_type = PACKET_OTHERHOST;
 	skb->protocol = htons(ETH_P_802_2);
@@ -2789,7 +2790,7 @@ ieee80211_rx_monitor(struct net_device *
 	sdata->stats.rx_packets++;
 	sdata->stats.rx_bytes += skb->len;
 
-	skb->mac.raw = skb->data;
+	skb_set_mac_header(skb, 0);
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 	skb->pkt_type = PACKET_OTHERHOST;
 	skb->protocol = htons(ETH_P_802_2);
diff -puN net/mac80211/ieee80211_sta.c~git-wireless-vs-git-net net/mac80211/ieee80211_sta.c
--- a/net/mac80211/ieee80211_sta.c~git-wireless-vs-git-net
+++ a/net/mac80211/ieee80211_sta.c
@@ -406,7 +406,9 @@ static void ieee80211_sta_tx(struct net_
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	skb->dev = sdata->local->mdev;
-	skb->mac.raw = skb->nh.raw = skb->h.raw = skb->data;
+	skb_set_mac_header(skb, 0);
+	skb_set_network_header(skb, 0);
+	skb_set_transport_header(skb, 0);
 
 	pkt_data = (struct ieee80211_tx_packet_data *) skb->cb;
 	memset(pkt_data, 0, sizeof(struct ieee80211_tx_packet_data));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
proc-fix-linkage-with-config_sysctl=y-config_proc_sysctl=n.patch
slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-avr32.patch
git-avr32-fixup.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-kvm.patch
git-libata-all.patch
git-libata-all-ipr-fix.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver-fix.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-ubi.patch
git-netdev-all.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net.patch
git-net-fixup.patch
git-parisc.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-piggy-bus.patch
git-pciseg.patch
git-s390.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-git-net.patch
fix-x86_64-mm-sched-clock-share.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation-tidy.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
driver_bfin_serial_core-update.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
parport-dev-driver-model-support-powerpc-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy.patch
add-support-for-deferrable-timers-respun-tidy.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc-fix.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization-fix.patch
revoke-core-code-fix-shared-mapping-revoke.patch
fbdev-hecuba-framebuffer-driver.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
mm-only-hrtimers-debug-patch-fix.patch
