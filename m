From: akpm@linux-foundation.org
Subject: - oss-trident-switch-from-write_proc.patch removed from -mm tree
Date: Mon, 19 May 2008 14:21:41 -0700
Message-ID: <200805192121.m4JLLfii021106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762877AbYESVX0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 17:23:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, muli@il.ibm.com, mm-commits@vger.kernel.org


The patch titled
     OSS trident: switch from ->write_proc
has been removed from the -mm tree.  Its filename was
     oss-trident-switch-from-write_proc.patch

This patch was dropped because that driver willbe removed

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: OSS trident: switch from ->write_proc
From: Alexey Dobriyan <adobriyan@gmail.com>

[muli@il.ibm.com: don't leak the proc entry]
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
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
+			res = proc_create_data("ALi5451", 0, NULL,
+					       &ali_proc_fops, card);
 		}
 
 		/* Add H/W Volume Control By Matt Wu Jul. 06, 2001 */
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
cifs-switch-to-seq_files.patch
git-kbuild-fixes.patch
atl1-fix-4g-memory-corruption-bug.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
rndis-switch-to-seq_files.patch
oss-trident-switch-from-write_proc.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
split-listh-and-move-rcu-protected-lists-into-rculisth.patch
rculisth-use-the-rcu-api.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

