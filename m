From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 26 Jun 2014 12:15:41 -0700
Message-ID: <53ac715d.rgI1mkUV1gg13IFm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaFZTPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jun 2014 15:15:42 -0400
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

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/gpio-fan.c |    6 ------
 net/bluetooth/hci_conn.c |    4 ----
 net/bluetooth/smp.c      |    6 ------
 3 files changed, 16 deletions(-)

diff -puN drivers/hwmon/gpio-fan.c~linux-next-git-rejects drivers/hwmon/gpio-fan.c
--- a/drivers/hwmon/gpio-fan.c~linux-next-git-rejects
+++ a/drivers/hwmon/gpio-fan.c
@@ -537,16 +537,10 @@ static int gpio_fan_probe(struct platfor
 	}
 
 	/* Make this driver part of hwmon class. */
-<<<<<<< HEAD
-	fan_data->hwmon_dev = hwmon_device_register_with_groups(&pdev->dev,
-						"gpio_fan", fan_data,
-						gpio_fan_groups);
-=======
 	fan_data->hwmon_dev =
 		devm_hwmon_device_register_with_groups(&pdev->dev,
 						       "gpio-fan", fan_data,
 						       gpio_fan_groups);
->>>>>>> linux-next/akpm-base
 	if (IS_ERR(fan_data->hwmon_dev))
 		return PTR_ERR(fan_data->hwmon_dev);
 
diff -puN net/bluetooth/hci_conn.c~linux-next-git-rejects net/bluetooth/hci_conn.c
--- a/net/bluetooth/hci_conn.c~linux-next-git-rejects
+++ a/net/bluetooth/hci_conn.c
@@ -900,11 +900,7 @@ static int hci_conn_auth(struct hci_conn
 		/* If we're already encrypted set the REAUTH_PEND flag,
 		 * otherwise set the ENCRYPT_PEND.
 		 */
-<<<<<<< HEAD
-		if (conn->link_mode & HCI_LM_ENCRYPT)
-=======
 		if (test_bit(HCI_CONN_ENCRYPT, &conn->flags))
->>>>>>> linux-next/akpm-base
 			set_bit(HCI_CONN_REAUTH_PEND, &conn->flags);
 		else
 			set_bit(HCI_CONN_ENCRYPT_PEND, &conn->flags);
diff -puN net/bluetooth/smp.c~linux-next-git-rejects net/bluetooth/smp.c
--- a/net/bluetooth/smp.c~linux-next-git-rejects
+++ a/net/bluetooth/smp.c
@@ -564,18 +564,12 @@ static u8 smp_random(struct smp_chan *sm
 		else
 			auth = 0;
 
-<<<<<<< HEAD
-		hci_add_ltk(hcon->hdev, &hcon->dst, hcon->dst_type,
-			    HCI_SMP_STK_SLAVE, auth, stk, smp->enc_key_size,
-			    ediv, rand);
-=======
 		/* Even though there's no _SLAVE suffix this is the
 		 * slave STK we're adding for later lookup (the master
 		 * STK never needs to be stored).
 		 */
 		hci_add_ltk(hcon->hdev, &hcon->dst, hcon->dst_type,
 			    SMP_STK, auth, stk, smp->enc_key_size, ediv, rand);
->>>>>>> linux-next/akpm-base
 	}
 
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
fs-isofs-logging-clean-up-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
linux-next-git-rejects.patch

