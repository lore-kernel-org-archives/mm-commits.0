Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CE92609E3
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 03:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789961496; cv=none; b=Eajy7OJNGyw3XCsuiHvDfQMvWH7/oqsbuiocuYj6ZePhVeMYpKQ26fsfa3wRg0DYepFhXHaYy8oKhwEHLFNz9bUdMK99A31PfKNrNqv44HU6X150tBmFe5/a4IZSTFUy2jMJl3h/X1doQ4hAHCgQSFSbvf1PEX9B9NnefEBojyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789961496; c=relaxed/simple;
	bh=9rgCgPjM4NunUQGMCF3mwrvGNZpAN8OB9dfqHvoEJ5E=;
	h=Date:To:From:Subject:Message-Id; b=FpI1HP4Bn4rVO/EDbT7Zbq7LXJDP3OJlCL6Ok/+HzsAIvvYNVyb143YiYhOR53oNeTxxcXFrmJfJxipfowJcQZtykPmTz2uXLxTo5rNW2pdnwHAwz0xQZFNZQRRH8thfAxdBZiwZQ6H4ov/FAIQCwmu1MbOWQYlpA1ONW3qQYUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q+jGJDiA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q+jGJDiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9641F000FF;
	Mon, 21 Sep 2026 03:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789961495;
	bh=ilyGFaet2FkBzUDZUDCNC77lONr6eaA1E7POcDWMVC8=;
	h=Date:To:From:Subject;
	b=q+jGJDiA2GXsv7U/S9ZBWiEbrDmGJVGgtbrCFxzc2Fo/Lp2x04G2yIm4c8+96l3ca
	 7GPWGESbKJhmxlLMSAaaEcqNm9SpSqslZ+GLmCxc7DDpef2BWz6hLHUqHFup8RZKqJ
	 vIjHLZe1Fcsoo1HWa1jVGaATakbxl0WOlcvEoKVI=
Date: Sun, 20 Sep 2026 20:31:35 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] f2fs-stop-using-pg_private.patch removed from -mm tree
Message-Id: <20260921033135.7A9641F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: f2fs: stop using PG_private
has been removed from the -mm tree.  Its filename was
     f2fs-stop-using-pg_private.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: f2fs: stop using PG_private
Date: Sun, 13 Sep 2026 22:24:04 -0400

f2fs sets its PAGE_PRIVATE_* flags in page->private and checking
page->private != NULL is equivalent to checking PG_private.  Change
PagePrivate() to page_private().  Meanwhile, in set_page_private_##name(),
page->private is first set to 0/NULL before an PAGE_PRIVATE_* flag is set,
but it can cause confusion when PG_private is removed and page->private !=
NULL is used instead.  Change it to initialize page->private to
PAGE_PRIVATE_NOT_POINTER instead and retain the original semantics.

It prepares for a future commit that removes PG_private.

No functional change intended.

Assisted-by: LLM
Link: https://lore.kernel.org/20260913-remove-pg_private-v4-6-848550f7574e@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Chao Yu <chao@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
---

 fs/f2fs/f2fs.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/f2fs/f2fs.h~f2fs-stop-using-pg_private
+++ a/fs/f2fs/f2fs.h
@@ -2691,7 +2691,7 @@ static inline bool folio_test_f2fs_##nam
 }									\
 static inline bool page_private_##name(struct page *page) \
 { \
-	return PagePrivate(page) && \
+	return page_private(page) && \
 		test_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)) && \
 		test_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
@@ -2710,9 +2710,9 @@ static inline void folio_set_f2fs_##name
 }									\
 static inline void set_page_private_##name(struct page *page) \
 { \
-	if (!PagePrivate(page)) \
-		attach_page_private(page, (void *)0); \
-	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
+	if (!page_private(page)) \
+		attach_page_private(page, \
+				(void *)BIT(PAGE_PRIVATE_NOT_POINTER)); \
 	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

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

