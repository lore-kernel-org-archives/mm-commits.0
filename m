From: akpm@linux-foundation.org
Subject: + oss-trident-switch-from-write_proc.patch added to -mm tree
Date: Tue, 13 May 2008 13:40:02 -0700
Message-ID: <200805132040.m4DKe2j1031109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760805AbYEMUkX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 16:40:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     OSS trident: switch from ->write_proc
has been added to the -mm tree.  Its filename is
     oss-trident-switch-from-write_proc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: OSS trident: switch from ->write_proc
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/trident.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN sound/oss/trident.c~oss-trident-switch-from-write_proc sound/oss/trident.c
--- a/sound/oss/trident.c~oss-trident-switch-from-write_proc
+++ a/sound/oss/trident.c
@@ -4028,10 +4028,10 @@ ali_free_other_states_resources(struct t
 
 static struct proc_dir_entry *res;
 
-static int
-ali_write_proc(struct file *file, const char __user *buffer, unsigned long count, void *data)
+static ssize_t
+ali_write_proc(struct file *file, const char __user *buffer, size_t count, loff_t *ppos)
 {
-	struct trident_card *card = (struct trident_card *) data;
+	struct trident_card *card = PDE(file->f_path.dentry->d_inode)->data;
 	unsigned long flags;
 	char c;
 
@@ -4068,6 +4068,11 @@ ali_write_proc(struct file *file, const 
 	return count;
 }
 
+static const struct file_operations ali_proc_fops = {
+	.owner	= THIS_MODULE,
+	.write	= ali_write_proc,
+};
+
 /* OSS /dev/mixer file operation methods */
 static int
 trident_open_mixdev(struct inode *inode, struct file *file)
@@ -4441,11 +4446,8 @@ trident_probe(struct pci_dev *pci_dev, c
 		/* ALi SPDIF OUT function */
 		if (card->revision == ALI_5451_V02) {
 			ali_setup_spdif_out(card, ALI_PCM_TO_SPDIF_OUT);
-			res = create_proc_entry("ALi5451", 0, NULL);
-			if (res) {
-				res->write_proc = ali_write_proc;
-				res->data = card;
-			}
+			proc_create_data("ALi5451", 0, NULL,
+					 &ali_proc_fops, card);
 		}
 
 		/* Add H/W Volume Control By Matt Wu Jul. 06, 2001 */
_

Patches currently in -mm which might be from adobriyan@gmail.com are

cpumask-remove-bitmap_scnprintf_len-and-cpumask_scnprintf_len.patch
linux-next.patch
cifs-switch-to-seq_files.patch
jfs-switch-to-seq_files.patch
git-kbuild-fixes.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
rndis-switch-to-seq_files.patch
rndis-switch-to-seq_files-checkpatch-fixes.patch
oss-trident-switch-from-write_proc.patch
ext4-switch-to-seq_files.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

