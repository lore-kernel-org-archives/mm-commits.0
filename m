From: akpm@linux-foundation.org
Subject: + sgi-gru-add-statistics-to-the-gru-context-management-functions.patch added to -mm tree
Date: Tue, 27 Jan 2009 16:25:02 -0800
Message-ID: <200901280025.n0S0P22F004727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716AbZA1AZG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 19:25:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     sgi-gru: add statistics to the GRU context management functions
has been added to the -mm tree.  Its filename is
     sgi-gru-add-statistics-to-the-gru-context-management-functions.patch

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
Subject: sgi-gru: add statistics to the GRU context management functions
From: Jack Steiner <steiner@sgi.com>

Add statistics to the GRU context management functions.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/gruhandles.c |   12 ++++++++
 drivers/misc/sgi-gru/gruprocfs.c  |   39 ++++++++++++++++++++++++++++
 drivers/misc/sgi-gru/grutables.h  |    8 +++++
 3 files changed, 59 insertions(+)

diff -puN drivers/misc/sgi-gru/gruhandles.c~sgi-gru-add-statistics-to-the-gru-context-management-functions drivers/misc/sgi-gru/gruhandles.c
--- a/drivers/misc/sgi-gru/gruhandles.c~sgi-gru-add-statistics-to-the-gru-context-management-functions
+++ a/drivers/misc/sgi-gru/gruhandles.c
@@ -35,6 +35,16 @@
 /* Extract the status field from a kernel handle */
 #define GET_MSEG_HANDLE_STATUS(h)	(((*(unsigned long *)(h)) >> 16) & 3)
 
+struct mcs_op_statistic mcs_op_statistics[mcsop_last];
+
+static void update_mcs_stats(enum mcs_op op, unsigned long clks)
+{
+	atomic_long_inc(&mcs_op_statistics[op].count);
+	atomic_long_add(clks, &mcs_op_statistics[op].total);
+	if (mcs_op_statistics[op].max < clks)
+		mcs_op_statistics[op].max = clks;
+}
+
 static void start_instruction(void *h)
 {
 	unsigned long *w0 = h;
@@ -57,6 +67,8 @@ static int wait_instruction_complete(voi
 		if (GRU_OPERATION_TIMEOUT < (get_cycles() - start_time))
 			panic("GRU %p is malfunctioning\n", h);
 	}
+	if (gru_options & OPT_STATS)
+		update_mcs_stats(opc, get_cycles() - start_time);
 	return status;
 }
 
diff -puN drivers/misc/sgi-gru/gruprocfs.c~sgi-gru-add-statistics-to-the-gru-context-management-functions drivers/misc/sgi-gru/gruprocfs.c
--- a/drivers/misc/sgi-gru/gruprocfs.c~sgi-gru-add-statistics-to-the-gru-context-management-functions
+++ a/drivers/misc/sgi-gru/gruprocfs.c
@@ -122,6 +122,30 @@ static ssize_t statistics_write(struct f
 	return count;
 }
 
+static int mcs_statistics_show(struct seq_file *s, void *p)
+{
+	int op;
+	unsigned long total, count, max;
+	static char *id[] = {"cch_allocate", "cch_start", "cch_interrupt",
+		"cch_interrupt_sync", "cch_deallocate", "tgh_invalidate"};
+
+	for (op = 0; op < mcsop_last; op++) {
+		count = atomic_long_read(&mcs_op_statistics[op].count);
+		total = atomic_long_read(&mcs_op_statistics[op].total);
+		max = mcs_op_statistics[op].max;
+		seq_printf(s, "%-20s%12ld%12ld%12ld\n", id[op], count,
+			   count ? total / count : 0, max);
+	}
+	return 0;
+}
+
+static ssize_t mcs_statistics_write(struct file *file,
+			const char __user *userbuf, size_t count, loff_t *data)
+{
+	memset(mcs_op_statistics, 0, sizeof(mcs_op_statistics));
+	return count;
+}
+
 static int options_show(struct seq_file *s, void *p)
 {
 	seq_printf(s, "0x%lx\n", gru_options);
@@ -137,6 +161,7 @@ static ssize_t options_write(struct file
 	if (copy_from_user
 	    (buf, userbuf, count < sizeof(buf) ? count : sizeof(buf)))
 		return -EFAULT;
+	buf[count - 1] = '\0';
 	if (!strict_strtoul(buf, 10, &val))
 		gru_options = val;
 
@@ -233,6 +258,11 @@ static int statistics_open(struct inode 
 	return single_open(file, statistics_show, NULL);
 }
 
+static int mcs_statistics_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, mcs_statistics_show, NULL);
+}
+
 static int options_open(struct inode *inode, struct file *file)
 {
 	return single_open(file, options_show, NULL);
@@ -257,6 +287,14 @@ static const struct file_operations stat
 	.release 	= single_release,
 };
 
+static const struct file_operations mcs_statistics_fops = {
+	.open 		= mcs_statistics_open,
+	.read 		= seq_read,
+	.write 		= mcs_statistics_write,
+	.llseek 	= seq_lseek,
+	.release 	= single_release,
+};
+
 static const struct file_operations options_fops = {
 	.open 		= options_open,
 	.read 		= seq_read,
@@ -285,6 +323,7 @@ static struct proc_entry {
 	struct proc_dir_entry *entry;
 } proc_files[] = {
 	{"statistics", 0644, &statistics_fops},
+	{"mcs_statistics", 0644, &mcs_statistics_fops},
 	{"debug_options", 0644, &options_fops},
 	{"cch_status", 0444, &cch_fops},
 	{"gru_status", 0444, &gru_fops},
diff -puN drivers/misc/sgi-gru/grutables.h~sgi-gru-add-statistics-to-the-gru-context-management-functions drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~sgi-gru-add-statistics-to-the-gru-context-management-functions
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -242,6 +242,14 @@ struct gru_stats_s {
 enum mcs_op {cchop_allocate, cchop_start, cchop_interrupt, cchop_interrupt_sync,
 	cchop_deallocate, tghop_invalidate, mcsop_last};
 
+struct mcs_op_statistic {
+	atomic_long_t	count;
+	atomic_long_t	total;
+	unsigned long	max;
+};
+
+extern struct mcs_op_statistic mcs_op_statistics[mcsop_last];
+
 #define OPT_DPRINT	1
 #define OPT_STATS	2
 #define GRU_QUICKLOOK	4
_

Patches currently in -mm which might be from steiner@sgi.com are

sgi-gru-add-definitions-of-x86_64-gru-mmrs.patch
sgi-gru-add-definitions-of-ia64-gru-mmrs.patch
sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts.patch
sgi-gru-misc-gru-cleanup.patch
sgi-gru-improvements-to-gru-debug-messages-statistics.patch
sgi-gru-change-gru-cch-commands-from-inline-functions-to-outofline-functions.patch
sgi-gru-add-statistics-to-the-gru-context-management-functions.patch
sgi-gru-add-support-for-a-user-to-explicitly-unload-a-gru-context.patch
sgi-gru-asid-context-management-bug-fixes.patch
sgi-gru-restructure-the-gru-vtop-functions.patch
sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts.patch
sgi-gru-macro-for-scanning-all-gru-chiplets.patch
sgi-gru-fix-bugs-related-to-module-unload-of-the-gru-driver.patch
sgi-gru-support-multiple-pagesizes-in-gru.patch

