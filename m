From: akpm@linux-foundation.org
Subject: [merged] kmemleak-use-seq_hex_dump-to-dump-buffers.patch removed
 from -mm tree
Date: Fri, 11 Sep 2015 11:13:13 -0700
Message-ID: <55f319b9.j1fDAHRHSlqJxv/U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbbIKSNO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:13:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, catalin.marinas@arm.com, deller@gmx.de, ingo.tuchscherer@de.ibm.com, joe@perches.com, qca_vkondrat@qca.qualcomm.com, tadeusz.struk@intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: kmemleak: use seq_hex_dump() to dump buffers
has been removed from the -mm tree.  Its filename was
     kmemleak-use-seq_hex_dump-to-dump-buffers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: kmemleak: use seq_hex_dump() to dump buffers

Instead of custom approach let's use recently introduced seq_hex_dump()
helper.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Joe Perches <joe@perches.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff -puN mm/kmemleak.c~kmemleak-use-seq_hex_dump-to-dump-buffers mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-use-seq_hex_dump-to-dump-buffers
+++ a/mm/kmemleak.c
@@ -302,23 +302,14 @@ static void hex_dump_object(struct seq_f
 			    struct kmemleak_object *object)
 {
 	const u8 *ptr = (const u8 *)object->pointer;
-	int i, len, remaining;
-	unsigned char linebuf[HEX_ROW_SIZE * 5];
+	size_t len;
 
 	/* limit the number of lines to HEX_MAX_LINES */
-	remaining = len =
-		min(object->size, (size_t)(HEX_MAX_LINES * HEX_ROW_SIZE));
+	len = min_t(size_t, object->size, HEX_MAX_LINES * HEX_ROW_SIZE);
 
-	seq_printf(seq, "  hex dump (first %d bytes):\n", len);
-	for (i = 0; i < len; i += HEX_ROW_SIZE) {
-		int linelen = min(remaining, HEX_ROW_SIZE);
