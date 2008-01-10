From: akpm@linux-foundation.org
Subject: + drivers-edac-i3000-missing-init-code.patch added to -mm tree
Date: Wed, 09 Jan 2008 21:28:35 -0800
Message-ID: <200801100528.m0A5SFIk006794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37069 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324AbYAJF24 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 00:28:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: h.mitake@gmail.com, dougthompson@xmisson.com, juhlenko@akamai.com


The patch titled
     drivers/edac: i3000: missing init code
has been added to the -mm tree.  Its filename is
     drivers-edac-i3000-missing-init-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/edac: i3000: missing init code
From: Hitoshi Mitake <h.mitake@gmail.com>

There is a missing sequence of initialization code during startup.

Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>
Signed-off-by: Jason Uhlenkott <juhlenko@akamai.com>
Signed-off-by: Doug Thompson <dougthompson@xmisson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i3000_edac.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN drivers/edac/i3000_edac.c~drivers-edac-i3000-missing-init-code drivers/edac/i3000_edac.c
--- a/drivers/edac/i3000_edac.c~drivers-edac-i3000-missing-init-code
+++ a/drivers/edac/i3000_edac.c
@@ -14,6 +14,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
+#include <linux/edac.h>
 #include "edac_core.h"
 
 #define I3000_REVISION		"1.1"
@@ -318,6 +319,15 @@ static int i3000_probe1(struct pci_dev *
 		return -ENODEV;
 	}
 
+	switch (edac_op_state) {
+	case EDAC_OPSTATE_POLL:
+	case EDAC_OPSTATE_NMI:
+		break;
+	default:
+		edac_op_state = EDAC_OPSTATE_POLL;
+		break;
+	}
+
 	c0dra[0] = readb(window + I3000_C0DRA + 0);	/* ranks 0,1 */
 	c0dra[1] = readb(window + I3000_C0DRA + 1);	/* ranks 2,3 */
 	c1dra[0] = readb(window + I3000_C1DRA + 0);	/* ranks 0,1 */
@@ -537,3 +547,6 @@ module_exit(i3000_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Akamai Technologies Arthur Ulfeldt/Jason Uhlenkott");
 MODULE_DESCRIPTION("MC support for Intel 3000 memory hub controllers");
+
+module_param(edac_op_state, int, 0444);
+MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
_

Patches currently in -mm which might be from h.mitake@gmail.com are

drivers-edac-i3000-missing-init-code.patch
