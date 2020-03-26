From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 26 Mar 2020 11:15:31 -0700
Message-ID: <20200326181531.7K7vEX0xm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbgCZSPd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 26 Mar 2020 14:15:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/amazon/ena/ena_netdev.c  |    6 ----
 drivers/net/macsec.c                          |    3 --
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |   22 ----------------
 tools/testing/selftests/net/Makefile          |    3 --
 4 files changed, 34 deletions(-)

--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3484,13 +3484,7 @@ static int ena_restore_device(struct ena
 
 	mod_timer(&adapter->timer_service, round_jiffies(jiffies + HZ));
 	adapter->last_keep_alive_jiffies = jiffies;
-<<<<<<< HEAD
-	dev_err(&pdev->dev,
-		"Device reset completed successfully, Driver info: %s\n",
-		version);
-=======
 	dev_err(&pdev->dev, "Device reset completed successfully\n");
->>>>>>> linux-next/akpm-base
 
 	return rc;
 err_disable_msix:
--- a/drivers/net/macsec.c~linux-next-git-rejects
+++ a/drivers/net/macsec.c
@@ -20,10 +20,7 @@
 #include <net/macsec.h>
 #include <linux/phy.h>
 #include <linux/if_arp.h>
-<<<<<<< HEAD
-=======
 #include <linux/byteorder/generic.h>
->>>>>>> linux-next/akpm-base
 
 #include <uapi/linux/if_macsec.h>
 
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c~linux-next-git-rejects
+++ a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -819,27 +819,6 @@ MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids
 
 static const struct iwl_dev_info iwl_dev_info_table[] = {
 #if IS_ENABLED(CONFIG_IWLMVM)
-<<<<<<< HEAD
-	IWL_DEV_INFO(0x2526, 0x0010, iwl9260_2ac_160_cfg, iwl9260_160_name),
-	IWL_DEV_INFO(0x2526, 0x0014, iwl9260_2ac_160_cfg, iwl9260_160_name),
-	IWL_DEV_INFO(0x2526, 0x0018, iwl9260_2ac_160_cfg, iwl9260_160_name),
-	IWL_DEV_INFO(0x2526, 0x001C, iwl9260_2ac_160_cfg, iwl9260_160_name),
-	IWL_DEV_INFO(0x2526, 0x4010, iwl9260_2ac_160_cfg, iwl9260_160_name),
-	IWL_DEV_INFO(0x2526, 0x4018, iwl9260_2ac_160_cfg, iwl9260_160_name),
-	IWL_DEV_INFO(0x2526, 0x401C, iwl9260_2ac_160_cfg, iwl9260_160_name),
-	IWL_DEV_INFO(0x2526, 0x6010, iwl9260_2ac_160_cfg, iwl9260_160_name),
-	IWL_DEV_INFO(0x2526, 0x6014, iwl9260_2ac_160_cfg, iwl9260_160_name),
-	IWL_DEV_INFO(0x2526, 0x8014, iwl9260_2ac_160_cfg, iwl9260_160_name),
-	IWL_DEV_INFO(0x2526, 0x8010, iwl9260_2ac_160_cfg, iwl9260_160_name),
-	IWL_DEV_INFO(0x2526, 0xA014, iwl9260_2ac_160_cfg, iwl9260_160_name),
-	IWL_DEV_INFO(0x2526, 0xE010, iwl9260_2ac_160_cfg, iwl9260_160_name),
-	IWL_DEV_INFO(0x2526, 0xE014, iwl9260_2ac_160_cfg, iwl9260_160_name),
-
-	IWL_DEV_INFO(0x2526, 0x0030, iwl9560_2ac_160_cfg, iwl9560_160_name),
-	IWL_DEV_INFO(0x2526, 0x0038, iwl9560_2ac_160_cfg, iwl9560_160_name),
-	IWL_DEV_INFO(0x2526, 0x003C, iwl9560_2ac_160_cfg, iwl9560_160_name),
-	IWL_DEV_INFO(0x2526, 0x4030, iwl9560_2ac_160_cfg, iwl9560_160_name),
-=======
 /* 9000 */
 	IWL_DEV_INFO(0x2526, 0x1550, iwl9260_2ac_cfg, iwl9260_killer_1550_name),
 	IWL_DEV_INFO(0x2526, 0x1551, iwl9560_2ac_cfg_soc, iwl9560_killer_1550s_name),
@@ -961,7 +940,6 @@ static const struct iwl_dev_info iwl_dev
 	IWL_DEV_INFO(0x2723, 0x1654, iwl_ax200_cfg_cc, iwl_ax200_killer_1650x_name),
 	IWL_DEV_INFO(0x2723, IWL_CFG_ANY, iwl_ax200_cfg_cc, iwl_ax200_name),
 
->>>>>>> linux-next/akpm-base
 #endif /* CONFIG_IWLMVM */
 };
 
--- a/tools/testing/selftests/net/Makefile~linux-next-git-rejects
+++ a/tools/testing/selftests/net/Makefile
@@ -14,10 +14,7 @@ TEST_PROGS += tcp_fastopen_backup_key.sh
 TEST_PROGS += fin_ack_lat.sh fib_nexthop_multiprefix.sh fib_nexthops.sh
 TEST_PROGS += altnames.sh icmp_redirect.sh ip6_gre_headroom.sh
 TEST_PROGS += route_localnet.sh
-<<<<<<< HEAD
-=======
 TEST_PROGS += reuseaddr_ports_exhausted.sh
->>>>>>> linux-next/akpm-base
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-infiniband-sw-siw-siw_qp_rxc-suppress-uninitialized-var-warning.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-gup-track-foll_pin-pages-fix-2-fix.patch
mm-swap-make-page_evictable-inline-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
hv_balloon-dont-check-for-memhp_auto_online-manually-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch
