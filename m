From: akpm@linux-foundation.org
Subject: [merged] fs-hfsplus-optionsc-replace-seq_printf-by-seq_puts.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:32:02 -0700
Message-ID: <53960bb2.CqMtn7d48P9LbmzS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaFITcD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:32:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, slava@dubeyko.com, fabf@skynet.be

Subject: [merged] fs-hfsplus-optionsc-replace-seq_printf-by-seq_puts.patch removed from -mm tree
To: fabf@skynet.be,slava@dubeyko.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:32:02 -0700


The patch titled
     Subject: fs/hfsplus/options.c: replace seq_printf by seq_puts
has been removed from the -mm tree.  Its filename was
     fs-hfsplus-optionsc-replace-seq_printf-by-seq_puts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/hfsplus/options.c: replace seq_printf by seq_puts

Replace seq_printf where possible

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/options.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN fs/hfsplus/options.c~fs-hfsplus-optionsc-replace-seq_printf-by-seq_puts fs/hfsplus/options.c
--- a/fs/hfsplus/options.c~fs-hfsplus-optionsc-replace-seq_printf-by-seq_puts
+++ a/fs/hfsplus/options.c
@@ -173,9 +173,8 @@ int hfsplus_parse_options(char *input, s
 			if (p)
 				sbi->nls = load_nls(p);
 			if (!sbi->nls) {
-				pr_err("unable to load "
-						"nls mapping \"%s\"\n",
-					p);
+				pr_err("unable to load nls mapping \"%s\"\n",
+				       p);
 				kfree(p);
 				return 0;
 			}
@@ -232,8 +231,8 @@ int hfsplus_show_options(struct seq_file
 	if (sbi->nls)
 		seq_printf(seq, ",nls=%s", sbi->nls->charset);
 	if (test_bit(HFSPLUS_SB_NODECOMPOSE, &sbi->flags))
-		seq_printf(seq, ",nodecompose");
+		seq_puts(seq, ",nodecompose");
 	if (test_bit(HFSPLUS_SB_NOBARRIER, &sbi->flags))
-		seq_printf(seq, ",nobarrier");
+		seq_puts(seq, ",nobarrier");
 	return 0;
 }
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

