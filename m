From: akpm@linux-foundation.org
Subject: [merged]
 lib-vsprintf-add-%pcnr-format-specifiers-for-clocks.patch removed from -mm
 tree
Date: Thu, 16 Apr 2015 09:54:53 -0700
Message-ID: <552fe95d.bfebmz8VNw4zF/4f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbbDPQtY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:49:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert+renesas@glider.be, corbet@lwn.net, mturquette@linaro.org, penguin-kernel@I-love.SAKURA.ne.jp, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf: add %pC{,n,r} format specifiers for clocks
has been removed from the -mm tree.  Its filename was
     lib-vsprintf-add-%pcnr-format-specifiers-for-clocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: lib/vsprintf: add %pC{,n,r} format specifiers for clocks

Add format specifiers for printing struct clk:
  - '%pC' or '%pCn': name (Common Clock Framework) or address (legacy
    clock framework) of the clock,
  - '%pCr': rate of the clock.

[akpm@linux-foundation.org: omit code if !CONFIG_HAVE_CLK]
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |   12 +++++++++
 lib/vsprintf.c                   |   37 +++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff -puN Documentation/printk-formats.txt~lib-vsprintf-add-%pcnr-format-specifiers-for-clocks Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~lib-vsprintf-add-%pcnr-format-specifiers-for-clocks
+++ a/Documentation/printk-formats.txt
@@ -261,6 +261,18 @@ struct va_format:
 
 	Passed by reference.
 
+struct clk:
+
+	%pC	pll1
+	%pCn	pll1
+	%pCr	1560000000
+
+	For printing struct clk structures. '%pC' and '%pCn' print the name
+	(Common Clock Framework) or address (legacy clock framework) of the
+	structure; '%pCr' prints the current clock rate.
+
+	Passed by reference.
+
 
 Thank you for your cooperation and attention.
 
diff -puN lib/vsprintf.c~lib-vsprintf-add-%pcnr-format-specifiers-for-clocks lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-add-%pcnr-format-specifiers-for-clocks
+++ a/lib/vsprintf.c
@@ -17,6 +17,7 @@
  */
 
 #include <stdarg.h>
+#include <linux/clk-provider.h>
 #include <linux/module.h>	/* for KSYM_SYMBOL_LEN */
 #include <linux/types.h>
 #include <linux/string.h>
@@ -1315,6 +1316,30 @@ char *address_val(char *buf, char *end,
 	return number(buf, end, num, spec);
 }
 
+static noinline_for_stack
+char *clock(char *buf, char *end, struct clk *clk, struct printf_spec spec,
+	    const char *fmt)
+{
+	if (!IS_ENABLED(CONFIG_HAVE_CLK) || !clk)
+		return string(buf, end, NULL, spec);
+
+	switch (fmt[1]) {
+	case 'r':
+		return number(buf, end, clk_get_rate(clk), spec);
+
+	case 'n':
+	default:
+#ifdef CONFIG_COMMON_CLK
+		return string(buf, end, __clk_get_name(clk), spec);
+#else
+		spec.base = 16;
+		spec.field_width = sizeof(unsigned long) * 2 + 2;
+		spec.flags |= SPECIAL | SMALL | ZEROPAD;
+		return number(buf, end, (unsigned long)clk, spec);
+#endif
+	}
+}
+
 int kptr_restrict __read_mostly;
 
 /*
@@ -1397,6 +1422,11 @@ int kptr_restrict __read_mostly;
  *           (default assumed to be phys_addr_t, passed by reference)
  * - 'd[234]' For a dentry name (optionally 2-4 last components)
  * - 'D[234]' Same as 'd' but for a struct file
+ * - 'C' For a clock, it prints the name (Common Clock Framework) or address
+ *       (legacy clock framework) of the clock
+ * - 'Cn' For a clock, it prints the name (Common Clock Framework) or address
+ *        (legacy clock framework) of the clock
+ * - 'Cr' For a clock, it prints the current rate of the clock
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -1541,6 +1571,8 @@ char *pointer(const char *fmt, char *buf
 		return address_val(buf, end, ptr, spec, fmt);
 	case 'd':
 		return dentry_name(buf, end, ptr, spec, fmt);
+	case 'C':
+		return clock(buf, end, ptr, spec, fmt);
 	case 'D':
 		return dentry_name(buf, end,
 				   ((const struct file *)ptr)->f_path.dentry,
@@ -1785,6 +1817,11 @@ qualifier:
  * %*pE[achnops] print an escaped buffer
  * %*ph[CDN] a variable-length hex string with a separator (supports up to 64
  *           bytes of the input)
+ * %pC output the name (Common Clock Framework) or address (legacy clock
+ *     framework) of a clock
+ * %pCn output the name (Common Clock Framework) or address (legacy clock
+ *      framework) of a clock
+ * %pCr output the current rate of a clock
  * %n is ignored
  *
  * ** Please update Documentation/printk-formats.txt when making changes **
_

Patches currently in -mm which might be from geert+renesas@glider.be are

origin.patch
linux-next.patch

