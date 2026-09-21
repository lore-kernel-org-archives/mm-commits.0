Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BDD146D5A
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 04:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789963784; cv=none; b=SotdQG80ZV/ByfA7lvTA9foIGkmRc7LZKBRXrYNgLjOw2cXVWQnv2eVtK9VsI+QCcNRYEHYCdb25X401K2F35zFXfR8d9HNExtrps8mS9IFluzOkThDuoOW1V7M4XP1QM4Nl4sHT0xm4zHyN34OcMwPUvhdlGL6P9J9AbFR2BNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789963784; c=relaxed/simple;
	bh=jSDfJBRCkeom1wopwvtIdKpLMg8ilzODOHr74r/cOss=;
	h=Date:To:From:Subject:Message-Id; b=OGCUAmVXIc2hKIygiXFC+y5oY2HtTlJtVEVBw7bMNY26QgIDdA5ytSISuvTZSU5lrC+p0OWB98D5znKesXY2PJGiDy4CZDCy5zpr61zXLJLYP1r5//HSxFtKQuJgZzH4Dbky5Md0q7lXBZh97WpNj9Kd51vGCHW8UFDTMn/1f3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=arqgCjgr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="arqgCjgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BEF1F000FF;
	Mon, 21 Sep 2026 04:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789963783;
	bh=HX9XOyh8WoxZQXPN50XhwEFTM7rYIhBl8rSDOg7iQrY=;
	h=Date:To:From:Subject;
	b=arqgCjgrTbsA4wIHTAD6+D81/oHAvip6G8WQe2Naf8ojE+syUuCV3AIHEhpQiFfoe
	 ESxGBRyKtlHebelhmd1YvlKOkUVnNpYI4k59z8cUP5+EpiimdCTpZ7wa8Qs28o82H9
	 atxPvTTxzTKf0fClce6AU1lrUDo7ClsxhKncynG4=
Date: Sun, 20 Sep 2026 21:09:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fscrypt-stop-setting-pg_private-on-bounce-page.patch added to mm-unstable branch
Message-Id: <20260921040942.F2BEF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fscrypt: stop setting PG_private on bounce page
has been added to the -mm mm-unstable branch.  Its filename is
     fscrypt-stop-setting-pg_private-on-bounce-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fscrypt-stop-setting-pg_private-on-bounce-page.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Zi Yan <ziy@nvidia.com>
Subject: fscrypt: stop setting PG_private on bounce page
Date: Sun, 20 Sep 2026 22:28:00 -0400

The pointer to a plain text folio is stored in bound_page->private and
cannot be NULL until the bounce_page is freed, making PG_private redundant.

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: LLM
Link: https://lore.kernel.org/20260920-remove-pg_private-v5-4-bb68b6a21869@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Eric Biggers <ebiggers@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
---

 fs/crypto/crypto.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/crypto/crypto.c~fscrypt-stop-setting-pg_private-on-bounce-page
+++ a/fs/crypto/crypto.c
@@ -65,7 +65,6 @@ void fscrypt_free_bounce_page(struct pag
 	if (!bounce_page)
 		return;
 	set_page_private(bounce_page, (unsigned long)NULL);
-	ClearPagePrivate(bounce_page);
 	mempool_free(bounce_page, fscrypt_bounce_page_pool);
 }
 EXPORT_SYMBOL(fscrypt_free_bounce_page);
@@ -210,7 +209,6 @@ struct page *fscrypt_encrypt_pagecache_b
 			return ERR_PTR(err);
 		}
 	}
-	SetPagePrivate(ciphertext_page);
 	set_page_private(ciphertext_page, (unsigned long)folio);
 	return ciphertext_page;
 }
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-zsmalloc-replace-pg_private-with-pointer-comparison.patch
perf-ring_buffer-stop-using-pg_private-as-aux-page-high-order-marker.patch
xen-grant-table-stop-setting-pg_private-on-pages-for-grant-mapping.patch
fscrypt-stop-setting-pg_private-on-bounce-page.patch
mm-hugetlb-use-direct-assignment-instead-of-folio_change_private.patch
f2fs-stop-using-pg_private.patch
f2fs-convert-the-private-flag-helpers-to-folio-only.patch
erofs-mm-pagemap-add-readahead_folio_last-to-avoid-folio-private.patch
erofs-use-folio_attach-detach_private-instead-of-direct-assignment.patch
mm-page-flags-check-page-folio-private-instead-of-pg_private.patch
treewide-remove-folio_set-clear_private-usage.patch
ceph-replace-pageprivate-with-page_private.patch
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

