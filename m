From: akpm@linux-foundation.org
Subject: + lib-vsprintf-update-documentation-to-cover-all-of-%p.patch added to -mm tree
Date: Wed, 05 Sep 2012 16:33:33 -0700
Message-ID: <20120905233333.9470F1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:63937 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759906Ab2IEXde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Sep 2012 19:33:34 -0400
Received: by qcqs25 with SMTP id s25so89684qcq.1
        for <mm-commits@vger.kernel.org>; Wed, 05 Sep 2012 16:33:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andriy.shevchenko@linux.intel.com, andrei.emeltchenko@intel.com


The patch titled
     Subject: lib/vsprintf: update documentation to cover all of %p[Mm][FR]
has been added to the -mm tree.  Its filename is
     lib-vsprintf-update-documentation-to-cover-all-of-%p.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -989,7 +989,7 @@ int kptr_restrict __read_mostly;
  * - 'm' For a 6-byte MAC address, it prints the hex address without colons
  * - 'MF' For a 6-byte MAC FDDI address, it prints the address
  *       with a dash-separated hex notation
- * - '[mM]R For a 6-byte MAC address, Reverse order (Bluetooth)
+ * - '[mM]R' For a 6-byte MAC address, Reverse order (Bluetooth)
  * - 'I' [46] for IPv4/IPv6 addresses printed in the usual way
  *       IPv4 uses dot-separated decimal without leading 0's (1.2.3.4)
  *       IPv6 uses colon separated network-order 16 bit hex with leading 0's
@@ -1340,7 +1340,10 @@ qualifier:
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

linux-next.patch
lib-vsprintf-update-documentation-to-cover-all-of-%p.patch

