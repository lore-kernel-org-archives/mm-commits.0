From: akpm@linux-foundation.org
Subject: [merged] scsi-replace-strnicmp-with-strncasecmp.patch removed
 from -mm tree
Date: Tue, 14 Oct 2014 11:22:20 -0700
Message-ID: <543d69dc.zATGF4GBKjBQOZuV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582AbaJNSWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:22:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: replace strnicmp with strncasecmp
has been removed from the -mm tree.  Its filename was
     scsi-replace-strnicmp-with-strncasecmp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: scsi: replace strnicmp with strncasecmp

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics and a
slightly buggy strncasecmp.  The latter is the POSIX name, so strnicmp was
renamed to strncasecmp, and strnicmp made into a wrapper for the new
strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in the
future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ips.c        |    2 +-
 drivers/scsi/scsi_debug.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ips.c~scsi-replace-strnicmp-with-strncasecmp drivers/scsi/ips.c
--- a/drivers/scsi/ips.c~scsi-replace-strnicmp-with-strncasecmp
+++ a/drivers/scsi/ips.c
@@ -528,7 +528,7 @@ ips_setup(char *ips_str)
 		 * Update the variables
 		 */
 		for (i = 0; i < ARRAY_SIZE(options); i++) {
-			if (strnicmp
+			if (strncasecmp
 			    (key, options[i].option_name,
 			     strlen(options[i].option_name)) == 0) {
 				if (value)
diff -puN drivers/scsi/scsi_debug.c~scsi-replace-strnicmp-with-strncasecmp drivers/scsi/scsi_debug.c
--- a/drivers/scsi/scsi_debug.c~scsi-replace-strnicmp-with-strncasecmp
+++ a/drivers/scsi/scsi_debug.c
@@ -3371,7 +3371,7 @@ static ssize_t opts_store(struct device_
 	char work[20];
 
         if (1 == sscanf(buf, "%10s", work)) {
-		if (0 == strnicmp(work,"0x", 2)) {
+		if (0 == strncasecmp(work,"0x", 2)) {
 			if (1 == sscanf(&work[2], "%x", &opts))
 				goto opts_done;
 		} else {
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

