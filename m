From: akpm@linux-foundation.org
Subject: +
 kasan-update-reported-bug-types-for-kernel-memory-accesses.patch
 tentatively added to -mm tree
Date: Mon, 14 Sep 2015 14:46:20 -0700
Message-ID: <55f7402c.xZa/U4WQqs6bKZpS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbbINVqV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 17:46:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, dvyukov@google.com, glider@google.com, kcc@google.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: update reported bug types for kernel memory accesses
has been added to the -mm tree.  Its filename is
     kasan-update-reported-bug-types-for-kernel-memory-accesses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-update-reported-bug-types-for-kernel-memory-accesses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-update-reported-bug-types-for-kernel-memory-accesses.patch

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

kasan-update-reported-bug-types-for-not-user-nor-kernel-memory-accesses.patch
kasan-update-reported-bug-types-for-kernel-memory-accesses.patch
kasan-accurately-determine-the-type-of-the-bad-access.patch
kasan-update-log-messages.patch
kasan-various-fixes-in-documentation.patch
kasan-move-kasan_sanitize-in-arch-x86-boot-makefile.patch
kasan-update-reference-to-kasan-prototype-repo.patch

