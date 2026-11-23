Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415130;
	b=VhJPDSK6JF+c0956eRZ3L/jPGVHJPLpiMIljw85nRajr0izKFJDzy+RZxPV3JiZHqZ5h
	 WcndfoXSRnwbhaJHokz6mc7J/yVtufVgrxLMmHBz4LzghFR0JzV+7XfemNfLvgXQ/2+9V
	 AQpFFsWibXr/chV6V0QshOmp69HQJLnpEgUTgRfMmZqCaPtenbuoHIoxsaEYyZBJVcg7/
	 KjEfhZuC+z8H7xDGgP8Yy9bLZKsrOrz8b8gQmB8RwnCeS08/9Ry3ZRxA0P/fGyJ6kxyvq
	 QOWeB7wAms2Z2mNqRcNb+QzFV6ka1aIqa3/0dbCra7HmpneKFs/88l7dWU+N2PCIP8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415130;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=ClWk66tS4/FKTayE6p2EFTJ26i1zYGM/BOZEtay9yKg=;
	b=sQ5TPlMas4aXgZlyDdieYPa9JA5VlWaMgxUjHrc4YEfP8SHbHSodpvM4zLnaWNSmwwx8
	 5lD615HAasYjk4rIHYR7YZAblGAloDfyTQh/7EyxfUII+Le3uUjHm90QIAWhRxJEOEv1W
	 uKT+mqx036c+7ezdojOswDipHlXSp9+YAYptszXfht96/QqyIBDZ5P428MLCa/P7gkgKj
	 Px6kN3sTQ9qZ4ftmYvvzXxxeKKObrzIKIMQp8OMA/ykyLKUSmAaw9x+Ur6I+KevyGhdIb
	 8paEtFjvbqcAef4kn8XHzbf+LwhtMZrr24RpGSRV67fHfjLw0ehDfHCYkJGG3Dcb/PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eLmnMnhZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D04606A32C;
	Mon, 23 Nov 2026 06:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eLmnMnhZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5730B1F000C0;
	Mon, 23 Nov 2026 06:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415130;
	bh=ClWk66tS4/FKTayE6p2EFTJ26i1zYGM/BOZEtay9yKg=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=eLmnMnhZYw6KnGI6oTAfxVUhOSUrx9qofSwU4Q3JOq6PMyIBHhQi5ioUvo5TYYwJq
	 dBT1oHDnonFrj+BdwGkzQq8VGzYHYH5khnjgEQn/eK1YghA0x4oO4fZQ5wfTr670Pv
	 7ywEj3w4TvSeb72H56tTqmQdJ7U6t+yP6TTYk0UQ=
Date: Sun, 22 Nov 2026 22:25:29 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vivek.kasireddy@intel.com,
	vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,
	stable@vger.kernel.org,skhan@linuxfoundation.org,rppt@kernel.org,
	riel@surriel.com,rdunlap@infradead.org,peterz@infradead.org,
	peterx@redhat.com,osalvador@suse.de,osalvador@kernel.org,npiggin@gmail.com,
	nao.horiguchi@gmail.com,muchun.song@linux.dev,mhocko@suse.com,
	mgorman@suse.de,mason@kernel.org,luojiajun3@huawei.com,ljs@kernel.org,
	linmiaohe@huawei.com,liam@infradead.org,leitao@debian.org,kraxel@redhat.com,
	jgg@ziepe.ca,hughd@google.com,hca@linux.ibm.com,gourry@gourry.net,
	gor@linux.ibm.com,david@kernel.org,corbet@lwn.net,borntraeger@linux.ibm.com,
	baolin.wang@linux.alibaba.com,arnd@arndb.de,apw@canonical.com,
	aneesh.kumar@kernel.org,airlied@redhat.com,agordeev@linux.ibm.com,
	ackerleytng@google.com,4ncienth@gmail.com,josef@toxicpanda.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261116-fixes_hugetlb-v2-7-4dd9e94ea9ac@kernel.org>
References: <20261116-fixes_hugetlb-v2-7-4dd9e94ea9ac@kernel.org>
Subject: [merged mm-hotfixes-stable] hugetlbfs-fix-unmapping-folios-from-private-vmas.patch removed from -mm tree
Message-Id: <20261123062530.5730B1F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: hugetlbfs: fix unmapping folios from private VMAs
has been removed from the -mm tree.  Its filename was
     hugetlbfs-fix-unmapping-folios-from-private-vmas.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josef Bacik <josef@toxicpanda.com>
Subject: hugetlbfs: fix unmapping folios from private VMAs
Date: Mon, 16 Nov 2026 19:29:28 +0100

hugetlb_unmap_file_folio() assumes vm_private_data points to a struct
hugetlb_vma_lock when hugetlb_vma_trylock_write() fails. Since hugetlb VMA
locking was extended to private VMAs, this can also happen when
vm_private_data contains a resv_map pointer; treating it as a
hugetlb_vma_lock corrupts memory and can cause crashes or hangs.

Only take the VMA lock when a shareable lock exists, as additional locking
is only needed for PMD table sharing. The fault mutex and i_mmap_rwsem
already provide the required protection for private VMAs.

Fix generated by an LLM and sent by Josef Bacik in private.

[david@kernel.org: simplify description and comment]
Link: https://patch.msgid.link/20261116-fixes_hugetlb-v2-7-4dd9e94ea9ac@kernel.org
Fixes: bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private VMAs")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Daehyeon Ko <4ncienth@gmail.com>
  Link: https://lore.kernel.org/20261116-fixes_hugetlb-v2-7-4dd9e94ea9ac@kernel.org
Acked-by: Muchun Song <muchun.song@linux.dev>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
  Link: https://lore.kernel.org/179490430300.482102.17633361840450824485.b4-reply@b4
Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Will Deacon <will@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Chris Mason <mason@kernel.org>
Cc: luojiajun <luojiajun3@huawei.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: <stable@vger.kernel.org>

 fs/hugetlbfs/inode.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-fix-unmapping-folios-from-private-vmas
+++ a/fs/hugetlbfs/inode.c
@@ -401,6 +401,16 @@ retry:
 		if (!hugetlb_vma_maps_pfn(vma, v_start, pfn))
 			continue;
 
+		/*
+		 * We only need additional VMA locking here for PMD table
+		 * sharing, which synchronizes on the shareable lock.
+		 */
+		if (!__vma_shareable_lock(vma)) {
+			unmap_hugepage_range(vma, v_start, v_end, NULL,
+					     ZAP_FLAG_DROP_MARKER);
+			continue;
+		}
+
 		if (!hugetlb_vma_trylock_write(vma)) {
 			vma_lock = vma->vm_private_data;
 			/*
_

Patches currently in -mm which might be from josef@toxicpanda.com are

mm-zswap-drop-the-stale-zswap-entry-of-a-zero-folio.patch
mm-swap-account-synchronous-swap-reads-as-memory-stall.patch
mm-mremap-fix-hugetlb-reservation-leak-on-partial-move.patch
selftests-mm-test-a-partial-mremap-of-hugetlb-memory.patch
mm-mremap-reaccount-on-unmap-failure-only-if-accounted.patch
mm-mremap-restore-vma_account_bit-if-the-unmap-fails.patch
selftests-mm-test-mremap-with-an-old-size-of-0.patch
zram-lz4-lz4hc-accept-dictionaries-of-more-than-64-kib.patch
mm-hugetlb-keep-surplus-folios-when-the-pool-shrinks.patch

