From: akpm@linux-foundation.org
Subject: - cfag12864b-fix.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:56:55 -0700
Message-ID: <200708242056.l7OKutjS014109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37444 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759003AbXHXVII (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxextreme@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cfag12864b fix
has been removed from the -mm tree.  Its filename was
     cfag12864b-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
