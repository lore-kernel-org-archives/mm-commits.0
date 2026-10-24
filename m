Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832248;
	b=T5AnrgYcfiCunDfwqGN25FduZ25QOgrLBvvWATFjaYoP6BnMknbGy+blL8ccoNhKPn8w
	 sTgsvKBEVBO65N3gRtdi+4JHkoAHVMSo3R2YnTmvVmEZkzlPojs0rFc81RaQMgInHqCVC
	 86T+val4IjxBWp6jXC64rIywfE/bbNv9is1F4Ki3U3UrwwgOcky21D4CqbKv+9t6vVt7j
	 YUcHK9h5ZEbFbxCrAaaq1fkM9f00ucN8BVZ7TRCsuhR36iBmIlZeSXQjhMxk+5lprzzB4
	 Ge5XWQXgsl7v9ZCjEBGBPRZCB1cCWJA/Q5ySxRavNM8VuqR+PM+AueDhWUSmsfba9ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832248;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=MQrurpo7gxTrEyL/tSzYDEBu2t88T6eX0tCZinZ0tp4=;
	b=wJZ5i5LeNF0Y3yh3MqW8kaLKHL4vu2H04PEYd8hjlu7ksuP7Hs8tZxM9QC/g2G651rnc
	 N8N9OrG9RNlB9xVMdBnQ19OpO1exsnoanEE/iaS/PDyPlBxiZ7x4q6GAWFTnMtxDY/Odb
	 3YehDba0LCkA/7XRAmHJ8tiP9G9lXuysc/rW23pexNtDj44IY4PDsOXOvBj6fiEvjICpj
	 W+nhaO3T1rhTz19fw8v4s+FPu4cV3ULLenwVia9kBLe/CGt4RxqMEMfu9Vyqu+femIKPa
	 95AJ/jTai4I6cqSO4kVBum/MR2Q57XOJJsonABWdhPBA+nb2nDuKGidlU2Wx7RzwRdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oc6iMaKz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D02606A31B;
	Sat, 24 Oct 2026 08:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oc6iMaKz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074991F01825;
	Sat, 24 Oct 2026 08:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832248;
	bh=MQrurpo7gxTrEyL/tSzYDEBu2t88T6eX0tCZinZ0tp4=;
	h=Date:To:From:Subject;
	b=oc6iMaKz7ctE+ScOr2Gf0mU22BoFGmge7wnv8wnBuDYsx5gOyazVX83BoE1m2Tftu
	 GJSwnN3N2JOi+NiR6pTSTyHPn1ERAJ5LPsDiTbZIZ6wEjIqRZpMi+klSS4ZdPgxdQS
	 Ttw2Z2JURrPyVmnDx7LoZkZkVTyawQLVBqvVneHQ=
Date: Sat, 24 Oct 2026 01:57:27 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mgorman@techsingularity.net,mason@kernel.org,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,jannh@google.com,david@kernel.org,agl@us.ibm.com,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-endless-write-fault-on-a-leftover-uffd-bit.patch removed from -mm tree
Message-Id: <20261024085728.074991F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/hugetlb: fix endless write fault on a leftover uffd bit
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-endless-write-fault-on-a-leftover-uffd-bit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm/hugetlb: fix endless write fault on a leftover uffd bit
Date: Thu, 15 Oct 2026 18:07:12 +0200

hugetlb_fault() resolves the uffd bit on a write fault only if the VMA is
registered for userfaultfd write protection, and hugetlb_wp() bails out
for any entry with the uffd bit set assuming hugetlb_fault() has already
resolved it.

When a read-only hugetlb entry with the uffd bit set is mapped in a VMA
that is not registered for uffd-wp, a write fault to it never makes
progress. If the access comes from the kernel, e.g. read(2) from
/dev/zero into such page, the task spins in the page fault handler,
ignores SIGKILL and keeps holding the locks taken by the system call.

Such entries should not exist, but an unprivileged user can create them,
for example with MADV_DONTNEED of a page protected with UFFDIO_RWPROTECT
or with UFFDIO_COPY in MODE_WP racing with UFFDIO_UNREGISTER.

Clear the uffd bit when the VMA is not registered for uffd-wp and let the
fault proceed to hugetlb_wp(), like do_wp_page() does for regular pages.

Note that a FOLL_FORCE write to a page protected with UFFDIO_RWPROTECT in
a private VMA that was made PROT_NONE now drops the RWP protection of
that page.

Original fix generated by an LLM and sent in private by Josef.

[rppt@kernel.org: massage commit message]
[david@kernel.org: convert comment into a TODO]
Link: https://lore.kernel.org/20261015-urgent_fixes-v1-6-42796911043b@kernel.org
Fixes: 60d5b473d61b ("mm/hugetlb: fix uffd wr-protection for CoW optimization path")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/hugetlb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-endless-write-fault-on-a-leftover-uffd-bit
+++ a/mm/hugetlb.c
@@ -6226,15 +6226,19 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		goto out_ptl;
 
 	/* Handle userfault-wp first, before trying to lock more pages */
-	if (userfaultfd_wp(vma) && huge_pte_uffd(huge_ptep_get(mm, vmf.address, vmf.pte)) &&
+	if (huge_pte_uffd(huge_ptep_get(mm, vmf.address, vmf.pte)) &&
 	    (flags & FAULT_FLAG_WRITE) && !huge_pte_write(vmf.orig_pte)) {
-		if (!userfaultfd_wp_async(vma)) {
+		if (userfaultfd_wp(vma) && !userfaultfd_wp_async(vma)) {
 			spin_unlock(vmf.ptl);
 			hugetlb_vma_unlock_read(vma);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			return handle_userfault(&vmf, VM_UFFD_WP);
 		}
 
+		/*
+		 * TODO: fix all cases where uffd PTE bits remain in VMAs that
+		 * are no longer registered with uffd.
+		 */
 		vmf.orig_pte = huge_pte_clear_uffd(vmf.orig_pte);
 		set_huge_pte_at(mm, vmf.address, vmf.pte, vmf.orig_pte,
 				huge_page_size(hstate_vma(vma)));
_

Patches currently in -mm which might be from josef@toxicpanda.com are


