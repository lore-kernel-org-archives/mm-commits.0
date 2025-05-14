Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658D426AC3;
	Wed, 14 May 2025 22:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747261522; cv=none; b=ELTow9c05E/si4Y11JjFvW/S/CjMWAcqOi86ujjPozu/E/kmhD1MS0JPIfSBWV1gk36OpQGPBOtdjBlfJ6Cq8ck6zORIyU9PcSDZjwL4hVzwZXpaUPjG6Mq3Pg/jZPu93fFDwhAzoaSNwV0UhP59nZ5C5dwjX+oIsSx0dpqMUdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747261522; c=relaxed/simple;
	bh=NEZMPbz2xJDcLS27vdI+X0/N8pwHgaM5WvrJfTNNnYY=;
	h=Date:To:From:Subject:Message-Id; b=DJGXE9q8xUowNyAvHMQ3imxgaVhHY+8kp8tq06nEWSPIkYDOyn5piZYiNrazy2BaxbUM2+rxlRcjFxMGNiZvWcthf1/hOcXiSbNr0F24OuYtT9M94O1S54zPZPogtNvAByu1LdwSVTXMwptNOZjDM5w7bL23qRnnbwumaKiy1q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cRj7f9Fl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cRj7f9Fl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8355C4CEED;
	Wed, 14 May 2025 22:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747261521;
	bh=NEZMPbz2xJDcLS27vdI+X0/N8pwHgaM5WvrJfTNNnYY=;
	h=Date:To:From:Subject:From;
	b=cRj7f9FlNqieJmfGUgdNPaBZqoDAg6crmSxkwULd8EBhMXy6lsTqyMTjosVz0BnO6
	 WOM4bcl/+82/RcxQn6WSzwtmNf6VreX7WvWFWsiyrYTVyUwmd3gMrQWkxu+jCePmgf
	 Zy/5JrRyGod+7oosV3YRu5AVZpnQBkQw8xFIP6AM=
Date: Wed, 14 May 2025 15:25:21 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,hughd@google.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + highmem-add-folio_test_partial_kmap.patch added to mm-hotfixes-unstable branch
Message-Id: <20250514222521.B8355C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: highmem: add folio_test_partial_kmap()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     highmem-add-folio_test_partial_kmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/highmem-add-folio_test_partial_kmap.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: highmem: add folio_test_partial_kmap()
Date: Wed, 14 May 2025 18:06:02 +0100

In commit c749d9b7ebbc (iov_iter: fix copy_page_from_iter_atomic() if
KMAP_LOCAL_FORCE_MAP), Hugh correctly noted that if KMAP_LOCAL_FORCE_MAP
is enabled, we must limit ourselves to PAGE_SIZE bytes per call to
kmap_local().  The same problem exists in memcpy_from_folio(),
memcpy_to_folio(), folio_zero_tail(), folio_fill_tail() and
memcpy_from_file_folio(), so add folio_test_partial_kmap() to do this more
succinctly.

Link: https://lkml.kernel.org/r/20250514170607.3000994-2-willy@infradead.org
Fixes: 00cdf76012ab ("mm: add memcpy_from_file_folio()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h    |   10 +++++-----
 include/linux/page-flags.h |    7 +++++++
 2 files changed, 12 insertions(+), 5 deletions(-)

--- a/include/linux/highmem.h~highmem-add-folio_test_partial_kmap
+++ a/include/linux/highmem.h
@@ -461,7 +461,7 @@ static inline void memcpy_from_folio(cha
 		const char *from = kmap_local_folio(folio, offset);
 		size_t chunk = len;
 
-		if (folio_test_highmem(folio) &&
+		if (folio_test_partial_kmap(folio) &&
 		    chunk > PAGE_SIZE - offset_in_page(offset))
 			chunk = PAGE_SIZE - offset_in_page(offset);
 		memcpy(to, from, chunk);
@@ -489,7 +489,7 @@ static inline void memcpy_to_folio(struc
 		char *to = kmap_local_folio(folio, offset);
 		size_t chunk = len;
 
-		if (folio_test_highmem(folio) &&
+		if (folio_test_partial_kmap(folio) &&
 		    chunk > PAGE_SIZE - offset_in_page(offset))
 			chunk = PAGE_SIZE - offset_in_page(offset);
 		memcpy(to, from, chunk);
@@ -522,7 +522,7 @@ static inline __must_check void *folio_z
 {
 	size_t len = folio_size(folio) - offset;
 
-	if (folio_test_highmem(folio)) {
+	if (folio_test_partial_kmap(folio)) {
 		size_t max = PAGE_SIZE - offset_in_page(offset);
 
 		while (len > max) {
@@ -560,7 +560,7 @@ static inline void folio_fill_tail(struc
 
 	VM_BUG_ON(offset + len > folio_size(folio));
 
-	if (folio_test_highmem(folio)) {
+	if (folio_test_partial_kmap(folio)) {
 		size_t max = PAGE_SIZE - offset_in_page(offset);
 
 		while (len > max) {
@@ -597,7 +597,7 @@ static inline size_t memcpy_from_file_fo
 	size_t offset = offset_in_folio(folio, pos);
 	char *from = kmap_local_folio(folio, offset);
 
-	if (folio_test_highmem(folio)) {
+	if (folio_test_partial_kmap(folio)) {
 		offset = offset_in_page(offset);
 		len = min_t(size_t, len, PAGE_SIZE - offset);
 	} else
--- a/include/linux/page-flags.h~highmem-add-folio_test_partial_kmap
+++ a/include/linux/page-flags.h
@@ -615,6 +615,13 @@ FOLIO_FLAG(dropbehind, FOLIO_HEAD_PAGE)
 PAGEFLAG_FALSE(HighMem, highmem)
 #endif
 
+/* Does kmap_local_folio() only allow access to one page of the folio? */
+#ifdef CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP
+#define folio_test_partial_kmap(f)	true
+#else
+#define folio_test_partial_kmap(f)	folio_test_highmem(f)
+#endif
+
 #ifdef CONFIG_SWAP
 static __always_inline bool folio_test_swapcache(const struct folio *folio)
 {
_

Patches currently in -mm which might be from willy@infradead.org are

highmem-add-folio_test_partial_kmap.patch
mm-rename-page-index-to-page-__folio_index.patch

