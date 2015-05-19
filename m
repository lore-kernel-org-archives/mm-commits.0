From: akpm@linux-foundation.org
Subject: + lib-sort-add-64-bit-swap-function-v2-fix.patch added to -mm
 tree
Date: Tue, 19 May 2015 16:17:32 -0700
Message-ID: <555bc48c.oux4O2dPVZWbNY0F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbbESXRd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 May 2015 19:17:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.wagner@bmw-carit.de, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/sort: Move the alignment check into a function
has been added to the -mm tree.  Its filename is
     lib-sort-add-64-bit-swap-function-v2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-sort-add-64-bit-swap-function-v2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-sort-add-64-bit-swap-function-v2-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: lib/sort: Move the alignment check into a function

Rasmus Villemoes suggestes to move the aliment check into a separate
function in order to improve the readability.

Furthermore, let's avoid the switch statement since gcc might mess it
up. My gcc 4.9.2 produces the same code for the x86_64
configuration. That is

	switch (size) {
		case 4:
			if (alignment_ok(base, 4))
				swap_func = u32_swap;
			       break;
		case 8:
			if (alignment_ok(base, 8))
				swap_func = u64_swap;
			break;
		}
		if (!swap_func)
			swap_func = generic_swap;
	}

resulted into the same object code.

Link: https://lkml.org/lkml/2015/5/15/89
Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sort.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff -puN lib/sort.c~lib-sort-add-64-bit-swap-function-v2-fix lib/sort.c
--- a/lib/sort.c~lib-sort-add-64-bit-swap-function-v2-fix
+++ a/lib/sort.c
@@ -8,6 +8,12 @@
 #include <linux/export.h>
 #include <linux/sort.h>
 
+static int alignment_ok(const void *base, int align)
+{
+	return IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
+		((unsigned long)base & (align - 1)) == 0;
+}
+
 static void u32_swap(void *a, void *b, int size)
 {
 	u32 t = *(u32 *)a;
@@ -58,29 +64,11 @@ void sort(void *base, size_t num, size_t
 	int i = (num/2 - 1) * size, n = num * size, c, r;
 
 	if (!swap_func) {
-#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
-		switch (size) {
-		case 4:
+		if (size == 4 && alignment_ok(base, 4))
 			swap_func = u32_swap;
-			break;
-		case 8:
+		else if (size == 8 && alignment_ok(base, 8))
 			swap_func = u64_swap;
-			break;
-		}
-#else
-		switch (size) {
-		case 4:
-			if (((unsigned long)base & 3) == 0)
-				swap_func = u32_swap;
-			break;
-		case 8:
-			if (((unsigned long)base & 7) == 0)
-				swap_func = u64_swap;
-			break;
-		}
-#endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
