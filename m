Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BBE5C2B9F2
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 21:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBE9C611AB
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 21:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhEVVuM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 May 2021 17:50:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231388AbhEVVuM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 May 2021 17:50:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEDB961177;
        Sat, 22 May 2021 21:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621720127;
        bh=qRy3Mr2ZAIQoQw3mU6QksbMMlYKHigivAldLKitoeck=;
        h=Date:From:To:Subject:From;
        b=hn0e9gtAwWrsOBFgTGArF9/CfQdLWrswz6+t3rX4gG7K550cSMzk56QM5ZVtD62NE
         aVoJMsj5nI+jkWwpcMJZzZkC6wbHOc9Q5vDWJ2B/X/dciGikTgtsJgv+HIFTGGP7oF
         zcCYiGm5CuVeMAOiHPkosN0PaRRvcrxoQH6Owsyc=
Date:   Sat, 22 May 2021 14:48:46 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  +
 mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix.patch
 added to -mm tree
Message-ID: <20210522214846.bi8eANQ-b%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: move scan_swap_map() under CONFIG_HIBERNATION
has been added to the -mm tree.  Its filename is
     mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swapfile: move scan_swap_map() under CONFIG_HIBERNATION

We should move scan_swap_map() under CONFIG_HIBERNATION since the only
caller of this function is get_swap_page_of_type() which is also under
CONFIG_HIBERNATION.  And this fixes the unused-function warning of
scan_swap_map().

Link: https://lkml.kernel.org/r/20210521070855.2015094-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix
+++ a/mm/swapfile.c
@@ -1037,21 +1037,6 @@ static void swap_free_cluster(struct swa
 	swap_range_free(si, offset, SWAPFILE_CLUSTER);
 }
 
-static unsigned long scan_swap_map(struct swap_info_struct *si,
-				   unsigned char usage)
-{
-	swp_entry_t entry;
-	int n_ret;
-
-	n_ret = scan_swap_map_slots(si, usage, 1, &entry);
-
-	if (n_ret)
-		return swp_offset(entry);
-	else
-		return 0;
-
-}
-
 int get_swap_pages(int n_goal, swp_entry_t swp_entries[], int entry_size)
 {
 	unsigned long size = swap_entry_size(entry_size);
@@ -1789,6 +1774,21 @@ int free_swap_and_cache(swp_entry_t entr
 
 #ifdef CONFIG_HIBERNATION
 
+static unsigned long scan_swap_map(struct swap_info_struct *si,
+				   unsigned char usage)
+{
+	swp_entry_t entry;
+	int n_ret;
+
+	n_ret = scan_swap_map_slots(si, usage, 1, &entry);
+
+	if (n_ret)
+		return swp_offset(entry);
+	else
+		return 0;
+
+}
+
 swp_entry_t get_swap_page_of_type(int type)
 {
 	struct swap_info_struct *si = swap_type_to_swap_info(type);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-use-percpu_ref-to-serialize-against-concurrent-swapoff.patch
swap-fix-do_swap_page-race-with-swapoff.patch
mm-swap-remove-confusing-checking-for-non_swap_entry-in-swap_ra_info.patch
mm-shmem-fix-shmem_swapin-race-with-swapoff.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation-fix.patch
mm-swap-remove-unused-local-variable-nr_shadows.patch
mm-swap_slotsc-delete-meaningless-forward-declarations.patch
mm-swap-remove-unused-global-variable-nr_swapper_spaces.patch
mm-huge_memoryc-remove-dedicated-macro-hpage_cache_index_mask.patch
mm-huge_memoryc-use-page-deferred_list.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4.patch
mm-huge_memoryc-remove-unnecessary-tlb_remove_page_size-for-huge-zero-pmd.patch
mm-huge_memoryc-dont-discard-hugepage-if-other-processes-are-mapping-it.patch
mm-zswapc-remove-unused-function-zswap_debugfs_exit.patch
mm-zswapc-avoid-unnecessary-copy-in-at-map-time.patch
mm-zswapc-fix-two-bugs-in-zswap_writeback_entry.patch

