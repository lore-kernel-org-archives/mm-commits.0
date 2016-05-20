From: akpm@linux-foundation.org
Subject: [folded-merged]
 x86-kasan-instrument-user-memory-access-api-fix.patch removed from -mm tree
Date: Fri, 20 May 2016 16:40:06 -0700
Message-ID: <573fa056.4f21sfdMyMdL2HYo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbcETXkH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:40:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-kasan-instrument-user-memory-access-api-fix
has been removed from the -mm tree.  Its filename was
     x86-kasan-instrument-user-memory-access-api-fix.patch

This patch was dropped because it was folded into x86-kasan-instrument-user-memory-access-api.patch

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: x86-kasan-instrument-user-memory-access-api-fix

Move kasan check under the condition, otherwise we may fail and not
do a user copy.

Link: http://lkml.kernel.org/r/1462869209-21096-1-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reported-by: Ingo Molnar <mingo@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/strncpy_from_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/strncpy_from_user.c~x86-kasan-instrument-user-memory-access-api-fix lib/strncpy_from_user.c
--- a/lib/strncpy_from_user.c~x86-kasan-instrument-user-memory-access-api-fix
+++ a/lib/strncpy_from_user.c
@@ -104,13 +104,13 @@ long strncpy_from_user(char *dst, const
 	if (unlikely(count <= 0))
 		return 0;
 
-	kasan_check_write(dst, count);
 	max_addr = user_addr_max();
 	src_addr = (unsigned long)src;
 	if (likely(src_addr < max_addr)) {
 		unsigned long max = max_addr - src_addr;
 		long retval;
 
+		kasan_check_write(dst, count);
 		user_access_begin();
 		retval = do_strncpy_from_user(dst, src, count, max);
 		user_access_end();
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-kasan-print-name-of-mem-caller-in-report.patch
mm-kasan-add-api-to-check-memory-regions.patch
x86-kasan-instrument-user-memory-access-api.patch
kasan-tests-add-tests-for-user-memory-access-functions.patch

