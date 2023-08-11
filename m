Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58C9C04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237012AbjHKXBQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237154AbjHKXAD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6D73AB8
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16F9C678E6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66315C433C8;
        Fri, 11 Aug 2023 22:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794796;
        bh=QjLzsDqoLPqmhB7oZDFnX+zWfFUsfUgFg9GfOA3fk4o=;
        h=Date:To:From:Subject:From;
        b=xUFQUqlc/5GkKXgT6r+MLDbhXI1d6X6Fgby2HQNPgPhAmo3OtQdkw6kxpDcidVO1K
         ak4GmdquVnXIupEFQ9pTEUaiVldo1sQGenFLbT+jSZRlqYaeqsNMmyHE987o0sw/YF
         1snn1SCn+xmrdjZ/GJ4o54ef20vAqF+dL3xCxv5c=
Date:   Fri, 11 Aug 2023 15:59:55 -0700
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
Subject: [merged mm-stable] mm-userfaultfd-support-uffdio_poison-for-hugetlbfs.patch removed from -mm tree
Message-Id: <20230811225956.66315C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: userfaultfd: support UFFDIO_POISON for hugetlbfs
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-support-uffdio_poison-for-hugetlbfs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: mm: userfaultfd: support UFFDIO_POISON for hugetlbfs
Date: Fri, 7 Jul 2023 14:55:37 -0700

The behavior here is the same as it is for anon/shmem.  This is done
separately because hugetlb pte marker handling is a bit different.

Link: https://lkml.kernel.org/r/20230707215540.2324998-6-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
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

 mm/hugetlb.c     |   19 +++++++++++++++++++
 mm/userfaultfd.c |    3 +--
 2 files changed, 20 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-userfaultfd-support-uffdio_poison-for-hugetlbfs
+++ a/mm/hugetlb.c
@@ -6262,6 +6262,25 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 	int writable;
 	bool folio_in_pagecache = false;
 
+	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON)) {
+		ptl = huge_pte_lock(h, dst_mm, dst_pte);
+
+		/* Don't overwrite any existing PTEs (even markers) */
+		if (!huge_pte_none(huge_ptep_get(dst_pte))) {
+			spin_unlock(ptl);
+			return -EEXIST;
+		}
+
+		_dst_pte = make_pte_marker(PTE_MARKER_POISONED);
+		set_huge_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
+
+		/* No need to invalidate - it was non-present before */
+		update_mmu_cache(dst_vma, dst_addr, dst_pte);
+
+		spin_unlock(ptl);
+		return 0;
+	}
+
 	if (is_continue) {
 		ret = -EFAULT;
 		folio = filemap_lock_folio(mapping, idx);
--- a/mm/userfaultfd.c~mm-userfaultfd-support-uffdio_poison-for-hugetlbfs
+++ a/mm/userfaultfd.c
@@ -377,8 +377,7 @@ static __always_inline ssize_t mfill_ato
 	 * by THP.  Since we can not reliably insert a zero page, this
 	 * feature is not supported.
 	 */
-	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE) ||
-	    uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON)) {
+	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE)) {
 		mmap_read_unlock(dst_mm);
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from axelrasmussen@google.com are


