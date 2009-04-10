From: akpm@linux-foundation.org
Subject: + at25-make-input-buffers-of-at25_write-const.patch added to -mm tree
Date: Thu, 09 Apr 2009 22:02:41 -0700
Message-ID: <200904100503.n3A52fLi001098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754030AbZDJFIP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 01:08:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, dbrownell@users.sourceforge.net, khali@linux-fr.org, khilman@deeprootsystems.com


The patch titled
     at25: make input buffers of at25_*write() const
has been added to the -mm tree.  Its filename is
     at25-make-input-buffers-of-at25_write-const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: at25: make input buffers of at25_*write() const
From: Geert Uytterhoeven <geert@linux-m68k.org>

| drivers/misc/eeprom/at25.c:358: warning: assignment from incompatible pointer type

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/eeprom/at25.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/misc/eeprom/at25.c~at25-make-input-buffers-of-at25_write-const drivers/misc/eeprom/at25.c
--- a/drivers/misc/eeprom/at25.c~at25-make-input-buffers-of-at25_write-const
+++ a/drivers/misc/eeprom/at25.c
@@ -140,7 +140,8 @@ at25_bin_read(struct kobject *kobj, stru
 
 
 static ssize_t
-at25_ee_write(struct at25_data *at25, char *buf, loff_t off, size_t count)
+at25_ee_write(struct at25_data *at25, const char *buf, loff_t off,
+	      size_t count)
 {
 	ssize_t			status = 0;
 	unsigned		written = 0;
@@ -276,7 +277,7 @@ static ssize_t at25_mem_read(struct memo
 	return at25_ee_read(at25, buf, offset, count);
 }
 
-static ssize_t at25_mem_write(struct memory_accessor *mem, char *buf,
+static ssize_t at25_mem_write(struct memory_accessor *mem, const char *buf,
 			  off_t offset, size_t count)
 {
 	struct at25_data *at25 = container_of(mem, struct at25_data, mem);
_

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
drivers-input-serio-hp_sdcc-fix-crash-when-removing-hp_sdc-module.patch
staging-agnx-make-input-parameters-const.patch
at24-make-input-buffers-of-at24_write-const.patch
at25-make-input-buffers-of-at25_write-const.patch
m68k-count-can-reach-51-not-50.patch
flat-fix-data-sections-alignment.patch

