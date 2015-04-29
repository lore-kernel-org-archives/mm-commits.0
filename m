From: akpm@linux-foundation.org
Subject: +
 bitmap-remove-explicit-newline-handling-using-scnprintf-format-string.patch added to -mm tree
Date: Wed, 29 Apr 2015 15:49:01 -0700
Message-ID: <55415fdd.w80p5V1yM+cIsCrz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbbD2WtC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Apr 2015 18:49:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudeep.holla@arm.com, Pawel.Moll@arm.com, peterz@infradead.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap: remove explicit newline handling using scnprintf format string
has been added to the -mm tree.  Its filename is
     bitmap-remove-explicit-newline-handling-using-scnprintf-format-string.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitmap-remove-explicit-newline-handling-using-scnprintf-format-string.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitmap-remove-explicit-newline-handling-using-scnprintf-format-string.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sudeep Holla <sudeep.holla@arm.com>
Subject: bitmap: remove explicit newline handling using scnprintf format string

bitmap_print_to_pagebuf uses scnprintf to copy the cpumask/list to page
buffer.  It handles the newline and trailing null character explicitly.

It's unnecessary and also partially duplicated as scnprintf already adds
trailing null character.  The newline can be passed through format string
to scnprintf.  This patch does that simplification.

However theoretically there's one behavior difference: when the buffer is
too small, the original code would still output '\n' at the end while the
new code(with this patch) would just continue to print the formatted
string.  Since this function is dealing with only page buffers, it's
highly unlikely to hit that corner case.

This patch will help in auditing the users of bitmap_print_to_pagebuf
to verify that the buffer passed is large enough and get rid of it
completely by replacing them with direct scnprintf()

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Suggested-by: Pawel Moll <Pawel.Moll@arm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN lib/bitmap.c~bitmap-remove-explicit-newline-handling-using-scnprintf-format-string lib/bitmap.c
--- a/lib/bitmap.c~bitmap-remove-explicit-newline-handling-using-scnprintf-format-string
+++ a/lib/bitmap.c
@@ -462,19 +462,18 @@ EXPORT_SYMBOL(bitmap_parse_user);
  * Output format is a comma-separated list of decimal numbers and
  * ranges if list is specified or hex digits grouped into comma-separated
  * sets of 8 digits/set. Returns the number of characters written to buf.
+ * It is assumed that the buffer passed is atleast PAGE_SIZE and easily
+ * accommodate nmaskbits.
  */
 int bitmap_print_to_pagebuf(bool list, char *buf, const unsigned long *maskp,
 			    int nmaskbits)
 {
-	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf - 2;
+	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
 	int n = 0;
 
-	if (len > 1) {
-		n = list ? scnprintf(buf, len, "%*pbl", nmaskbits, maskp) :
-			   scnprintf(buf, len, "%*pb", nmaskbits, maskp);
-		buf[n++] = '\n';
-		buf[n] = '\0';
-	}
+	if (len > 1)
+		n = list ? scnprintf(buf, len, "%*pbl\n", nmaskbits, maskp) :
+			   scnprintf(buf, len, "%*pb\n", nmaskbits, maskp);
 	return n;
 }
 EXPORT_SYMBOL(bitmap_print_to_pagebuf);
_

Patches currently in -mm which might be from sudeep.holla@arm.com are

bitmap-remove-explicit-newline-handling-using-scnprintf-format-string.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch

