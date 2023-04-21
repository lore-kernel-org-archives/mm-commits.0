Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29499C7EE21
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 21:53:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbjDUVx2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Apr 2023 17:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbjDUVxV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Apr 2023 17:53:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239A130DF
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 14:52:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0220B61A00
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 21:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582A3C433D2;
        Fri, 21 Apr 2023 21:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682113977;
        bh=vgjZwuLt279ASfy6cra2/A5avJzfo8FF0rRoW7S8DrI=;
        h=Date:To:From:Subject:From;
        b=CgutrSdXaMGQV1oMYoc+mLYEuoHqUobLvtICd+xyzzagmq1VsCE0MmMhXm82FJzdF
         NfVB7YEOOGfK/5YIJ0A/HTFtsC9aJKEsMZyd2wotgPf03D3TfRwoIwLb2izfPHtYkq
         xYDSsjZUy/p0aYxqpdmQFhEz4UUYNv2F6LcKpwZE=
Date:   Fri, 21 Apr 2023 14:52:56 -0700
To:     mm-commits@vger.kernel.org, muchun.song@linux.dev,
        mike.kravetz@oracle.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-pte_alloc_huge-to-replace-huge-pte_alloc_map.patch removed from -mm tree
Message-Id: <20230421215257.582A3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: pte_alloc_huge() to replace huge pte_alloc_map()
has been removed from the -mm tree.  Its filename was
     hugetlb-pte_alloc_huge-to-replace-huge-pte_alloc_map.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: hugetlb: pte_alloc_huge() to replace huge pte_alloc_map()
Date: Tue, 18 Apr 2023 22:22:02 -0700 (PDT)

Some architectures can have their hugetlb pages down at the lowest PTE
level: their huge_pte_alloc() using pte_alloc_map(), but without any
following pte_unmap().  Since none of these arches uses CONFIG_HIGHPTE,
this is not seen as a problem at present; but would become a problem if
forthcoming changes were to add an rcu_read_lock() into pte_offset_map(),
with the rcu_read_unlock() expected in pte_unmap().

Similarly in their huge_pte_offset(): pte_offset_kernel() is good enough
for that, but it's probably less confusing if we define pte_offset_huge()
along with pte_alloc_huge().  Only define them without CONFIG_HIGHPTE: so
there would be a build error to signal if ever more work is needed.

For ease of development, define these now for 6.4-rc1, ahead of any use:
then architectures can integrate patches using them, independent from mm.

Link: https://lkml.kernel.org/r/ae9e7d98-8a3a-cfd9-4762-bcddffdf96cf@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/include/linux/hugetlb.h~hugetlb-pte_alloc_huge-to-replace-huge-pte_alloc_map
+++ a/include/linux/hugetlb.h
@@ -191,6 +191,23 @@ extern struct list_head huge_boot_pages;
 
 /* arch callbacks */
 
+#ifndef CONFIG_HIGHPTE
+/*
+ * pte_offset_huge() and pte_alloc_huge() are helpers for those architectures
+ * which may go down to the lowest PTE level in their huge_pte_offset() and
+ * huge_pte_alloc(): to avoid reliance on pte_offset_map() without pte_unmap().
+ */
+static inline pte_t *pte_offset_huge(pmd_t *pmd, unsigned long address)
+{
+	return pte_offset_kernel(pmd, address);
+}
+static inline pte_t *pte_alloc_huge(struct mm_struct *mm, pmd_t *pmd,
+				    unsigned long address)
+{
+	return pte_alloc(mm, pmd) ? NULL : pte_offset_huge(pmd, address);
+}
+#endif
+
 pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long addr, unsigned long sz);
 /*
_

Patches currently in -mm which might be from hughd@google.com are

ia64-fix-an-addr-to-taddr-in-huge_pte_offset.patch

