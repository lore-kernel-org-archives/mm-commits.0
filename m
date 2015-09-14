From: akpm@linux-foundation.org
Subject: + kasan-accurately-determine-the-type-of-the-bad-access.patch
 tentatively added to -mm tree
Date: Mon, 14 Sep 2015 14:46:22 -0700
Message-ID: <55f7402e.kHT58v0RlT+b/eB7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbbINVqX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 17:46:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, dvyukov@google.com, glider@google.com, kcc@google.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: accurately determine the type of the bad access
has been added to the -mm tree.  Its filename is
     kasan-accurately-determine-the-type-of-the-bad-access.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-accurately-determine-the-type-of-the-bad-access.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-accurately-determine-the-type-of-the-bad-access.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: accurately determine the type of the bad access

Makes KASAN accurately determine the type of the bad access. If the shadow
byte value is in the [0, KASAN_SHADOW_SCALE_SIZE) range we can look at
the next shadow byte to determine the type of the access.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Konstantin Serebryany <kcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN mm/kasan/report.c~kasan-accurately-determine-the-type-of-the-bad-access mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-accurately-determine-the-type-of-the-bad-access
+++ a/mm/kasan/report.c
@@ -50,15 +50,26 @@ static const void *find_first_bad_addr(c
 static void print_error_description(struct kasan_access_info *info)
 {
 	const char *bug_type = "unknown-crash";
-	u8 shadow_val;
+	u8 *shadow_addr;
 
 	info->first_bad_addr = find_first_bad_addr(info->access_addr,
 						info->access_size);
 
-	shadow_val = *(u8 *)kasan_mem_to_shadow(info->first_bad_addr);
+	shadow_addr = (u8 *)kasan_mem_to_shadow(info->first_bad_addr);
 
-	switch (shadow_val) {
+	/*
+	 * If shadow byte value is in [0, KASAN_SHADOW_SCALE_SIZE) we can look
+	 * at the next shadow byte to determine the type of the bad access.
+	 */
+	if (*shadow_addr > 0 && *shadow_addr <= KASAN_SHADOW_SCALE_SIZE - 1)
+		shadow_addr++;
+
+	switch (*shadow_addr) {
 	case 0 ... KASAN_SHADOW_SCALE_SIZE - 1:
+		/*
+		 * In theory it's still possible to see these shadow values
+		 * due to a data race in the kernel code.
+		 */
 		bug_type = "out-of-bounds";
 		break;
 	case KASAN_PAGE_REDZONE:
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-update-reported-bug-types-for-not-user-nor-kernel-memory-accesses.patch
kasan-update-reported-bug-types-for-kernel-memory-accesses.patch
kasan-accurately-determine-the-type-of-the-bad-access.patch
kasan-update-log-messages.patch
kasan-various-fixes-in-documentation.patch
kasan-move-kasan_sanitize-in-arch-x86-boot-makefile.patch
kasan-update-reference-to-kasan-prototype-repo.patch

