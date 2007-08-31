From: akpm@linux-foundation.org
Subject: + export-reciprocal_value-for-modules.patch added to -mm tree
Date: Fri, 31 Aug 2007 12:30:14 -0700
Message-ID: <200708311930.l7VJUEQv023093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58849 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608AbXHaTaZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 15:30:25 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l7VJUElw018157
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2007 12:30:16 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@linux-foundation.org


The patch titled
     export reciprocal_value for modules
has been added to the -mm tree.  Its filename is
     export-reciprocal_value-for-modules.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: export reciprocal_value for modules
From: Stephen Hemminger <shemminger@linux-foundation.org>

Need this in later sky2 code.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/reciprocal_div.c |    2 ++
 1 files changed, 2 insertions(+)

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
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
sky2-fe-chip-support.patch
sky2-use-debugfs-rename.patch
sky2-document-gphy_ctrl-bits.patch
sky2-dont-restrict-config-space-access.patch
sky2-advanced-error-reporting.patch
sky2-use-pci_config-access-functions.patch
sky2-use-net_device-internal-stats.patch
ktime_sub_ns-analog-of-ktime_add_ns.patch
export-reciprocal_value-for-modules.patch
sky2-hardware-receive-timestamp-counter.patch
sky2-avoid-divide-in-receive-path.patch
sky2-118.patch
git-net.patch
i386-optimize-memset-of-6-and-8-bytes.patch
