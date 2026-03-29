Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EE8433AD
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744795; cv=none; b=lENaLjVRYOY/EhO2Fl053uD7aHyEghUsqiAkVdMtc5BtJg5oOUB0M8GxJceVmslbehZuhcz5Kd4fKf/Aq3a8GAtbT6UFb9Zr4I6iyaacBDjVny9p9RMdKpZcv98YWSZXSpkw19erpGywTxS5T4GaEo3gHvtAsJHuW6kDPJjHzn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744795; c=relaxed/simple;
	bh=HR99q8eWx2DJBaYDxfvthcGHbduklXa0cKczWrqDDOE=;
	h=Date:To:From:Subject:Message-Id; b=iTq8n5GwSoAcTdYDsK+6AJvsBw8Wmp/XNOfsxIojYBeFRr7grGzMxMEsqDoUEC1/htX2u4OA3R1g4jog+ab/W/w2F35mFdr/+SGh0DS2/+1dzMq93PfywfEveMZFZ5BrELtRn4j1O4+LZw+CxTRa3jsKKFVJUphUj7BdI84X1mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ltOSwBYl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ltOSwBYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69473C4CEF7;
	Sun, 29 Mar 2026 00:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744795;
	bh=HR99q8eWx2DJBaYDxfvthcGHbduklXa0cKczWrqDDOE=;
	h=Date:To:From:Subject:From;
	b=ltOSwBYl215bV+B+Mg3aK7VLxbZxjocfJPSCmfLOPRhzEEnRntiBTzZmMdeAT8xn8
	 0dGaIrheQ2WmEwSchNGgq2t3TH4osSVNrcAQ8LR9H4eNejqkx+LK6miLL5pjslOMeK
	 PaJSrBsv+6a76yr4vpF8Ig+D/OL3iilBKR+3/K/A=
Date: Sat, 28 Mar 2026 17:39:54 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,maciej.wieczor-retman@intel.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,ryabinin.a.a@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-fix-bug-type-classification-for-sw_tags-mode.patch removed from -mm tree
Message-Id: <20260329003955.69473C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: fix bug type classification for SW_TAGS mode
has been removed from the -mm tree.  Its filename was
     kasan-fix-bug-type-classification-for-sw_tags-mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


