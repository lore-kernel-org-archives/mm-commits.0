Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9396019C566;
	Sat, 21 Mar 2026 17:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774115418; cv=none; b=cDdhZOnctc2Q1qCqN08PuNKNicOJ7ixI+L8oxa2XbOrNDSzCl8PLExO4psGX5QCDUV5gV/upqDMzu7xy42AfgfkKwssdq7IpOV4mw8GS4v1wAIvSXpQq1QZt9SzIIn8aokKtD2i9WMe4vKkrblZf7VRNSJwtWGd4x41Yv9P07F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774115418; c=relaxed/simple;
	bh=xXzonp7D10Cz5jJkv0m/d5dQVZX/TtxiWY9SFWMPM6s=;
	h=Date:To:From:Subject:Message-Id; b=eBohPRdAjpsj8ePokWTqWEG4ujnRXwttc2a7Ky0d2DRx5zrKH5mpdgMqm1ogSqlNc5Q8mQqCN6ocoZJ16XculjoYiOvOl1Gh6plr2YY51iMXUp8syaDhnk0UHG2IR9xoPP9swFxTgOnC9w0N70FvsJR+6dWbAkVsavJt3j0+gR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W+CZCQhK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W+CZCQhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0E7C19421;
	Sat, 21 Mar 2026 17:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774115418;
	bh=xXzonp7D10Cz5jJkv0m/d5dQVZX/TtxiWY9SFWMPM6s=;
	h=Date:To:From:Subject:From;
	b=W+CZCQhK/MJ4CA4yMq1O/VhrIgVlOl66utZC5MmTvCgyc9NdRTdwqV28sZzV7MU7l
	 I6pcj9U0V/LU/ioHejY7p1S8HhsAfdtx9t5GqYsssT6B9IOD/oS6lIN2+W6wiL/LzC
	 jGQCgX3kVUYQUgVZFN/JQOCl4ZFLRo/Ni8KmByEA=
Date: Sat, 21 Mar 2026 10:50:17 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,mark-pk.tsai@mediatek.com,syoshida@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-copy-kmsan-metadata-in-zs_page_migrate.patch added to mm-new branch
Message-Id: <20260321175018.5B0E7C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: copy KMSAN metadata in zs_page_migrate()
has been added to the -mm mm-new branch.  Its filename is
     mm-zsmalloc-copy-kmsan-metadata-in-zs_page_migrate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-copy-kmsan-metadata-in-zs_page_migrate.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Shigeru Yoshida <syoshida@redhat.com>
Subject: mm/zsmalloc: copy KMSAN metadata in zs_page_migrate()
Date: Sat, 21 Mar 2026 22:29:11 +0900

zs_page_migrate() uses copy_page() to copy the contents of a zspage page
during migration.  However, copy_page() is not instrumented by KMSAN, so
the shadow and origin metadata of the destination page are not updated.

As a result, subsequent accesses to the migrated page are reported as
use-after-free by KMSAN, despite the data being correctly copied.

Add a kmsan_copy_page_meta() call after copy_page() to propagate the KMSAN
metadata to the new page, matching what copy_highpage() does internally.

Link: https://lkml.kernel.org/r/20260321132912.93434-1-syoshida@redhat.com
Fixes: afb2d666d025 ("zsmalloc: use copy_page for full page copy")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Cc: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/zsmalloc.c~mm-zsmalloc-copy-kmsan-metadata-in-zs_page_migrate
+++ a/mm/zsmalloc.c
@@ -1753,6 +1753,7 @@ static int zs_page_migrate(struct page *
 	 */
 	d_addr = kmap_local_zpdesc(newzpdesc);
 	copy_page(d_addr, s_addr);
+	kmsan_copy_page_meta(zpdesc_page(newzpdesc), zpdesc_page(zpdesc));
 	kunmap_local(d_addr);
 
 	for (addr = s_addr + offset; addr < s_addr + PAGE_SIZE;
_

Patches currently in -mm which might be from syoshida@redhat.com are

mm-zsmalloc-copy-kmsan-metadata-in-zs_page_migrate.patch

