Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB581E86E
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 00:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253221; cv=none; b=Wr0HKeYsr9Uzjv9iCOhranTqSn0a4mYypV3l5GpaOxAbG0eHHtol6IxS3Xtw2rN2081bkvwAccFsh0vvwNKTKQS1srLNGndLpRY1Qr5zgmDTncLGOjZrDBLSx2iz6UdMT94FRX87P1EpHReBEAGRZ7cmAiyYTarqWl7zdtVU3ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253221; c=relaxed/simple;
	bh=L9gUdYH0AG3Xb7qtwnwoAze553YQfNAurFdqGeGb/8E=;
	h=Date:To:From:Subject:Message-Id; b=PivgY6T3IIKo7ibR9QxDMauJ1CKAlAvc6U7FWKd4n9+JWxjKLfgAFhzQMIyEol/817ZIcPjoKUaezI40oN0jqa2+0mjwmV6OPBVVq/YyPO7mJgWOGJINCIwJf9P+F+2D+aX4gIemGlQyd7KBlTZfM53VY/D8VgxhSOzRiZw/liM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KU9WUiPk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KU9WUiPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4FFC4CEF1;
	Wed, 27 Aug 2025 00:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756253220;
	bh=L9gUdYH0AG3Xb7qtwnwoAze553YQfNAurFdqGeGb/8E=;
	h=Date:To:From:Subject:From;
	b=KU9WUiPk+IJt3sIrVK8gxMsVwffQxmKw8cWhqYGq+8VxQnKVVLpf5Nsl9UQWMWzDd
	 3qXM2yZ1V37eCQ1Q/GUEePwwaQ3urxjPgr3iRoLvUpAL8kk17Efz7yx253rEFosP4F
	 wkZPgw0r1SyaX/029XTRhARFQCTTOq2cD5gwA1UQ=
Date: Tue, 26 Aug 2025 17:07:00 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-correct-sign-extension-issue-in-mmf_-flag-masks-fix.patch added to mm-unstable branch
Message-Id: <20250827000700.DE4FFC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: prefer BIT() to _BITUL()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-correct-sign-extension-issue-in-mmf_-flag-masks-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-correct-sign-extension-issue-in-mmf_-flag-masks-fix.patch

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
Subject: mm: prefer BIT() to _BITUL()
Date: Tue, 26 Aug 2025 15:01:18 +0100

BIT() does the same thing, and is defined in actual linux headers rather
than a uapi header.  per David.

Link: https://lkml.kernel.org/r/a0290c77-cd88-46d6-8d9a-073be7600d88@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/include/linux/mm_types.h~mm-correct-sign-extension-issue-in-mmf_-flag-masks-fix
+++ a/include/linux/mm_types.h
@@ -1767,7 +1767,7 @@ enum {
  * the modes are SUID_DUMP_* defined in linux/sched/coredump.h
  */
 #define MMF_DUMPABLE_BITS 2
-#define MMF_DUMPABLE_MASK (_BITUL(MMF_DUMPABLE_BITS) - 1)
+#define MMF_DUMPABLE_MASK (BIT(MMF_DUMPABLE_BITS) - 1)
 /* coredump filter bits */
 #define MMF_DUMP_ANON_PRIVATE	2
 #define MMF_DUMP_ANON_SHARED	3
@@ -1782,13 +1782,13 @@ enum {
 #define MMF_DUMP_FILTER_SHIFT	MMF_DUMPABLE_BITS
 #define MMF_DUMP_FILTER_BITS	9
 #define MMF_DUMP_FILTER_MASK \
-	((_BITUL(MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
+	((BIT(MMF_DUMP_FILTER_BITS) - 1) << MMF_DUMP_FILTER_SHIFT)
 #define MMF_DUMP_FILTER_DEFAULT \
-	(_BITUL(MMF_DUMP_ANON_PRIVATE) | _BITUL(MMF_DUMP_ANON_SHARED) | \
-	 _BITUL(MMF_DUMP_HUGETLB_PRIVATE) | MMF_DUMP_MASK_DEFAULT_ELF)
+	(BIT(MMF_DUMP_ANON_PRIVATE) | BIT(MMF_DUMP_ANON_SHARED) | \
+	 BIT(MMF_DUMP_HUGETLB_PRIVATE) | MMF_DUMP_MASK_DEFAULT_ELF)
 
 #ifdef CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS
-# define MMF_DUMP_MASK_DEFAULT_ELF	_BITUL(MMF_DUMP_ELF_HEADERS)
+# define MMF_DUMP_MASK_DEFAULT_ELF	BIT(MMF_DUMP_ELF_HEADERS)
 #else
 # define MMF_DUMP_MASK_DEFAULT_ELF	0
 #endif
@@ -1808,7 +1808,7 @@ enum {
 #define MMF_UNSTABLE		22	/* mm is unstable for copy_from_user */
 #define MMF_HUGE_ZERO_FOLIO	23      /* mm has ever used the global huge zero folio */
 #define MMF_DISABLE_THP		24	/* disable THP for all VMAs */
-#define MMF_DISABLE_THP_MASK	_BITUL(MMF_DISABLE_THP)
+#define MMF_DISABLE_THP_MASK	BIT(MMF_DISABLE_THP)
 #define MMF_OOM_REAP_QUEUED	25	/* mm was queued for oom_reaper */
 #define MMF_MULTIPROCESS	26	/* mm is shared between processes */
 /*
@@ -1821,15 +1821,15 @@ enum {
 #define MMF_HAS_PINNED		27	/* FOLL_PIN has run, never cleared */
 
 #define MMF_HAS_MDWE		28
-#define MMF_HAS_MDWE_MASK	_BITUL(MMF_HAS_MDWE)
+#define MMF_HAS_MDWE_MASK	BIT(MMF_HAS_MDWE)
 
 #define MMF_HAS_MDWE_NO_INHERIT	29
 
 #define MMF_VM_MERGE_ANY	30
-#define MMF_VM_MERGE_ANY_MASK	_BITUL(MMF_VM_MERGE_ANY)
+#define MMF_VM_MERGE_ANY_MASK	BIT(MMF_VM_MERGE_ANY)
 
 #define MMF_TOPDOWN		31	/* mm searches top down by default */
-#define MMF_TOPDOWN_MASK	_BITUL(MMF_TOPDOWN)
+#define MMF_TOPDOWN_MASK	BIT(MMF_TOPDOWN)
 
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
 				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
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
mm-correct-sign-extension-issue-in-mmf_-flag-masks-fix.patch
mm-update-fork-mm-flags-initialisation-to-use-bitmap.patch
mm-convert-remaining-users-to-mm_flags_-accessors.patch
mm-replace-mm-flags-with-bitmap-entirely-and-set-to-64-bits.patch

