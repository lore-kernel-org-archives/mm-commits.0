Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E95B311C1D
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334311; cv=none; b=sCjXcCn2D+gkWJTxa4bZngrccEVVZaCWDgGMqsi79EaVSE3h9WNdwMF+HNygmpK5uLKwCUX2dpu454c3jQbGLUSuwo/LAFEFshxB3S8xu1VdIRHK6jvhgzKr+tDtSx/dShEmIYbRFbEujJDDMNBVwRlVWZSfenVyi3I3SMrAYqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334311; c=relaxed/simple;
	bh=+NUXgARNSNGsjEnY9Mnl7UP41bcVKLPdLeyAwyYlLMM=;
	h=Date:To:From:Subject:Message-Id; b=FE/gvJOWh5IhA4wf74Qzul5l/jWvBezNRYWF/aI1tC3cXN3cNyX98Ut1+NfQx1yKdqX0sbvQWZz+HmDoAgBuKGDddbaKwokQ14RLjgnzDjq7w9GxuPsrnJgqcZqjunL+Z488OWAxIdm/QA5q8smb7q2708VA9a829y64UuTURig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KOkNjL+N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KOkNjL+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B6B1F0089B;
	Wed,  7 Oct 2026 00:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334310;
	bh=rbgyQ6AyZiX13MUvr5qyl0OfVwg0YV589pTOHVbQt4A=;
	h=Date:To:From:Subject;
	b=KOkNjL+NSc9HZGTe16Ap4PwIwg0+t2Z3JPq0K6TMUInhsfw/M8nAAsMRF/W8+5Voa
	 LR7/4cYlJH3FOpFZQONp3+wBro0eHe/2obXtFGZk8BareZBk/SEaTMAhzp8IN7xi5h
	 wRVS0jfMnB71B/JzluPBBHL8Ivisyu7d0byEIPLc=
Date: Tue, 06 Oct 2026 17:51:49 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,samuel.holland@sifive.com,rppt@kernel.org,ljs@kernel.org,kernel@xen0n.name,james.bottomley@HansenPartnership.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,deller@gmx.de,david@kernel.org,dalias@libc.org,chenhuacai@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-ptval_to_str-generally-available.patch removed from -mm tree
Message-Id: <20261007005150.22B6B1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make ptval_to_str() generally available
has been removed from the -mm tree.  Its filename was
     mm-make-ptval_to_str-generally-available.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: make ptval_to_str() generally available
Date: Mon, 31 Aug 2026 11:13:23 +0530

Patch series "mm: Drop pxd_ERROR()".

pxd_ERROR() macros have been provided by all platforms, which are very
much identical and can be dropped off completely if these pgtable printing
could be moved to callers in generic MM aka all pxd_clear_bad().

But first cleanups and re-organizations are required in some platforms
that are using these macros internally.  Afterwards
[pte|pmd|pud|p4d|pgd]_ERROR() macros have been completely dropped from the
entire tree.


This patch (of 8):

Move ptval_to_str() inside a header thus making the helper more generally
available for new users which are being added later.  While here, also
move another related string size macro PTVAL_STR_MAX inside the header as
well.

Link: https://lore.kernel.org/20260831054331.625505-1-anshuman.khandual@arm.com
Link: https://lore.kernel.org/20260831054331.625505-2-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---

 include/linux/pgtable.h |   14 ++++++++++++++
 mm/memory.c             |   15 +--------------
 2 files changed, 15 insertions(+), 14 deletions(-)

--- a/include/linux/pgtable.h~mm-make-ptval_to_str-generally-available
+++ a/include/linux/pgtable.h
@@ -2313,6 +2313,20 @@ static inline const char *pgtable_level_
 	}
 }
 
+void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size);
+
+#define ptval_to_str(buf, val)								\
+	do {										\
+		auto __val = (val);							\
+											\
+		ptval_bytes_to_hex_str((buf), sizeof(buf), &__val, sizeof(__val));	\
+	} while (0)
+
+#if defined(__SIZEOF_INT128__)
+#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */
+#else
+#define PTVAL_STR_MAX	(16 + 1) /* Max 64-bit value in hex + NUL */
+#endif
 #endif /* !__ASSEMBLER__ */
 
 #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
--- a/mm/memory.c~mm-make-ptval_to_str-generally-available
+++ a/mm/memory.c
@@ -495,7 +495,7 @@ static inline void add_mm_rss_vec(struct
 /* Allow a burst of 60 bad page map reports per minute. */
 static DEFINE_RATELIMIT_STATE(bad_page_map_ratelimit, 60 * HZ, 60);
 
-static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
+void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
 {
 	if (WARN_ON_ONCE(buf_size < entry_size * 2 + 1)) {
 		snprintf(buf, buf_size, "overflow");
@@ -522,19 +522,6 @@ static void ptval_bytes_to_hex_str(char
 	}
 }
 
-#define ptval_to_str(buf, val)								\
-	do {										\
-		auto __val = (val);							\
-											\
-		ptval_bytes_to_hex_str((buf), sizeof(buf), &__val, sizeof(__val));	\
-	} while (0)
-
-#if defined(__SIZEOF_INT128__)
-#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */
-#else
-#define PTVAL_STR_MAX	(16 + 1) /* Max 64-bit value in hex + NUL */
-#endif
-
 static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long addr)
 {
 	char pgd_str[PTVAL_STR_MAX];
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-constify-arguments-in-default-pxdp_get.patch
arm64-mm-move-__check_safe_pte_update.patch
arm64-mm-standardize-printing-for-pgtable-entries.patch

