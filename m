Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE11153565
	for <mm-commits@vger.kernel.org>; Sat,  1 Feb 2025 11:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738410839; cv=none; b=EGv0pkL9oWiMN9hvD8jjKHTlx31TbJsqhLkFjgygt74ViLRstKE7twHpNASIMH5r/6JcgRo5X6f16yXFgEwWACMcO4HgOKtbxwz/0bf5FwKQU4Gmf+/ptFvlZzuOkAcjsF9RYPg8KoyBHVXFJjDsPGRKIU8gzPIIGEOEnZzn4pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738410839; c=relaxed/simple;
	bh=8CpWq/U/oHPhVsT/EqOow122qhssEpKAuqiuDO66pm4=;
	h=Date:To:From:Subject:Message-Id; b=MhjOTakSYbo3Qp5d4A71ZB2g7pJivBV/Kbhikz7EN3Sg0oxCr9Qbil2G0Omm7c0N+5IOUGSrxyVuaHgDmTIPT053V2QRttvGOSNipkKWmwldykDWdgrmB7YGHF/OHPUJ53Ou9EJ3pPL4MSUivUmvL7WURmNCJz6QtCsLFRLZXRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KTvZ8LAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KTvZ8LAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567B3C4CEE2;
	Sat,  1 Feb 2025 11:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738410839;
	bh=8CpWq/U/oHPhVsT/EqOow122qhssEpKAuqiuDO66pm4=;
	h=Date:To:From:Subject:From;
	b=KTvZ8LAa81WqFmaSFaYUz36BLAoc3L7pIEpSEV4Aoa7rD3KBhBezq3yHZPty4c8IK
	 fX007yb8XflVjBTB1wwsGxCcpgVFSBIHaMSRYD7KtFNi4ZQUdQ0YbWLoeYVLkYNU8e
	 sU/JBGKly+2W7TtqNo0P0jROLoTWOXpAWEqQn8Yk=
Date: Sat, 01 Feb 2025 03:53:58 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,lkp@intel.com,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-zsmalloc-add-__maybe_unused-attribute-for-is_first_zpdesc.patch removed from -mm tree
Message-Id: <20250201115359.567B3C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: add __maybe_unused attribute for is_first_zpdesc()
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-add-__maybe_unused-attribute-for-is_first_zpdesc.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm/zsmalloc: add __maybe_unused attribute for is_first_zpdesc()
Date: Tue, 28 Jan 2025 08:16:31 +0900

Commit c1b3bb73d55e ("mm/zsmalloc: use zpdesc in
trylock_zspage()/lock_zspage()") introduces is_first_zpdesc() function. 
However, the function is only used when CONFIG_DEBUG_VM=y.

When building with LLVM=1 and W=1 option, the following warning is
generated:
  $ make -j12 W=1 LLVM=1 mm/zsmalloc.o
  mm/zsmalloc.c:455:20: error: function 'is_first_zpdesc' is not needed and will not be emitted [-Werror,-Wunneeded-internal-declaration]
    455 | static inline bool is_first_zpdesc(struct zpdesc *zpdesc)
        |                    ^~~~~~~~~~~~~~~
  1 error generated.

Fix the warning by adding __maybe_unused attribute to the function.
No functional change intended.

Link: https://lkml.kernel.org/r/20250127231631.4363-1-42.hyeyoo@gmail.com
Fixes: c1b3bb73d55e ("mm/zsmalloc: use zpdesc in trylock_zspage()/lock_zspage()")
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501240958.4ILzuBrH-lkp@intel.com/
Cc: Alex Shi <alexs@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-add-__maybe_unused-attribute-for-is_first_zpdesc
+++ a/mm/zsmalloc.c
@@ -452,7 +452,7 @@ static DEFINE_PER_CPU(struct mapping_are
 	.lock	= INIT_LOCAL_LOCK(lock),
 };
 
-static inline bool is_first_zpdesc(struct zpdesc *zpdesc)
+static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
 {
 	return PagePrivate(zpdesc_page(zpdesc));
 }
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are

mm-zswap-fix-inconsistency-when-zswap_store_page-fails.patch
mm-zswap-fix-inconsistency-when-zswap_store_page-fails-fix.patch

