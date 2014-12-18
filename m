From: akpm@linux-foundation.org
Subject: + lib-string_get_size-remove-redundant-prefixes.patch added to
 -mm tree
Date: Thu, 18 Dec 2014 13:46:37 -0800
Message-ID: <54934b3d.Or17ls+e7BIjxNVG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaLRVqi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Dec 2014 16:46:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string_helpers.c:string_get_size(): remove redundant prefixes
has been added to the -mm tree.  Its filename is
     lib-string_get_size-remove-redundant-prefixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string_get_size-remove-redundant-prefixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string_get_size-remove-redundant-prefixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/string_helpers.c:string_get_size(): remove redundant prefixes

While 3c9f3681d0b4 "[SCSI] lib: add generic helper to print sizes rounded
to the correct SI range" says that Z and Y are included in preparation for
128 bit computers, they just waste .text currently.  If and when we get
u128, string_get_size needs updating anyway (and ISO needs to come up with
four more prefixes).

Also there's no need to include and test for the NULL sentinel; once we
reach "E" size is at most 18.  [The test is also wrong; it should be
units_str[units][i+1]; if we've reached NULL we're already doomed.]

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string_helpers.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN lib/string_helpers.c~lib-string_get_size-remove-redundant-prefixes lib/string_helpers.c
--- a/lib/string_helpers.c~lib-string_get_size-remove-redundant-prefixes
+++ a/lib/string_helpers.c
@@ -28,11 +28,10 @@ int string_get_size(u64 size, const enum
 		    char *buf, int len)
 {
 	static const char *const units_10[] = {
-		"B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB", NULL
+		"B", "kB", "MB", "GB", "TB", "PB", "EB"
 	};
 	static const char *const units_2[] = {
-		"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB",
-		NULL
+		"B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"
 	};
 	static const char *const *const units_str[] = {
 		[STRING_UNITS_10] = units_10,
@@ -49,7 +48,7 @@ int string_get_size(u64 size, const enum
 	tmp[0] = '\0';
 	i = 0;
 	if (size >= divisor[units]) {
-		while (size >= divisor[units] && units_str[units][i]) {
+		while (size >= divisor[units]) {
 			remainder = do_div(size, divisor[units]);
 			i++;
 		}
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
lib-string_get_size-remove-redundant-prefixes.patch
lib-string_get_size-use-32-bit-arithmetic-when-possible.patch
lib-string_get_size-return-void.patch

