From: akpm@linux-foundation.org
Subject: - drivers-scsi-sr_vendorc-use-bcd2bin.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:37:58 -0700
Message-ID: <200810202037.m9KKbwuf011755@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754177AbYJTUqp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/sr_vendor.c: use bcd2bin
has been removed from the -mm tree.  Its filename was
     drivers-scsi-sr_vendorc-use-bcd2bin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi/sr_vendor.c: use bcd2bin
From: Adrian Bunk <bunk@kernel.org>

Change sr_vendor.c to use the new bcd2bin function instead of the obsolete
BCD2BIN macro.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sr_vendor.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/sr_vendor.c~drivers-scsi-sr_vendorc-use-bcd2bin drivers/scsi/sr_vendor.c
--- a/drivers/scsi/sr_vendor.c~drivers-scsi-sr_vendorc-use-bcd2bin
+++ a/drivers/scsi/sr_vendor.c
@@ -223,9 +223,9 @@ int sr_cd_check(struct cdrom_device_info
 				no_multi = 1;
 				break;
 			}
-			min = BCD2BIN(buffer[15]);
-			sec = BCD2BIN(buffer[16]);
-			frame = BCD2BIN(buffer[17]);
+			min = bcd2bin(buffer[15]);
+			sec = bcd2bin(buffer[16]);
+			frame = bcd2bin(buffer[17]);
 			sector = min * CD_SECS * CD_FRAMES + sec * CD_FRAMES + frame;
 			break;
 		}
@@ -252,9 +252,9 @@ int sr_cd_check(struct cdrom_device_info
 			}
 			if (rc != 0)
 				break;
-			min = BCD2BIN(buffer[1]);
-			sec = BCD2BIN(buffer[2]);
-			frame = BCD2BIN(buffer[3]);
+			min = bcd2bin(buffer[1]);
+			sec = bcd2bin(buffer[2]);
+			frame = bcd2bin(buffer[3]);
 			sector = min * CD_SECS * CD_FRAMES + sec * CD_FRAMES + frame;
 			if (sector)
 				sector -= CD_MSF_OFFSET;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-kernel-smpbootc-must-include-linux-cpuh.patch
the-overdue-eepro100-removal.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
reiser4.patch

