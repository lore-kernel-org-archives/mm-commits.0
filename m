From: akpm@linux-foundation.org
Subject: [merged] fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:28:07 -0700
Message-ID: <53960ac7.B5k4EDHFeBN04v6z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbaFIT2H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:28:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sage@inktank.com, fabf@skynet.be

Subject: [merged] fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch removed from -mm tree
To: fabf@skynet.be,sage@inktank.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:28:07 -0700


The patch titled
     Subject: fs/ceph/debugfs.c: replace seq_printf by seq_puts
has been removed from the -mm tree.  Its filename was
     fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ceph/debugfs.c: replace seq_printf by seq_puts

Replace seq_printf where possible.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Sage Weil <sage@inktank.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ceph/debugfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ceph/debugfs.c~fs-ceph-debugfsc-replace-seq_printf-by-seq_puts fs/ceph/debugfs.c
--- a/fs/ceph/debugfs.c~fs-ceph-debugfsc-replace-seq_printf-by-seq_puts
+++ a/fs/ceph/debugfs.c
@@ -71,9 +71,9 @@ static int mdsc_show(struct seq_file *s,
 		seq_printf(s, "%s", ceph_mds_op_name(req->r_op));
 
 		if (req->r_got_unsafe)
-			seq_printf(s, "\t(unsafe)");
+			seq_puts(s, "\t(unsafe)");
 		else
-			seq_printf(s, "\t");
+			seq_puts(s, "\t");
 
 		if (req->r_inode) {
 			seq_printf(s, " #%llx", ceph_ino(req->r_inode));
@@ -119,7 +119,7 @@ static int mdsc_show(struct seq_file *s,
 				seq_printf(s, " %s", req->r_path2);
 		}
 
-		seq_printf(s, "\n");
+		seq_puts(s, "\n");
 	}
 	mutex_unlock(&mdsc->mutex);
 
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

