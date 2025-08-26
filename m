Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18764944F
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 22:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756248354; cv=none; b=H26ydckaFOuRDNYfdcS47PDWg3vgTujmvqwVS5gccM96bY79he/oMRQo6c/Ns9+rZq71c61vRGXLrkKU8xCc9aVaXpx+uIRgIjP5aOjD2qpvMplBcdvwtXFR84V31vlHCQGk6P4hQkVE7OShn9S+3WIFBBzyPtjyETbUYJ6EW/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756248354; c=relaxed/simple;
	bh=6eftXxCF07qXJwbFG/79hMP57lBqTCu8bCtcw26KFT8=;
	h=Date:To:From:Subject:Message-Id; b=YoK/XeIjKYGldG49WP4/bRfLQCXg3zRFErQyrObferLyXfCyd3AowI9M4HbTJ+dKnHCkLzJYTkpY0p5Sasv1pzFnzuXAjoo+t94nOOPmr8giqpJdGyo0XjbKBw871IoAGzWjYUQMVCaO/upOVOrfA4YhkMndf9Ua/A4/5WlESrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OnH8hSAA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OnH8hSAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C587C4CEF1;
	Tue, 26 Aug 2025 22:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756248353;
	bh=6eftXxCF07qXJwbFG/79hMP57lBqTCu8bCtcw26KFT8=;
	h=Date:To:From:Subject:From;
	b=OnH8hSAAacyV/S8jm5ibft6j4X8inBtJm9SCiCBv7zRuTnvepZIXbykH7VnFqz/Xw
	 ybp5eKU2uKDBcgBX4sbf4XwNlEdCWS+y9yHLD1F7LnQjaChqTWBgKWCrKX0L5z0AJL
	 V46RiZ6/cXsFGH1RKzq14MnHegAzOkNaycCLf+28=
Date: Tue, 26 Aug 2025 15:45:52 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags-fix.patch added to mm-unstable branch
Message-Id: <20250826224553.7C587C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: abstract set_mask_bits() invocation to mm_types.h to satisfy ARC
has been added to the -mm mm-unstable branch.  Its filename is
     mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags-fix.patch

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
Subject: mm: abstract set_mask_bits() invocation to mm_types.h to satisfy ARC
Date: Tue, 26 Aug 2025 12:25:16 +0100

There's some horrible recursive header issue for ARCH whereby you can't
even apparently include very fundamental headers like compiler_types.h in
linux/sched/coredump.h.

So work around this by putting the thing that needs this (use of
ACCESS_PRIVATE()) into mm_types.h which presumably in some fashion avoids
this issue.

This also makes it consistent with __mm_flags_get_dumpable() so is a good
change to make things more consistent and neat anyway.

Link: https://lkml.kernel.org/r/0e7ad263-1ff7-446d-81fe-97cff9c0e7ed@lucifer.local
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508240502.frw1Krzo-lkp@intel.com/
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h       |   12 ++++++++++++
 include/linux/sched/coredump.h |    5 +----
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/include/linux/mm_types.h~mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags-fix
+++ a/include/linux/mm_types.h
@@ -1255,6 +1255,18 @@ static inline unsigned long __mm_flags_g
 	return bitmap_read(bitmap, 0, BITS_PER_LONG);
 }
 
+/*
+ * Update the first system word of mm flags ONLY, applying the specified mask to
+ * it, then setting all flags specified by bits.
+ */
+static inline void __mm_flags_set_mask_bits_word(struct mm_struct *mm,
+		unsigned long mask, unsigned long bits)
+{
+	unsigned long *bitmap = ACCESS_PRIVATE(&mm->_flags, __mm_flags);
+
+	set_mask_bits(bitmap, mask, bits);
+}
+
 #define MM_MT_FLAGS	(MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN | \
 			 MT_FLAGS_USE_RCU)
 extern struct mm_struct init_mm;
--- a/include/linux/sched/coredump.h~mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags-fix
+++ a/include/linux/sched/coredump.h
@@ -2,7 +2,6 @@
 #ifndef _LINUX_SCHED_COREDUMP_H
 #define _LINUX_SCHED_COREDUMP_H
 
-#include <linux/compiler_types.h>
 #include <linux/mm_types.h>
 
 #define SUID_DUMP_DISABLE	0	/* No setuid dumping */
@@ -20,9 +19,7 @@ static inline unsigned long __mm_flags_g
 
 static inline void __mm_flags_set_mask_dumpable(struct mm_struct *mm, int value)
 {
-	unsigned long *bitmap = ACCESS_PRIVATE(&mm->_flags, __mm_flags);
-
-	set_mask_bits(bitmap, MMF_DUMPABLE_MASK, value);
+	__mm_flags_set_mask_bits_word(mm, MMF_DUMPABLE_MASK, value);
 }
 
 extern void set_dumpable(struct mm_struct *mm, int value);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-add-bitmap-mm-flags-field.patch
mm-add-bitmap-mm-flags-field-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors.patch
mm-convert-prctl-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors.patch
mm-convert-arch-specific-code-to-mm_flags_-accessors-fix.patch
mm-convert-uprobes-to-mm_flags_-accessors.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags.patch
mm-update-coredump-logic-to-correctly-use-bitmap-mm-flags-fix.patch
mm-correct-sign-extension-issue-in-mmf_-flag-masks.patch
mm-update-fork-mm-flags-initialisation-to-use-bitmap.patch
mm-convert-remaining-users-to-mm_flags_-accessors.patch
mm-replace-mm-flags-with-bitmap-entirely-and-set-to-64-bits.patch

