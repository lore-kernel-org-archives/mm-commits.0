From: akpm@linux-foundation.org
Subject: + memory-leak-in-tpm_ascii_bios_measurements_open-fix.patch added to -mm tree
Date: Thu, 19 Jul 2007 23:28:03 -0700
Message-ID: <200707200628.l6K6S3EE011437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52894 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753664AbXGTG2e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 02:28:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, kjhall@us.ibm.com, munetoh@jp.ibm.com, sailer@watson.ibm.com, stefanb@us.ibm.com


The patch titled
     Memory leak in tpm_ascii_bios_measurements_open()
has been added to the -mm tree.  Its filename is
     memory-leak-in-tpm_ascii_bios_measurements_open-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Memory leak in tpm_ascii_bios_measurements_open()
From: Jesper Juhl <jesper.juhl@gmail.com>

Coverity found a memory leak in tpm_ascii_bios_measurements_open().

If "read_log(log)" fails, then we may leak 'log' and
'log->bios_event_log'.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Seiji Munetoh <munetoh@jp.ibm.com>
Cc: Stefan Berger <stefanb@us.ibm.com>
Cc: Reiner Sailer <sailer@watson.ibm.com>
Cc: Kylene Hall <kjhall@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm_bios.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/char/tpm/tpm_bios.c~memory-leak-in-tpm_ascii_bios_measurements_open-fix drivers/char/tpm/tpm_bios.c
--- a/drivers/char/tpm/tpm_bios.c~memory-leak-in-tpm_ascii_bios_measurements_open-fix
+++ a/drivers/char/tpm/tpm_bios.c
@@ -427,7 +427,7 @@ static int tpm_ascii_bios_measurements_o
 		return -ENOMEM;
 
 	if ((err = read_log(log)))
-		return err;
+		goto out_free;
 
 	/* now register seq file */
 	err = seq_open(file, &tpm_ascii_b_measurments_seqops);
@@ -435,10 +435,15 @@ static int tpm_ascii_bios_measurements_o
 		seq = file->private_data;
 		seq->private = log;
 	} else {
-		kfree(log->bios_event_log);
-		kfree(log);
+		goto out_free;
 	}
+
+out:
 	return err;
+out_free:
+	kfree(log->bios_event_log);
+	kfree(log);
+	goto out;
 }
 
 const struct file_operations tpm_ascii_bios_measurements_ops = {
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
cr_backlight_probe-allocates-too-little-storage-for-struct-cr_panel.patch
memory-leak-in-tpm_ascii_bios_measurements_open-fix.patch
fix-acpi_ev_pci_config_region_setup-to-avoid-memory-leak.patch
git-gfs2-nmw.patch
git-mtd.patch
git-xfs.patch
ipmi-fix-mem-leak-in-try_init_dmi.patch
fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
