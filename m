Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26580219484
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731019123; cv=none; b=cY66uHdNvQUjE00nyg3eP8r5ERfGOQjvzjn91wgq1na5+xC6ipvBNIKJrd0BD0uA1kFiX/KkfsrUTOS9tCNuAF/sTwO5gMZhNzUQzUx2TMgv46kuEqMGFgAUkPrnHIWVBIT7LONC1xzUAgbLFPKIdNe8zyV+skHhSaBuQHu3Gtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731019123; c=relaxed/simple;
	bh=vT1rMaJpRRtNAoMTPR+CEFcr6L6acn1lSRjYN9nrDyE=;
	h=Date:To:From:Subject:Message-Id; b=W8WZA+uo0cChle/AioLhnD/m1+hPvMlfR7eFKIX3Xksb53IP1KajhI1Q5za5Ws6JHNV3vxK+clxMegMGRGNSbZPt1w5/zniAo1VRtc/6L4pvj8qHi2CniVx0j/Qa1XoNpV3EBKacMwEXOE5hP05rS44FP4XrtvAaE4+XBrsvZNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WaS/VbdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WaS/VbdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4903C4CECC;
	Thu,  7 Nov 2024 22:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731019123;
	bh=vT1rMaJpRRtNAoMTPR+CEFcr6L6acn1lSRjYN9nrDyE=;
	h=Date:To:From:Subject:From;
	b=WaS/VbdEeq33FhsZpwYM06yZoiYEQ+I94b4XWdwL1hwH/9Ve8Y9T5SGP8daQMa33J
	 CjegSAhLk+c4L9Z2RKl/knALJumFs3DLQkXvFVNdvfDd8H5PKy4HsZ+07kjd+ZQLOg
	 cf4qOv+J4o+JceTe3HbXI8lD1cCGdYFLgyd+KWRY=
Date: Thu, 07 Nov 2024 14:38:42 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-page-private-instead-of-page-index-in-percpu.patch removed from -mm tree
Message-Id: <20241107223842.E4903C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use page->private instead of page->index in percpu
has been removed from the -mm tree.  Its filename was
     mm-use-page-private-instead-of-page-index-in-percpu.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use page->private instead of page->index in percpu
Date: Sat, 5 Oct 2024 21:01:18 +0100

The percpu allocator only uses one field in struct page, just change it
from page->index to page->private.

Link: https://lkml.kernel.org/r/20241005200121.3231142-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/percpu.c~mm-use-page-private-instead-of-page-index-in-percpu
+++ a/mm/percpu.c
@@ -253,13 +253,13 @@ static int pcpu_chunk_slot(const struct
 /* set the pointer to a chunk in a page struct */
 static void pcpu_set_page_chunk(struct page *page, struct pcpu_chunk *pcpu)
 {
-	page->index = (unsigned long)pcpu;
+	page->private = (unsigned long)pcpu;
 }
 
 /* obtain pointer to a chunk from a page struct */
 static struct pcpu_chunk *pcpu_get_page_chunk(struct page *page)
 {
-	return (struct pcpu_chunk *)page->index;
+	return (struct pcpu_chunk *)page->private;
 }
 
 static int __maybe_unused pcpu_page_idx(unsigned int cpu, int page_idx)
_

Patches currently in -mm which might be from willy@infradead.org are


