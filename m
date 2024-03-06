Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF7D1C11
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759103; cv=none; b=RpXl9cXQO4y8XOJXik8Wx2PO4pkXewYDENLn4sQzIkxksF/mOSVLFLEOP2+HreeH6OLI2JEFj4byGw8HMxpESgEEAMFUX7Z8dw0wVTN+n0AWWDxIcRKslB8n2fuyxl9RGBgfYwyxWSlJQRyqtZ6Y7CycAV2Hov3yHbkeMIbyALg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759103; c=relaxed/simple;
	bh=JPm7RiHHFE/nRewfQPOmTdXqf4JUKuObD0gUjulFKCM=;
	h=Date:To:From:Subject:Message-Id; b=k33Px97vMrDLzKpfFssWQeETlT6sm5LlmpLXWhcJ7kwHTkXCWfEPLYrfMPLfT5T1GkX3eNzz5l3N4c2oQkwB6HrlSbi6pz9S329v8fYu02BXh1wQIpUIQxjib5bsGXOTRQWIUYYIMktR27kSD+RvFRLw49SOgVkZygPTlaSIS04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cnmNOS9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cnmNOS9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AC2C43394;
	Wed,  6 Mar 2024 21:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759103;
	bh=JPm7RiHHFE/nRewfQPOmTdXqf4JUKuObD0gUjulFKCM=;
	h=Date:To:From:Subject:From;
	b=cnmNOS9Ee7tuYy74ZAh49i4Ql9kShsjGF6f88qxJm/3grs6XPq1bE75W6AG0xBrtS
	 N/qsQLMdMyePfjwoDc5KqDsOlalLPoD6gvv09ICu0byMMxbRK/vXCYuF8ElKq11ZFF
	 gikZg50ZiHP1pl7RQJyhooTnh1WJVCRIGm3Z/ng4=
Date: Wed, 06 Mar 2024 13:05:02 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch removed from -mm tree
Message-Id: <20240306210503.39AC2C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove PageWaiters, PageSetWaiters and PageClearWaiters
has been removed from the -mm tree.  Its filename was
     mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove PageWaiters, PageSetWaiters and PageClearWaiters
Date: Tue, 27 Feb 2024 19:23:29 +0000

All callers have been converted to use folios.  This was the only user of
PF_ONLY_HEAD, so remove that too.

Link: https://lkml.kernel.org/r/20240227192337.757313-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters
+++ a/include/linux/page-flags.h
@@ -328,9 +328,6 @@ static unsigned long *folio_flags(struct
  *     for compound page all operations related to the page flag applied to
  *     head page.
  *
- * PF_ONLY_HEAD:
- *     for compound page, callers only ever operate on the head page.
- *
  * PF_NO_TAIL:
  *     modifications of the page flag must be done on small or head pages,
  *     checks can be done on tail pages too.
@@ -346,9 +343,6 @@ static unsigned long *folio_flags(struct
 		page; })
 #define PF_ANY(page, enforce)	PF_POISONED_CHECK(page)
 #define PF_HEAD(page, enforce)	PF_POISONED_CHECK(compound_head(page))
-#define PF_ONLY_HEAD(page, enforce) ({					\
-		VM_BUG_ON_PGFLAGS(PageTail(page), page);		\
-		PF_POISONED_CHECK(page); })
 #define PF_NO_TAIL(page, enforce) ({					\
 		VM_BUG_ON_PGFLAGS(enforce && PageTail(page), page);	\
 		PF_POISONED_CHECK(compound_head(page)); })
@@ -362,7 +356,6 @@ static unsigned long *folio_flags(struct
 /* Which page is the flag stored in */
 #define FOLIO_PF_ANY		0
 #define FOLIO_PF_HEAD		0
-#define FOLIO_PF_ONLY_HEAD	0
 #define FOLIO_PF_NO_TAIL	0
 #define FOLIO_PF_NO_COMPOUND	0
 #define FOLIO_PF_SECOND		1
@@ -488,7 +481,7 @@ static inline int TestClearPage##uname(s
 	TESTSETFLAG_FALSE(uname, lname) TESTCLEARFLAG_FALSE(uname, lname)
 
 __PAGEFLAG(Locked, locked, PF_NO_TAIL)
-PAGEFLAG(Waiters, waiters, PF_ONLY_HEAD)
+FOLIO_FLAG(waiters, FOLIO_HEAD_PAGE)
 PAGEFLAG(Error, error, PF_NO_TAIL) TESTCLEARFLAG(Error, error, PF_NO_TAIL)
 PAGEFLAG(Referenced, referenced, PF_HEAD)
 	TESTCLEARFLAG(Referenced, referenced, PF_HEAD)
@@ -1138,7 +1131,6 @@ static inline bool folio_has_private(str
 
 #undef PF_ANY
 #undef PF_HEAD
-#undef PF_ONLY_HEAD
 #undef PF_NO_TAIL
 #undef PF_NO_COMPOUND
 #undef PF_SECOND
_

Patches currently in -mm which might be from willy@infradead.org are


