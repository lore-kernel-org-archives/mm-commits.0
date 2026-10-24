Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832240;
	b=un6YfWTTfozQAR2Cffv7s1FVmQ3k4DB1MnTkeFgapvCd3zr7FzEDFVn6auH/6x/gqMTk
	 QbkiUr82GNY/dYpqPJSQ5WgqmT/I9TbA1z58p4TgG9W1wN5WsU7a5hdbbjWfzeBikGCBs
	 m6+kpTCfagBGNoPm29obCLs/Ypxtgco9UyYzJMxFkLgRbVs0unUSK/LhwzaMM+4j5qGFT
	 iSQcgIsLk9RopOQDwFaf2evMhmBGUzuQQiQGDM6vjVlGWzt8v28YGCNryoyoSTB50Lc8S
	 20Dg46bucoFYfJ6bIGl7AZ0Bk3VWS0bpLuMNyRpoUEPvkNbwFUovu8+VX6jbzM7oqtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832240;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=q6H6iv88V981j6004o/1rbfZ1x8Cbo2Yw3FXFWJYlPM=;
	b=EONK4SLW+eziiI6JzNa1tCPHCbtRMY+6hQW2UwUmWn+w/HzeFxcWWkcJBGYIilxnpBVj
	 Ekwvt0vn6dhldflZFxKPxHXo0KAtG19rG9qDdG17vGuDsg41YijuSUGNM9d5rNNE+KSeX
	 1w9PF/MXe3YQOFcjADgLaYYk9XlW4ZyjVf6hZXiQ0+h9Twrep6TQQ8PfKwlEOHSsNF0an
	 sm2wdFcVsE3hpdIAYAIG2cVjjzew/21GXwkpMhBRd0mGsOvE2u8xYMBwVT6nmBchoaJJS
	 5SLy5RLap///phFFQMKL8+7LOo1GHmL1gc9Kz1P7Y/wZB1lfswBes8bMTjYtWEoAz0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vnJr5IJy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F8E606A31A;
	Sat, 24 Oct 2026 08:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vnJr5IJy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9BD1F01825;
	Sat, 24 Oct 2026 08:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832240;
	bh=q6H6iv88V981j6004o/1rbfZ1x8Cbo2Yw3FXFWJYlPM=;
	h=Date:To:From:Subject;
	b=vnJr5IJyWk1AR7bhljwIPnqvaqnoxtz8jSH0ni9IT5krxLV6dAIhS0aHw9ZARmrDW
	 ig9Pl7cP3vZrHSsL7GApj13pIbpvYGadgmYrVT7Qa5wOPHe/zUe/5vndfKbtxXHMeH
	 M1uB36UJxrEYESzvIIZoDfkrkvuDgTgzOpA2HD+o=
Date: Sat, 24 Oct 2026 01:57:19 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mgorman@techsingularity.net,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,jannh@google.com,david@kernel.org,azpijr@gmail.com,agl@us.ibm.com,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-dont-leak-the-commit-charge-on-mmap-failure.patch removed from -mm tree
Message-Id: <20261024085719.EB9BD1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/vma: don't leak the commit charge on mmap failure
has been removed from the -mm tree.  Its filename was
     mm-vma-dont-leak-the-commit-charge-on-mmap-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[david@kernel.org: call variable "uncharged" and make it const, adjust/simplify comments]
Link: https://lore.kernel.org/20261015-urgent_fixes-v1-0-42796911043b@kernel.org
Link: https://lore.kernel.org/20261015-urgent_fixes-v1-1-42796911043b@kernel.org
Fixes: 4f87153e82c4 ("mm: change failure of MAP_FIXED to restoring the gap on failure")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
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


