From: akpm@linux-foundation.org
Subject: [merged]
 kasan-update-reported-bug-types-for-kernel-memory-accesses.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:17:37 -0800
Message-ID: <563d0ae1.W5bWpBCKtxKrMpcu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162871AbbKFURi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, dvyukov@google.com, glider@google.com, kcc@google.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: update reported bug types for kernel memory accesses
has been removed from the -mm tree.  Its filename was
     kasan-update-reported-bug-types-for-kernel-memory-accesses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: update reported bug types for kernel memory accesses

Update the names of the bad access types to better reflect the type of
the access that happended and make these error types "literals" that can
be used for classification and deduplication in scripts.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Konstantin Serebryany <kcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN mm/kasan/report.c~kasan-update-reported-bug-types-for-kernel-memory-accesses mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-update-reported-bug-types-for-kernel-memory-accesses
+++ a/mm/kasan/report.c
@@ -49,7 +49,7 @@ static const void *find_first_bad_addr(c
 
 static void print_error_description(struct kasan_access_info *info)
 {
-	const char *bug_type = "unknown crash";
+	const char *bug_type = "unknown-crash";
 	u8 shadow_val;
 
 	info->first_bad_addr = find_first_bad_addr(info->access_addr,
@@ -58,21 +58,25 @@ static void print_error_description(stru
 	shadow_val = *(u8 *)kasan_mem_to_shadow(info->first_bad_addr);
 
 	switch (shadow_val) {
-	case KASAN_FREE_PAGE:
-	case KASAN_KMALLOC_FREE:
-		bug_type = "use after free";
+	case 0 ... KASAN_SHADOW_SCALE_SIZE - 1:
+		bug_type = "out-of-bounds";
 		break;
 	case KASAN_PAGE_REDZONE:
 	case KASAN_KMALLOC_REDZONE:
+		bug_type = "slab-out-of-bounds";
+		break;
 	case KASAN_GLOBAL_REDZONE:
-	case 0 ... KASAN_SHADOW_SCALE_SIZE - 1:
-		bug_type = "out of bounds access";
+		bug_type = "global-out-of-bounds";
 		break;
 	case KASAN_STACK_LEFT:
 	case KASAN_STACK_MID:
 	case KASAN_STACK_RIGHT:
 	case KASAN_STACK_PARTIAL:
-		bug_type = "out of bounds on stack";
+		bug_type = "stack-out-of-bounds";
+		break;
+	case KASAN_FREE_PAGE:
+	case KASAN_KMALLOC_FREE:
+		bug_type = "use-after-free";
 		break;
 	}
 
_

Patches currently in -mm which might be from andreyknvl@google.com are


