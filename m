Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E87C6FD18
	for <mm-commits@archiver.kernel.org>; Wed, 19 Apr 2023 20:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjDSUxS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Apr 2023 16:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjDSUxS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Apr 2023 16:53:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF56510E0
        for <mm-commits@vger.kernel.org>; Wed, 19 Apr 2023 13:53:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59A3061645
        for <mm-commits@vger.kernel.org>; Wed, 19 Apr 2023 20:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2202C433EF;
        Wed, 19 Apr 2023 20:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681937595;
        bh=Wy2QbPs+2Rf0Q56UmdonxQrD/HnE8q7c9S20uGvCMcw=;
        h=Date:To:From:Subject:From;
        b=pWYT4CDll6DDTV1wmiWlh2WbrIiGx5KHXCP6wXgyaWq9rB+/UZx47HxzqgRY8x7+K
         X3eFw2kTmsRmO77oduCeIAjGYa+gDB3SuG7/Dc6b0HXTLJxBSPu2TlxiJzxzj7Giv0
         ro91VS8w+zFmX1BHb1FdKjSO6gFFemuyKpnRq0vw=
Date:   Wed, 19 Apr 2023 13:53:15 -0700
To:     mm-commits@vger.kernel.org, muchun.song@linux.dev,
        mike.kravetz@oracle.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-pte_alloc_huge-to-replace-huge-pte_alloc_map.patch added to mm-unstable branch
Message-Id: <20230419205315.B2202C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: pte_alloc_huge() to replace huge pte_alloc_map()
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-pte_alloc_huge-to-replace-huge-pte_alloc_map.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-pte_alloc_huge-to-replace-huge-pte_alloc_map.patch

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
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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

hugetlb-pte_alloc_huge-to-replace-huge-pte_alloc_map.patch
ia64-fix-an-addr-to-taddr-in-huge_pte_offset.patch

