Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 808C7C001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236923AbjHKXBP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236932AbjHKXAC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9165935B1
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26F6265772
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747CEC433C7;
        Fri, 11 Aug 2023 22:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794792;
        bh=L3+zUIZHX7X74F5P8w8v2Rabb3NvB0fcLlmR3898D3M=;
        h=Date:To:From:Subject:From;
        b=pWVMq6RJrkEbwnpmgbhYt6kv+YieXNzWvAwsYklSVk/Vlcfz2+ZM6P0W89V67vrwP
         VwCyi5+hwLgw7xz5UJeWOld+PoouywQxc8UOpd+Pr036nK7K0gYxH+eCjWOINsUHh1
         a4MdFEgs8ZNpER25G7sJ5q3DCKdjaPrwDIrYREJc=
Date:   Fri, 11 Aug 2023 15:59:52 -0700
To:     mm-commits@vger.kernel.org, zhangpeng362@huawei.com,
        yuzhao@google.com, ying.huang@intel.com,
        wangkefeng.wang@huawei.com, viro@zeniv.linux.org.uk,
        talumbau@google.com, surenb@google.com, suleiman@google.com,
        shuah@kernel.org, ryan.roberts@arm.com, rppt@kernel.org,
        peterx@redhat.com, naoya.horiguchi@nec.com, namit@vmware.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, Liam.Howlett@oracle.com,
        jthoughton@google.com, jiaqiyan@google.com, hughd@google.com,
        heftig@archlinux.org, david@redhat.com, cuigaosheng1@huawei.com,
        corbet@lwn.net, brauner@kernel.org, bgeffon@google.com,
        axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-userfaultfd-extract-file-size-check-out-into-a-helper.patch removed from -mm tree
Message-Id: <20230811225952.747CEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: userfaultfd: extract file size check out into a helper
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-extract-file-size-check-out-into-a-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: mm: userfaultfd: extract file size check out into a helper
Date: Fri, 7 Jul 2023 14:55:35 -0700

This code is already duplicated twice, and UFFDIO_POISON will do the same
check a third time.  So, it's worth extracting into a helper to save
repetitive lines of code.

Link: https://lkml.kernel.org/r/20230707215540.2324998-4-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gaosheng Cui <cuigaosheng1@huawei.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nadav Amit <namit@vmware.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: T.J. Alumbaugh <talumbau@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: ZhangPeng <zhangpeng362@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-extract-file-size-check-out-into-a-helper
+++ a/mm/userfaultfd.c
@@ -45,6 +45,22 @@ struct vm_area_struct *find_dst_vma(stru
 	return dst_vma;
 }
 
+/* Check if dst_addr is outside of file's size. Must be called with ptl held. */
+static bool mfill_file_over_size(struct vm_area_struct *dst_vma,
+				 unsigned long dst_addr)
+{
+	struct inode *inode;
+	pgoff_t offset, max_off;
+
+	if (!dst_vma->vm_file)
+		return false;
+
+	inode = dst_vma->vm_file->f_inode;
+	offset = linear_page_index(dst_vma, dst_addr);
+	max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
+	return offset >= max_off;
+}
+
 /*
  * Install PTEs, to map dst_addr (within dst_vma) to page.
  *
@@ -64,8 +80,6 @@ int mfill_atomic_install_pte(pmd_t *dst_
 	bool page_in_cache = page_mapping(page);
 	spinlock_t *ptl;
 	struct folio *folio;
-	struct inode *inode;
-	pgoff_t offset, max_off;
 
 	_dst_pte = mk_pte(page, dst_vma->vm_page_prot);
 	_dst_pte = pte_mkdirty(_dst_pte);
@@ -81,14 +95,9 @@ int mfill_atomic_install_pte(pmd_t *dst_
 	if (!dst_pte)
 		goto out;
 
-	if (vma_is_shmem(dst_vma)) {
-		/* serialize against truncate with the page table lock */
-		inode = dst_vma->vm_file->f_inode;
-		offset = linear_page_index(dst_vma, dst_addr);
-		max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
+	if (mfill_file_over_size(dst_vma, dst_addr)) {
 		ret = -EFAULT;
-		if (unlikely(offset >= max_off))
-			goto out_unlock;
+		goto out_unlock;
 	}
 
 	ret = -EEXIST;
@@ -211,8 +220,6 @@ static int mfill_atomic_pte_zeropage(pmd
 	pte_t _dst_pte, *dst_pte;
 	spinlock_t *ptl;
 	int ret;
-	pgoff_t offset, max_off;
-	struct inode *inode;
 
 	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
 					 dst_vma->vm_page_prot));
@@ -220,14 +227,9 @@ static int mfill_atomic_pte_zeropage(pmd
 	dst_pte = pte_offset_map_lock(dst_vma->vm_mm, dst_pmd, dst_addr, &ptl);
 	if (!dst_pte)
 		goto out;
-	if (dst_vma->vm_file) {
-		/* the shmem MAP_PRIVATE case requires checking the i_size */
-		inode = dst_vma->vm_file->f_inode;
-		offset = linear_page_index(dst_vma, dst_addr);
-		max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
+	if (mfill_file_over_size(dst_vma, dst_addr)) {
 		ret = -EFAULT;
-		if (unlikely(offset >= max_off))
-			goto out_unlock;
+		goto out_unlock;
 	}
 	ret = -EEXIST;
 	if (!pte_none(ptep_get(dst_pte)))
_

Patches currently in -mm which might be from axelrasmussen@google.com are


