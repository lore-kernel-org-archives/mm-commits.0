From: akpm@linux-foundation.org
Subject: [merged]
 kasan-accurately-determine-the-type-of-the-bad-access.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:17:39 -0800
Message-ID: <563d0ae3.Vwp2nbWL8jmULHgi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162900AbbKFURk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, dvyukov@google.com, glider@google.com, kcc@google.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: accurately determine the type of the bad access
has been removed from the -mm tree.  Its filename was
     kasan-accurately-determine-the-type-of-the-bad-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


