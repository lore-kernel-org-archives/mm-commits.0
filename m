From: akpm@linux-foundation.org
Subject: [merged] input-edt-ft5x06-replace-strnicmp-with-strncasecmp.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:22:24 -0700
Message-ID: <543d69e0.8BoFCdRKGG34pmtn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbaJNSWX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:22:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, dmitry.torokhov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: input: edt-ft5x06: replace strnicmp with strncasecmp
has been removed from the -mm tree.  Its filename was
     input-edt-ft5x06-replace-strnicmp-with-strncasecmp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: input: edt-ft5x06: replace strnicmp with strncasecmp

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics and a
slightly buggy strncasecmp.  The latter is the POSIX name, so strnicmp was
renamed to strncasecmp, and strnicmp made into a wrapper for the new
strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in the
future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/edt-ft5x06.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/touchscreen/edt-ft5x06.c~input-edt-ft5x06-replace-strnicmp-with-strncasecmp drivers/input/touchscreen/edt-ft5x06.c
--- a/drivers/input/touchscreen/edt-ft5x06.c~input-edt-ft5x06-replace-strnicmp-with-strncasecmp
+++ a/drivers/input/touchscreen/edt-ft5x06.c
@@ -812,7 +812,7 @@ static int edt_ft5x06_ts_identify(struct
 	/* if we find something consistent, stay with that assumption
 	 * at least M09 won't send 3 bytes here
 	 */
-	if (!(strnicmp(rdbuf + 1, "EP0", 3))) {
+	if (!(strncasecmp(rdbuf + 1, "EP0", 3))) {
 		tsdata->version = M06;
 
 		/* remove last '$' end marker */
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

