Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D51310F1
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 05:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730696440; cv=none; b=FwwXQnT9teSA6/5QQYNn/Ci8ie+xJouTL12S0bh7dp9u+sjop7LX7V2qrruVulHCYVrzVeWG/gQXLsfgvRzQiaLJ5HVG9iYW/vhDMxgo2xqmnHA1KXcrQJom3OtISKy1BmuMRRbt68honIu7bqM37KnTll7F/+TMXMwo3YYZStE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730696440; c=relaxed/simple;
	bh=9hY6ej0ZtpzAj/xHqyJDeNiLCTEhAHuGQzxdQvWLgFM=;
	h=Date:To:From:Subject:Message-Id; b=FzbtlHKWWNYpOxb2OW4+tI6l9iqNMnTXyZcka/9oCH7CigLJtzwjQsGk7mDob5zpQEYYurHNBXd4WMDUbG9cwE/DogI6+VRElhXR/g4tNQSukvk6jPivoFwiOCOqtKWVIzgvp5YTfZLFDqfc1VCZOigZ2oraUzh4zqsVwWAaLRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QuIJ/nnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QuIJ/nnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5B2C4CECE;
	Mon,  4 Nov 2024 05:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730696438;
	bh=9hY6ej0ZtpzAj/xHqyJDeNiLCTEhAHuGQzxdQvWLgFM=;
	h=Date:To:From:Subject:From;
	b=QuIJ/nnKwrUDqNhJfPlBdRJ+pp9us+dRU1R+95QqyUXfbokIuT7aY1QInjMJkrBl4
	 GjgmQ/rzmKcr/YjB5JehNxU1zbBo2skZVQQn+VST/54eYAMj43Zx+ibjW3aNqr6cZy
	 +iiL6R2FWk/YUgRNxHRmJyXl4Gc0Dbrwqt1LHqu4=
Date: Sun, 03 Nov 2024 21:00:38 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,hughd@google.com,dhowells@redhat.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages-fix.patch removed from -mm tree
Message-Id: <20241104050038.9B5B2C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages-fix
has been removed from the -mm tree.  Its filename was
     mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages-fix.patch

This patch was dropped because it was folded into mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages.patch

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages-fix
Date: Fri, 1 Nov 2024 09:56:29 +0800

code layout cleaup, per dhowells

Link: https://lkml.kernel.org/r/32dd938c-3531-49f7-93e4-b7ff21fec569@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: David Howells <dhowells@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/shmem.c~mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages-fix
+++ a/mm/shmem.c
@@ -3332,12 +3332,11 @@ static ssize_t shmem_file_splice_read(st
 		 * Fallback to PAGE_SIZE splice if the large folio has hwpoisoned
 		 * pages.
 		 */
-		if (likely(!fallback_page_splice)) {
-			size = len;
-		} else {
+		size = len;
+		if (unlikely(fallback_page_splice)) {
 			size_t offset = *ppos & ~PAGE_MASK;
 
-			size = min_t(loff_t, PAGE_SIZE - offset, len);
+			size = umin(size, PAGE_SIZE - offset);
 		}
 		part = min_t(loff_t, isize - *ppos, size);
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-fix-khugepaged-activation-policy-for-shmem.patch
mm-shmem-update-iocb-ki_pos-directly-to-simplify-tmpfs-read-logic.patch
mm-shmem-improve-the-tmpfs-large-folio-read-performance.patch
mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages.patch

