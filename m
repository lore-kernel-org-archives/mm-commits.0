Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2351B241673
	for <mm-commits@vger.kernel.org>; Wed,  7 May 2025 18:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746641616; cv=none; b=JKcV2FEvaPK6dC02vFQpwhFailpmBQP82BEkx9WL+woVkeGbONQzXMyvuxmE2WE+RcjEe8VQnzYBFqiUebBI0+XxsFVmnqlOxP6eU0LFtazgNGi8U/jCZa6EVK0eI7c461cL+eWhCLDEP0GA1V8Ui+lmY/N+5/FaSMKuAAce0sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746641616; c=relaxed/simple;
	bh=Viddabnp6RWcAmFOTcx6dO1okQGs3+JsMfu2Ag07QX0=;
	h=Date:To:From:Subject:Message-Id; b=bhtEB4IeU75HjoXkZlu1mRtRf4dhaJjPLiJSe+jxfPLt+7qiH7JPdDYoj2s1/n1zecbNZuYpWN059KiSUmXH4nDTYuTpbpUmZt0dLFNdlFG0oH5BAzDgU1KTn45M26TeilklkJQmyfK3yyLa++JsAr2kWmP+eRhNFB0ZvlAmB0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WlTMYjIn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WlTMYjIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C849C4CEE2;
	Wed,  7 May 2025 18:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746641615;
	bh=Viddabnp6RWcAmFOTcx6dO1okQGs3+JsMfu2Ag07QX0=;
	h=Date:To:From:Subject:From;
	b=WlTMYjIn/2yKbUCvxWw9TYGRyR+AdBDBTO8WBRJGpWRAaZuzVQSni3q2JNZKFIZp7
	 WGojJksihlNFWomgoxhOT5hZ397Vu90k5YoeMQB6ux7mjHTjDmPxclHZAuzSB9B1N2
	 ni/una0pd1XCjnrCPsGkPzJmkEufMx5JbaWcBvhI=
Date: Wed, 07 May 2025 11:13:34 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,igor.b@beldev.am,hannes@cmpxchg.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-dont-underflow-size-calculation-in-zs_obj_write.patch added to mm-hotfixes-unstable branch
Message-Id: <20250507181335.8C849C4CEE2@smtp.kernel.org>
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
Date: Wed, 7 May 2025 14:42:24 +0900

Do not mix class->size and object size during offsets/sizes calculation in
zs_obj_write().  Size classes can merge into clusters, based on
objects-per-zspage and pages-per-zspage characteristics, so some size
classes can store objects smaller than class->size.  This becomes
problematic when object size is much smaller than class->size.  zsmalloc
can falsely decide that object spans two physical pages, because a larger
class->size value is used for that check, while the actual object is much
smaller and fits the free space of the first physical page, so there is
nothing to write to the second page and memcpy() size calculation
underflows.

 Unable to handle kernel paging request at virtual address ffffc00081ff4000
 pc : __memcpy+0x10/0x24
 lr : zs_obj_write+0x1b0/0x1d0 [zsmalloc]
 Call trace:
  __memcpy+0x10/0x24 (P)
  zram_write_page+0x150/0x4fc [zram]
  zram_submit_bio+0x5e0/0x6a4 [zram]
  __submit_bio+0x168/0x220
  submit_bio_noacct_nocheck+0x128/0x2c8
  submit_bio_noacct+0x19c/0x2f8

This is mostly seen on system with larger page-sizes, because size class
cluters of such systems hold wider size ranges than on 4K PAGE_SIZE
systems.

Assume a 16K PAGE_SIZE system, a write of 820 bytes object to a 864-bytes
size class at offset 15560.  15560 + 864 is more than 16384 so zsmalloc
attempts to memcpy() it to two physical pages.  However, 16384 - 15560 =
824 which is more than 820, so the object in fact doesn't span two
physical pages, and there is no data to write to the second physical page.

We always know the exact size in bytes of the object that we are about to
write (store), so use it instead of class->size.

Link: https://lkml.kernel.org/r/20250507054312.4135983-1-senozhatsky@chromium.org
Fixes: 44f76413496e ("zsmalloc: introduce new object mapping API")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Igor Belousov <igor.b@beldev.am>
Tested-by: Igor Belousov <igor.b@beldev.am>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
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

