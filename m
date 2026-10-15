Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7F412B94;
	Thu, 15 Oct 2026 22:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792105099; cv=none; b=H7DzjI25xkuBhCfhKEBmqdezijjps+EdW3lQhmhh5q9VyKgYzZ9WO77tz8XjgMUlDIIY6ZHCa40Y9MR/TnN34rWRijyeF1lurM1EV8TF2PqKCqXU4WMmyTjaoEYuA2/IvQ15AQX8HVIyOg1lIZyypCueYeFHLZBONxk8FWDMXdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792105099; c=relaxed/simple;
	bh=ZvVfpvFZJiDo30GkPH0cbd3rziqUXN70WspPh3eBQ64=;
	h=Date:To:From:Subject:Message-Id; b=Bfra1dGM9PgX+x+J/dinM6gpRxGVRx44dwCtgs5DwzrqXMW6mP2+2Db35J6ElbnTynuVa3ovc26HqHpsfvBYeGQbCG7OP754BIv8qEWwV6T4zM1tB/7lOs0pUOMc8yhGujSkUf8Vh8e9S8ODPyKmBWflVwcKhlfzdQaCiw/+otc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UUPXqsBK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UUPXqsBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C801F000C4;
	Thu, 15 Oct 2026 22:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792105096;
	bh=8b0EtdAuKO46RgstjAFS/jsRY6RpJ3wLJj0UDzt0Vi8=;
	h=Date:To:From:Subject;
	b=UUPXqsBKbx7Tvi6hczZVaRqPegEjSTkmmMs8cHVd29VhPnAKMDER7tyNYF8LYyj5/
	 Y8DF/FRVdNV3MOA+VSIqw2rdOO3RPJvegFIyj9nxejA3lJfAAAPgABTpOUdP7WavcQ
	 hyGZaKEEHGOstFg5eawg1daYga3BZLXg5LvtJPeE=
Date: Thu, 15 Oct 2026 15:58:15 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mel@csn.ul.ie,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,kas@kernel.org,jannh@google.com,david@kernel.org,agl@us.ibm.com,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-dont-leak-the-commit-charge-on-mmap-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20261015225816.73C801F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: don't leak the commit charge on mmap failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vma-dont-leak-the-commit-charge-on-mmap-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-dont-leak-the-commit-charge-on-mmap-failure.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm/vma: don't leak the commit charge on mmap failure
Date: Thu, 15 Oct 2026 18:07:07 +0200

Patch series "mm: various (urgent?) fixes", v1.

Here are various MM fixes.  The majority was reported by Josef at
Anthrophic, the remainder was found while reviewing/overhauling them.

Two issues/fixes reported are not included, as we are discussing
(better) alternatives on the list already.

I left most of the original commit messages as schloppy as they are: I
don't particularly care as long as the code is in good shape and as long
as they are not actively wrong.  But I (and Mike) could not be stopped
from overhauling at least some of them.

While I don't think there is anything too critical in here, I think this
is a good opportunity to see how fast we can get pre-screened/pre-reviewed
fixes upstream that might be security-related.

The majority are hugetlb + uffd issues, that are not actually that
relevant for most installations.  But all things that should just get
fixed.  Some uffd fixes need proper follow ups to fix some more of the
root causes of leftover UFFD PTE bits (or proof that there are none
remaining).


This patch (of 10):

When an accountable mapping replaces existing mappings (MAP_FIXED),
__mmap_setup() only charges the difference between the size of the new
mapping and the VM_ACCOUNT pages it replaces. It then zeroes
vms->nr_accounted so that unmapping the old VMAs does not return their
charge, which now backs the new mapping.

If the operation fails after that point, the error path returns
map->charged, i.e. only the difference. By then vms_clean_up_area() has
zapped the page tables and closed the old VMAs, so
vms_abort_munmap_vmas() cannot reattach them. It leaves a gap and
finishes the unmap with vms_complete_munmap_vmas(), which uncharges
vms->nr_accounted == 0 pages. The old VMAs are gone, the new one was
never created, and the charge of the old ones is never returned, not
even when the process exits.

No privilege is needed to hit this, only a file whose mmap hook fails,
for example a socket (sock_no_mmap() returns -ENODEV):

	p = mmap(NULL, len, PROT_READ | PROT_WRITE,
		 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	mmap(p, len, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_FIXED,
	     socket_fd, 0);

Every iteration adds len to Committed_AS for good. With
vm.overcommit_memory=2 this lets any user make all further accountable
allocations in the system fail with -ENOMEM.

Once the new mapping has taken over the charge of the mappings it
replaces, it owns the charge for all of its pages. Record that in
map->charged, so that the error path returns all of it.

A failure in __mmap_setup() itself is not affected: it happens before
the charge is taken over and the old VMAs are reattached with their
charge intact.

Original fix generated by an LLM and sent in private by Josef.

Link: https://lore.kernel.org/20261015-urgent_fixes-v1-0-42796911043b@kernel.org
Link: https://lore.kernel.org/20261015-urgent_fixes-v1-1-42796911043b@kernel.org
Fixes: 4f87153e82c4 ("mm: change failure of MAP_FIXED to restoring the gap on failure")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
[ david: call variable "uncharged" and make it const, adjust/simplify comments ]
---

 mm/vma.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/vma.c~mm-vma-dont-leak-the-commit-charge-on-mmap-failure
+++ a/mm/vma.c
@@ -2577,14 +2577,17 @@ static int __mmap_setup(struct mmap_stat
 
 	/* Private writable mapping: check memory availability. */
 	if (accountable_mapping(map)) {
-		map->charged = map->pglen;
-		map->charged -= vms->nr_accounted;
-		if (map->charged) {
-			error = security_vm_enough_memory_mm(map->mm, map->charged);
+		const unsigned long uncharged = map->pglen - vms->nr_accounted;
+
+		/* Charge only what's not already charged by mappings we replace. */
+		if (uncharged) {
+			error = security_vm_enough_memory_mm(map->mm, uncharged);
 			if (error)
 				return error;
 		}
 
+		/* Our new mapping owns the entire charge now. */
+		map->charged = map->pglen;
 		vms->nr_accounted = 0;
 		vma_flags_set(&map->vma_flags, VMA_ACCOUNT_BIT);
 	}
_

Patches currently in -mm which might be from josef@toxicpanda.com are

mm-vma-dont-leak-the-commit-charge-on-mmap-failure.patch
mm-hugetlb-fix-use-after-free-of-a-new-anon-folio.patch
mm-hugetlb-unmap-the-page-where-the-other-vma-maps-it.patch
mm-hugetlb-dont-clear-the-resv_map-of-a-vma-whose-lock-is-held.patch
mm-hugetlb-fix-endless-write-fault-on-a-leftover-uffd-bit.patch
mm-hugetlb-dont-leave-a-uffd-wp-marker-when-zapping-an-rwp-entry.patch

