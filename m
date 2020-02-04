From: akpm@linux-foundation.org
Subject: [folded-merged]
 proc-convert-everything-to-struct-proc_ops-fix.patch removed from -mm tree
Date: Mon, 03 Feb 2020 17:12:35 -0800
Message-ID: <20200204011235.sOm8dNUGc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726834AbgBDBMg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:12:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-convert-everything-to-struct-proc_ops-fix
has been removed from the -mm tree.  Its filename was
     proc-convert-everything-to-struct-proc_ops-fix.patch

This patch was dropped because it was folded into proc-convert-everything-to-struct-proc_ops.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-convert-everything-to-struct-proc_ops-fix

fix drivers/isdn/capi/kcapi_proc.c

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/kcapi_proc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/isdn/capi/kcapi_proc.c~proc-convert-everything-to-struct-proc_ops-fix
+++ a/drivers/isdn/capi/kcapi_proc.c
@@ -199,8 +199,8 @@ static ssize_t empty_read(struct file *f
 	return 0;
 }
 
-static const struct file_operations empty_fops = {
-	.read	= empty_read,
+static const struct proc_ops empty_proc_ops = {
+	.proc_read	= empty_read,
 };
 
 // ---------------------------------------------------------------------------
@@ -214,7 +214,7 @@ kcapi_proc_init(void)
 	proc_create_seq("capi/contrstats",   0, NULL, &seq_contrstats_ops);
 	proc_create_seq("capi/applications", 0, NULL, &seq_applications_ops);
 	proc_create_seq("capi/applstats",    0, NULL, &seq_applstats_ops);
-	proc_create("capi/driver",           0, NULL, &empty_fops);
+	proc_create("capi/driver",           0, NULL, &empty_proc_ops);
 }
 
 void
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ipc-consolidate-all-xxxctl_down-functions.patch
drivers-block-null_blk_mainc-fix-layout.patch
drivers-block-null_blk_mainc-fix-uninitialized-var-warnings.patch
proc-convert-everything-to-struct-proc_ops.patch
