Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231BA1925AD;
	Fri,  6 Dec 2024 03:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457322; cv=none; b=JoSTwn9FgM3tIulF9+vVBb8Kgqfy2OQL+7kK2/Y4snG8gHc2Qz03YtD+k2UJqzvOQs8W9mjet0/+SfKsynX1EB++m8peb07COUBJexSm8zhhmLnt1d3C9li2NZo2OqytNk6Q3kVaIuKcfU4WFPjPFUBkGRlZjUPdx3aesdhpnas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457322; c=relaxed/simple;
	bh=BxIr7me1q/vyzx4dWFMAWtp949Lsul9tKUWA4rKiMbI=;
	h=Date:To:From:Subject:Message-Id; b=qX95p79/h90rtoj0N8VeZDuiGPJhhhGElCEiQNUQ/xgdXFtBvdmRvQjlL50msCFWzrcW0Fydc6OtfWxLFdTaT+nR13+DSaomNybb9S3vbycRHmIBfH++dunNTHTMFKbYiG/OEovyXKyrCxC+Fm3jr0i8LEBMKygTCRq+KwSiCjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yc9B3qIg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yc9B3qIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE1DC4CED1;
	Fri,  6 Dec 2024 03:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457321;
	bh=BxIr7me1q/vyzx4dWFMAWtp949Lsul9tKUWA4rKiMbI=;
	h=Date:To:From:Subject:From;
	b=yc9B3qIgvp+A+Mb0laeExkF+c2c7a3ric/1oe0RYGcuvMKqI+GY+lDgxIpPE50fg0
	 HAFTPi0yrRAkCQaUnMKY9uO+CivuXIHZ5YL2n86+41BhR0abN16+4iy6ChG8rVNmv4
	 OK3qjQk4vJvHedMCeclPUFtm+AT3e03NPFtzeC7E=
Date: Thu, 05 Dec 2024 19:55:21 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,phil@fifi.org,anders.blomdell@gmail.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch removed from -mm tree
Message-Id: <20241206035521.9DE1DC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "readahead: properly shorten readahead when falling back to do_page_cache_ra()"
has been removed from the -mm tree.  Its filename was
     revert-readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: Revert "readahead: properly shorten readahead when falling back to do_page_cache_ra()"
Date: Tue, 26 Nov 2024 15:52:08 +0100

This reverts commit 7c877586da3178974a8a94577b6045a48377ff25.

Anders and Philippe have reported that recent kernels occasionally hang
when used with NFS in readahead code.  The problem has been bisected to
7c877586da3 ("readahead: properly shorten readahead when falling back to
do_page_cache_ra()").  The cause of the problem is that ra->size can be
shrunk by read_pages() call and subsequently we end up calling
do_page_cache_ra() with negative (read huge positive) number of pages. 
Let's revert 7c877586da3 for now until we can find a proper way how the
logic in read_pages() and page_cache_ra_order() can coexist.  This can
lead to reduced readahead throughput due to readahead window confusion but
that's better than outright hangs.

Link: https://lkml.kernel.org/r/20241126145208.985-1-jack@suse.cz
Fixes: 7c877586da31 ("readahead: properly shorten readahead when falling back to do_page_cache_ra()")
Reported-by: Anders Blomdell <anders.blomdell@gmail.com>
Reported-by: Philippe Troin <phil@fifi.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Tested-by: Philippe Troin <phil@fifi.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/readahead.c~revert-readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra
+++ a/mm/readahead.c
@@ -458,8 +458,7 @@ void page_cache_ra_order(struct readahea
 		struct file_ra_state *ra, unsigned int new_order)
 {
 	struct address_space *mapping = ractl->mapping;
-	pgoff_t start = readahead_index(ractl);
-	pgoff_t index = start;
+	pgoff_t index = readahead_index(ractl);
 	unsigned int min_order = mapping_min_folio_order(mapping);
 	pgoff_t limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
 	pgoff_t mark = index + ra->size - ra->async_size;
@@ -522,7 +521,7 @@ void page_cache_ra_order(struct readahea
 	if (!err)
 		return;
 fallback:
-	do_page_cache_ra(ractl, ra->size - (index - start), ra->async_size);
+	do_page_cache_ra(ractl, ra->size, ra->async_size);
 }
 
 static unsigned long ractl_max_pages(struct readahead_control *ractl,
_

Patches currently in -mm which might be from jack@suse.cz are

readahead-dont-shorted-readahead-window-in-read_pages.patch
readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch

