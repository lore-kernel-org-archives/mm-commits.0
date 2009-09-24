From: akpm@linux-foundation.org
Subject: [nacked] scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch removed from -mm tree
Date: Thu, 24 Sep 2009 14:34:30 -0700
Message-ID: <200909242134.n8OLYUU2010204@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751697AbZIXVe4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 17:34:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     scsi: use the common hex_asc array rather than a private one
has been removed from the -mm tree.  Its filename was
     scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: use the common hex_asc array rather than a private one
From: Harvey Harrison <harvey.harrison@gmail.com>

Also use the hi/lo helpers.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ibmmca.c    |    3 +--
 drivers/scsi/ultrastor.c |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/ibmmca.c~scsi-use-the-common-hex_asc-array-rather-than-a-private-one drivers/scsi/ibmmca.c
--- a/drivers/scsi/ibmmca.c~scsi-use-the-common-hex_asc-array-rather-than-a-private-one
+++ a/drivers/scsi/ibmmca.c
@@ -1002,12 +1002,11 @@ static char *ti_p(int dev)
 /* interpreter for logical device numbers (ldn) */
 static char *ti_l(int val)
 {
-	const char hex[16] = "0123456789abcdef";
 	static char answer[2];
 
 	answer[1] = (char) (0x0);
 	if (val <= MAX_LOG_DEV)
-		answer[0] = hex[val];
+		answer[0] = hex_asc[val];
 	else
 		answer[0] = '-';
 	return (char *) &answer;
diff -puN drivers/scsi/ultrastor.c~scsi-use-the-common-hex_asc-array-rather-than-a-private-one drivers/scsi/ultrastor.c
--- a/drivers/scsi/ultrastor.c~scsi-use-the-common-hex_asc-array-rather-than-a-private-one
+++ a/drivers/scsi/ultrastor.c
@@ -876,8 +876,8 @@ static int ultrastor_abort(struct scsi_c
 	for (i = 0; i < 16; i++)
 	  {
 	    unsigned char p = inb(port0 + i);
-	    out[28 + i * 3] = "0123456789abcdef"[p >> 4];
-	    out[29 + i * 3] = "0123456789abcdef"[p & 15];
+	    out[28 + i * 3] = hex_asc_hi(p);
+	    out[29 + i * 3] = hex_asc_lo(p);
 	    out[30 + i * 3] = ' ';
 	  }
 	out[28 + i * 3] = '\n';
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch

