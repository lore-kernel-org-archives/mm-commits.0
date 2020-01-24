From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?lib-reduce-user=5Faccess=5Fbegin-boundaries-in-strncpy=5F?=
 =?US-ASCII?Q?from=5Fuser-and-strnlen=5Fuser.patch?= added to -mm tree
Date: Thu, 23 Jan 2020 17:16:29 -0800
Message-ID: <20200124011629.q_Ad1PA-o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729009AbgAXBQb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jan 2020 20:16:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christophe.leroy@c-s.fr, mm-commits@vger.kernel.org, torvalds@linux-foundation.org


The patch titled
     Subject: lib: reduce user_access_begin() boundaries in strncpy_from_user() and strnlen_user()
has been added to the -mm tree.  Its filename is
     lib-reduce-user_access_begin-boundaries-in-strncpy_from_user-and-strnlen_user.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-reduce-user_access_begin-boundaries-in-strncpy_from_user-and-strnlen_user.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-reduce-user_access_begin-boundaries-in-strncpy_from_user-and-strnlen_user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: lib: reduce user_access_begin() boundaries in strncpy_from_user() and strnlen_user()

The range passed to user_access_begin() by strncpy_from_user() and
strnlen_user() starts at 'src' and goes up to the limit of userspace
allthough reads will be limited by the 'count' param.

On 32 bits powerpc (book3s/32) access has to be granted for each 256Mbytes
segment and the cost increases with the number of segments to unlock.

Limit the range with 'count' param.

Link: http://lkml.kernel.org/r/70f99f7474826883877e84f93224e937d9c974de.1579767339.git.christophe.leroy@c-s.fr
Fixes: 594cc251fdd0 ("make 'user_access_begin()' do 'access_ok()'")
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/strncpy_from_user.c |   14 +++++++-------
 lib/strnlen_user.c      |   14 +++++++-------
 2 files changed, 14 insertions(+), 14 deletions(-)

--- a/lib/strncpy_from_user.c~lib-reduce-user_access_begin-boundaries-in-strncpy_from_user-and-strnlen_user
+++ a/lib/strncpy_from_user.c
@@ -30,13 +30,6 @@ static inline long do_strncpy_from_user(
 	const struct word_at_a_time constants = WORD_AT_A_TIME_CONSTANTS;
 	unsigned long res = 0;
 
-	/*
-	 * Truncate 'max' to the user-specified limit, so that
-	 * we only have one limit we need to check in the loop
-	 */
-	if (max > count)
-		max = count;
-
 	if (IS_UNALIGNED(src, dst))
 		goto byte_at_a_time;
 
@@ -114,6 +107,13 @@ long strncpy_from_user(char *dst, const
 		unsigned long max = max_addr - src_addr;
 		long retval;
 
+		/*
+		 * Truncate 'max' to the user-specified limit, so that
+		 * we only have one limit we need to check in the loop
+		 */
+		if (max > count)
+			max = count;
+
 		kasan_check_write(dst, count);
 		check_object_size(dst, count, false);
 		if (user_access_begin(src, max)) {
--- a/lib/strnlen_user.c~lib-reduce-user_access_begin-boundaries-in-strncpy_from_user-and-strnlen_user
+++ a/lib/strnlen_user.c
@@ -27,13 +27,6 @@ static inline long do_strnlen_user(const
 	unsigned long c;
 
 	/*
-	 * Truncate 'max' to the user-specified limit, so that
-	 * we only have one limit we need to check in the loop
-	 */
-	if (max > count)
-		max = count;
