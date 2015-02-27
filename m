From: akpm@linux-foundation.org
Subject: + lib-vsprintf-document-%p-parameters-passed-by-reference.patch
 added to -mm tree
Date: Fri, 27 Feb 2015 14:18:59 -0800
Message-ID: <54f0ed53.YPHFbb6YquMyddNM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbbB0WTA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Feb 2015 17:19:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert+renesas@glider.be, corbet@lwn.net, mturquette@linaro.org, penguin-kernel@I-love.SAKURA.ne.jp, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf: document %p parameters passed by reference
has been added to the -mm tree.  Its filename is
     lib-vsprintf-document-%p-parameters-passed-by-reference.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintf-document-%25p-parameters-passed-by-reference.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintf-document-%25p-parameters-passed-by-reference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: lib/vsprintf: document %p parameters passed by reference

This patch series improves the documentation for printk() formats, and
adds support for printing clocks.  The latter has always been a hassle if
you wanted to support both the common and legacy clock frameworks.

  - '%pC' and '%pCn' print the name (Common Clock Framework) or address
    (legacy clock framework) of a clock,
  - '%pCr' prints the current clock rate.



This patch (of 3):

Make sure all %p extensions that take parameters by references are
documented to do so.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN Documentation/printk-formats.txt~lib-vsprintf-document-%p-parameters-passed-by-reference Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~lib-vsprintf-document-%p-parameters-passed-by-reference
+++ a/Documentation/printk-formats.txt
@@ -54,6 +54,7 @@ Struct Resources:
 
 	For printing struct resources. The 'R' and 'r' specifiers result in a
 	printed resource with ('R') or without ('r') a decoded flags member.
+	Passed by reference.
 
 Physical addresses types phys_addr_t:
 
@@ -132,6 +133,8 @@ MAC/FDDI addresses:
 	specifier to use reversed byte order suitable for visual interpretation
 	of Bluetooth addresses which are in the little endian order.
 
+	Passed by reference.
+
 IPv4 addresses:
 
 	%pI4	1.2.3.4
@@ -146,6 +149,8 @@ IPv4 addresses:
 	host, network, big or little endian order addresses respectively. Where
 	no specifier is provided the default network/big endian order is used.
 
+	Passed by reference.
+
 IPv6 addresses:
 
 	%pI6	0001:0002:0003:0004:0005:0006:0007:0008
@@ -160,6 +165,8 @@ IPv6 addresses:
 	print a compressed IPv6 address as described by
 	http://tools.ietf.org/html/rfc5952
 
+	Passed by reference.
+
 IPv4/IPv6 addresses (generic, with port, flowinfo, scope):
 
 	%pIS	1.2.3.4		or 0001:0002:0003:0004:0005:0006:0007:0008
@@ -186,6 +193,8 @@ IPv4/IPv6 addresses (generic, with port,
 	specifiers can be used as well and are ignored in case of an IPv6
 	address.
 
+	Passed by reference.
+
 	Further examples:
 
 	%pISfc		1.2.3.4		or [1:2:3:4:5:6:7:8]/123456789
@@ -207,6 +216,8 @@ UUID/GUID addresses:
 	Where no additional specifiers are used the default little endian
 	order with lower case hex characters will be printed.
 
+	Passed by reference.
+
 dentry names:
 	%pd{,2,3,4}
 	%pD{,2,3,4}
@@ -216,6 +227,8 @@ dentry names:
 	equivalent of %s dentry->d_name.name we used to use, %pd<n> prints
 	n last components.  %pD does the same thing for struct file.
 
+	Passed by reference.
+
 struct va_format:
 
 	%pV
@@ -231,6 +244,8 @@ struct va_format:
 	Do not use this feature without some mechanism to verify the
 	correctness of the format string and va_list arguments.
 
+	Passed by reference.
+
 u64 SHOULD be printed with %llu/%llx:
 
 	printk("%llu", u64_var);
_

Patches currently in -mm which might be from geert+renesas@glider.be are

lib-vsprintf-document-%p-parameters-passed-by-reference.patch
lib-vsprintf-move-integer-format-types-to-the-top.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
linux-next.patch

