Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6A62D73A0
	for <mm-commits@vger.kernel.org>; Tue, 26 May 2026 20:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779826528; cv=none; b=Fj5ySGQ4aXzOnxQj5yC/MgYbMUGiiSGx/kw0Cs7zmzyr1B5yesI1WqWIDKLFCJ+C0AELzVH1n0w9XJfjdASoi3/ynzv57tcj969F4FlLxm8iCgt0ioW3dIlSRR7idTaDQZFjjBX/oVQEe+ZTj33loB4/X8+Hq7kXIdCuG5/JJ7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779826528; c=relaxed/simple;
	bh=MzXsdVO5YOnyVUNfCCrfy4jKghXU2VCGmsSavMhiK2U=;
	h=Date:To:From:Subject:Message-Id; b=lzJb2JsV/UuBOv4yP0RKI5zSsNBW3YYKIXUaXxG/0Kh7NF1A+P7CHoJQUU7Ssnbq0Jo2z5bvmbz2ZhoebjgGtIAxJktfHQO1Ob8hdWBHDDMvp512Vfx7gevrjoe2IlGSMY5xSEsPTqql41jPLPXL4dRdI7e1cxZZQdp/etI/2rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EHi0ogvs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EHi0ogvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E49D1F000E9;
	Tue, 26 May 2026 20:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779826527;
	bh=JMYT45ml8QufbJadr6Jf6FKR89ThSVriG/dEUrNMYVI=;
	h=Date:To:From:Subject;
	b=EHi0ogvsgpNHN28V7D0H620EP2k4UYHdWJ1B5dG1BRaflGU4plRMm6nHSfncgjzAy
	 PeoPPf17CYvHVWZTNs8uwzORcfAlNwnNKS1dwEaYWchubrXMcl5BOtwWMiK60tMKau
	 0B96zn486ESPKWKK9J8aaTr6TuL+UR5EWJ8k7tzc=
Date: Tue, 26 May 2026 13:15:26 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-document-the-folio-refcount-a-little-better.patch added to mm-new branch
Message-Id: <20260526201527.1E49D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: document the folio refcount a little better
has been added to the -mm mm-new branch.  Its filename is
     mm-document-the-folio-refcount-a-little-better.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-document-the-folio-refcount-a-little-better.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: document the folio refcount a little better
Date: Tue, 26 May 2026 21:00:30 +0100

Expand the documentation of folio_ref_count() to talk about expected,
temporary and spurious refcounts as well as the concept of freezing.

Link: https://lore.kernel.org/20260526200032.353868-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ref.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/include/linux/page_ref.h~mm-document-the-folio-refcount-a-little-better
+++ a/include/linux/page_ref.h
@@ -71,6 +71,12 @@ static inline int page_ref_count(const s
  * folio_ref_count - The reference count on this folio.
  * @folio: The folio.
  *
+ * Folios contain a reference count.  When that reference count reaches
+ * zero, the folio is referred to as frozen.  At this point, it will
+ * usually be returned to the memory allocator, but some parts of the
+ * kernel freeze folios in order to perform unusual operations on them
+ * such as splitting or migration.
+ *
  * The refcount is usually incremented by calls to folio_get() and
  * decremented by calls to folio_put().  Some typical users of the
  * folio refcount:
@@ -82,6 +88,18 @@ static inline int page_ref_count(const s
  * - Pipes
  * - Direct IO which references this page in the process address space
  *
+ * The reference count has three components: expected, temporary and
+ * spurious.  The expected reference count of a folio is that which
+ * we would logically expect it to be from just reading the code.
+ * Temporary refcounts are gained by threads which need a temporary
+ * reference to make sure the folio isn't reallocated while they use it.
+ * Spurious refcounts are gained by threads which, thanks to RCU walks
+ * of the page tables or file cache, find a stale pointer to a folio.
+ * These threads will drop the refcount after discoveering the pointer
+ * is stale, but it can surprise other users to see the spurious refcount
+ * on a freshly allocated folio (eg they may see a refcount of 2 instead
+ * of 1).
+ *
  * Return: The number of references to this folio.
  */
 static inline int folio_ref_count(const struct folio *folio)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-mentions-of-pagewriteback.patch
mm-document-the-folio-refcount-a-little-better.patch

