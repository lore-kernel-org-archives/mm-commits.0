Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095223537D2
	for <mm-commits@vger.kernel.org>; Mon,  1 Jun 2026 18:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780339617; cv=none; b=mcMmKXSy/erUCvSUFU4GBimqRtb2W5ekcx9NAD6N7LhzSeJQOpPXpCQkUoJND2ynpDGIclP7TSRo2Ycj0YrEQQRBiLAr90xns/aD1/pj45N5SWXxnZ5t8xVJ2gths9xQdBq0/cQ++inXIn8c5CpMfaRsNs/YsVfX+MDgKKiUShM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780339617; c=relaxed/simple;
	bh=GPJucPjylfQfLe0jGlcJDS7+/nANXjejuNkXdzaE+uA=;
	h=Date:To:From:Subject:Message-Id; b=ofNrDgw2pdy0eouPRc//VsRDPUN9U4nODev0YAzVsiXnUr1gwoPiLF4OYV8SadfI4o7X9Zd40KlPf9ZgHfIgSTVoClKp0oVq17HumHdt/jxAoViZAYZbmgWMC7fqg6Czgo7cn8DvYKWydQkb86NWNeXSlCbwt3zzFk1pBG0A2zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LVybTsIW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LVybTsIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488611F00893;
	Mon,  1 Jun 2026 18:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780339614;
	bh=OPC3lk+skTPZ5Fxk99/eYcrdJWlR+51IcFaBQLspubQ=;
	h=Date:To:From:Subject;
	b=LVybTsIW6riHAlCCJ1bcVqOlopNFD3kxLtoJlrg7T/X2C8FhKHUyTqujSaBTfHAjk
	 aJBsyc+T2ZTG3OQqffZtrH00FNMmbNAeBmg6TXvVN8pRqh9GSAuljFCU2xRuIrjBez
	 JiHx7DX3robdfrYl02VT6vp9jzY5ZneqJ/sgMMnM=
Date: Mon, 01 Jun 2026 11:46:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,tanze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-use-folio_next_index-for-start.patch added to mm-new branch
Message-Id: <20260601184654.488611F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: use folio_next_index() for start
has been added to the -mm mm-new branch.  Its filename is
     mm-filemap-use-folio_next_index-for-start.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-use-folio_next_index-for-start.patch

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
@@ -2283,8 +2283,7 @@ unsigned filemap_get_folios_contig(struc
 			goto put_folio;
 
 		if (!folio_batch_add(fbatch, folio)) {
-			nr = folio_nr_pages(folio);
-			*start = folio->index + nr;
+			*start = folio_next_index(folio);
 			goto out;
 		}
 		xas_advance(&xas, folio_next_index(folio) - 1);
@@ -2344,8 +2343,7 @@ unsigned filemap_get_folios_tag(struct a
 		if (xa_is_value(folio))
 			continue;
 		if (!folio_batch_add(fbatch, folio)) {
-			unsigned long nr = folio_nr_pages(folio);
-			*start = folio->index + nr;
+			*start = folio_next_index(folio);
 			goto out;
 		}
 	}
@@ -2403,8 +2401,7 @@ unsigned filemap_get_folios_dirty(struct
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

mm-filemap-use-folio_next_index-for-start.patch

