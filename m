Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B89112C460
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 21:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723067614; cv=none; b=HmudFWjj/EGXf9wj2kDvO7rGWrGN2+c3YZ6/YYg3PLx9RECdr9rsOhKc0a8AsZfmWiLEtHo1ccAiUFKZMVt9exy7DiZdvmsCEPM8xfhfrnAV1QcYg8L61vwmKmk/GdWlUV6+m/Kg9IFG9lMqabalvlZWke1TwqOBDxzM4PbbV2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723067614; c=relaxed/simple;
	bh=ABiBrQcTvMM/q55CKuxfAeBFcb0KqU3WdVNW3A0rYxU=;
	h=Date:To:From:Subject:Message-Id; b=na7lsvkyfQc/DtpRVkd/T53/irhl/D/70DaYDmMxuPxhuICFdxwIRgKsshlcErIi1+5V/KcVzshknXYH1V7L6aPVlCayVYzOms+VL+/7CBSgR4YrbZK/lLwrWoktCOXadmbq1J+yum54PKCvi6zw13/Ov2SoyJRLnztuHQv9wVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0RXTrdNX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0RXTrdNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7898C32781;
	Wed,  7 Aug 2024 21:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723067613;
	bh=ABiBrQcTvMM/q55CKuxfAeBFcb0KqU3WdVNW3A0rYxU=;
	h=Date:To:From:Subject:From;
	b=0RXTrdNXVdnig69XJ0fnWc41MchJMB1z5dADjuoxV99tJtwxfrDsxw23UFXlaOQ/b
	 9muHgxQxwC14Uk00Ykr8NIm2eFZY0ecpFSFTJq8YLurnLhJ7bZREZENB1E/ayvPUIX
	 e9tJtFIRXhxz5vVlhwqSOy/Jv9bpYTYYUeAwwGvI=
Date: Wed, 07 Aug 2024 14:53:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-pg_error.patch added to mm-unstable branch
Message-Id: <20240807215333.D7898C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove PG_error
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-pg_error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-pg_error.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm: remove PG_error
Date: Wed, 7 Aug 2024 20:35:26 +0100

The PG_error bit is now unused; delete it and free up a bit in
page->flags.

Link: https://lkml.kernel.org/r/20240807193528.1865100-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c                         |    1 -
 include/linux/page-flags.h             |    6 +-----
 include/trace/events/mmflags.h         |    1 -
 include/uapi/linux/kernel-page-flags.h |    2 +-
 4 files changed, 2 insertions(+), 8 deletions(-)

--- a/fs/proc/page.c~mm-remove-pg_error
+++ a/fs/proc/page.c
@@ -182,7 +182,6 @@ u64 stable_page_flags(const struct page
 #endif
 
 	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
-	u |= kpf_copy_bit(k, KPF_ERROR,		PG_error);
 	u |= kpf_copy_bit(k, KPF_DIRTY,		PG_dirty);
 	u |= kpf_copy_bit(k, KPF_UPTODATE,	PG_uptodate);
 	u |= kpf_copy_bit(k, KPF_WRITEBACK,	PG_writeback);
--- a/include/linux/page-flags.h~mm-remove-pg_error
+++ a/include/linux/page-flags.h
@@ -66,8 +66,6 @@
  * PG_referenced, PG_reclaim are used for page reclaim for anonymous and
  * file-backed pagecache (see mm/vmscan.c).
  *
- * PG_error is set to indicate that an I/O error occurred on this page.
- *
  * PG_arch_1 is an architecture specific page state bit.  The generic code
  * guarantees that this bit is cleared for a page when it first is entered into
  * the page cache.
@@ -103,7 +101,6 @@ enum pageflags {
 	PG_waiters,		/* Page has waiters, check its waitqueue. Must be bit #7 and in the same byte as "PG_locked" */
 	PG_active,
 	PG_workingset,
-	PG_error,
 	PG_owner_priv_1,	/* Owner use. If pagecache, fs may use*/
 	PG_arch_1,
 	PG_reserved,
@@ -183,7 +180,7 @@ enum pageflags {
 	 */
 
 	/* At least one page in this folio has the hwpoison flag set */
-	PG_has_hwpoisoned = PG_error,
+	PG_has_hwpoisoned = PG_active,
 	PG_large_rmappable = PG_workingset, /* anon or file-backed */
 };
 
@@ -506,7 +503,6 @@ static inline int TestClearPage##uname(s
 
 __PAGEFLAG(Locked, locked, PF_NO_TAIL)
 FOLIO_FLAG(waiters, FOLIO_HEAD_PAGE)
-PAGEFLAG(Error, error, PF_NO_TAIL) TESTCLEARFLAG(Error, error, PF_NO_TAIL)
 FOLIO_FLAG(referenced, FOLIO_HEAD_PAGE)
 	FOLIO_TEST_CLEAR_FLAG(referenced, FOLIO_HEAD_PAGE)
 	__FOLIO_SET_FLAG(referenced, FOLIO_HEAD_PAGE)
--- a/include/trace/events/mmflags.h~mm-remove-pg_error
+++ a/include/trace/events/mmflags.h
@@ -100,7 +100,6 @@
 #define __def_pageflag_names						\
 	DEF_PAGEFLAG_NAME(locked),					\
 	DEF_PAGEFLAG_NAME(waiters),					\
-	DEF_PAGEFLAG_NAME(error),					\
 	DEF_PAGEFLAG_NAME(referenced),					\
 	DEF_PAGEFLAG_NAME(uptodate),					\
 	DEF_PAGEFLAG_NAME(dirty),					\
--- a/include/uapi/linux/kernel-page-flags.h~mm-remove-pg_error
+++ a/include/uapi/linux/kernel-page-flags.h
@@ -7,7 +7,7 @@
  */
 
 #define KPF_LOCKED		0
-#define KPF_ERROR		1
+#define KPF_ERROR		1	/* Now unused */
 #define KPF_REFERENCED		2
 #define KPF_UPTODATE		3
 #define KPF_DIRTY		4
_

Patches currently in -mm which might be from willy@infradead.org are

fs-remove-calls-to-set-and-clear-the-folio-error-flag.patch
mm-remove-pg_error.patch
mm-return-the-folio-from-swapin_readahead.patch

