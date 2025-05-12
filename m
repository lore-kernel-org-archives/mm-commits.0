Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8EF153598
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747010998; cv=none; b=WbRf5OgxLlpfzWxG3ttnyIQlLEfiZWXq2Qh2hjXiodQkaUH56zBPVpbHJe2LoRdzFef2Hi4ICaHijBGEydAcHgrzzoDCwpPk3MEueFh97pZDSrA76miPyXR/U9smZ5AK65Kz30/tX5nCSFh9B33bA6Q1BKzq8hNgbj8TkHF0GDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747010998; c=relaxed/simple;
	bh=gErJA2J6gomMaRFi+FEKwNkasChlI+btGZyBNA0zzGk=;
	h=Date:To:From:Subject:Message-Id; b=V4nBBo24Kpda6eIsQnZPUYlALtgN9pLoPwMBbG82RLvNidgN/JGI9RROZsOBzYO7sibOY/mkoyJrtc0rO4Jjfcsc/uonFNcO+S1LYH1uQGewjd17AyrS6nJsFFbneCBcLermtnZfy9BISBo5FrQyZGKk0D8gjELwapmJuTVLnes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ii//OTjZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ii//OTjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1A6C4CEE4;
	Mon, 12 May 2025 00:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747010997;
	bh=gErJA2J6gomMaRFi+FEKwNkasChlI+btGZyBNA0zzGk=;
	h=Date:To:From:Subject:From;
	b=Ii//OTjZdPgeCl4I1Z0gi161N5gYgNixrjUKBE5WPj6uhTHzSXf1KI1c3R4Hp5rci
	 fs78Wltf9bEXB0pwB4I/Sd6hNWMK3IUEliQ9/rc8+yGBglIlnQhZKBnOLYeIy1VaMH
	 j31uqZt8ke5LPmXCPROgWYPzKtZyZhSFe1ftlpi8=
Date: Sun, 11 May 2025 17:49:56 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-remove-readahead_page_batch.patch removed from -mm tree
Message-Id: <20250512004957.5A1A6C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: filemap: remove readahead_page_batch()
has been removed from the -mm tree.  Its filename was
     filemap-remove-readahead_page_batch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: filemap: remove readahead_page_batch()
Date: Wed, 2 Apr 2025 22:06:09 +0100

This function has no more callers; delete it.

Link: https://lkml.kernel.org/r/20250402210612.2444135-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   14 --------------
 1 file changed, 14 deletions(-)

--- a/include/linux/pagemap.h~filemap-remove-readahead_page_batch
+++ a/include/linux/pagemap.h
@@ -1448,20 +1448,6 @@ static inline unsigned int __readahead_b
 }
 
 /**
- * readahead_page_batch - Get a batch of pages to read.
- * @rac: The current readahead request.
- * @array: An array of pointers to struct page.
- *
- * Context: The pages are locked and have an elevated refcount.  The caller
- * should decreases the refcount once the page has been submitted for I/O
- * and unlock the page once all I/O to that page has completed.
- * Return: The number of pages placed in the array.  0 indicates the request
- * is complete.
- */
-#define readahead_page_batch(rac, array)				\
-	__readahead_batch(rac, array, ARRAY_SIZE(array))
-
-/**
  * readahead_pos - The byte offset into the file of this readahead request.
  * @rac: The readahead request.
  */
_

Patches currently in -mm which might be from willy@infradead.org are


