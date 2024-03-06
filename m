Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB901C11
	for <mm-commits@vger.kernel.org>; Wed,  6 Mar 2024 21:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759102; cv=none; b=VsEMKaohkBXpGD+pPTclfunl0jiG6md0yNOvzPck3azQNCZwi9XT4DMec+b6Ya0CwAiBdBd2ySVD0KdTUsvZH95B/E948327uxU/JxysuJzeg9ak1pzwJkxqTYZhsvIqV6MRTdyroBYMH5XzxYrtGwkV0w7/132qnMP8wK9fkUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759102; c=relaxed/simple;
	bh=yuAwTCOAlPdH83TKslDXUp+FEE5lxVfBgXV7LMmS60o=;
	h=Date:To:From:Subject:Message-Id; b=eUddrALhbzmzTWkkAPvZLAAJQe8c9DQWxdmchZ69pjCKASDZ8R6nNnFwMZm9eHG8wslOQYKH/WiuBUja4RMdyLWZwZ3yC1K04EIbBdnp1PkiywOJjumagEJTPtIi1T5e5eZHZRH45NU1bUmN0PyX/HZMsX+BDl6dVZf2c1NXFk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wtb/cK8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wtb/cK8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65930C433F1;
	Wed,  6 Mar 2024 21:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709759102;
	bh=yuAwTCOAlPdH83TKslDXUp+FEE5lxVfBgXV7LMmS60o=;
	h=Date:To:From:Subject:From;
	b=Wtb/cK8AwLpI2MeB0GlWVf4lwi24L1eQIcKkblHowdTtx2Vk/LBSKuUBFUHBNLC8Z
	 uPLL9rhRkGxJb4anLrN4BQ1msWI9+IZELQD3y2j+KlPwuKFR8Rd0JRs7QlO2rjjjzy
	 fwmWDCnDyU43+Rld6Utp2ne+LxoBJXb1Cgzt32m8=
Date: Wed, 06 Mar 2024 13:05:01 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-separate-out-folio_flags-from-pageflags.patch removed from -mm tree
Message-Id: <20240306210502.65930C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: separate out FOLIO_FLAGS from PAGEFLAGS
has been removed from the -mm tree.  Its filename was
     mm-separate-out-folio_flags-from-pageflags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: separate out FOLIO_FLAGS from PAGEFLAGS
Date: Tue, 27 Feb 2024 19:23:28 +0000

Patch series "PageFlags cleanups".

We have now successfully removed all of the uses of some of the PageFlags
from the kernel, but there's nothing to stop somebody reintroducing them. 
By splitting out FOLIO_FLAGS from PAGEFLAGS, we can stop defining the old
flags; and we do that in some of the later patches.

After doing this, I realised that dump_page() was living dangerously; we
could end up calling folio_test_foo() on a pointer which no longer pointed
to a folio (as dump_page() is not necessarily called when the caller has a
reference to the page).  So I fixed that up.

And then I realised that this was the key to making dump_page() take a
const argument, which means we can constify the page flags testing, which
means we can remove more cast-away-the-const bad code.

And here's where I ended up.


This patch (of 8):

We've progressed far enough with the folio transition that some flags are
now no longer checked on pages, but only on folios.  To prevent new users
appearing, prepare to only define the folio versions of the flag
test/set/clear.

Link: https://lkml.kernel.org/r/20240227192337.757313-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240227192337.757313-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   63 +++++++++++++++++++++++------------
 1 file changed, 43 insertions(+), 20 deletions(-)

--- a/include/linux/page-flags.h~mm-separate-out-folio_flags-from-pageflags
+++ a/include/linux/page-flags.h
@@ -367,54 +367,77 @@ static unsigned long *folio_flags(struct
 #define FOLIO_PF_NO_COMPOUND	0
 #define FOLIO_PF_SECOND		1
 
+#define FOLIO_HEAD_PAGE		0
+#define FOLIO_SECOND_PAGE	1
+
 /*
  * Macros to create function definitions for page flags
  */
+#define FOLIO_TEST_FLAG(name, page)					\
+static __always_inline bool folio_test_##name(struct folio *folio)	\
+{ return test_bit(PG_##name, folio_flags(folio, page)); }
+
+#define FOLIO_SET_FLAG(name, page)					\
+static __always_inline void folio_set_##name(struct folio *folio)	\
+{ set_bit(PG_##name, folio_flags(folio, page)); }
+
+#define FOLIO_CLEAR_FLAG(name, page)					\
+static __always_inline void folio_clear_##name(struct folio *folio)	\
+{ clear_bit(PG_##name, folio_flags(folio, page)); }
+
+#define __FOLIO_SET_FLAG(name, page)					\
+static __always_inline void __folio_set_##name(struct folio *folio)	\
+{ __set_bit(PG_##name, folio_flags(folio, page)); }
+
+#define __FOLIO_CLEAR_FLAG(name, page)					\
+static __always_inline void __folio_clear_##name(struct folio *folio)	\
+{ __clear_bit(PG_##name, folio_flags(folio, page)); }
+
+#define FOLIO_TEST_SET_FLAG(name, page)					\
+static __always_inline bool folio_test_set_##name(struct folio *folio)	\
+{ return test_and_set_bit(PG_##name, folio_flags(folio, page)); }
+
+#define FOLIO_TEST_CLEAR_FLAG(name, page)				\
+static __always_inline bool folio_test_clear_##name(struct folio *folio) \
+{ return test_and_clear_bit(PG_##name, folio_flags(folio, page)); }
+
+#define FOLIO_FLAG(name, page)						\
+FOLIO_TEST_FLAG(name, page)						\
+FOLIO_SET_FLAG(name, page)						\
+FOLIO_CLEAR_FLAG(name, page)
+
 #define TESTPAGEFLAG(uname, lname, policy)				\
-static __always_inline bool folio_test_##lname(struct folio *folio)	\
-{ return test_bit(PG_##lname, folio_flags(folio, FOLIO_##policy)); }	\
+FOLIO_TEST_FLAG(lname, FOLIO_##policy)					\
 static __always_inline int Page##uname(struct page *page)		\
 { return test_bit(PG_##lname, &policy(page, 0)->flags); }
 
 #define SETPAGEFLAG(uname, lname, policy)				\
-static __always_inline							\
-void folio_set_##lname(struct folio *folio)				\
-{ set_bit(PG_##lname, folio_flags(folio, FOLIO_##policy)); }		\
+FOLIO_SET_FLAG(lname, FOLIO_##policy)					\
 static __always_inline void SetPage##uname(struct page *page)		\
 { set_bit(PG_##lname, &policy(page, 1)->flags); }
 
 #define CLEARPAGEFLAG(uname, lname, policy)				\
-static __always_inline							\
-void folio_clear_##lname(struct folio *folio)				\
-{ clear_bit(PG_##lname, folio_flags(folio, FOLIO_##policy)); }		\
+FOLIO_CLEAR_FLAG(lname, FOLIO_##policy)					\
 static __always_inline void ClearPage##uname(struct page *page)		\
 { clear_bit(PG_##lname, &policy(page, 1)->flags); }
 
 #define __SETPAGEFLAG(uname, lname, policy)				\
-static __always_inline							\
-void __folio_set_##lname(struct folio *folio)				\
-{ __set_bit(PG_##lname, folio_flags(folio, FOLIO_##policy)); }		\
+__FOLIO_SET_FLAG(lname, FOLIO_##policy)					\
 static __always_inline void __SetPage##uname(struct page *page)		\
 { __set_bit(PG_##lname, &policy(page, 1)->flags); }
 
 #define __CLEARPAGEFLAG(uname, lname, policy)				\
-static __always_inline							\
-void __folio_clear_##lname(struct folio *folio)				\
-{ __clear_bit(PG_##lname, folio_flags(folio, FOLIO_##policy)); }	\
+__FOLIO_CLEAR_FLAG(lname, FOLIO_##policy)				\
 static __always_inline void __ClearPage##uname(struct page *page)	\
 { __clear_bit(PG_##lname, &policy(page, 1)->flags); }
 
 #define TESTSETFLAG(uname, lname, policy)				\
-static __always_inline							\
-bool folio_test_set_##lname(struct folio *folio)			\
-{ return test_and_set_bit(PG_##lname, folio_flags(folio, FOLIO_##policy)); } \
+FOLIO_TEST_SET_FLAG(lname, FOLIO_##policy)				\
 static __always_inline int TestSetPage##uname(struct page *page)	\
 { return test_and_set_bit(PG_##lname, &policy(page, 1)->flags); }
 
 #define TESTCLEARFLAG(uname, lname, policy)				\
-static __always_inline							\
-bool folio_test_clear_##lname(struct folio *folio)			\
-{ return test_and_clear_bit(PG_##lname, folio_flags(folio, FOLIO_##policy)); } \
+FOLIO_TEST_CLEAR_FLAG(lname, FOLIO_##policy)				\
 static __always_inline int TestClearPage##uname(struct page *page)	\
 { return test_and_clear_bit(PG_##lname, &policy(page, 1)->flags); }
 
_

Patches currently in -mm which might be from willy@infradead.org are


