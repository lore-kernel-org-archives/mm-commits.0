From: akpm@linux-foundation.org
Subject: - export-reciprocal_value-for-modules.patch removed from -mm tree
Date: Fri, 28 Sep 2007 22:58:50 -0700
Message-ID: <200709290558.l8T5woYb002922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42552 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752540AbXI2F6w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Sep 2007 01:58:52 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l8T5wojN028768
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 28 Sep 2007 22:58:51 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     export reciprocal_value for modules
has been removed from the -mm tree.  Its filename was
     export-reciprocal_value-for-modules.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: export reciprocal_value for modules
From: Stephen Hemminger <shemminger@linux-foundation.org>

Need this in later sky2 code.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/reciprocal_div.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/reciprocal_div.c~export-reciprocal_value-for-modules lib/reciprocal_div.c
--- a/lib/reciprocal_div.c~export-reciprocal_value-for-modules
+++ a/lib/reciprocal_div.c
@@ -1,5 +1,6 @@
 #include <asm/div64.h>
 #include <linux/reciprocal_div.h>
+#include <linux/module.h>
 
 u32 reciprocal_value(u32 k)
 {
@@ -7,3 +8,4 @@ u32 reciprocal_value(u32 k)
 	do_div(val, k);
 	return (u32)val;
 }
+EXPORT_SYMBOL(reciprocal_value);
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
fix-oops-in-platform-uevent.patch
git-infiniband.patch
git-input.patch
git-net.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
export-reciprocal_value-for-modules.patch
skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch
