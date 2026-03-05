Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F4E369238
	for <mm-commits@vger.kernel.org>; Thu,  5 Mar 2026 23:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772755175; cv=none; b=SQjcbrp9dLbxkNpp4M02Z73vtXAxBxo6Zx2hX7RBJ2GpZib+iCsVR7+c+YhF0KOZwKyiqIHXLzNe/o8ZOrbNUAXAcIZTSZyrZspRA8ttk4cUvm1hHiWDT205y2ZQ5u20sFPbiDazyOhvJlg2baZCNn6hQ0PUorF6i5uvJVLkkNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772755175; c=relaxed/simple;
	bh=28TiFHys2S7p5WqLjes37McLqiIXbAiCI8T1+fGp/KM=;
	h=Date:To:From:Subject:Message-Id; b=d362MsUWAecj6DrJVfWZmTIeSWmdIlyWx3TbbEjRcl8KI3DkiqIcaAWkbxy94AZ6RcBKDi6CIAyTrziVjV04pX1za2za38wWI/jBrcVLUu8eJVFzRydjUIYUHVLqBhkh5+r6o72RPoKF0dapXdmlNKp8OxbkaOhfNdhrVLq9cRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uu9IUy6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uu9IUy6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88FCC2BC87;
	Thu,  5 Mar 2026 23:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772755174;
	bh=28TiFHys2S7p5WqLjes37McLqiIXbAiCI8T1+fGp/KM=;
	h=Date:To:From:Subject:From;
	b=Uu9IUy6jyEOuPDKaz5KPmOq3K793FAbu5Ml4EHbxMcaPKXewfldfghLqPEL+53f3I
	 9WnkSNLReRbUJt7k5z59ChwkTUVPFbcB4wrL7NdqSZvOkwQBJyx7ugNHVU70OX8RD4
	 MAWoAJvJDpkhEcHv0eJugyV0DglUccjmdL0b7Vzk=
Date: Thu, 05 Mar 2026 15:59:34 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,maciej.wieczor-retman@intel.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,ryabinin.a.a@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fix-bug-type-classification-for-sw_tags-mode.patch added to mm-new branch
Message-Id: <20260305235934.C88FCC2BC87@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan: fix bug type classification for SW_TAGS mode
has been added to the -mm mm-new branch.  Its filename is
     kasan-fix-bug-type-classification-for-sw_tags-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-fix-bug-type-classification-for-sw_tags-mode.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: kasan: fix bug type classification for SW_TAGS mode
Date: Thu, 5 Mar 2026 19:56:59 +0100

kasan_non_canonical_hook() derives orig_addr from kasan_shadow_to_mem(),
but the pointer tag may remain in the top byte.  In SW_TAGS mode this
tagged address is compared against PAGE_SIZE and TASK_SIZE, which leads to
incorrect bug classification.

As a result, NULL pointer dereferences may be reported as
"wild-memory-access".

Strip the tag before performing these range checks and use the untagged
value when reporting addresses in these ranges.

Before:
  [ ] Unable to handle kernel paging request at virtual address ffef800000000000
  [ ] KASAN: maybe wild-memory-access in range [0xff00000000000000-0xff0000000000000f]

After:
  [ ] Unable to handle kernel paging request at virtual address ffef800000000000
  [ ] KASAN: null-ptr-deref in range [0x0000000000000000-0x000000000000000f]

Link: https://lkml.kernel.org/r/20260305185659.20807-1-ryabinin.a.a@gmail.com
Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/kasan/report.c~kasan-fix-bug-type-classification-for-sw_tags-mode
+++ a/mm/kasan/report.c
@@ -638,7 +638,7 @@ void kasan_report_async(void)
  */
 void kasan_non_canonical_hook(unsigned long addr)
 {
-	unsigned long orig_addr;
+	unsigned long orig_addr, user_orig_addr;
 	const char *bug_type;
 
 	/*
@@ -650,6 +650,9 @@ void kasan_non_canonical_hook(unsigned l
 
 	orig_addr = (unsigned long)kasan_shadow_to_mem((void *)addr);
 
+	/* Strip pointer tag before comparing against userspace ranges */
+	user_orig_addr = (unsigned long)set_tag((void *)orig_addr, 0);
+
 	/*
 	 * For faults near the shadow address for NULL, we can be fairly certain
 	 * that this is a KASAN shadow memory access.
@@ -661,11 +664,13 @@ void kasan_non_canonical_hook(unsigned l
 	 * address, but make it clear that this is not necessarily what's
 	 * actually going on.
 	 */
-	if (orig_addr < PAGE_SIZE)
+	if (user_orig_addr < PAGE_SIZE) {
 		bug_type = "null-ptr-deref";
-	else if (orig_addr < TASK_SIZE)
+		orig_addr = user_orig_addr;
+	} else if (user_orig_addr < TASK_SIZE) {
 		bug_type = "probably user-memory-access";
-	else if (addr_in_shadow((void *)addr))
+		orig_addr = user_orig_addr;
+	} else if (addr_in_shadow((void *)addr))
 		bug_type = "probably wild-memory-access";
 	else
 		bug_type = "maybe wild-memory-access";
_

Patches currently in -mm which might be from ryabinin.a.a@gmail.com are

kasan-fix-bug-type-classification-for-sw_tags-mode.patch

