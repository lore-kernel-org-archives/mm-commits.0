Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D592F39A4
	for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2025 21:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755121375; cv=none; b=aDXRcfEqdtWYY+EQcSLhz5qGTB9IPrxMUYDD7AKCzIqDGflH8HpksDQXqjMTxSvAtVNDlgdHBuCtQ63iuPg3LxMhx6l4+wZAGmDDvk3++LxQ+EOqCYlT/5sssLCmS1eSpFBUxeJ3aCDSoOYrh7uVqER8Z4j5n6tbJ9K/9+mORUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755121375; c=relaxed/simple;
	bh=Rz9uhK+pD18KWJVoMgoAGX79W+ak0Mk8nU1fmy1/Yv0=;
	h=Date:To:From:Subject:Message-Id; b=FipANmyOgPkNVJIq2+1CY5bYiXx+KGLIIMZ6Vnb8a+YumrTJ6w1YER79SEgg8x+90wTk4Tj8kaY5K+djjgD9P0OhxWwqMftqQ0V05yojX+cutzBuQUZL5D6FNf+7IGoYCGiSLKS5FdhVtx+3ckjY10SqVWptkDtbhlWqZkeQ4WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A03buT3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A03buT3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F389FC4CEEB;
	Wed, 13 Aug 2025 21:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755121373;
	bh=Rz9uhK+pD18KWJVoMgoAGX79W+ak0Mk8nU1fmy1/Yv0=;
	h=Date:To:From:Subject:From;
	b=A03buT3MGUlCJkH4vYHs0D9suqckPzSDYhe4n7/Ff/uj5KFDoIzh9rtAtAUP9FBEw
	 G+grl9og+ZsjG3Xj1Od0MuLrhkpEyIjkMK8L2TmkXjarEahMs1nsTlViz+Czw9fRhw
	 /xCUz4i+gLQLkHNlN8FCa7f09R5PHyzT7bCf7JDo=
Date: Wed, 13 Aug 2025 14:42:52 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-bitmap-mm-flags-field-fix.patch added to mm-unstable branch
Message-Id: <20250813214252.F389FC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: place __private in correct place, const-ify __mm_flags_get_word
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-bitmap-mm-flags-field-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-bitmap-mm-flags-field-fix.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: place __private in correct place, const-ify __mm_flags_get_word
Date: Wed, 13 Aug 2025 20:40:10 +0100

The __private sparse indicator was placed in the wrong location, resulting
in sparse errors, correct this by placing it where it ought to be.

Also, share some code for __mm_flags_get_word() and const-ify it to be
consistent.

Finally, fixup inconsistency in __mm_flags_set_word() param alignment.

Link: https://lkml.kernel.org/r/d4ba117d-6234-4069-b871-254d152d7d21@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/include/linux/mm_types.h~mm-add-bitmap-mm-flags-field-fix
+++ a/include/linux/mm_types.h
@@ -934,8 +934,8 @@ struct mm_cid {
  */
 #define NUM_MM_FLAG_BITS BITS_PER_LONG
 typedef struct {
-	__private DECLARE_BITMAP(__mm_flags, NUM_MM_FLAG_BITS);
-} mm_flags_t;
+	DECLARE_BITMAP(__mm_flags, NUM_MM_FLAG_BITS);
+} __private mm_flags_t;
 
 struct kioctx_table;
 struct iommu_mm_data;
@@ -1233,17 +1233,8 @@ struct mm_struct {
 	unsigned long cpu_bitmap[];
 };
 
-/* Read the first system word of mm flags, non-atomically. */
-static inline unsigned long __mm_flags_get_word(struct mm_struct *mm)
-{
-	unsigned long *bitmap = ACCESS_PRIVATE(&mm->_flags, __mm_flags);
-
-	return bitmap_read(bitmap, 0, BITS_PER_LONG);
-}
-
 /* Set the first system word of mm flags, non-atomically. */
-static inline void __mm_flags_set_word(struct mm_struct *mm,
-				       unsigned long value)
+static inline void __mm_flags_set_word(struct mm_struct *mm, unsigned long value)
 {
 	unsigned long *bitmap = ACCESS_PRIVATE(&mm->_flags, __mm_flags);
 
@@ -1256,6 +1247,14 @@ static inline const unsigned long *__mm_
 	return (const unsigned long *)ACCESS_PRIVATE(&mm->_flags, __mm_flags);
 }
 
+/* Read the first system word of mm flags, non-atomically. */
+static inline unsigned long __mm_flags_get_word(const struct mm_struct *mm)
+{
+	const unsigned long *bitmap = __mm_flags_get_bitmap(mm);
+
+	return bitmap_read(bitmap, 0, BITS_PER_LONG);
+}
+
 #define MM_MT_FLAGS	(MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN | \
 			 MT_FLAGS_USE_RCU)
 extern struct mm_struct init_mm;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

tools-testing-add-linux-argsh-header-and-fix-radix-vma-tests.patch
mm-mremap-allow-multi-vma-move-when-filesystem-uses-thp_get_unmapped_area.patch
mm-mremap-catch-invalid-multi-vma-moves-earlier.patch
selftests-mm-add-test-for-invalid-multi-vma-operations.patch
mm-add-bitmap-mm-flags-field.patch
mm-add-bitmap-mm-flags-field-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors.patch
mm-convert-prctl-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors.patch
mm-convert-uprobes-to-mm_flags_-accessors.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks.patch
mm-update-fork-mm-flags-initialisation-to-use-bitmap.patch
mm-convert-remaining-users-to-mm_flags_-accessors.patch
mm-replace-mm-flags-with-bitmap-entirely-and-set-to-64-bits.patch

