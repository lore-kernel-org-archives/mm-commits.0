From: akpm@linux-foundation.org
Subject: - pnpacpi-print-resource-shortage-message-only-once-more.patch removed from -mm tree
Date: Sat, 19 Jan 2008 23:04:41 -0800
Message-ID: <200801200704.m0K74LKl007799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58740 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518AbYATHEY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 Jan 2008 02:04:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: len.brown@intel.com, oliver.hartkopp@volkswagen.de, mm-commits@vger.kernel.org


The patch titled
     pnpacpi: print resource shortage message only once (more)
has been removed from the -mm tree.  Its filename was
     pnpacpi-print-resource-shortage-message-only-once-more.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnpacpi: print resource shortage message only once (more)
From: Len Brown <len.brown@intel.com>

Wups, previous patch was ineffective in 2 cases.

http://bugzilla.kernel.org/show_bug.cgi?id=9535

Signed-off-by: Len Brown <len.brown@intel.com>
Reported-by: "Hartkopp, Oliver (K-EFE/E)" <oliver.hartkopp@volkswagen.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpacpi/rsparser.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/pnp/pnpacpi/rsparser.c~pnpacpi-print-resource-shortage-message-only-once-more drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~pnpacpi-print-resource-shortage-message-only-once-more
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -215,6 +215,7 @@ static void pnpacpi_parse_allocated_iore
 	} else if (!warned) {
 		printk(KERN_ERR "pnpacpi: exceeded the max number of IO "
 				"resources: %d \n", PNP_MAX_PORT);
+		warned = 1;
 	}
 }
 
@@ -242,6 +243,7 @@ static void pnpacpi_parse_allocated_memr
 	} else if (!warned) {
 		printk(KERN_ERR "pnpacpi: exceeded the max number of mem "
 				"resources: %d\n", PNP_MAX_MEM);
+		warned = 1;
 	}
 }
 
_

Patches currently in -mm which might be from len.brown@intel.com are

origin.patch
git-acpi.patch
git-libata-all.patch
git-x86.patch
