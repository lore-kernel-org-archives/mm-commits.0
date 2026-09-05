Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F47E4F797E;
	Sat,  5 Sep 2026 18:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788634098; cv=none; b=OahAhEkapkPdZKewsRQruPjQysIB0M7YnSba1CF6zH/oWVceMsr3BuI5dsf63j5vmaqVBQMAKhX4sYYnc4jz0KRxh2OYk5LEDMfBV/buT3mPQo08h/bQTXV7uB9B8J630fDK658FDCuvir0bOKv35Rt+UY77zgb3Rg5T3P15aUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788634098; c=relaxed/simple;
	bh=D4w3qePoNZYqHWaqI+xsHlyV+AjezfqXTsUdm9yZr9c=;
	h=Date:To:From:Subject:Message-Id; b=pxHrdVg9x0J9EBcu9TTp5tH0xCSvd7zm+BhvFwHFBsA2J5FpMg1ZuCWYVQ7w5Hg1mMoKNDHOFpTYDW+rgoHMKDyxZarWoSiWmJv8WSxuQhZipJvmCiMpBpqaXGQRHimYL9NMi7j+W32okAU5y/fQn/gPCt+AbOpYv/E4kW4csOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U2xjSmzq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U2xjSmzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361BB1F00A3D;
	Sat,  5 Sep 2026 18:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788634097;
	bh=vVBtpfQ2hM1cFUHrPwG07kltDJyj1ypfgC4JgnHNuMg=;
	h=Date:To:From:Subject;
	b=U2xjSmzqUVTnIJ0UCuR53Mg2AyGufUFvtMGmqi432+w4bsB1xNVEUy3L9aORmkGL2
	 FKis5NfEoJ9yfScT7ej7EGBE9uUnwZ4HmahCsTivocdu+rw9SBwhBBm9XnYI77oteU
	 Bdl8MISSwr0xFH8jkzjgaF8aYFXXP+Zi+KRqVXRo=
Date: Sat, 05 Sep 2026 11:48:16 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tz2294@columbia.edu,trond.myklebust@hammerspace.com,stable@vger.kernel.org,jack@suse.cz,baohua@kernel.org,axboe@kernel.dk,qiwenjie@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-filemap-retain-mapped-dropbehind-folios.patch removed from -mm tree
Message-Id: <20260905184817.361BB1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: filemap: retain mapped dropbehind folios
has been removed from the -mm tree.  Its filename was
     mm-filemap-retain-mapped-dropbehind-folios.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wenjie Qi <qiwenjie@xiaomi.com>
Subject: mm: filemap: retain mapped dropbehind folios
Date: Sun, 30 Aug 2026 01:36:12 +0800

Fault-around can map ready dropbehind folios without going through the
normal page-cache lookup that clears dropbehind.  A mapping represents a
competing cached user, so retain the folio instead of forcibly unmapping
it when writeback completes.

For a mapped folio, folio_unmap_invalidate() can call
unmap_mapping_folio(), which takes i_mmap_rwsem and may sleep.  Retaining
mapped folios avoids this path when folio_end_dropbehind() runs in
non-preemptible task context.

Tal was able to trigger a sleeping-in-atomic warning due to this [1].

Unmapped dropbehind folios continue through the existing invalidation path.

Link: https://lore.kernel.org/4aba05e1a2c3b61cb337d373eb9b7a8db4ddd822.1788024049.git.qiwenjie@xiaomi.com
Link: https://lore.kernel.org/076bb01b-6fcf-4691-be8c-0e8507c9fe64@columbia.edu [1]
Fixes: fb7d3bc41493 ("mm/filemap: drop streaming/uncached pages when writeback completes")
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Tal Zussman <tz2294@columbia.edu>
Tested-by: Tal Zussman <tz2294@columbia.edu>
Cc: Barry Song <baohua@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-retain-mapped-dropbehind-folios
+++ a/mm/filemap.c
@@ -1616,7 +1616,7 @@ static void filemap_end_dropbehind(struc
 		return;
 	if (!folio_test_clear_dropbehind(folio))
 		return;
-	if (mapping)
+	if (mapping && !folio_mapped(folio))
 		folio_unmap_invalidate(mapping, folio, 0);
 }
 
_

Patches currently in -mm which might be from qiwenjie@xiaomi.com are


