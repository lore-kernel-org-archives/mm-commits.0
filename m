Return-Path: <SRS0=hqm6=DJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C2FC41604
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 23:36:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 460DC206CD
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 23:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601681795;
	bh=+zhgQ1Dqg1wAEvi6TdsVktAu5W177MfRVGungQsS6dk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=gAm9awOngJx/r78c96nfQMv13JJwsNHICzs4u5FSiFuXhYRGjyhtgHKIS9663ca+x
	 /XNcP1Q1VjO10eeG5HdCFd5XtQgxb0OJPTIdNVkzNqtrzMy3uQR7qxKNfFALXQbhI7
	 AC9itmUO6z9gJezZwQHojVt9Ko72VYu56w37xmQk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbgJBXge (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Oct 2020 19:36:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgJBXge (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Oct 2020 19:36:34 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E807206CD;
        Fri,  2 Oct 2020 23:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601681792;
        bh=+zhgQ1Dqg1wAEvi6TdsVktAu5W177MfRVGungQsS6dk=;
        h=Date:From:To:Subject:From;
        b=BNLP2OiT5jW5ogNsCNa5V/HqZ5flufETIuG5z4m9loK2KrT8N+mguswBmXYBhdzuc
         bLC8aqX4hHx55ACkqQSGic5JAMUpmFhs9ieVlLjqskqnug3H9At91bMrTwkjarnobY
         /R6vvWABtK8isyOnKcYZNyDd8htJUboz/U8r/9Ik=
Date:   Fri, 02 Oct 2020 16:36:31 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20201002233631.7kvEnGOa5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


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

 drivers/gpio/gpio-mockup.c |    8 --------
 fs/btrfs/dev-replace.c     |   20 --------------------
 2 files changed, 28 deletions(-)

--- a/drivers/gpio/gpio-mockup.c~linux-next-git-rejects
+++ a/drivers/gpio/gpio-mockup.c
@@ -577,11 +577,7 @@ static int __init gpio_mockup_init(void)
 
 	err = platform_driver_register(&gpio_mockup_driver);
 	if (err) {
-<<<<<<< HEAD
-		gpio_mockup_err("error registering platform driver\n");
-=======
 		pr_err("error registering platform driver\n");
->>>>>>> linux-next/akpm-base
 		debugfs_remove_recursive(gpio_mockup_dbg_dir);
 		return err;
 	}
@@ -592,11 +588,7 @@ static int __init gpio_mockup_init(void)
 			platform_driver_unregister(&gpio_mockup_driver);
 			gpio_mockup_unregister_pdevs();
 			debugfs_remove_recursive(gpio_mockup_dbg_dir);
-<<<<<<< HEAD
-			return PTR_ERR(pdev);
-=======
 			return err;
->>>>>>> linux-next/akpm-base
 		}
 	}
 
--- a/fs/btrfs/dev-replace.c~linux-next-git-rejects
+++ a/fs/btrfs/dev-replace.c
@@ -593,8 +593,6 @@ static void btrfs_rm_dev_replace_unblock
 	wake_up(&fs_info->dev_replace.replace_wait);
 }
 
-<<<<<<< HEAD
-=======
 static void btrfs_dev_replace_update_device_in_mapping_tree(
 						struct btrfs_fs_info *fs_info,
 						struct btrfs_device *srcdev,
@@ -621,7 +619,6 @@ static void btrfs_dev_replace_update_dev
 	write_unlock(&em_tree->lock);
 }
 
->>>>>>> linux-next/akpm-base
 /*
  * When finishing the device replace, before swapping the source device with the
  * target device we must update the chunk allocation state in the target device,
@@ -818,23 +815,6 @@ error:
 	mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 
 	btrfs_rm_dev_replace_free_srcdev(src_device);
-<<<<<<< HEAD
-
-	return 0;
-}
-
-static void btrfs_dev_replace_update_device_in_mapping_tree(
-						struct btrfs_fs_info *fs_info,
-						struct btrfs_device *srcdev,
-						struct btrfs_device *tgtdev)
-{
-	struct extent_map_tree *em_tree = &fs_info->mapping_tree;
-	struct extent_map *em;
-	struct map_lookup *map;
-	u64 start = 0;
-	int i;
-=======
->>>>>>> linux-next/akpm-base
 
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
mm-mempool-add-else-to-split-mutually-exclusive-case-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
checkpatch-emit-a-warning-on-embedded-filenames-fix.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
fs-fuse-virtio_fsc-fix-for-mm-memremap_pages-convert-to-struct-range.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

