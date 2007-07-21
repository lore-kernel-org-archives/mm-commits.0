From: akpm@linux-foundation.org
Subject: - memory-leak-in-tpm_ascii_bios_measurements_open-fix.patch removed from -mm tree
Date: Sat, 21 Jul 2007 03:25:02 -0700
Message-ID: <200707211025.l6LAP2iR011965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34032 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932685AbXGUKZu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Jul 2007 06:25:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, kjhall@us.ibm.com, munetoh@jp.ibm.com, sailer@watson.ibm.com, stefanb@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Memory leak in tpm_ascii_bios_measurements_open()
has been removed from the -mm tree.  Its filename was
     memory-leak-in-tpm_ascii_bios_measurements_open-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
