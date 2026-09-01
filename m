Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4CC3AA50B
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 01:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788227755; cv=none; b=FTlH2ghrUiWGZ9ScK6Qw1IXtuyOHuq8lhmw/E0DOBl8k9hCIjg88Fv08vw9pLHGBIL7yJRXA23vOouGy5KFK1w3RvIogcCUeuHJd6vnVQ2KGwpn5lQbkh1xqUqFQW1OLWJP7GDpGAU0P5+pztSJ/hdj5RfhPVvfReXnTY20xLp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788227755; c=relaxed/simple;
	bh=8uSLBfFf0Pzc8Lot0eS6UV7/BO84jDTVrFC2sm8lkIQ=;
	h=Date:To:From:Subject:Message-Id; b=VZ7hKeTxyOJXoewtup/CBGXJl9D8Pl8qbEMjrMYEXWaO6fkAurkAqRBjhA0Y3g5UYzTTV/SJz/2ngez2aPVMf1j07FcfDC3HItYCAhEMHwwW9mZyDe66cqGoKyYwiqn918VadP54aVRAWQOCGl1JxeMRPjtfFdDRw0TQSk73Sj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n2/r63dQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n2/r63dQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F6D1F00A3E;
	Tue,  1 Sep 2026 01:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788227738;
	bh=plppUip1FzKi43PafBIRLgdRqjlJb5BbTRt+M+XiWE8=;
	h=Date:To:From:Subject;
	b=n2/r63dQyQA1JMv3TGpFOM4egeE6gplccD0adHLSV4zM2Xu50f+TIbhhgtKwDzrQX
	 SgPuNleelRYwarMDqsrAHH3WzWUS8X9A0WFl5TA4rDWAqKtOVFO44Oq5exUiqDCAvD
	 KBpuDzOSNXgsE+eNhePUmEThGNMrA2YMzqEZcgEU=
Date: Mon, 31 Aug 2026 18:55:37 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,samuel.holland@sifive.com,rppt@kernel.org,ljs@kernel.org,kernel@xen0n.name,james.bottomley@HansenPartnership.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,deller@gmx.de,david@kernel.org,dalias@libc.org,chenhuacai@kernel.org,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-ptval_to_str-generally-available.patch added to mm-new branch
Message-Id: <20260901015538.63F6D1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make ptval_to_str() generally available
has been added to the -mm mm-new branch.  Its filename is
     mm-make-ptval_to_str-generally-available.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-ptval_to_str-generally-available.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-make-ptval_to_str-generally-available.patch
mm-stop-using-pxd_error.patch
loongarch-mm-stop-using-pte_error.patch
parisc-mm-directly-use-generic-_clear_bad.patch
sh-mm-stop-using-pte_error.patch
sh-mm-stop-using-_error.patch
sh-mm-stop-using-pgd_error.patch
mm-drop-pxd_error.patch

