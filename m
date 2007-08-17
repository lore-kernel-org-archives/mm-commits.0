From: akpm@linux-foundation.org
Subject: + cfag12864b-fix.patch added to -mm tree
Date: Fri, 17 Aug 2007 13:55:40 -0700
Message-ID: <200708172055.l7HKteGZ029039@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46049 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755187AbXHQU4R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 16:56:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maxextreme@gmail.com


The patch titled
     cfag12864b fix
has been added to the -mm tree.  Its filename is
     cfag12864b-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cfag12864b fix
From: Miguel Ojeda <maxextreme@gmail.com>

This one-liner patch fixes a bug in drivers/auxdisplay/cfag12864b.c

At cfag12864b_init(), the driver tries to kalloc some memory in the
variable cfag12864b_cache.

Then, as usual, it checks if the call failed. However, it checks
cfag12864b_buffer instead.

This patch changes the "cfag12864b_buffer" to "cfag12864b_cache" so the
correct variable is checked.

Signed-off-by: Miguel Ojeda <maxextreme@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/auxdisplay/cfag12864b.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/auxdisplay/cfag12864b.c~cfag12864b-fix drivers/auxdisplay/cfag12864b.c
--- a/drivers/auxdisplay/cfag12864b.c~cfag12864b-fix
+++ a/drivers/auxdisplay/cfag12864b.c
@@ -355,7 +355,7 @@ static int __init cfag12864b_init(void)
 
 	cfag12864b_cache = kmalloc(sizeof(unsigned char) *
 		CFAG12864B_SIZE, GFP_KERNEL);
-	if (cfag12864b_buffer == NULL) {
+	if (cfag12864b_cache == NULL) {
 		printk(KERN_ERR CFAG12864B_NAME ": ERROR: "
 			"can't alloc cache buffer (%i bytes)\n",
 			CFAG12864B_SIZE);
_

Patches currently in -mm which might be from maxextreme@gmail.com are

cfag12864b-fix.patch
