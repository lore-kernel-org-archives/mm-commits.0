Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965742C6B7
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957105; cv=none; b=JB+TrdtYK/ftC0GtK4raWqrz0qnteAhcfgog22v242MjzbkXtHWjOicbFF/xiVwZFqYuMJb2FG0yES62mPDKro1tDhmbN9q6UPJMDCkMtLCscMSwhfFrG+4XyqAeiUJbUuJBCxepoJh/6CX01qtMysA9Q5EpGeVZ/opiTSUBWqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957105; c=relaxed/simple;
	bh=UqcUnL068/G3I8c9vBhTutnJDb70N03ZIy4IQqhYSLg=;
	h=Date:To:From:Subject:Message-Id; b=gam/Rqnv87i+Xe8BX5G6c/qK5lReCsIs1Rs8oEGLS9HDY6k925o4LDXXVlFA5Fao1pP48n3vj12wKrHwY41+LlnKpl6K8kSWZgR8Gtjbi9msGMOFAXElFyP6XjNf0EJvqK6miQKlsWcXrwrZkyxq2cWwcagLRLLg+s5rn0voWSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IqpiI2oM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IqpiI2oM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1AEC116B1;
	Mon,  6 May 2024 00:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957105;
	bh=UqcUnL068/G3I8c9vBhTutnJDb70N03ZIy4IQqhYSLg=;
	h=Date:To:From:Subject:From;
	b=IqpiI2oM3jOoPSAujaigMy/1JApp9RfeVl54w03dIyiQSXirK1LyLGD/RWj0wZavj
	 1ZscubWN82oxa5l8p5nlTO6YP4tDbCxJ3WthUvXKMOmQuJb/J6vT91hMM6kZ7yk9Er
	 28QRDnvXgsWPbBzKCJ+BZ9kYof4yg5GyLDO6vz78=
Date: Sun, 05 May 2024 17:58:24 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-kernel-doc-for-folio_mark_accessed.patch removed from -mm tree
Message-Id: <20240506005825.6F1AEC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add kernel-doc for folio_mark_accessed()
has been removed from the -mm tree.  Its filename was
     mm-add-kernel-doc-for-folio_mark_accessed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add kernel-doc for folio_mark_accessed()
Date: Wed, 24 Apr 2024 20:19:11 +0100

Convert the existing documentation to kernel-doc and remove references to
pages.

Link: https://lkml.kernel.org/r/20240424191914.361554-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/mm/swap.c~mm-add-kernel-doc-for-folio_mark_accessed
+++ a/mm/swap.c
@@ -447,15 +447,18 @@ static void folio_inc_refs(struct folio
 }
 #endif /* CONFIG_LRU_GEN */
 
-/*
- * Mark a page as having seen activity.
+/**
+ * folio_mark_accessed - Mark a folio as having seen activity.
+ * @folio: The folio to mark.
  *
- * inactive,unreferenced	->	inactive,referenced
- * inactive,referenced		->	active,unreferenced
- * active,unreferenced		->	active,referenced
+ * This function will perform one of the following transitions:
  *
- * When a newly allocated page is not yet visible, so safe for non-atomic ops,
- * __SetPageReferenced(page) may be substituted for mark_page_accessed(page).
+ * * inactive,unreferenced	->	inactive,referenced
+ * * inactive,referenced	->	active,unreferenced
+ * * active,unreferenced	->	active,referenced
+ *
+ * When a newly allocated folio is not yet visible, so safe for non-atomic ops,
+ * __folio_set_referenced() may be substituted for folio_mark_accessed().
  */
 void folio_mark_accessed(struct folio *folio)
 {
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

