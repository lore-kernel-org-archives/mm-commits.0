Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415124;
	b=NKrVZFtqUaJNNNCQr69b4Ey2Mx9yvqTmD8Ijws8B6jDKtEDbydnbtbYijbe6W5XYEIql
	 mPinNn9PaqmgVnT5933pQ/P452U3JPrrtlBbQ4g9VpIFeDBeIDXJ7zJJClKmj815+WiSx
	 JG8frGdz4pcjJgHx1puBiqS/ncAX8aRaDgb32T0fcYiSHjXRgOeMYWEsameYueBAo7cfG
	 yiDKyIde/L5mdsZ/IN6jsXLDjZ2yqLod27n8e3WEcrB7dFEK1DogQCn+7X/NogMRnyUrc
	 7ZeRoO52VEYPW50Re+2I1yEc7CUlgMlpw1AA74ZdPtnLzA5RHkmrvxZTlY1BycR/97w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415124;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=D09dkXM9IMBQTvBXGK1I74C5JnX8Qaj9vntsag0PCj0=;
	b=vkXJtcjuPkm92I8Ab0Yzegtm4WpEaJtxnBYE4nOhv3o28qpSRY6BxhsHNDZGCX1JX6jk
	 4wmA3izGynQJNKwtLPyp79BBwrUEf94ZdGEMN8hxQC7CHdLRQPL+a2nB0O028oXCaWSnO
	 LVXwXGuK8Pmscut94UEjVNTKcPzGVDT3SG0I8BaFeUWzGFd/rE87txkSpBUoOceZHVFJ+
	 y8fyLlckQhwmf8uK0ZG+DG0C/DpAY7tVd2qaqK3KCNxnaB4lDqxuBU3pfNdCduX0YnUeh
	 NaS5BTfRXYLoBoM46fUWF/98iAegDULOuuhsKzvLAKHOuq//GJxT0l253tt7NMAaTWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xdPFcI5r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4814F606A31A;
	Mon, 23 Nov 2026 06:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xdPFcI5r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8FC1F000C0;
	Mon, 23 Nov 2026 06:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415123;
	bh=D09dkXM9IMBQTvBXGK1I74C5JnX8Qaj9vntsag0PCj0=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=xdPFcI5rImUrDp+XW89waYZty4xWIrVIhf7uCT6fKXS5EMWNMN5Hu61L62LteFQW3
	 fD7yhrrCR/DDhDiIhGsLaya8OyFxj4ZLgZNyeXJ8H2AvrPtiS4P3kxP+Z/PNwQbFSm
	 b83eQuDbJukeABuUTVR6kwN3wQePVQhOUB9f9hlk=
Date: Sun, 22 Nov 2026 22:25:23 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vivek.kasireddy@intel.com,
	vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,
	stable@vger.kernel.org,skhan@linuxfoundation.org,rppt@kernel.org,
	riel@surriel.com,rdunlap@infradead.org,peterz@infradead.org,
	peterx@redhat.com,osalvador@suse.de,osalavador@suse.de,npiggin@gmail.com,
	nao.horiguchi@gmail.com,muchun.song@linux.dev,mhocko@suse.com,
	mgorman@suse.de,mason@kernel.org,luojiajun3@huawei.com,ljs@kernel.org,
	linmiaohe@huawei.com,liam@infradead.org,leitao@debian.org,kraxel@redhat.com,
	josef@toxicpanda.com,jgg@ziepe.ca,hughd@google.com,hca@linux.ibm.com,
	gourry@gourry.net,gor@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,
	baolin.wang@linux.alibaba.com,arnd@arndb.de,apw@canonical.com,
	aneesh.kumar@kernel.org,airlied@redhat.com,agordeev@linux.ibm.com,
	ackerleytng@google.com,4ncienth@gmail.com,david@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261116-fixes_hugetlb-v2-1-4dd9e94ea9ac@kernel.org>
References: <20261116-fixes_hugetlb-v2-1-4dd9e94ea9ac@kernel.org>
Subject: [merged mm-hotfixes-stable] hugetlbfs-fix-integer-overflow-in-fallocate.patch removed from -mm tree
Message-Id: <20261123062523.8C8FC1F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: hugetlbfs: fix integer overflow in fallocate()
has been removed from the -mm tree.  Its filename was
     hugetlbfs-fix-integer-overflow-in-fallocate.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: hugetlbfs: fix integer overflow in fallocate()
Date: Mon, 16 Nov 2026 19:29:22 +0100

hugetlbfs_fallocate() rounds the range end up by adding hpage_size - 1
to offset + len. vfs_fallocate()'s existing overflow check only makes
sure that offset + len does not overflow.

Once we overflow for valid endpoints near LLONG_MAX, we can get a
negative temporary result that is then converted to a very large
huge page index.

A one-byte allocation ending at LLONG_MAX can therefore consume all
available huge pages. Pages added beyond LLONG_MAX are skipped during
inode eviction, leaking them and triggering the BUG_ON() in clear_inode().

To fix it, calculate the end index in a simpler way that cannot
overflow. This also fixes the signed overflow reported by luojiajun in
2019.

Backporting notes: without commit a08c7193e4f18 ("mm/filemap: remove
hugetlb special casing in filemap.c"), remove_inode_hugepages() must
include the final huge page during truncate and eviction.

Link: https://lore.kernel.org/20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org
Link: https://patch.msgid.link/20261116-fixes_hugetlb-v2-1-4dd9e94ea9ac@kernel.org
Fixes: 70c3547e36f5 ("hugetlbfs: add hugetlbfs_fallocate()")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: luojiajun <luojiajun3@huawei.com>
Closes: https://lore.kernel.org/all/1554775226-67213-1-git-send-email-luojiajun3@huawei.com/
Reported-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
  Link: https://lore.kernel.org/20261116-fixes_hugetlb-v2-1-4dd9e94ea9ac@kernel.org
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Oscar Salvador <osalvador@suse.de>
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
Cc: Daehyeon Ko <4ncienth@gmail.com>
Cc: Oscar Salvador <osalavador@suse.de>
Cc: <stable@vger.kernel.org>

 fs/hugetlbfs/inode.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-fix-integer-overflow-in-fallocate
+++ a/fs/hugetlbfs/inode.c
@@ -722,11 +722,13 @@ static long hugetlbfs_fallocate(struct f
 
 	/*
 	 * Default preallocate case.
-	 * For this range, start is rounded down and end is rounded up
-	 * as well as being converted to page offsets.
+	 * vfs_fallocate() guarantees that offset + len is positive and does
+	 * not overflow. Avoid overflows when calculating the end huge page
+	 * index: set it to one past the index of the huge page containing the
+	 * last byte.
 	 */
 	start = offset >> hpage_shift;
-	end = (offset + len + hpage_size - 1) >> hpage_shift;
+	end = ((offset + len - 1) >> hpage_shift) + 1;
 
 	inode_lock(inode);
 
_

Patches currently in -mm which might be from david@kernel.org are

mm-mprotect-dont-skip-uffd-marker-install-when-racing-with-pte-table-reclaim.patch
mm-khugepaged-free-unused-page-table-when-setting-a-huge-pmd-fails.patch
mm-userfaultfd-prevent-poison-marker-loss.patch
mm-hugetlb-compare-against-persistent-count-when-freeing-lowmem-folios.patch
mm-hugetlb-preserve-reservations-when-shrinking-on-highmem.patch
mm-hugetlb-account-temporary-folios-separately.patch
mm-hugetlb-account-temporary-folios-separately-fix.patch
mm-hugetlb-serialize-page-cache-allocations-with-truncation.patch
mm-memfd-recheck-the-page-cache-before-allocating-a-hugetlb-folio.patch
mm-hugetlb-count-again-if-the-reserve-map-shrank.patch
mm-hugetlb-account-restored-reservations-before-freeing-folios.patch
mm-hugetlb-delay-anon-folio-rmap-removal-until-after-the-tlb-flush.patch

