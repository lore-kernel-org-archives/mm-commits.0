From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintf-add-%pa-format-specifier-for-phys_addr_t-types.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:39:56 -0800
Message-ID: <20130222203956.C11335A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:60515 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011Ab3BVUj6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:39:58 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so103644yen.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:39:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stepanm@codeaurora.org, andrei.emeltchenko@intel.com, andriy.shevchenko@linux.intel.com, linux@horizon.com, mingo@elte.hu, rob@landley.net, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: add %pa format specifier for phys_addr_t types
has been removed from the -mm tree.  Its filename was
     lib-vsprintf-add-%pa-format-specifier-for-phys_addr_t-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: lib/vsprintf.c: add %pa format specifier for phys_addr_t types

Add the %pa format specifier for printing a phys_addr_t type and its
derivative types (such as resource_size_t), since the physical address
size on some platforms can vary based on build options, regardless of the
native integer type.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: Rob Landley <rob@landley.net>
Cc: George Spelvin <linux@horizon.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |   14 +++++++++++---
 lib/vsprintf.c                   |    7 +++++++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff -puN Documentation/printk-formats.txt~lib-vsprintf-add-%pa-format-specifier-for-phys_addr_t-types Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~lib-vsprintf-add-%pa-format-specifier-for-phys_addr_t-types
+++ a/Documentation/printk-formats.txt
@@ -53,6 +53,14 @@ Struct Resources:
 	For printing struct resources. The 'R' and 'r' specifiers result in a
 	printed resource with ('R') or without ('r') a decoded flags member.
 
+Physical addresses:
+
+	%pa	0x01234567 or 0x0123456789abcdef
+
+	For printing a phys_addr_t type (and its derivatives, such as
+	resource_size_t) which can vary based on build options, regardless of
+	the width of the CPU data path. Passed by reference.
+
 Raw buffer as a hex string:
 	%*ph	00 01 02  ...  3f
 	%*phC	00:01:02: ... :3f
@@ -150,9 +158,9 @@ s64 SHOULD be printed with %lld/%llx, (l
 	printk("%lld", (long long)s64_var);
 
 If <type> is dependent on a config option for its size (e.g., sector_t,
-blkcnt_t, phys_addr_t, resource_size_t) or is architecture-dependent
-for its size (e.g., tcflag_t), use a format specifier of its largest
-possible type and explicitly cast to it.  Example:
+blkcnt_t) or is architecture-dependent for its size (e.g., tcflag_t), use a
+format specifier of its largest possible type and explicitly cast to it.
+Example:
 
 	printk("test: sector number/total blocks: %llu/%llu\n",
 		(unsigned long long)sector, (unsigned long long)blockcount);
diff -puN lib/vsprintf.c~lib-vsprintf-add-%pa-format-specifier-for-phys_addr_t-types lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-add-%pa-format-specifier-for-phys_addr_t-types
+++ a/lib/vsprintf.c
@@ -1030,6 +1030,7 @@ int kptr_restrict __read_mostly;
  *              N no separator
  *            The maximum supported length is 64 bytes of the input. Consider
  *            to use print_hex_dump() for the larger input.
+ * - 'a' For a phys_addr_t type and its derivative types (passed by reference)
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -1120,6 +1121,12 @@ char *pointer(const char *fmt, char *buf
 			return netdev_feature_string(buf, end, ptr, spec);
 		}
 		break;
+	case 'a':
+		spec.flags |= SPECIAL | SMALL | ZEROPAD;
+		spec.field_width = sizeof(phys_addr_t) * 2 + 2;
+		spec.base = 16;
+		return number(buf, end,
+			      (unsigned long long) *((phys_addr_t *)ptr), spec);
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
_

Patches currently in -mm which might be from stepanm@codeaurora.org are

origin.patch

