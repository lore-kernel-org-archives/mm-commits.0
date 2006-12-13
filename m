From: akpm@osdl.org
Subject: - add-module_-attributes-to-bit-reversal-library.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:55:51 -0800
Message-ID: <200612130655.kBD6tpes030676@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57868 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965033AbWLMGz7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:55:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cp@absolutedigital.net, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     add MODULE_* attributes to bit reversal library
has been removed from the -mm tree.  Its filename was
     add-module_-attributes-to-bit-reversal-library.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add MODULE_* attributes to bit reversal library
From: Cal Peake <cp@absolutedigital.net>

Add MODULE_* attributes to the new bit reversal library.  Most notably
MODULE_LICENSE which prevents superfluous kernel tainting.

Signed-off-by: Cal Peake <cp@absolutedigital.net>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 lib/bitrev.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN lib/bitrev.c~add-module_-attributes-to-bit-reversal-library lib/bitrev.c
--- a/lib/bitrev.c~add-module_-attributes-to-bit-reversal-library
+++ a/lib/bitrev.c
@@ -2,6 +2,10 @@
 #include <linux/module.h>
 #include <linux/bitrev.h>
 
+MODULE_AUTHOR("Akinobu Mita <akinobu.mita@gmail.com>");
+MODULE_DESCRIPTION("Bit ordering reversal functions");
+MODULE_LICENSE("GPL");
+
 const u8 byte_rev_table[256] = {
 	0x00, 0x80, 0x40, 0xc0, 0x20, 0xa0, 0x60, 0xe0,
 	0x10, 0x90, 0x50, 0xd0, 0x30, 0xb0, 0x70, 0xf0,
_

Patches currently in -mm which might be from cp@absolutedigital.net are

origin.patch

