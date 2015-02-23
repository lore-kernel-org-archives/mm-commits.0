From: akpm@linux-foundation.org
Subject: + s390-remove-use-of-seq_printf-return-value.patch added to -mm
 tree
Date: Mon, 23 Feb 2015 15:59:08 -0800
Message-ID: <54ebbecc.qbpgmP0WBTe5zXlw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbbBWX7J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 18:59:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, gerald.schaefer@de.ibm.com, heiko.carstens@de.ibm.com, oberpar@linux.vnet.ibm.com, schwidefsky@de.ibm.com, sebott@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390: remove use of seq_printf return value
has been added to the -mm tree.  Its filename is
     s390-remove-use-of-seq_printf-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-remove-use-of-seq_printf-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-remove-use-of-seq_printf-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: s390: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/pci/pci_debug.c    |    6 ++++--
 drivers/s390/cio/blacklist.c |   12 +++++++-----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff -puN arch/s390/pci/pci_debug.c~s390-remove-use-of-seq_printf-return-value arch/s390/pci/pci_debug.c
--- a/arch/s390/pci/pci_debug.c~s390-remove-use-of-seq_printf-return-value
+++ a/arch/s390/pci/pci_debug.c
@@ -45,8 +45,10 @@ static int pci_perf_show(struct seq_file
 
 	if (!zdev)
 		return 0;
-	if (!zdev->fmb)
-		return seq_printf(m, "FMB statistics disabled\n");
+	if (!zdev->fmb) {
+		seq_puts(m, "FMB statistics disabled\n");
+		return 0;
+	}
 
 	/* header */
 	seq_printf(m, "FMB @ %p\n", zdev->fmb);
diff -puN drivers/s390/cio/blacklist.c~s390-remove-use-of-seq_printf-return-value drivers/s390/cio/blacklist.c
--- a/drivers/s390/cio/blacklist.c~s390-remove-use-of-seq_printf-return-value
+++ a/drivers/s390/cio/blacklist.c
@@ -330,18 +330,20 @@ cio_ignore_proc_seq_show(struct seq_file
 	if (!iter->in_range) {
 		/* First device in range. */
 		if ((iter->devno == __MAX_SUBCHANNEL) ||
-		    !is_blacklisted(iter->ssid, iter->devno + 1))
+		    !is_blacklisted(iter->ssid, iter->devno + 1)) {
 			/* Singular device. */
-			return seq_printf(s, "0.%x.%04x\n",
-					  iter->ssid, iter->devno);
+			seq_printf(s, "0.%x.%04x\n", iter->ssid, iter->devno);
+			return 0;
+		}
 		iter->in_range = 1;
-		return seq_printf(s, "0.%x.%04x-", iter->ssid, iter->devno);
+		seq_printf(s, "0.%x.%04x-", iter->ssid, iter->devno);
+		return 0;
 	}
 	if ((iter->devno == __MAX_SUBCHANNEL) ||
 	    !is_blacklisted(iter->ssid, iter->devno + 1)) {
 		/* Last device in range. */
 		iter->in_range = 0;
-		return seq_printf(s, "0.%x.%04x\n", iter->ssid, iter->devno);
+		seq_printf(s, "0.%x.%04x\n", iter->ssid, iter->devno);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from joe@perches.com are

staging-lustre-convert-return-seq_printf-uses.patch
staging-lustre-convert-seq_-hash-functions-to-return-void.patch
staging-lustre-convert-uses-of-int-rc-=-seq_printf.patch
staging-lustre-convert-remaining-uses-of-=-seq_printf.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
pxa27x_udc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
mfd-ab8500-debugfs-remove-use-of-seq_printf-return-value.patch
staging-i2o-remove-use-of-seq_printf-return-value.patch
staging-rtl8192x-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
i8k-remove-use-of-seq_printf-return-value.patch
watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
regulator-dbx500-remove-use-of-seq_puts-seq_printf-return-value.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
linux-next.patch

