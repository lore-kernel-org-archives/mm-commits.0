From: akpm@linux-foundation.org
Subject: [merged] vsprintf-add-%pad-extension-for-dma_addr_t-use.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:00:57 -0800
Message-ID: <52e2b869.FwCi4sO5VIGOVyoY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTA6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net, laurent.pinchart+renesas@ideasonboard.com, julia.lawall@lip6.fr, andriy.shevchenko@intel.com, joe@perches.com

Subject: [merged] vsprintf-add-%pad-extension-for-dma_addr_t-use.patch removed from -mm tree
To: joe@perches.com,andriy.shevchenko@intel.com,julia.lawall@lip6.fr,laurent.pinchart+renesas@ideasonboard.com,rob@landley.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:57 -0800


The patch titled
     Subject: vsprintf: add %pad extension for dma_addr_t use
has been removed from the -mm tree.  Its filename was
     vsprintf-add-%pad-extension-for-dma_addr_t-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: vsprintf: add %pad extension for dma_addr_t use

dma_addr_t's can be either u32 or u64 depending on a CONFIG option.

There are a few hundred dma_addr_t's printed via either cast to unsigned
long long, unsigned long or no cast at all.

Add %pad to be able to emit them without the cast.

Update Documentation/printk-formats.txt too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Cc: Rob Landley <rob@landley.net>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |   11 +++++++--
 lib/vsprintf.c                   |   33 +++++++++++++++++++++++------
 2 files changed, 36 insertions(+), 8 deletions(-)

diff -puN Documentation/printk-formats.txt~vsprintf-add-%pad-extension-for-dma_addr_t-use Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~vsprintf-add-%pad-extension-for-dma_addr_t-use
+++ a/Documentation/printk-formats.txt
@@ -55,14 +55,21 @@ Struct Resources:
 	For printing struct resources. The 'R' and 'r' specifiers result in a
 	printed resource with ('R') or without ('r') a decoded flags member.
 
-Physical addresses:
+Physical addresses types phys_addr_t:
 
-	%pa	0x01234567 or 0x0123456789abcdef
+	%pa[p]	0x01234567 or 0x0123456789abcdef
 
 	For printing a phys_addr_t type (and its derivatives, such as
 	resource_size_t) which can vary based on build options, regardless of
 	the width of the CPU data path. Passed by reference.
 
+DMA addresses types dma_addr_t:
+
+	%pad	0x01234567 or 0x0123456789abcdef
+
+	For printing a dma_addr_t type which can vary based on build options,
+	regardless of the width of the CPU data path. Passed by reference.
+
 Raw buffer as a hex string:
 	%*ph	00 01 02  ...  3f
 	%*phC	00:01:02: ... :3f
diff -puN lib/vsprintf.c~vsprintf-add-%pad-extension-for-dma_addr_t-use lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-add-%pad-extension-for-dma_addr_t-use
+++ a/lib/vsprintf.c
@@ -1155,6 +1155,30 @@ char *netdev_feature_string(char *buf, c
 	return number(buf, end, *(const netdev_features_t *)addr, spec);
 }
 
+static noinline_for_stack
+char *address_val(char *buf, char *end, const void *addr,
+		  struct printf_spec spec, const char *fmt)
+{
+	unsigned long long num;
+
+	spec.flags |= SPECIAL | SMALL | ZEROPAD;
+	spec.base = 16;
+
+	switch (fmt[1]) {
+	case 'd':
+		num = *(const dma_addr_t *)addr;
+		spec.field_width = sizeof(dma_addr_t) * 2 + 2;
+		break;
+	case 'p':
+	default:
+		num = *(const phys_addr_t *)addr;
+		spec.field_width = sizeof(phys_addr_t) * 2 + 2;
+		break;
+	}
+
+	return number(buf, end, num, spec);
+}
+
 int kptr_restrict __read_mostly;
 
 /*
@@ -1218,7 +1242,8 @@ int kptr_restrict __read_mostly;
  *              N no separator
  *            The maximum supported length is 64 bytes of the input. Consider
  *            to use print_hex_dump() for the larger input.
- * - 'a' For a phys_addr_t type and its derivative types (passed by reference)
+ * - 'a[pd]' For address types [p] phys_addr_t, [d] dma_addr_t and derivatives
+ *           (default assumed to be phys_addr_t, passed by reference)
  * - 'd[234]' For a dentry name (optionally 2-4 last components)
  * - 'D[234]' Same as 'd' but for a struct file
  *
@@ -1353,11 +1378,7 @@ char *pointer(const char *fmt, char *buf
 		}
 		break;
 	case 'a':
-		spec.flags |= SPECIAL | SMALL | ZEROPAD;
-		spec.field_width = sizeof(phys_addr_t) * 2 + 2;
-		spec.base = 16;
-		return number(buf, end,
-			      (unsigned long long) *((phys_addr_t *)ptr), spec);
+		return address_val(buf, end, ptr, spec, fmt);
 	case 'd':
 		return dentry_name(buf, end, ptr, spec, fmt);
 	case 'D':
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
ipc-whitespace-cleanup.patch
linux-next.patch
softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch

