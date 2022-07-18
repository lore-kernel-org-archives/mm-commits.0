Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99AB1C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbiGRAVi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbiGRAUF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:20:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B032A140F7
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FE6F60F32
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4336C341C0;
        Mon, 18 Jul 2022 00:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103512;
        bh=ap0UmQpHl5rNEjtCDDzxZxtZfwebaX68REXdYd4tq/0=;
        h=Date:To:From:Subject:From;
        b=QJHQ1O5PcTzYrMO9cDgcl3bmZtz5uXog/P+7djxApJYFrVla5hkZSd2oOXvqpes0o
         6uhOO/z7EvuFq954EufvcBl9uOPNgH8bDHKtR/ZCuXdCwEz7aNX2UZEJF2hCK55PAw
         daz0IwuC83F9zrKV0NB8RhIrayNPLCzsWoQWqft8=
Date:   Sun, 17 Jul 2022 17:18:32 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-use-helper-macro-__attr_rw.patch removed from -mm tree
Message-Id: <20220718001832.A4336C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: use helper macro __ATTR_RW
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-helper-macro-__attr_rw.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-remove-obsolete-comment-in-do_fault_around.patch

