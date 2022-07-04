Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7940C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 23:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbiGDXEZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jul 2022 19:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbiGDXET (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jul 2022 19:04:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13897BF6B
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 16:04:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EC4D617A1
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 23:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0329BC341CB;
        Mon,  4 Jul 2022 23:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656975858;
        bh=d7elJMrDvCsqSZzMx5waDiKqsYjsWrzJs1N2LBctWqM=;
        h=Date:To:From:Subject:From;
        b=PkFSr3QSAV+D+bGDSpYFPp7zadpNu8ZrVJ+d6fwQ9cSbRQXwfvVIll1GSmZWZQ3t+
         kBVe3U4Gqn9VbUvtYNkFreVhHVQa8IWs40MDu+TvxPj1TP07kEXqLsIRUhiPHGEHv+
         +Gojqv22LwSSwqsHwCCepP49GdLqEHZkINA2S04o=
Date:   Mon, 04 Jul 2022 16:04:17 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-use-helper-macro-__attr_rw.patch added to mm-unstable branch
Message-Id: <20220704230418.0329BC341CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: use helper macro __ATTR_RW
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-use-helper-macro-__attr_rw.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-use-helper-macro-__attr_rw.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory: use helper macro __ATTR_RW
Date: Mon, 4 Jul 2022 21:21:53 +0800

Use helper macro __ATTR_RW to define use_zero_page_attr, defrag_attr and
enabled_attr to make code more clear. Minor readability improvement.

Link: https://lkml.kernel.org/r/20220704132201.14611-9-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-helper-macro-__attr_rw
+++ a/mm/huge_memory.c
@@ -276,8 +276,8 @@ static ssize_t enabled_store(struct kobj
 	}
 	return ret;
 }
-static struct kobj_attribute enabled_attr =
-	__ATTR(enabled, 0644, enabled_show, enabled_store);
+
+static struct kobj_attribute enabled_attr = __ATTR_RW(enabled);
 
 ssize_t single_hugepage_flag_show(struct kobject *kobj,
 				  struct kobj_attribute *attr, char *buf,
@@ -366,8 +366,7 @@ static ssize_t defrag_store(struct kobje
 
 	return count;
 }
-static struct kobj_attribute defrag_attr =
-	__ATTR(defrag, 0644, defrag_show, defrag_store);
+static struct kobj_attribute defrag_attr = __ATTR_RW(defrag);
 
 static ssize_t use_zero_page_show(struct kobject *kobj,
 				  struct kobj_attribute *attr, char *buf)
@@ -381,8 +380,7 @@ static ssize_t use_zero_page_store(struc
 	return single_hugepage_flag_store(kobj, attr, buf, count,
 				 TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
 }
-static struct kobj_attribute use_zero_page_attr =
-	__ATTR(use_zero_page, 0644, use_zero_page_show, use_zero_page_store);
+static struct kobj_attribute use_zero_page_attr = __ATTR_RW(use_zero_page);
 
 static ssize_t hpage_pmd_size_show(struct kobject *kobj,
 				   struct kobj_attribute *attr, char *buf)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-huge_memory-use-flush_pmd_tlb_range-in-move_huge_pmd.patch
mm-huge_memory-access-vm_page_prot-with-read_once-in-remove_migration_pmd.patch
mm-huge_memory-fix-comment-of-__pud_trans_huge_lock.patch
mm-huge_memory-use-helper-touch_pud-in-huge_pud_set_accessed.patch
mm-huge_memory-use-helper-touch_pmd-in-huge_pmd_set_accessed.patch
mm-huge_memory-rename-mmun_start-to-haddr-in-remove_migration_pmd.patch
mm-huge_memory-use-helper-function-vma_lookup-in-split_huge_pages_pid.patch
mm-huge_memory-use-helper-macro-__attr_rw.patch
mm-huge_memory-fix-comment-in-zap_huge_pud.patch
mm-huge_memory-check-pmd_present-first-in-is_huge_zero_pmd.patch
mm-huge_memory-try-to-free-subpage-in-swapcache-when-possible.patch
mm-huge_memory-minor-cleanup-for-split_huge_pages_all.patch
mm-huge_memory-fix-comment-of-page_deferred_list.patch
mm-huge_memory-correct-comment-of-prep_transhuge_page.patch
mm-huge_memory-comment-the-subtly-logic-in-__split_huge_pmd.patch
mm-huge_memory-use-helper-macro-is_err_or_null-in-split_huge_pages_pid.patch

