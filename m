Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914066F2EB
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423473; cv=none; b=VtpSXK8VRn179CogzmPYqJB/Gp9ZPhg/vcU+cEF8az7hoj88bgIbbyoFMy7spDe1vXfo0TdpQE3ATOsQkkSBtYrMfxxCb8yyWoM+qoXsB8iCaENcH9U77i3DglAEK1l4NW9Kr1U7MT1ct9uAM3F3po98/B1zC0Dadp4u3KnRagE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423473; c=relaxed/simple;
	bh=xKfkBgHpmmIArKEmqpPU7NtYvpSSsNFHZlw4GIm2wwA=;
	h=Date:To:From:Subject:Message-Id; b=MJRNg76d9SspCS6MU9kgS7QBkjMj1XeZIVTXIduywPGcFEyv9/5O77CkJgopNG3wrg8oc5b6qgOYXTAF27tHovXgxdQbG9PjaTe+SMN7+cD8Lpwjnq0LpF0h1U8f5hvsLkZvDzygHyfnnDftzdRdAKR/A/E9JOd5gcVPTcgMoys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FTwoTQJS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FTwoTQJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63548C4CEC2;
	Wed,  4 Sep 2024 04:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423473;
	bh=xKfkBgHpmmIArKEmqpPU7NtYvpSSsNFHZlw4GIm2wwA=;
	h=Date:To:From:Subject:From;
	b=FTwoTQJSaRquImiabEN+zw+HwBnq3C0TF6fcOZgn2hsPw+CtQHIkxfuWzRX7Umfm1
	 8eei1T/DWXzOuei8afR9Uq7hx8Q+tlJHyW6jrKmN2M4QizOQygK7z+1T+z1h1xhLoA
	 VxEQKlG5jxsp9lv9B0qa1BglUsnV2SvLNdwgAE6E=
Date: Tue, 03 Sep 2024 21:17:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch removed from -mm tree
Message-Id: <20240904041753.63548C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: drop folio reference count using 'nr_pages' in shmem_delete_from_page_cache()
has been removed from the -mm tree.  Its filename was
     mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: drop folio reference count using 'nr_pages' in shmem_delete_from_page_cache()
Date: Mon, 12 Aug 2024 15:42:08 +0800

To support large folio swapin/swapout for shmem in the following patches,
drop the folio's reference count by the number of pages contained in the
folio when a shmem folio is deleted from shmem pagecache after adding into
swap cache.

Link: https://lkml.kernel.org/r/b371eadb27f42fc51261c51008fbb9a334985b4c.1723434324.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache
+++ a/mm/shmem.c
@@ -851,7 +851,7 @@ static void shmem_delete_from_page_cache
 	__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, -nr);
 	__lruvec_stat_mod_folio(folio, NR_SHMEM, -nr);
 	xa_unlock_irq(&mapping->i_pages);
-	folio_put(folio);
+	folio_put_refs(folio, nr);
 	BUG_ON(error);
 }
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


