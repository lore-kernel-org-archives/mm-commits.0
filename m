From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintf-update-documentation-to-cover-all-of-%p.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:14:22 -0700
Message-ID: <20121005201423.2294C200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:39842 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab2JEUOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:14:25 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so138358fae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:14:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, andrei.emeltchenko@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf: update documentation to cover all of %p[Mm][FR]
has been removed from the -mm tree.  Its filename was
     lib-vsprintf-update-documentation-to-cover-all-of-%p.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/vsprintf: update documentation to cover all of %p[Mm][FR]

Acked-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |    1 +
 lib/vsprintf.c                   |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN Documentation/printk-formats.txt~lib-vsprintf-update-documentation-to-cover-all-of-%p Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~lib-vsprintf-update-documentation-to-cover-all-of-%p
+++ a/Documentation/printk-formats.txt
@@ -69,6 +69,7 @@ MAC/FDDI addresses:
 	%pMR	05:04:03:02:01:00
 	%pMF	00-01-02-03-04-05
 	%pm	000102030405
+	%pmR	050403020100
 
 	For printing 6-byte MAC/FDDI addresses in hex notation. The 'M' and 'm'
 	specifiers result in a printed address with ('M') or without ('m') byte
diff -puN lib/vsprintf.c~lib-vsprintf-update-documentation-to-cover-all-of-%p lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-update-documentation-to-cover-all-of-%p
+++ a/lib/vsprintf.c
@@ -987,7 +987,7 @@ int kptr_restrict __read_mostly;
  * - 'm' For a 6-byte MAC address, it prints the hex address without colons
  * - 'MF' For a 6-byte MAC FDDI address, it prints the address
  *       with a dash-separated hex notation
- * - '[mM]R For a 6-byte MAC address, Reverse order (Bluetooth)
+ * - '[mM]R' For a 6-byte MAC address, Reverse order (Bluetooth)
  * - 'I' [46] for IPv4/IPv6 addresses printed in the usual way
  *       IPv4 uses dot-separated decimal without leading 0's (1.2.3.4)
  *       IPv6 uses colon separated network-order 16 bit hex with leading 0's
@@ -1338,7 +1338,10 @@ qualifier:
  * %pR output the address range in a struct resource with decoded flags
  * %pr output the address range in a struct resource with raw flags
  * %pM output a 6-byte MAC address with colons
+ * %pMR output a 6-byte MAC address with colons in reversed order
+ * %pMF output a 6-byte MAC address with dashes
  * %pm output a 6-byte MAC address without colons
+ * %pmR output a 6-byte MAC address without colons in reversed order
  * %pI4 print an IPv4 address without leading zeros
  * %pi4 print an IPv4 address with leading zeros
  * %pI6 print an IPv6 address with colons
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch

