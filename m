Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CA42DB794
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968173; cv=none; b=cofNZjqVOoGju4p43tstX6TufilvTbRCMJxhaTQY0mHQ9fmX3ujfuKEoUVDFNA6N/LppzBFBv5A41u+/Lg1ckBgcHEJnSPqSe8dHgjcFLKbPjS38qBNfnnwbmtzJFGQkBOxtLEp2BG0m4bnQ8w0BIpVrul45BzyGj6e6uxzJUy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968173; c=relaxed/simple;
	bh=CL/Zl2xsuim7n8wKyZP6HHI2N0qpP8a4COm5J7mX3PU=;
	h=Date:To:From:Subject:Message-Id; b=sP/H2Rz2el0gEdZhnVAgbkzkDR1lMsETzK+3keJiBLnIdDTGNno9Fh6WT8hVjTQDLnKx9+0Rc7nqnYMvTRydKNtEm3Jf8YGAitcuQ1ggPhjQMbdOidjJmAXLPJ7Zl5Vm9ARzh7BZvzjs9rVwHmJ7ORN0zCeF5MSnbtxbv8gDX1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b5bg2NM0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b5bg2NM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE681F00899;
	Tue,  9 Jun 2026 01:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968171;
	bh=YmGMoUng5QmwZVKpnbZ9Wtzaw0HDgqAVl1fObJ0ke/8=;
	h=Date:To:From:Subject;
	b=b5bg2NM07DbmXfpfBE6HuLQxFTBazx8ThOWA+n3M8TPQahKwtSG1zbiDkr5QDLpNU
	 KiOPPVkiLG9vuqjv2MeMpXnno53i1T2RM730uiswxTtb3l89tbiSU4XKtc94TDV3lH
	 QSDWRRUU0KuUZ7v+0QJoHsG1V0Pxj3/3CsIhAmOU=
Date: Mon, 08 Jun 2026 18:22:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,tanze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-use-folio_next_index-for-start.patch removed from -mm tree
Message-Id: <20260609012251.ADE681F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: use folio_next_index() for start
has been removed from the -mm tree.  Its filename was
     mm-filemap-use-folio_next_index-for-start.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: tanze <tanze@kylinos.cn>
Subject: mm/filemap: use folio_next_index() for start
Date: Mon, 1 Jun 2026 19:04:23 +0800

Use folio_next_index() instead of open-coding folio->index +
folio_nr_pages(folio) when updating @start in filemap_get_folios_contig(),
filemap_get_folios_tag(), and filemap_get_folios_dirty().

Link: https://lore.kernel.org/20260601110425.44784-1-tanze@kylinos.cn
Signed-off-by: tanze <tanze@kylinos.cn>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/filemap.c~mm-filemap-use-folio_next_index-for-start
+++ a/mm/filemap.c
@@ -2284,8 +2284,7 @@ unsigned filemap_get_folios_contig(struc
 			goto put_folio;
 
 		if (!folio_batch_add(fbatch, folio)) {
-			nr = folio_nr_pages(folio);
-			*start = folio->index + nr;
+			*start = folio_next_index(folio);
 			goto out;
 		}
 		xas_advance(&xas, folio_next_index(folio) - 1);
@@ -2345,8 +2344,7 @@ unsigned filemap_get_folios_tag(struct a
 		if (xa_is_value(folio))
 			continue;
 		if (!folio_batch_add(fbatch, folio)) {
-			unsigned long nr = folio_nr_pages(folio);
-			*start = folio->index + nr;
+			*start = folio_next_index(folio);
 			goto out;
 		}
 	}
@@ -2404,8 +2402,7 @@ unsigned filemap_get_folios_dirty(struct
 			}
 		}
 		if (!folio_batch_add(fbatch, folio)) {
-			unsigned long nr = folio_nr_pages(folio);
-			*start = folio->index + nr;
+			*start = folio_next_index(folio);
 			goto out;
 		}
 	}
_

Patches currently in -mm which might be from tanze@kylinos.cn are


