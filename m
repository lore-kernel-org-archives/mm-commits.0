Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE1013777E;
	Mon, 13 Jan 2025 03:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736737450; cv=none; b=jFF3yO7AFKnnwynTCj5ae1MyhKH8TSCc83a43l2g7MoNAekLAwVz8PlaOuWT9+RWgj7vzb//wcvQyeMiFiH3Y4bUTE3oLCdHDj631Ms4sxipvQjRKsfQe4PrGPg+4ahkP67ShavSPK9yxUlEzQqtYI1SIxS13JvxSFw0oM/46PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736737450; c=relaxed/simple;
	bh=OZ0YBmFY+tIvujuEvNzpA6X2iFMgi33z18JpXyorR10=;
	h=Date:To:From:Subject:Message-Id; b=AWpmKAceXgJzqnmHlWFgYTUgSS4RkDznrKrwTTt87qM1kRzHBBDQXsuN9rh7IfDPnBhHbkZ1tgd4XYpk4yFZu9wl5Lb+vtxtrHTluoQzLB2ubRotabO+OV/nGVIL/sHNmiQYvlwWVUDRoVH0m49XprFLh98EPBFXW/GM37h5uPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p6bNuAdY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p6bNuAdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABBBC4CEDF;
	Mon, 13 Jan 2025 03:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736737449;
	bh=OZ0YBmFY+tIvujuEvNzpA6X2iFMgi33z18JpXyorR10=;
	h=Date:To:From:Subject:From;
	b=p6bNuAdYugwaBY3/EoW9WvkwiA1kAscJ3sXBkZK6cJ/8abVeCAVpu+TE/cvAb+6ZO
	 Vx7nOf6NPqT4owQeSlckAPnA5WzRAE0mEUZBSVIksY28y3RulD0JnRE51YIzNGR66T
	 3CiWvIEtnOWgde8HGJx19wISc4iCQMryJZcnrT4o=
Date: Sun, 12 Jan 2025 19:04:09 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,marco.nelissen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] filemap-avoid-truncating-64-bit-offset-to-32-bits.patch removed from -mm tree
Message-Id: <20250113030409.9ABBBC4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: filemap: avoid truncating 64-bit offset to 32 bits
has been removed from the -mm tree.  Its filename was
     filemap-avoid-truncating-64-bit-offset-to-32-bits.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Marco Nelissen <marco.nelissen@gmail.com>
Subject: filemap: avoid truncating 64-bit offset to 32 bits
Date: Thu, 2 Jan 2025 11:04:11 -0800

On 32-bit kernels, folio_seek_hole_data() was inadvertently truncating a
64-bit value to 32 bits, leading to a possible infinite loop when writing
to an xfs filesystem.

Link: https://lkml.kernel.org/r/20250102190540.1356838-1-marco.nelissen@gmail.com
Fixes: 54fa39ac2e00 ("iomap: use mapping_seek_hole_data")
Signed-off-by: Marco Nelissen <marco.nelissen@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~filemap-avoid-truncating-64-bit-offset-to-32-bits
+++ a/mm/filemap.c
@@ -2996,7 +2996,7 @@ static inline loff_t folio_seek_hole_dat
 		if (ops->is_partially_uptodate(folio, offset, bsz) ==
 							seek_data)
 			break;
-		start = (start + bsz) & ~(bsz - 1);
+		start = (start + bsz) & ~((u64)bsz - 1);
 		offset += bsz;
 	} while (offset < folio_size(folio));
 unlock:
_

Patches currently in -mm which might be from marco.nelissen@gmail.com are


