Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06471C69D;
	Thu,  4 Sep 2025 00:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756944690; cv=none; b=ko9KFSqQOXqhi+mGer2BTxbQrjMKo/QUGcqh+2w+JDSaQtcEy780ou0FrOLEGezJFR4j69Jzmn0WsKs9lMtgvXT7POl87xwcw5kAknn4yaGMcn1M/E4jItFOfpiRCQncmM3KaGOXygDxZgJ2fi8WsuWFDGCsktYaMZb36NbsThA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756944690; c=relaxed/simple;
	bh=a0EMd0RJ7hfE4CFEN4ip/kcLtt/fvZCkUF4lyLB9Pe0=;
	h=Date:To:From:Subject:Message-Id; b=F5Uue10v23Cb4t39QgcpxxzdnX35X4MfANou/VTFpDP3vvJOf2z/TmWHbdSZpe/MCooBEj2OIMkRJoC6aVt6SLTMXvwyd5YmE4y9NmtDXNAmEF4r6gzW1lyas2Gg1xIlKQJ4va/wPq4yaxUvkZ2t+hi4DRe02bOCvojVMiBA42M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zMXNmmWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zMXNmmWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F519C4CEE7;
	Thu,  4 Sep 2025 00:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756944689;
	bh=a0EMd0RJ7hfE4CFEN4ip/kcLtt/fvZCkUF4lyLB9Pe0=;
	h=Date:To:From:Subject:From;
	b=zMXNmmWANJ0C0l1aSIvTBXdpNjvGOwzJW3mQTZB8xRomQi/qUFRnN7loSZsoUxXdv
	 XKPkYSv59qKUCiqjvzZuYH6LK9KByqZqnw/P/VtM0t5wUvIFl/nZ6ccttg0QaPxYnD
	 knbYKZ6FFneRZ52hIIb8T2boUVObeP2JpWor2glM=
Date: Wed, 03 Sep 2025 17:11:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,stable@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young.patch removed from -mm tree
Message-Id: <20250904001129.6F519C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: fix the address passed to notifier on testing young
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/khugepaged: fix the address passed to notifier on testing young
Date: Fri, 22 Aug 2025 06:33:18 +0000

Commit 8ee53820edfd ("thp: mmu_notifier_test_young") introduced
mmu_notifier_test_young(), but we are passing the wrong address.
In xxx_scan_pmd(), the actual iteration address is "_address" not
"address".  We seem to misuse the variable on the very beginning.

Change it to the right one.

[akpm@linux-foundation.org fix whitespace, per everyone]
Link: https://lkml.kernel.org/r/20250822063318.11644-1-richard.weiyang@gmail.com
Fixes: 8ee53820edfd ("thp: mmu_notifier_test_young")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-the-address-passed-to-notifier-on-testing-young
+++ a/mm/khugepaged.c
@@ -1417,8 +1417,8 @@ static int hpage_collapse_scan_pmd(struc
 		 */
 		if (cc->is_khugepaged &&
 		    (pte_young(pteval) || folio_test_young(folio) ||
-		     folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
-								     address)))
+		     folio_test_referenced(folio) ||
+		     mmu_notifier_test_young(vma->vm_mm, _address)))
 			referenced++;
 	}
 	if (!writable) {
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-rmap-do-__folio_mod_stat-in-__folio_add_rmap.patch
selftests-mm-do-check_huge_anon-with-a-number-been-passed-in.patch
mm-rmap-not-necessary-to-mask-off-folio_pages_mapped.patch
mm-rmap-use-folio_large_nr_pages-when-we-are-sure-it-is-a-large-folio.patch
selftests-mm-put-general-ksm-operation-into-vm_util.patch
selftests-mm-test-that-rmap-behave-as-expected.patch
mm-khugepaged-use-list_xxx-helper-to-improve-readability.patch
mm-page_alloc-use-xxx_pageblock_isolate-for-better-reading.patch
mm-pageblock-flags-remove-pb_migratetype_bits-pb_migrate_end.patch
mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order.patch
mm-page_alloc-find_large_buddy-from-start_pfn-aligned-order-v2.patch

