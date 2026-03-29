Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038D6277CB8;
	Sun, 29 Mar 2026 00:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744954; cv=none; b=RIqpQcseQXsSxXK8i0NBjJYSUdmWIS6lsg80rRj/0Ix0Gnj1AXIUknqNeZw1Rd3783n30SxOUTggFt/pIl25eTfCTZ7Bu33KNxPCfmohscsXwZnMAgNz0otGI8IEWYAC1abmeIpIpdIuzDCmkS6k9COQBiOmAYGf6897DMk8SSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744954; c=relaxed/simple;
	bh=swXzs6RR6yCU+4E4xLd7ZOvaH5J7aZj39QQpncnAyEs=;
	h=Date:To:From:Subject:Message-Id; b=iRfwM0bBuJ5k0xKPc42Wv9rvVu7W5RV7GHcKrR1ultczP1YkhNaS4CAUv2ZdYp5We/ST4ujhPkcPd62n4dTMfy1PeGzbRioH5jOymleXQbEFyD7DIrI6CEft4+tSuW6xfiaLTYoVwuPQkn0HJgiPOsHEOj23B4WyXvW2xtZ/Ryc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SaPYcTHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SaPYcTHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF588C4CEF7;
	Sun, 29 Mar 2026 00:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744953;
	bh=swXzs6RR6yCU+4E4xLd7ZOvaH5J7aZj39QQpncnAyEs=;
	h=Date:To:From:Subject:From;
	b=SaPYcTHn8vbdCWn4Hf017hM/wmog95P3wB85XhBm/3m7bC90Kmu/MkdmP+rRMIAOQ
	 aPNeWz2f9JmX8TysPF6Lygw6a3Xef050Ku/jwVlPdJXCUDPFZSzt+MPWehBVm0hNII
	 R61ZCPbUuWtOciwhBW81FgrWHtQHeUcRcvTSFv6g=
Date: Sat, 28 Mar 2026 17:42:33 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,mark-pk.tsai@mediatek.com,syoshida@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-copy-kmsan-metadata-in-zs_page_migrate.patch removed from -mm tree
Message-Id: <20260329004233.CF588C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: copy KMSAN metadata in zs_page_migrate()
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-copy-kmsan-metadata-in-zs_page_migrate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Cc: Minchan Kim <minchan@kernel.org>
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


