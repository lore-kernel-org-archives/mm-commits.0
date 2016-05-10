From: akpm@linux-foundation.org
Subject: + x86-kasan-instrument-user-memory-access-api-fix.patch added to
 -mm tree
Date: Tue, 10 May 2016 11:28:16 -0700
Message-ID: <57322840.8tWD5TKl+cnrclPH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbcEJS2R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2016 14:28:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-kasan-instrument-user-memory-access-api-fix
has been added to the -mm tree.  Its filename is
     x86-kasan-instrument-user-memory-access-api-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-kasan-instrument-user-memory-access-api-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-kasan-instrument-user-memory-access-api-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-kasan-initial-memory-quarantine-implementation-v8-fix.patch
mm-kasan-print-name-of-mem-caller-in-report.patch
mm-kasan-add-api-to-check-memory-regions.patch
x86-kasan-instrument-user-memory-access-api.patch
x86-kasan-instrument-user-memory-access-api-fix.patch
kasan-tests-add-tests-for-user-memory-access-functions.patch

