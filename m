From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintfc-improve-sanity-check-in-vsnprintf.patch
 removed from -mm tree
Date: Fri, 13 Feb 2015 12:22:04 -0800
Message-ID: <54de5cec.+x2WRwQ2EiA8e5yo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbbBMUWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:22:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, jkosina@suse.cz, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: improve sanity check in vsnprintf()
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-improve-sanity-check-in-vsnprintf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/vsprintf.c: improve sanity check in vsnprintf()

On 64 bit, size may very well be huge even if bit 31 happens to be 0. 
Somehow it doesn't feel right that one can pass a 5 GiB buffer but not a 3
GiB one.  So cap at INT_MAX as was probably the intention all along.  This
is also the made-up value passed by sprintf and vsprintf.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-improve-sanity-check-in-vsnprintf lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-improve-sanity-check-in-vsnprintf
+++ a/lib/vsprintf.c
@@ -1727,7 +1727,7 @@ int vsnprintf(char *buf, size_t size, co
 
 	/* Reject out-of-range values early.  Large positive sizes are
 	   used for unknown buffer sizes. */
-	if (WARN_ON_ONCE((int) size < 0))
+	if (WARN_ON_ONCE(size > INT_MAX))
 		return 0;
 
 	str = buf;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
lib-bitmapc-change-prototype-of-bitmap_copy_le.patch
lib-bitmapc-elide-bitmap_copy_le-on-little-endian.patch
lib-bitmap-change-bitmap_shift_right-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_right.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_right.patch
lib-bitmap-yet-another-simplification-in-__bitmap_shift_right.patch
lib-bitmap-change-bitmap_shift_left-to-take-unsigned-parameters.patch
lib-bitmap-eliminate-branch-in-__bitmap_shift_left.patch
lib-bitmap-remove-redundant-code-from-__bitmap_shift_left.patch
lib-stringc-improve-strrchr.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
linux-next.patch

