From: akpm@linux-foundation.org
Subject: + hexdump-do-not-print-debug-dumps-for-config_debug.patch added
 to -mm tree
Date: Wed, 22 Jul 2015 16:21:02 -0700
Message-ID: <55b0255e.lqmO7KJGTjmejlLU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbbGVXVD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jul 2015 19:21:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linus.walleij@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hexdump: do not print debug dumps for !CONFIG_DEBUG
has been added to the -mm tree.  Its filename is
     hexdump-do-not-print-debug-dumps-for-config_debug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hexdump-do-not-print-debug-dumps-for-config_debug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hexdump-do-not-print-debug-dumps-for-config_debug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
hexdump-do-not-print-debug-dumps-for-config_debug.patch
linux-next.patch

