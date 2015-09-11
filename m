From: akpm@linux-foundation.org
Subject: [merged] hexdump-do-not-print-debug-dumps-for-config_debug.patch
 removed from -mm tree
Date: Fri, 11 Sep 2015 11:11:59 -0700
Message-ID: <55f3196f.697ymOnNwJZTaBZb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbbIKSL7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:11:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linus.walleij@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hexdump: do not print debug dumps for !CONFIG_DEBUG
has been removed from the -mm tree.  Its filename was
     hexdump-do-not-print-debug-dumps-for-config_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Linus Walleij <linus.walleij@linaro.org>
Subject: hexdump: do not print debug dumps for !CONFIG_DEBUG

print_hex_dump_debug() is likely supposed to be analogous to pr_debug() or
dev_dbg() & friends.  Currently it will adhere to dynamic debug, but will
not stub out prints if CONFIG_DEBUG is not set.  Let's make it do the
right thing, because I am tired of having my dmesg buffer full of hex
dumps on production systems.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN include/linux/printk.h~hexdump-do-not-print-debug-dumps-for-config_debug include/linux/printk.h
--- a/include/linux/printk.h~hexdump-do-not-print-debug-dumps-for-config_debug
+++ a/include/linux/printk.h
@@ -456,11 +456,17 @@ static inline void print_hex_dump_bytes(
 			     groupsize, buf, len, ascii)	\
 	dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
 			 groupsize, buf, len, ascii)
-#else
+#elif defined(DEBUG)
 #define print_hex_dump_debug(prefix_str, prefix_type, rowsize,		\
 			     groupsize, buf, len, ascii)		\
 	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, rowsize,	\
 		       groupsize, buf, len, ascii)
-#endif /* defined(CONFIG_DYNAMIC_DEBUG) */
+#else
+static inline void print_hex_dump_debug(const char *prefix_str, int prefix_type,
+					int rowsize, int groupsize,
+					const void *buf, size_t len, bool ascii)
+{
+}
+#endif
 
 #endif
_

Patches currently in -mm which might be from linus.walleij@linaro.org are


