From: akpm@linux-foundation.org
Subject: - ide_in_drive_list-accept-null-as-the-wildcard-for-firmware-revision.patch removed from -mm tree
Date: Wed, 30 May 2007 16:28:26 -0700
Message-ID: <200705302328.l4UNSPkV007753@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752722AbXE3X2n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 19:28:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junkio@cox.net, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ide_in_drive_list(): accept NULL as the wildcard for firmware revision
has been removed from the -mm tree.  Its filename was
     ide_in_drive_list-accept-null-as-the-wildcard-for-firmware-revision.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ide_in_drive_list(): accept NULL as the wildcard for firmware revision
From: Junio C Hamano <junkio@cox.net>

Earlier, the matching of (model,rev) in ide-dma black/white list handling was
to consider "ALL" in the table to match any revision.  This makes NULL to be
also an accepted wildcard, and changes the entries of tables in ide-dma.c to
use NULL.

The code still accepts "ALL" as the wildcard, in order to keep any out-of-tree
ide driver that feeds its own table that uses "ALL" as the wildcard to
ide_in_drive_list() function from breaking.

Signed-off-by: Junio C Hamano <junkio@cox.net>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-dma.c |   67 ++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 33 deletions(-)

diff -puN drivers/ide/ide-dma.c~ide_in_drive_list-accept-null-as-the-wildcard-for-firmware-revision drivers/ide/ide-dma.c
--- a/drivers/ide/ide-dma.c~ide_in_drive_list-accept-null-as-the-wildcard-for-firmware-revision
+++ a/drivers/ide/ide-dma.c
@@ -91,45 +91,45 @@
 
 static const struct drive_list_entry drive_whitelist [] = {
 
-	{ "Micropolis 2112A"	,       "ALL"		},
-	{ "CONNER CTMA 4000"	,       "ALL"		},
-	{ "CONNER CTT8000-A"	,       "ALL"		},
-	{ "ST34342A"		,	"ALL"		},
+	{ "Micropolis 2112A"	,       NULL		},
+	{ "CONNER CTMA 4000"	,       NULL		},
+	{ "CONNER CTT8000-A"	,       NULL		},
+	{ "ST34342A"		,	NULL		},
 	{ NULL			,	NULL		}
 };
 
 static const struct drive_list_entry drive_blacklist [] = {
 
-	{ "WDC AC11000H"	,	"ALL"		},
-	{ "WDC AC22100H"	,	"ALL"		},
-	{ "WDC AC32500H"	,	"ALL"		},
-	{ "WDC AC33100H"	,	"ALL"		},
-	{ "WDC AC31600H"	,	"ALL"		},
+	{ "WDC AC11000H"	,	NULL 		},
+	{ "WDC AC22100H"	,	NULL 		},
+	{ "WDC AC32500H"	,	NULL 		},
+	{ "WDC AC33100H"	,	NULL 		},
+	{ "WDC AC31600H"	,	NULL 		},
 	{ "WDC AC32100H"	,	"24.09P07"	},
 	{ "WDC AC23200L"	,	"21.10N21"	},
-	{ "Compaq CRD-8241B"	,	"ALL"		},
-	{ "CRD-8400B"		,	"ALL"		},
-	{ "CRD-8480B",			"ALL"		},
-	{ "CRD-8482B",			"ALL"		},
- 	{ "CRD-84"		,	"ALL"		},
-	{ "SanDisk SDP3B"	,	"ALL"		},
-	{ "SanDisk SDP3B-64"	,	"ALL"		},
-	{ "SANYO CD-ROM CRD"	,	"ALL"		},
-	{ "HITACHI CDR-8"	,	"ALL"		},
-	{ "HITACHI CDR-8335"	,	"ALL"		},
-	{ "HITACHI CDR-8435"	,	"ALL"		},
-	{ "Toshiba CD-ROM XM-6202B"	,	"ALL"		},
-	{ "TOSHIBA CD-ROM XM-1702BC",	"ALL"		},
-	{ "CD-532E-A"		,	"ALL"		},
-	{ "E-IDE CD-ROM CR-840",	"ALL"		},
-	{ "CD-ROM Drive/F5A",	"ALL"		},
-	{ "WPI CDD-820",		"ALL"		},
-	{ "SAMSUNG CD-ROM SC-148C",	"ALL"		},
-	{ "SAMSUNG CD-ROM SC",	"ALL"		},
-	{ "ATAPI CD-ROM DRIVE 40X MAXIMUM",	"ALL"		},
-	{ "_NEC DV5800A",               "ALL"           },  
+	{ "Compaq CRD-8241B"	,	NULL 		},
+	{ "CRD-8400B"		,	NULL 		},
+	{ "CRD-8480B",			NULL 		},
+	{ "CRD-8482B",			NULL 		},
+	{ "CRD-84"		,	NULL 		},
+	{ "SanDisk SDP3B"	,	NULL 		},
+	{ "SanDisk SDP3B-64"	,	NULL 		},
+	{ "SANYO CD-ROM CRD"	,	NULL 		},
+	{ "HITACHI CDR-8"	,	NULL 		},
+	{ "HITACHI CDR-8335"	,	NULL 		},
+	{ "HITACHI CDR-8435"	,	NULL 		},
+	{ "Toshiba CD-ROM XM-6202B"	,	NULL 		},
+	{ "TOSHIBA CD-ROM XM-1702BC",	NULL 		},
+	{ "CD-532E-A"		,	NULL 		},
+	{ "E-IDE CD-ROM CR-840",	NULL 		},
+	{ "CD-ROM Drive/F5A",	NULL 		},
+	{ "WPI CDD-820",		NULL 		},
+	{ "SAMSUNG CD-ROM SC-148C",	NULL 		},
+	{ "SAMSUNG CD-ROM SC",	NULL 		},
+	{ "ATAPI CD-ROM DRIVE 40X MAXIMUM",	NULL 		},
+	{ "_NEC DV5800A",               NULL            },
 	{ "SAMSUNG CD-ROM SN-124",	"N001" },
-	{ "Seagate STT20000A",		"ALL" },
+	{ "Seagate STT20000A",		NULL  },
 	{ NULL			,	NULL		}
 
 };
@@ -147,8 +147,9 @@ int ide_in_drive_list(struct hd_driveid 
 {
 	for ( ; drive_table->id_model ; drive_table++)
 		if ((!strcmp(drive_table->id_model, id->model)) &&
-		    ((strstr(id->fw_rev, drive_table->id_firmware)) ||
-		     (!strcmp(drive_table->id_firmware, "ALL"))))
+		    (!drive_table->id_firmware ||
+		     !strcmp(drive_table->id_firmware, "ALL") || /* to be removed later */
+		     strstr(id->fw_rev, drive_table->id_firmware)))
 			return 1;
 	return 0;
 }
_

Patches currently in -mm which might be from junkio@cox.net are
