Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBA626B971
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 21:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758661578; cv=none; b=WfORVq4CLG8jygkCa4p/Ly3WDNjkN7gnltX+I6GEugUz/TMo31Z8c8AmpSCX1SVb2O9GKI2UpaB5niydFaQzu81FPgsZ+ILWxj8am/yKdye9Ys6Wil9VK78Em4bx7E51mdIhrIT0IiIFR70CQMumLQ1Kvxppe+DFYm1mwMOAL9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758661578; c=relaxed/simple;
	bh=xjviS5lC60tmw0KmIXFSIjZEcCJDdGoNOYJPH3c1O0Q=;
	h=Date:To:From:Subject:Message-Id; b=JHW4+YTeSmN7Y8tbDc/H+J4nsYD0a2bu6aRzc/CWyP0ocv5ZNe7WZAwHLibzuutDWAkdJfV/06LLbXURLKeJ9ZTiFkgiDxgwGJ35aJurXz1iZ7p2MjOpCZav11T6pyfpQi2cAvM1VCQ1QbJvRXHppFn/92S7Lgdghb87Gr2ej2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D2LsLRa0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D2LsLRa0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0DDC4CEF5;
	Tue, 23 Sep 2025 21:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758661578;
	bh=xjviS5lC60tmw0KmIXFSIjZEcCJDdGoNOYJPH3c1O0Q=;
	h=Date:To:From:Subject:From;
	b=D2LsLRa0lg9+PWfsG/F5ozuTbmNQaE9SvlSd3qnqOUeLuwvgnrKY0rGU4qHaupwLs
	 /mp5zLJtuMoZm2KsMc7ECoohaDbkDkdtKN91Tqg/15jHtXuf/yISwE9RpQ2TOZGxbC
	 w4H9hELYK/Kqy5EJes1rMJeJgQ+Crxe/VeuHsCPQ=
Date: Tue, 23 Sep 2025 14:06:17 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,kas@kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-folio_page-back-to-a-macro.patch added to mm-new branch
Message-Id: <20250923210618.3F0DDC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert folio_page() back to a macro
has been added to the -mm mm-new branch.  Its filename is
     mm-convert-folio_page-back-to-a-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-folio_page-back-to-a-macro.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm: convert folio_page() back to a macro
Date: Tue, 23 Sep 2025 16:00:58 +0200

In commit 73b3294b1152 ("mm: simplify folio_page() and folio_page_idx()")
we converted folio_page() into a static inline function.  However briefly
afterwards in commit a847b17009ec ("mm: constify highmem related functions
for improved const-correctness") we had to add some nasty const-away
casting to make the compiler happy when checking const correctness.

So let's just convert it back to a simple macro so the compiler can check
const correctness properly.  There is the alternative of using a
_Generic() similar to page_folio(), but there is not a lot of benefit
compared to just using a simple macro.

Link: https://lkml.kernel.org/r/20250923140058.2020023-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/include/linux/page-flags.h~mm-convert-folio_page-back-to-a-macro
+++ a/include/linux/page-flags.h
@@ -316,10 +316,7 @@ static __always_inline unsigned long _co
  * check that the page number lies within @folio; the caller is presumed
  * to have a reference to the page.
  */
-static inline struct page *folio_page(const struct folio *folio, unsigned long n)
-{
-	return (struct page *)(&folio->page + n);
-}
+#define folio_page(folio, n)	(&(folio)->page + (n))
 
 static __always_inline int PageTail(const struct page *page)
 {
_

Patches currently in -mm which might be from david@redhat.com are

mm-convert-folio_page-back-to-a-macro.patch

