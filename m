Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287281369
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SSsLPxtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E974C433C7;
	Mon, 11 Dec 2023 00:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702255394;
	bh=nPl7NfGahEhmMW8PtdnjpUjQMA3+Wi1i1i9bJzuiUHg=;
	h=Date:To:From:Subject:From;
	b=SSsLPxtVePUJybYMH/w9oIsCQynQuhPc+MZ6tPJeapW4FAN6hPAvljTvT+b4nforo
	 uHJKgmTZjPGqzH1sEs8Is8kh/Rksp9XTOAnWZNttJtxL5fCAozfs7IEEy5yxmFzn44
	 9Mpaw/5egoYr0dd6SQaz+kqV8NE7U8nZbm3CC71I=
Date: Sun, 10 Dec 2023 16:43:14 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tytso@mit.edu,djwong@kernel.org,agruenba@redhat.com,adilger.kernel@dilger.ca,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-folio_zero_tail-and-use-it-in-ext4-fix.patch removed from -mm tree
Message-Id: <20231211004314.8E974C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-folio_zero_tail-and-use-it-in-ext4-fix
has been removed from the -mm tree.  Its filename was
     mm-add-folio_zero_tail-and-use-it-in-ext4-fix.patch

This patch was dropped because it was folded into mm-add-folio_zero_tail-and-use-it-in-ext4.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-folio_zero_tail-and-use-it-in-ext4-fix
Date: Thu Nov  9 02:39:20 PM PST 2023

fix kerneldoc argument ordering

Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/highmem.h~mm-add-folio_zero_tail-and-use-it-in-ext4-fix
+++ a/include/linux/highmem.h
@@ -486,8 +486,8 @@ static inline void memcpy_to_folio(struc
 /**
  * folio_zero_tail - Zero the tail of a folio.
  * @folio: The folio to zero.
- * @kaddr: The address the folio is currently mapped to.
  * @offset: The byte offset in the folio to start zeroing at.
+ * @kaddr: The address the folio is currently mapped to.
  *
  * If you have already used kmap_local_folio() to map a folio, written
  * some data to it and now need to zero the end of the folio (and flush
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-add-folio_zero_tail-and-use-it-in-ext4.patch
mm-add-folio_fill_tail-and-use-it-in-iomap-fix.patch
mm-memcg-restore-subtree-stats-flushing-fix.patch
kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix.patch

