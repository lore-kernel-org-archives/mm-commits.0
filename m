From: akpm@linux-foundation.org
Subject: [merged] fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:41:16 -0700
Message-ID: <53960ddc.Ifb8Tetk1NzTz+Vj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54386 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaFITlQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:41:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ccaulfie@redhat.com, fabf@skynet.be

Subject: [merged] fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch removed from -mm tree
To: fabf@skynet.be,ccaulfie@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:41:16 -0700


The patch titled
     Subject: fs/dlm/debug_fs.c: replace seq_printf by seq_puts
has been removed from the -mm tree.  Its filename was
     fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/dlm/debug_fs.c: replace seq_printf by seq_puts

Replace seq_printf where possible.  This patch also fixes the following
checkpatch warning "unnecessary whitespace before a quoted newline"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/debug_fs.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN fs/dlm/debug_fs.c~fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts fs/dlm/debug_fs.c
--- a/fs/dlm/debug_fs.c~fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts
+++ a/fs/dlm/debug_fs.c
@@ -68,7 +68,7 @@ static int print_format1_lock(struct seq
 	if (lkb->lkb_wait_type)
 		seq_printf(s, " wait_type: %d", lkb->lkb_wait_type);
 
-	return seq_printf(s, "\n");
+	return seq_puts(s, "\n");
 }
 
 static int print_format1(struct dlm_rsb *res, struct seq_file *s)
@@ -92,31 +92,31 @@ static int print_format1(struct dlm_rsb
 	}
 
 	if (res->res_nodeid > 0)
-		rv = seq_printf(s, "\"  \nLocal Copy, Master is node %d\n",
+		rv = seq_printf(s, "\"\nLocal Copy, Master is node %d\n",
 				res->res_nodeid);
 	else if (res->res_nodeid == 0)
-		rv = seq_printf(s, "\"  \nMaster Copy\n");
+		rv = seq_puts(s, "\"\nMaster Copy\n");
 	else if (res->res_nodeid == -1)
-		rv = seq_printf(s, "\"  \nLooking up master (lkid %x)\n",
+		rv = seq_printf(s, "\"\nLooking up master (lkid %x)\n",
 			   	res->res_first_lkid);
 	else
-		rv = seq_printf(s, "\"  \nInvalid master %d\n",
+		rv = seq_printf(s, "\"\nInvalid master %d\n",
 				res->res_nodeid);
 	if (rv)
 		goto out;
 
 	/* Print the LVB: */
 	if (res->res_lvbptr) {
-		seq_printf(s, "LVB: ");
+		seq_puts(s, "LVB: ");
 		for (i = 0; i < lvblen; i++) {
 			if (i == lvblen / 2)
-				seq_printf(s, "\n     ");
+				seq_puts(s, "\n     ");
 			seq_printf(s, "%02x ",
 				   (unsigned char) res->res_lvbptr[i]);
 		}
 		if (rsb_flag(res, RSB_VALNOTVALID))
-			seq_printf(s, " (INVALID)");
-		rv = seq_printf(s, "\n");
+			seq_puts(s, " (INVALID)");
+		rv = seq_puts(s, "\n");
 		if (rv)
 			goto out;
 	}
@@ -133,21 +133,21 @@ static int print_format1(struct dlm_rsb
 	}
 
 	/* Print the locks attached to this resource */
-	seq_printf(s, "Granted Queue\n");
+	seq_puts(s, "Granted Queue\n");
 	list_for_each_entry(lkb, &res->res_grantqueue, lkb_statequeue) {
 		rv = print_format1_lock(s, lkb, res);
 		if (rv)
 			goto out;
 	}
 
-	seq_printf(s, "Conversion Queue\n");
+	seq_puts(s, "Conversion Queue\n");
 	list_for_each_entry(lkb, &res->res_convertqueue, lkb_statequeue) {
 		rv = print_format1_lock(s, lkb, res);
 		if (rv)
 			goto out;
 	}
 
-	seq_printf(s, "Waiting Queue\n");
+	seq_puts(s, "Waiting Queue\n");
 	list_for_each_entry(lkb, &res->res_waitqueue, lkb_statequeue) {
 		rv = print_format1_lock(s, lkb, res);
 		if (rv)
@@ -157,13 +157,13 @@ static int print_format1(struct dlm_rsb
 	if (list_empty(&res->res_lookup))
 		goto out;
 
-	seq_printf(s, "Lookup Queue\n");
+	seq_puts(s, "Lookup Queue\n");
 	list_for_each_entry(lkb, &res->res_lookup, lkb_rsb_lookup) {
 		rv = seq_printf(s, "%08x %s", lkb->lkb_id,
 				print_lockmode(lkb->lkb_rqmode));
 		if (lkb->lkb_wait_type)
 			seq_printf(s, " wait_type: %d", lkb->lkb_wait_type);
-		rv = seq_printf(s, "\n");
+		rv = seq_puts(s, "\n");
 	}
  out:
 	unlock_rsb(res);
@@ -300,7 +300,7 @@ static int print_format3(struct dlm_rsb
 		else
 			seq_printf(s, " %02x", (unsigned char)r->res_name[i]);
 	}
-	rv = seq_printf(s, "\n");
+	rv = seq_puts(s, "\n");
 	if (rv)
 		goto out;
 
@@ -311,7 +311,7 @@ static int print_format3(struct dlm_rsb
 
 	for (i = 0; i < lvblen; i++)
 		seq_printf(s, " %02x", (unsigned char)r->res_lvbptr[i]);
-	rv = seq_printf(s, "\n");
+	rv = seq_puts(s, "\n");
 	if (rv)
 		goto out;
 
@@ -377,7 +377,7 @@ static int print_format4(struct dlm_rsb
 		else
 			seq_printf(s, " %02x", (unsigned char)r->res_name[i]);
 	}
-	rv = seq_printf(s, "\n");
+	rv = seq_puts(s, "\n");
  out:
 	unlock_rsb(r);
 	return rv;
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

