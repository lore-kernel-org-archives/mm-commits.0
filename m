From: akpm@linux-foundation.org
Subject: +
 mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-ks.patch added to
 -mm tree
Date: Thu, 16 Jun 2016 15:22:36 -0700
Message-ID: <576326ac.d6N2FbsOk3nKyhWQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbcFPWWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2016 18:22:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebru.akagunduz@gmail.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, gorcunov@openvz.org, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan.kim@gmail.com, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: make swapin readahead under down_read of mmap_sem
has been added to the -mm tree.  Its filename is
     mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-ks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-ks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-ks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Return-Path: <kirill.shutemov@linux.intel.com>
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on y.localdomain
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.5 tests=BAYES_00
	autolearn=unavailable autolearn_force=no version=3.4.1
Received: from y.localdomain (localhost [127.0.0.1])
	by y.localdomain (8.14.9/8.14.9/Debian-4) with ESMTP id u5FK7mnf023453
	for <akpm@localhost>; Wed, 15 Jun 2016 13:07:50 -0700
X-Original-To: akpm@mail.linuxfoundation.org
Delivered-To: akpm@mail.linuxfoundation.org
Received: from mail.linuxfoundation.org [140.211.169.12]
	by y.localdomain with IMAP (fetchmail-6.3.26)
	for <akpm@localhost> (single-drop); Wed, 15 Jun 2016 13:07:50 -0700 (PDT)
Received: from smtp1.linuxfoundation.org (smtp1.linux-foundation.org [172.17.192.35])
	by mail.linuxfoundation.org (Postfix) with ESMTPS id AD8587AA
	for <akpm@mail.linuxfoundation.org>; Wed, 15 Jun 2016 20:06:57 +0000 (UTC)
X-Greylist: whitelisted by SQLgrey-1.7.6
Received: from mail-pa0-f71.google.com (mail-pa0-f71.google.com [209.85.220.71])
	by smtp1.linuxfoundation.org (Postfix) with ESMTPS id D670912E
	for <akpm@mail.linuxfoundation.org>; Wed, 15 Jun 2016 20:06:56 +0000 (UTC)
Received: by mail-pa0-f71.google.com with SMTP id he1so49819125pac.0
        for <akpm@mail.linuxfoundation.org>; Wed, 15 Jun 2016 13:06:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20130820;
        h=x-original-authentication-results:x-gm-message-state:from:to:cc
         :subject:date:message-id:in-reply-to:references:delivered-to;
        bh=bOP57HXts0EogG7bHJnFAli/U3R4CE9wVNaqDS4M2gs=;
        b=JTT0FR5liE1XV4zZ4b+e0sCX4v5aFr5QYXwY7yuNYYspEhssEKWMY58RI7goT+JtIU
         fqmguDbCX1EgM0LMGf38lGxoV6dISQnCn3/VQiOhsAFoVz8XTARgNGqhTQwGZAOHDSdA
         ZcqkndEaK0dZnG3uwWwYQ0oCDvkonEQ9tBXH3PRHFSCm8Goi2+yzCdXWde5asGRBG9iI
         dt5n3HwwsG35844rwq9dgZCfO+bLibAEwcBZXc2XBQ0yuW4Z4d+C5YrD9vqeEs2L768b
         KvJzXcLgmVkEotxHZE9moFNntsQ6F+Ab0oNVEG7SwW502+nJaQUKSG1fipXJm+dj7NOb
         o3HA==
X-Original-Authentication-Results: mx.google.com;       spf=pass (google.com: best guess record for domain of kirill.shutemov@linux.intel.com designates 192.55.52.120 as permitted sender) smtp.mailfrom=kirill.shutemov@linux.intel.com
X-Gm-Message-State: ALyK8tIqTkj3cS1SkSv0ht5ytJDR2MN56JiZR7lYNbKQ4+xCAMJoVrPrcmBZtdrBzki+vbRV02j4Q2vdCEYutwijdjOntwRFz2aB/5Myt9ejAs4Vq7a3fBZYrTiPm6eUZ6Jxyx47lMHHf3kjU7XkgdiZ2u+ZHG3BVFv1SqyF0BDy/kfRJHljL5oT5DwsU5gMqE+WLg==
X-Received: by 10.67.15.72 with SMTP id fm8mr589991pad.50.1466021216589;
        Wed, 15 Jun 2016 13:06:56 -0700 (PDT)
X-Received: by 10.67.15.72 with SMTP id fm8mr589918pad.50.1466021215673;
        Wed, 15 Jun 2016 13:06:55 -0700 (PDT)
Received: from mga04.intel.com (mga04.intel.com. [192.55.52.120])
        by mx.google.com with ESMTP id f10si981797pfj.137.2016.06.15.13.06.55
        for <akpm@linux-foundation.org>;
        Wed, 15 Jun 2016 13:06:55 -0700 (PDT)
Received-SPF: pass (google.com: best guess record for domain of kirill.shutemov@linux.intel.com designates 192.55.52.120 as permitted sender) client-ip=192.55.52.120;
Authentication-Results: mx.google.com;
       spf=pass (google.com: best guess record for domain of kirill.shutemov@linux.intel.com designates 192.55.52.120 as permitted sender) smtp.mailfrom=kirill.shutemov@linux.intel.com
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP; 15 Jun 2016 13:06:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.26,477,1459839600"; 
   d="scan'208";a="988242008"
Received: from black.fi.intel.com ([10.237.72.93])
  by fmsmga001.fm.intel.com with ESMTP; 15 Jun 2016 13:06:49 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 9A090E5; Wed, 15 Jun 2016 23:06:48 +0300 (EEST)
To: Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Vlastimil Babka <vbabka@suse.cz>,
        Christoph Lameter <cl@gentwo.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Jerome Marchand <jmarchan@redhat.com>, Yang Shi <yang.shi@linaro.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andres Lagar-Cavilla <andreslc@google.com>, Ning Qu <quning@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Ebru Akagunduz <ebru.akagunduz@gmail.com>,
        Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: mm, thp: make swapin readahead under down_read of mmap_sem
Date: Wed, 15 Jun 2016 23:06:06 +0300
Message-Id: <1466021202-61880-2-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1466021202-61880-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1465222029-45942-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1466021202-61880-1-git-send-email-kirill.shutemov@linux.intel.com>
Delivered-To: akpm@linux-foundation.org


Currently khugepaged makes swapin readahead under down_write.  This patch
supplies to make swapin readahead under down_read instead of down_write.

The patch was tested with a test program that allocates 800MB of memory,
writes to it, and then sleeps.  The system was forced to swap out all.
Afterwards, the test program touches the area by writing, it skips a page
in each 20 pages of the area.

Link: http://lkml.kernel.org/r/1464335964-6510-4-git-send-email-ebru.akagunduz@gmail.com
Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/huge_memory.c | 92 ++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 29 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f2bc57c45d2f..96dfe3f09bf6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2378,6 +2378,35 @@ static bool hugepage_vma_check(struct vm_area_struct *vma)
 }
 
 /*
+ * If mmap_sem temporarily dropped, revalidate vma
+ * before taking mmap_sem.
+ * Return 0 if succeeds, otherwise return none-zero
+ * value (scan code).
+ */
+
+static int hugepage_vma_revalidate(struct mm_struct *mm,
+				   struct vm_area_struct *vma,
+				   unsigned long address)
+{
+	unsigned long hstart, hend;
+
+	if (unlikely(khugepaged_test_exit(mm)))
+		return SCAN_ANY_PROCESS;
+
+	vma = find_vma(mm, address);
+	if (!vma)
+		return SCAN_VMA_NULL;
+
+	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
+	hend = vma->vm_end & HPAGE_PMD_MASK;
+	if (address < hstart || address + HPAGE_PMD_SIZE > hend)
+		return SCAN_ADDRESS_RANGE;
+	if (!hugepage_vma_check(vma))
+		return SCAN_VMA_CHECK;
+	return 0;
+}
+
+/*
  * Bring missing pages in from swap, to complete THP collapse.
  * Only done if khugepaged_scan_pmd believes it is worthwhile.
  *
@@ -2385,7 +2414,7 @@ static bool hugepage_vma_check(struct vm_area_struct *vma)
  * but with mmap_sem held to protect against vma changes.
  */
 
-static void __collapse_huge_page_swapin(struct mm_struct *mm,
+static bool __collapse_huge_page_swapin(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					unsigned long address, pmd_t *pmd)
 {
@@ -2401,11 +2430,18 @@ static void __collapse_huge_page_swapin(struct mm_struct *mm,
 			continue;
 		swapped_in++;
 		ret = do_swap_page(mm, vma, _address, pte, pmd,
-				   FAULT_FLAG_ALLOW_RETRY|FAULT_FLAG_RETRY_NOWAIT,
+				   FAULT_FLAG_ALLOW_RETRY,
 				   pteval);
+		/* do_swap_page returns VM_FAULT_RETRY with released mmap_sem */
+		if (ret & VM_FAULT_RETRY) {
+			down_read(&mm->mmap_sem);
+			/* vma is no longer available, don't continue to swapin */
+			if (hugepage_vma_revalidate(mm, vma, address))
+				return false;
+		}
 		if (ret & VM_FAULT_ERROR) {
 			trace_mm_collapse_huge_page_swapin(mm, swapped_in, 0);
-			return;
+			return false;
 		}
 		/* pte is unmapped now, we need to map it */
 		pte = pte_offset_map(pmd, _address);
@@ -2413,6 +2449,7 @@ static void __collapse_huge_page_swapin(struct mm_struct *mm,
 	pte--;
 	pte_unmap(pte);
 	trace_mm_collapse_huge_page_swapin(mm, swapped_in, 1);
+	return true;
 }
 
 static void collapse_huge_page(struct mm_struct *mm,
@@ -2427,7 +2464,6 @@ static void collapse_huge_page(struct mm_struct *mm,
 	struct page *new_page;
 	spinlock_t *pmd_ptl, *pte_ptl;
 	int isolated = 0, result = 0;
-	unsigned long hstart, hend;
 	struct mem_cgroup *memcg;
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
@@ -2450,39 +2486,37 @@ static void collapse_huge_page(struct mm_struct *mm,
 		goto out_nolock;
 	}
 
-	/*
-	 * Prevent all access to pagetables with the exception of
-	 * gup_fast later hanlded by the ptep_clear_flush and the VM
-	 * handled by the anon_vma lock + PG_lock.
-	 */
-	down_write(&mm->mmap_sem);
-	if (unlikely(khugepaged_test_exit(mm))) {
-		result = SCAN_ANY_PROCESS;
+	down_read(&mm->mmap_sem);
+	result = hugepage_vma_revalidate(mm, vma, address);
+	if (result)
 		goto out;
-	}
 
-	vma = find_vma(mm, address);
-	if (!vma) {
-		result = SCAN_VMA_NULL;
-		goto out;
-	}
-	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
-	hend = vma->vm_end & HPAGE_PMD_MASK;
-	if (address < hstart || address + HPAGE_PMD_SIZE > hend) {
-		result = SCAN_ADDRESS_RANGE;
-		goto out;
-	}
-	if (!hugepage_vma_check(vma)) {
-		result = SCAN_VMA_CHECK;
-		goto out;
-	}
 	pmd = mm_find_pmd(mm, address);
 	if (!pmd) {
 		result = SCAN_PMD_NULL;
 		goto out;
 	}
 
-	__collapse_huge_page_swapin(mm, vma, address, pmd);
+	/*
+	 * __collapse_huge_page_swapin always returns with mmap_sem
+	 * locked. If it fails, release mmap_sem and jump directly
+	 * label out. Continuing to collapse causes inconsistency.
+	 */
+	if (!__collapse_huge_page_swapin(mm, vma, address, pmd)) {
+		up_read(&mm->mmap_sem);
+		goto out;
+	}
+
+	up_read(&mm->mmap_sem);
+	/*
+	 * Prevent all access to pagetables with the exception of
+	 * gup_fast later handled by the ptep_clear_flush and the VM
+	 * handled by the anon_vma lock + PG_lock.
+	 */
+	down_write(&mm->mmap_sem);
+	result = hugepage_vma_revalidate(mm, vma, address);
+	if (result)
+		goto out;
 
 	anon_vma_lock_write(vma->anon_vma);
 
-- 
2.8.1

Patches currently in -mm which might be from ebru.akagunduz@gmail.com are

mm-make-optimistic-check-for-swapin-readahead.patch
mm-make-optimistic-check-for-swapin-readahead-fix-3.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-ks.patch
mm-thp-fix-locking-inconsistency-in-collapse_huge_page.patch

