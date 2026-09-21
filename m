Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1FB225A38
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 03:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789961494; cv=none; b=aOxl+18rWukZxkkGBCbQy19F6qpJMMtGw36A7B1iQoKPjczIdr9k+FcqEPxzJQFl1QEN6BjJf9hZ6VySOnGQgAFosfUNbafyqHVJ941heHf8eoRJI7LPqSZBdn1zW90X8aj0Hc45S7DdbGFC1UWdWK1ltSqjScGL2ElEET0AV3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789961494; c=relaxed/simple;
	bh=+CxJ3nCIfJC/7sBf7UXmQxB5TUHrphDQu8gZoGm3v+g=;
	h=Date:To:From:Subject:Message-Id; b=RJVL0TMX4alaB9rEb/O3coWaE/nn1+oRDe4TofdcEIGeMA5Kay4wGB9izMtPJHAgsZaQcs/K/HggCWvm27gCGDTbRv0bATDQITOQOrTPNIc0Fhqp1fTFVgC1+VGPAJwJqMnuymUmaXwkOndGxP8lSjjKUoOH5ZbrnHwHHkz6Bi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gvY3dXym; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gvY3dXym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4911F000FF;
	Mon, 21 Sep 2026 03:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789961493;
	bh=qKJIz6XQShEkW9J480cGNISrJqfKcBWtZbq4pKMf/xA=;
	h=Date:To:From:Subject;
	b=gvY3dXym2Du+uM2X4XCtp5+xNX6tVfwVU3Rr4s/ktw4G98mdCK5dhD0112JG5iEUD
	 DAl/pKY7PsfbyHpHlb3Bh1bcBRfpE/UE6F9VKrYbdxC0jIscMseMWVUF7I5tXVKVKS
	 2RsvZwr50Gvo9XS0Z5/+YktfoI3snxK5WEtxXpoI=
Date: Sun, 20 Sep 2026 20:31:32 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fscrypt-stop-setting-pg_private-on-bounce-page.patch removed from -mm tree
Message-Id: <20260921033133.5B4911F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fscrypt: stop setting PG_private on bounce page
has been removed from the -mm tree.  Its filename was
     fscrypt-stop-setting-pg_private-on-bounce-page.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: fscrypt: stop setting PG_private on bounce page
Date: Sun, 13 Sep 2026 22:24:02 -0400

The pointer to a plain text folio is stored in bound_page->private and
cannot be NULL until the bounce_page is freed, making PG_private
redundant.

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: LLM
Link: https://lore.kernel.org/20260913-remove-pg_private-v4-4-848550f7574e@nvidia.com
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

mm-hugetlb-use-direct-assignment-instead-of-folio_change_private.patch
f2fs-stop-using-pg_private.patch
f2fs-convert-the-private-flag-helpers-to-folio-only.patch
erofs-mm-pagemap-add-readahead_folio_last-to-avoid-folio-private.patch
erofs-use-folio_attach-detach_private-instead-of-direct-assignment.patch
mm-page-flags-check-page-folio-private-instead-of-pg_private.patch
treewide-remove-folio_set-clear_private-usage.patch
ceph-replace-pageprivate-with-page_private.patch
md-md-bitmap-replace-pageprivate-with-page_private.patch
buffer-replace-page_buffer-with-page_private-and-delete-it.patch
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

