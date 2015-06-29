From: akpm@linux-foundation.org
Subject: [merged]
 bitmap-remove-explicit-newline-handling-using-scnprintf-format-string.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:48:00 -0700
Message-ID: <5591af00.zq8EpZs8q3t07tYg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50910 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbbF2UsB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudeep.holla@arm.com, Pawel.Moll@arm.com, peterz@infradead.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap: remove explicit newline handling using scnprintf format string
has been removed from the -mm tree.  Its filename was
     bitmap-remove-explicit-newline-handling-using-scnprintf-format-string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: tweak comment]
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Suggested-by: Pawel Moll <Pawel.Moll@arm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN lib/bitmap.c~bitmap-remove-explicit-newline-handling-using-scnprintf-format-string lib/bitmap.c
--- a/lib/bitmap.c~bitmap-remove-explicit-newline-handling-using-scnprintf-format-string
+++ a/lib/bitmap.c
@@ -462,19 +462,20 @@ EXPORT_SYMBOL(bitmap_parse_user);
  * Output format is a comma-separated list of decimal numbers and
  * ranges if list is specified or hex digits grouped into comma-separated
  * sets of 8 digits/set. Returns the number of characters written to buf.
+ *
+ * It is assumed that @buf is a pointer into a PAGE_SIZE area and that
+ * sufficient storage remains at @buf to accommodate the
+ * bitmap_print_to_pagebuf() output.
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

origin.patch

