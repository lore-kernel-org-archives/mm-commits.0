Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F93FC0C
	for <mm-commits@vger.kernel.org>; Sat,  8 Jun 2024 04:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717820908; cv=none; b=idarH2vtfdLCWBcCHUb/kpPX2/Lh0s8ngtVZq1Ofe6gDTkTPPGpj0Ah2kFjwVk1f+vVWbA03FbfRZUWcwOEHLPRz5bEnteLLMXhb1ynb6rohWB6G9LJTDUVCNbqp7m/iGY4HscVbXqU7xcfbthLfzxPjxp9NQwKPIxMNaUFx8uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717820908; c=relaxed/simple;
	bh=14XTYGzWQmpy8Esg5bL7lwNxtE2yMBQSKbYGpiAk67U=;
	h=Date:To:From:Subject:Message-Id; b=T6TR5jeXDnpKk98A7l0QFCHxLmR70+yY0yUu3AuDYCxZL9g43b/zY0fAYS0ux8E9GFahUzDG5ubRQ0ZpdllF+yV7BqDo4F5lzk/Uop+4i2hh28WFY23ld6vfgq7QREULmsUVHZSfvnZUVYIP/EsDQBPjRA8VMXx1W5bbPHx9KKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nVFikTBe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nVFikTBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5ACC2BD11;
	Sat,  8 Jun 2024 04:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717820907;
	bh=14XTYGzWQmpy8Esg5bL7lwNxtE2yMBQSKbYGpiAk67U=;
	h=Date:To:From:Subject:From;
	b=nVFikTBeP9dUJskQFoO0NWOJiw1uoLDGgnJ3k3Svs95jm16u4MHolUPlylF3q0BwE
	 Z75fwtfb+LOQ1+lViTKXN61DFvpcWbLO8d7ghEdobt05cXgN2CAStjfYkaBdJoM30W
	 zPzNTIPToJ6N7Ya8R+bMr6otR4RaL6O0QSmLhyLY=
Date: Fri, 07 Jun 2024 21:28:26 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,vbabka@suse.cz,osandov@osandov.com,gehao@kylinos.cn,david@redhat.com,stephen.s.brennan@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-page-type-macros-to-enum.patch added to mm-unstable branch
Message-Id: <20240608042827.7B5ACC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert page type macros to enum
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-page-type-macros-to-enum.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-page-type-macros-to-enum.patch

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
From: Stephen Brennan <stephen.s.brennan@oracle.com>
Subject: mm: convert page type macros to enum
Date: Fri, 7 Jun 2024 13:29:53 -0700

Changing PG_slab from a page flag to a page type in commit 46df8e73a4a3
("mm: free up PG_slab") in has the unintended consequence of removing the
PG_slab constant from kernel debuginfo.  The commit does add the value to
the vmcoreinfo note, which allows debuggers to find the value without
hardcoding it.  However it's most flexible to continue representing the
constant with an enum.  To that end, convert the page type fields into an
enum.  Debuggers will now be able to detect that PG_slab's type has
changed from enum pageflags to enum pagetype.

Link: https://lkml.kernel.org/r/20240607202954.1198180-1-stephen.s.brennan@oracle.com
Fixes: 46df8e73a4a3 ("mm: free up PG_slab")
Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hao Ge <gehao@kylinos.cn>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Omar Sandoval <osandov@osandov.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- a/include/linux/page-flags.h~mm-convert-page-type-macros-to-enum
+++ a/include/linux/page-flags.h
@@ -940,20 +940,23 @@ PAGEFLAG_FALSE(HasHWPoisoned, has_hwpois
  * mistaken for a page type value.
  */
 
-#define PAGE_TYPE_BASE	0x80000000
-/*
- * Reserve 0xffff0000 - 0xfffffffe to catch _mapcount underflows and
- * allow owners that set a type to reuse the lower 16 bit for their own
- * purposes.
- */
-#define PG_buddy	0x40000000
-#define PG_offline	0x20000000
-#define PG_table	0x10000000
-#define PG_guard	0x08000000
-#define PG_hugetlb	0x04000000
-#define PG_slab		0x02000000
-#define PG_zsmalloc	0x01000000
-#define PAGE_MAPCOUNT_RESERVE	(~0x0000ffff)
+enum pagetype {
+	/*
+	 * Reserve 0xffff0000 - 0xfffffffe to catch _mapcount underflows and
+	 * allow owners that set a type to reuse the lower 16 bit for their own
+	 * purposes.
+	 */
+	PG_buddy	= 0x40000000,
+	PG_offline	= 0x20000000,
+	PG_table	= 0x10000000,
+	PG_guard	= 0x08000000,
+	PG_hugetlb	= 0x04000000,
+	PG_slab		= 0x02000000,
+	PG_zsmalloc	= 0x01000000,
+
+	PAGE_TYPE_BASE	= 0x80000000,
+	PAGE_MAPCOUNT_RESERVE	= ~0x0000ffff,
+};
 
 #define PageType(page, flag)						\
 	((page->page_type & (PAGE_TYPE_BASE | flag)) == PAGE_TYPE_BASE)
_

Patches currently in -mm which might be from stephen.s.brennan@oracle.com are

mm-convert-page-type-macros-to-enum.patch

