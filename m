Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501DB34D2B3;
	Tue,  6 May 2025 00:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746492741; cv=none; b=bt7/yE0G8SJN28FR13y3T5cuIueTBdsk9YOTY7/BA8mW7FOu2keSkFBrLDq52PS0TKJKL5cREcQ28fKrT+68MqBnPHLo71YEXqO/UEin4ATzdYVoHDN4txMW+mjzpq8SKEWVhp3CdtpT0F+Z4HIX+mjd+bx56ATJ+Ey29nn2PPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746492741; c=relaxed/simple;
	bh=EqFsCWOwjwAUcIHJxhy1ULIGTniQIjjShStO0nXv03U=;
	h=Date:To:From:Subject:Message-Id; b=GFyM2qkrbB6zxHwP/SiUlergwZw6nTX+4JkCRvPXWGeRZskhXZXrVVnqfoqyBuGxc3vBkjmw3CWv//YeKw/B3pE34Agrq8KzKqcg8cyeJoc4RZ/o6sDpa+uHOA3yXGOKCJ+39bQlyYNcw5K9h3iTCOfMZviwIRb0AskeQEo7sKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N63aY4LC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N63aY4LC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD82BC4CEE4;
	Tue,  6 May 2025 00:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746492739;
	bh=EqFsCWOwjwAUcIHJxhy1ULIGTniQIjjShStO0nXv03U=;
	h=Date:To:From:Subject:From;
	b=N63aY4LC6+zlKgBQEexax7m/i8bY3W8HnVCtwKR9GbDeQyOC2MR+gDW7hoLRzfG4O
	 Yyo4a0S9xDa41d3LYlE8abTLuiKD5x0U4dP9hcA7nAXNWA7Nvra/Q+40QXcGGqERxc
	 +u29wKPTDH0zLkSBEq9lLWU9Oa+/meDYFEx++Rtw=
Date: Mon, 05 May 2025 17:52:19 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,minchan@kernel.org,igor.b@beldev.am,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-dont-underflow-size-calculation-in-zs_obj_write.patch added to mm-hotfixes-unstable branch
Message-Id: <20250506005219.AD82BC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zsmalloc: don't underflow size calculation in zs_obj_write()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     zsmalloc-dont-underflow-size-calculation-in-zs_obj_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-dont-underflow-size-calculation-in-zs_obj_write.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: don't underflow size calculation in zs_obj_write()
Date: Sun, 4 May 2025 20:00:22 +0900

Do not mix class->size and object size during offsets/sizes calculation in
zs_obj_write().  Size classes can merge into clusters, based on
objects-per-zspage and pages-per-zspage characteristics, so some size
classes can store objects smaller than class->size.  This becomes
problematic when object size is much smaller than class->size - we can
determine that object spans two physical pages, because we use a larger
class->size for this, while the actual object is much smaller and fits one
physical page, so there is nothing to write to the second page and
memcpy() size calculation underflows.

We always know the exact size in bytes of the object that we are about to
write (store), so use it instead of class->size.

Link: https://lkml.kernel.org/r/20250504110650.2783619-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Igor Belousov <igor.b@beldev.am>
Tested-by: Igor Belousov <igor.b@beldev.am>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-dont-underflow-size-calculation-in-zs_obj_write
+++ a/mm/zsmalloc.c
@@ -1243,19 +1243,19 @@ void zs_obj_write(struct zs_pool *pool,
 	class = zspage_class(pool, zspage);
 	off = offset_in_page(class->size * obj_idx);
 
-	if (off + class->size <= PAGE_SIZE) {
+	if (!ZsHugePage(zspage))
+		off += ZS_HANDLE_SIZE;
+
+	if (off + mem_len <= PAGE_SIZE) {
 		/* this object is contained entirely within a page */
 		void *dst = kmap_local_zpdesc(zpdesc);
 
-		if (!ZsHugePage(zspage))
-			off += ZS_HANDLE_SIZE;
 		memcpy(dst + off, handle_mem, mem_len);
 		kunmap_local(dst);
 	} else {
 		/* this object spans two pages */
 		size_t sizes[2];
 
-		off += ZS_HANDLE_SIZE;
 		sizes[0] = PAGE_SIZE - off;
 		sizes[1] = mem_len - sizes[0];
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-dont-underflow-size-calculation-in-zs_obj_write.patch
zsmalloc-prefer-the-the-original-pages-node-for-compressed-data-fix.patch
zram-modernize-writeback-interface.patch
zram-modernize-writeback-interface-v3.patch
zram-modernize-writeback-interface-v4.patch
zsmalloc-cleanup-headers-includes.patch
documentation-zram-update-idle-pages-tracking-documentation.patch

