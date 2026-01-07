Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9146359FA2
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 18:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767809838; cv=none; b=E8a2zf67VBuDhLTmpLMYaAihebmLgJHIOWEq0/kPl+95c8XKOPdrPlkpy0kB1gprtyCrglTOp1Foded01xQI7cl/S5Vf5QS7lYrBfexRilST07GfCV1R882O1YuemnNQJaJZIYdiuNJy21UePDHXyoMqecyM74hCnz1ybVPqQXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767809838; c=relaxed/simple;
	bh=N3D3C7zB+mNij807l7OEUO3C1avFyBMfb5+OmkxXDzY=;
	h=Date:To:From:Subject:Message-Id; b=ZOI2iwUX4kZ6AFIUhCsWIqBrZbES5709YRsO6HYaR+E0J+KeNKfY0sc6VFEW6gvPu6/5EqHUKXeOj7D3toxTttPCeypHZtEjJgsI/u6wdIzOuGhdzVLx4qOxS4qPn7FjM39Sh0qhhdt1FK0yN1y9yvbLhvg8zb1ARJQ/tfCV/tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0Nci0A5a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Nci0A5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33245C4CEF1;
	Wed,  7 Jan 2026 18:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767809837;
	bh=N3D3C7zB+mNij807l7OEUO3C1avFyBMfb5+OmkxXDzY=;
	h=Date:To:From:Subject:From;
	b=0Nci0A5amSBk4vrMQfYJionbLjSxfim+QNyE9ygRE69VJy2vMgbU8sk51wyOPlr2u
	 uJaD3GkFJpKkKDrDZfmkff36kjZd6ovGP4RZZ2dpb3+mkDchL18FuLcFtJBSccDHHz
	 +AjmfVSzXl6ZQMnz8jzkydp1Utk/+puVYbBb/vnM=
Date: Wed, 07 Jan 2026 10:17:16 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,chengming.zhou@linux.dev,bgeffon@google.com,axboe@kernel.dk,yosry.ahmed@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-simplify-read-begin-end-logic.patch added to mm-new branch
Message-Id: <20260107181717.33245C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zsmalloc: simplify read begin/end logic
has been added to the -mm mm-new branch.  Its filename is
     zsmalloc-simplify-read-begin-end-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-simplify-read-begin-end-logic.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: zsmalloc: simplify read begin/end logic
Date: Wed, 7 Jan 2026 14:21:45 +0900

When we switched from using class->size (for spans detection) to actual
compressed object size, we had to compensate for the fact that class->size
implicitly took inlined handle into consideration.  In fact, instead of
adjusting the size of compressed object (adding handle offset for non-huge
size classes), we can move some lines around and simplify the code: there
are already paths in read_begin/end that compensate for inlined object
handle offset.

Link: https://lkml.kernel.org/r/20260107052145.3586917-2-senozhatsky@chromium.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-simplify-read-begin-end-logic
+++ a/mm/zsmalloc.c
@@ -1088,7 +1088,7 @@ void *zs_obj_read_begin(struct zs_pool *
 	off = offset_in_page(class->size * obj_idx);
 
 	if (!ZsHugePage(zspage))
-		mem_len += ZS_HANDLE_SIZE;
+		off += ZS_HANDLE_SIZE;
 
 	if (off + mem_len <= PAGE_SIZE) {
 		/* this object is contained entirely within a page */
@@ -1110,9 +1110,6 @@ void *zs_obj_read_begin(struct zs_pool *
 				 0, sizes[1]);
 	}
 
-	if (!ZsHugePage(zspage))
-		addr += ZS_HANDLE_SIZE;
-
 	return addr;
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_begin);
@@ -1133,11 +1130,9 @@ void zs_obj_read_end(struct zs_pool *poo
 	off = offset_in_page(class->size * obj_idx);
 
 	if (!ZsHugePage(zspage))
-		mem_len += ZS_HANDLE_SIZE;
+		off += ZS_HANDLE_SIZE;
 
 	if (off + mem_len <= PAGE_SIZE) {
-		if (!ZsHugePage(zspage))
-			off += ZS_HANDLE_SIZE;
 		handle_mem -= off;
 		kunmap_local(handle_mem);
 	}
_

Patches currently in -mm which might be from yosry.ahmed@linux.dev are

zsmalloc-simplify-read-begin-end-logic.patch

