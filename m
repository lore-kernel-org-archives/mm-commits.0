Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BAA170849
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 20:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724272451; cv=none; b=NSn1G6xs6s5bxwxpsH6ovTzConeoNpkNqX0Zu9Obwa/FJ/YneUW2GpcccbBxy1dHNLcZElxP48xLwbFPejmYcU9s5+PFPOAGCGbXx7bdDVqCyA1ZWQhAliqC6yU8n2m3KO95/LGhCdt+6604LdUjPxsIsTOWvaHGToLUP1HJyKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724272451; c=relaxed/simple;
	bh=JBi0U2ZnF5VeGRpap05z7HD3fY8uoLAb0j8DxqA0fag=;
	h=Date:To:From:Subject:Message-Id; b=dz+9dZG5vmbebyCJSPui0am4SDbTTvc7W695VjtEu8D2L1l0buaXzIEForG3/4lPgO1LryXCPCSCfgVy0i2ZPMs9UYVsDj1H+gd/WN2JWeYF2oyq2pA1mUlzApw79iLM7d0hs+q5fGuW8uiNyWmLZ2d0nxp1ZibGS7cZjS86/QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AhM/F0yr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AhM/F0yr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A583EC32781;
	Wed, 21 Aug 2024 20:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724272449;
	bh=JBi0U2ZnF5VeGRpap05z7HD3fY8uoLAb0j8DxqA0fag=;
	h=Date:To:From:Subject:From;
	b=AhM/F0yrlMmfBUinxOaJUOAM8bcaoMAuNMqT5PDFxrj1ZjDWKIP8Jpf361tKr1O86
	 JfT9S5f0EZQhTB2Diy0GUeHR7jZr/nrcmTURS8ZB4n9DqNXMQY7ilOSlKriqnkD7hL
	 iytjr/TLxEKDr8jUL1Qb0pR0o86c0b1Br/vRJnZM=
Date: Wed, 21 Aug 2024 13:34:08 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-pg_mappedtodisk-to-pg_owner_2.patch added to mm-unstable branch
Message-Id: <20240821203409.A583EC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rename PG_mappedtodisk to PG_owner_2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rename-pg_mappedtodisk-to-pg_owner_2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-pg_mappedtodisk-to-pg_owner_2.patch

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
Subject: mm: rename PG_mappedtodisk to PG_owner_2
Date: Wed, 21 Aug 2024 20:34:42 +0100

This flag has similar constraints to PG_owner_priv_1 -- it is ignored by
core code, and is entirely for the use of the code which allocated the
folio.  Since the pagecache does not use it, individual filesystems can
use it.  The bufferhead code does use it, so filesystems which use the
buffer cache must not use it for another purpose.

Link: https://lkml.kernel.org/r/20240821193445.2294269-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c                    |    2 +-
 include/linux/kernel-page-flags.h |    2 +-
 include/linux/page-flags.h        |   24 ++++++++++++++++--------
 include/trace/events/mmflags.h    |    2 +-
 tools/mm/page-types.c             |   10 +++++-----
 5 files changed, 24 insertions(+), 16 deletions(-)

--- a/fs/proc/page.c~mm-rename-pg_mappedtodisk-to-pg_owner_2
+++ a/fs/proc/page.c
@@ -211,7 +211,7 @@ u64 stable_page_flags(const struct page
 #endif
 
 	u |= kpf_copy_bit(k, KPF_RESERVED,	PG_reserved);
-	u |= kpf_copy_bit(k, KPF_MAPPEDTODISK,	PG_mappedtodisk);
+	u |= kpf_copy_bit(k, KPF_OWNER_2,	PG_owner_2);
 	u |= kpf_copy_bit(k, KPF_PRIVATE,	PG_private);
 	u |= kpf_copy_bit(k, KPF_PRIVATE_2,	PG_private_2);
 	u |= kpf_copy_bit(k, KPF_OWNER_PRIVATE,	PG_owner_priv_1);
--- a/include/linux/kernel-page-flags.h~mm-rename-pg_mappedtodisk-to-pg_owner_2
+++ a/include/linux/kernel-page-flags.h
@@ -10,7 +10,7 @@
  */
 #define KPF_RESERVED		32
 #define KPF_MLOCKED		33
-#define KPF_MAPPEDTODISK	34
+#define KPF_OWNER_2		34
 #define KPF_PRIVATE		35
 #define KPF_PRIVATE_2		36
 #define KPF_OWNER_PRIVATE	37
--- a/include/linux/page-flags.h~mm-rename-pg_mappedtodisk-to-pg_owner_2
+++ a/include/linux/page-flags.h
@@ -101,12 +101,12 @@ enum pageflags {
 	PG_waiters,		/* Page has waiters, check its waitqueue. Must be bit #7 and in the same byte as "PG_locked" */
 	PG_active,
 	PG_workingset,
-	PG_owner_priv_1,	/* Owner use. If pagecache, fs may use*/
+	PG_owner_priv_1,	/* Owner use. If pagecache, fs may use */
+	PG_owner_2,		/* Owner use. If pagecache, fs may use */
 	PG_arch_1,
 	PG_reserved,
 	PG_private,		/* If pagecache, has fs-private data */
 	PG_private_2,		/* If pagecache, has fs aux data */
-	PG_mappedtodisk,	/* Has blocks allocated on-disk */
 	PG_reclaim,		/* To be reclaimed asap */
 	PG_swapbacked,		/* Page is backed by RAM/swap */
 	PG_unevictable,		/* Page is "unevictable"  */
@@ -131,6 +131,11 @@ enum pageflags {
 
 	PG_readahead = PG_reclaim,
 
+	/* Anonymous memory (and shmem) */
+	PG_swapcache = PG_owner_priv_1, /* Swap page: swp_entry_t in private */
+	/* Some filesystems */
+	PG_checked = PG_owner_priv_1,
+
 	/*
 	 * Depending on the way an anonymous folio can be mapped into a page
 	 * table (e.g., single PMD/PUD/CONT of the head page vs. PTE-mapped
@@ -138,13 +143,13 @@ enum pageflags {
 	 * tail pages of an anonymous folio. For now, we only expect it to be
 	 * set on tail pages for PTE-mapped THP.
 	 */
-	PG_anon_exclusive = PG_mappedtodisk,
-
-	/* Filesystems */
-	PG_checked = PG_owner_priv_1,
+	PG_anon_exclusive = PG_owner_2,
 
-	/* SwapBacked */
-	PG_swapcache = PG_owner_priv_1,	/* Swap page: swp_entry_t in private */
+	/*
+	 * Set if all buffer heads in the folio are mapped.
+	 * Filesystems which do not use BHs can use it for their own purpose.
+	 */
+	PG_mappedtodisk = PG_owner_2,
 
 	/* Two page bits are conscripted by FS-Cache to maintain local caching
 	 * state.  These bits are set on pages belonging to the netfs's inodes
@@ -540,6 +545,9 @@ FOLIO_FLAG(swapbacked, FOLIO_HEAD_PAGE)
 PAGEFLAG(Private, private, PF_ANY)
 PAGEFLAG(Private2, private_2, PF_ANY) TESTSCFLAG(Private2, private_2, PF_ANY)
 
+/* owner_2 can be set on tail pages for anon memory */
+FOLIO_FLAG(owner_2, FOLIO_HEAD_PAGE)
+
 /*
  * Only test-and-set exist for PG_writeback.  The unconditional operators are
  * risky: they bypass page accounting.
--- a/include/trace/events/mmflags.h~mm-rename-pg_mappedtodisk-to-pg_owner_2
+++ a/include/trace/events/mmflags.h
@@ -107,13 +107,13 @@
 	DEF_PAGEFLAG_NAME(active),					\
 	DEF_PAGEFLAG_NAME(workingset),					\
 	DEF_PAGEFLAG_NAME(owner_priv_1),				\
+	DEF_PAGEFLAG_NAME(owner_2),					\
 	DEF_PAGEFLAG_NAME(arch_1),					\
 	DEF_PAGEFLAG_NAME(reserved),					\
 	DEF_PAGEFLAG_NAME(private),					\
 	DEF_PAGEFLAG_NAME(private_2),					\
 	DEF_PAGEFLAG_NAME(writeback),					\
 	DEF_PAGEFLAG_NAME(head),					\
-	DEF_PAGEFLAG_NAME(mappedtodisk),				\
 	DEF_PAGEFLAG_NAME(reclaim),					\
 	DEF_PAGEFLAG_NAME(swapbacked),					\
 	DEF_PAGEFLAG_NAME(unevictable)					\
--- a/tools/mm/page-types.c~mm-rename-pg_mappedtodisk-to-pg_owner_2
+++ a/tools/mm/page-types.c
@@ -71,7 +71,7 @@
 /* [32-] kernel hacking assistances */
 #define KPF_RESERVED		32
 #define KPF_MLOCKED		33
-#define KPF_MAPPEDTODISK	34
+#define KPF_OWNER_2		34
 #define KPF_PRIVATE		35
 #define KPF_PRIVATE_2		36
 #define KPF_OWNER_PRIVATE	37
@@ -129,7 +129,7 @@ static const char * const page_flag_name
 
 	[KPF_RESERVED]		= "r:reserved",
 	[KPF_MLOCKED]		= "m:mlocked",
-	[KPF_MAPPEDTODISK]	= "d:mappedtodisk",
+	[KPF_OWNER_2]		= "d:owner_2",
 	[KPF_PRIVATE]		= "P:private",
 	[KPF_PRIVATE_2]		= "p:private_2",
 	[KPF_OWNER_PRIVATE]	= "O:owner_private",
@@ -472,9 +472,9 @@ static int bit_mask_ok(uint64_t flags)
 
 static uint64_t expand_overloaded_flags(uint64_t flags, uint64_t pme)
 {
-	/* Anonymous pages overload PG_mappedtodisk */
-	if ((flags & BIT(ANON)) && (flags & BIT(MAPPEDTODISK)))
-		flags ^= BIT(MAPPEDTODISK) | BIT(ANON_EXCLUSIVE);
+	/* Anonymous pages use PG_owner_2 for anon_exclusive */
+	if ((flags & BIT(ANON)) && (flags & BIT(OWNER_2)))
+		flags ^= BIT(OWNER_2) | BIT(ANON_EXCLUSIVE);
 
 	/* SLUB overloads several page flags */
 	if (flags & BIT(SLAB)) {
_

Patches currently in -mm which might be from willy@infradead.org are

fs-remove-calls-to-set-and-clear-the-folio-error-flag.patch
mm-remove-pg_error.patch
mm-return-the-folio-from-swapin_readahead.patch
printf-remove-%pgt-support.patch
mm-introduce-page_mapcount_is_type.patch
mm-support-only-one-page_type-per-page.patch
zsmalloc-use-all-available-24-bits-of-page_type.patch
mm-remove-pageactive.patch
mm-remove-pageswapbacked.patch
mm-remove-pagereadahead.patch
mm-remove-pageswapcache.patch
mm-remove-pageunevictable.patch
mm-remove-pagemlocked.patch
mm-remove-pageownerpriv1.patch
mm-remove-page_has_private.patch
mm-rename-pg_mappedtodisk-to-pg_owner_2.patch
x86-remove-pg_uncached.patch

