From: akpm@linux-foundation.org
Subject: [merged] at24-make-input-buffers-of-at24_write-const.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:49:44 -0700
Message-ID: <200904141949.n3EJni28019778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752828AbZDNUJA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 16:09:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, dbrownell@users.sourceforge.net, khali@linux-fr.org, khilman@deeprootsystems.com, mm-commits@vger.kernel.org


The patch titled
     at24: make input buffers of at24_*write() const
has been removed from the -mm tree.  Its filename was
     at24-make-input-buffers-of-at24_write-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: at24: make input buffers of at24_*write() const
From: Geert Uytterhoeven <geert@linux-m68k.org>

| drivers/misc/eeprom/at24.c:508: warning: assignment from incompatible pointer
type

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/eeprom/at24.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/misc/eeprom/at24.c~at24-make-input-buffers-of-at24_write-const drivers/misc/eeprom/at24.c
--- a/drivers/misc/eeprom/at24.c~at24-make-input-buffers-of-at24_write-const
+++ a/drivers/misc/eeprom/at24.c
@@ -278,7 +278,7 @@ static ssize_t at24_bin_read(struct kobj
  * We only use page mode writes; the alternative is sloooow. This routine
  * writes at most one page.
  */
-static ssize_t at24_eeprom_write(struct at24_data *at24, char *buf,
+static ssize_t at24_eeprom_write(struct at24_data *at24, const char *buf,
 		unsigned offset, size_t count)
 {
 	struct i2c_client *client;
@@ -347,8 +347,8 @@ static ssize_t at24_eeprom_write(struct 
 	return -ETIMEDOUT;
 }
 
-static ssize_t at24_write(struct at24_data *at24,
-		char *buf, loff_t off, size_t count)
+static ssize_t at24_write(struct at24_data *at24, const char *buf, loff_t off,
+			  size_t count)
 {
 	ssize_t retval = 0;
 
@@ -406,7 +406,7 @@ static ssize_t at24_macc_read(struct mem
 	return at24_read(at24, buf, offset, count);
 }
 
-static ssize_t at24_macc_write(struct memory_accessor *macc, char *buf,
+static ssize_t at24_macc_write(struct memory_accessor *macc, const char *buf,
 			  off_t offset, size_t count)
 {
 	struct at24_data *at24 = container_of(macc, struct at24_data, macc);
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
drivers-input-serio-hp_sdcc-fix-crash-when-removing-hp_sdc-module.patch
agnx-make-input-parameters-const.patch
scsi-a4000-correct-driver-unregistration-in-case-of-failure.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch

