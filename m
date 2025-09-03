Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E86D2E3391
	for <mm-commits@vger.kernel.org>; Wed,  3 Sep 2025 20:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756932410; cv=none; b=ovWwkNDwxwRjINZUa6iKnrtiF21xID70GOtmaykMgkY0hYGMi4APV+JVJLBbT3US5JpSYyzIFwU2NZSYaZ8E5ENapchMw8fcJVF3mQyaUdwnAIsezTfP8hROp5D6btUqwHLBpNYjOTbYHe1RX7gksd4GVklcM1BP4tS+qPwVtdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756932410; c=relaxed/simple;
	bh=Yo0iyPWMtC85eG45UIRC3dVkcdt/b0aMCmPpuE7hPXQ=;
	h=Date:To:From:Subject:Message-Id; b=S8dFZU0jTd2oWBnOVA+qJBBX+GGE/NlWydWELp9X+HRzMLCqWGMHRikxlmtITQewBvzq0yYeNX/7MCRtFGjsEgTy+vaHkivpz/51qbCg4rna4nVcJKBTnoDOuy2Q5UednU4N12RIfXCd86xNktkfWbEkfYaMbIoSRmDeieKHjtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mlBb7YbM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mlBb7YbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB14C4CEE7;
	Wed,  3 Sep 2025 20:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756932410;
	bh=Yo0iyPWMtC85eG45UIRC3dVkcdt/b0aMCmPpuE7hPXQ=;
	h=Date:To:From:Subject:From;
	b=mlBb7YbMD7bN7GTFIGNLUDd3Sb6d+oujpK55oWr/gfwYUiCfdNtDVnwHE/aVizhrS
	 tQyRsQYsuxVKmfuPgLsvYCPjCp0S3/ruvgsPqhvvbC593dPyFZcrPhw2nabJAoO6cD
	 yR4k4fN7i6qGRi8AEHwlJG38U3NKMMpSIuQYYNTA=
Date: Wed, 03 Sep 2025 13:46:49 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-mlock_count-from-struct-page.patch added to mm-new branch
Message-Id: <20250903204649.EBB14C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove mlock_count from struct page
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-mlock_count-from-struct-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-mlock_count-from-struct-page.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm: remove mlock_count from struct page
Date: Wed, 3 Sep 2025 20:10:39 +0100

All users now use folio->mlock_count so we can remove this element of
struct page.  Move the useful comments over to struct folio.

Link: https://lkml.kernel.org/r/20250903191041.1630338-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/include/linux/mm_types.h~mm-remove-mlock_count-from-struct-page
+++ a/include/linux/mm_types.h
@@ -94,14 +94,6 @@ struct page {
 			union {
 				struct list_head lru;
 
-				/* Or, for the Unevictable "LRU list" slot */
-				struct {
-					/* Always even, to negate PageTail */
-					void *__filler;
-					/* Count page's or folio's mlocks */
-					unsigned int mlock_count;
-				};
-
 				/* Or, free page */
 				struct list_head buddy_list;
 				struct list_head pcp_list;
@@ -391,7 +383,9 @@ struct folio {
 			union {
 				struct list_head lru;
 	/* private: avoid cluttering the output */
+				/* For the Unevictable "LRU list" slot */
 				struct {
+					/* Avoid compound_head */
 					void *__filler;
 	/* public: */
 					unsigned int mlock_count;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-introduce-memdesc_flags_t.patch
mm-introduce-memdesc_flags_t-fix.patch
mm-convert-page_to_section-to-memdesc_section.patch
mm-introduce-memdesc_nid.patch
mm-introduce-memdesc_zonenum.patch
slab-use-memdesc_flags_t.patch
slab-use-memdesc_nid.patch
mm-introduce-memdesc_is_zone_device.patch
mm-reimplement-folio_is_device_private.patch
mm-reimplement-folio_is_device_coherent.patch
mm-reimplement-folio_is_fsdax.patch
mm-add-folio_is_pci_p2pdma.patch
mm-remove-mlock_count-from-struct-page.patch

