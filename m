Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08F636B915
	for <mm-commits@vger.kernel.org>; Mon, 14 Sep 2026 03:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789357920; cv=none; b=Vl5+KVljf39GggHTOaH1qQLvzsGE5m0ewUvcggtMWx2MXKPKfpARLbB+mAMC64OySfv8VJa1yh4dk7uqCMnkPwOnjwyylPmUbqg7sJylVzIWR7RYwA+JZboAovPh5KrFVBp0wft8UZbtbtUxdkUqdukoI8dklJ9m1TIYBGxVOFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789357920; c=relaxed/simple;
	bh=LVYLFgDuvNL6/zXJb/Osg21BCo0deIc0Vt7yvn98eWs=;
	h=Date:To:From:Subject:Message-Id; b=IdCwub8EVocyAohyuGiJ2Fkl+thgvA9YggFlN7QBmlSftvYolNOTWxPekudC3qRmuhKrF378B0uSRoGDj2Bhck6p57EIPbozyVTF2Gm5MQmiIisWRT+zCfZDDJ3ipPOdMtf73/FBNPM4jucOD2NiZev8Ph7mkYqEyJYuOjw505g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XwgShlyW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XwgShlyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB301F000FF;
	Mon, 14 Sep 2026 03:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789357918;
	bh=ZZ49RxMbUvGzKrdD9/WspRzSKAY7GlFZwVFzKCh6IJI=;
	h=Date:To:From:Subject;
	b=XwgShlyWPN8yHVMuj3+j0JDhgJzK4G7GGHibFi020ei9KjpM3Acc6BadRyze0WxPT
	 mtjeqdlH1xuKsaW4a6d6Lpodu0CS79saSXRm8uMgv4/6G3FMpV8jO7RK2EtloQ0ZGX
	 +AqOsil/9X5C1cteKsabfbi3d3sCMxylJrh6KQ8Q=
Date: Sun, 13 Sep 2026 20:51:58 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,tytso@mit.edu,jaegeuk@kernel.org,ebiggers@kernel.org,david@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fscrypt-stop-setting-pg_private-on-bounce-page.patch added to mm-new branch
Message-Id: <20260914035158.8FB301F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fscrypt: stop setting PG_private on bounce page
has been added to the -mm mm-new branch.  Its filename is
     fscrypt-stop-setting-pg_private-on-bounce-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fscrypt-stop-setting-pg_private-on-bounce-page.patch

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
md-md-bitmap-replace-pageprivate-with-page_private.patch
buffer-replace-page_buffer-with-page_private-and-delete-it.patch
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

