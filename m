From: akpm@linux-foundation.org
Subject: [wrecked] sound-convert-snd_info_register-to-use-proc_create_data.patch removed from -mm tree
Date: Mon, 08 Apr 2013 11:53:26 -0700
Message-ID: <20130408185326.9FF8C5A4005@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:47945 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935223Ab3DHSx2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 14:53:28 -0400
Received: by mail-ia0-f202.google.com with SMTP id p22so1543174iad.5
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 11:53:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nzimmer@sgi.com, perex@perex.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: sound: convert snd_info_register() to use proc_create_data()
has been removed from the -mm tree.  Its filename was
     sound-convert-snd_info_register-to-use-proc_create_data.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: sound: convert snd_info_register() to use proc_create_data()

Convert snd_info_register to use proc_create_data instead of
create_proc_entry.  This corrects a sparse warning introduced by "procfs:
Improve Scaling in proc" It is also a bit cleaner to let proc_create_data
set the ->data and ->proc_fops.

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/core/info.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN sound/core/info.c~sound-convert-snd_info_register-to-use-proc_create_data sound/core/info.c
--- a/sound/core/info.c~sound-convert-snd_info_register-to-use-proc_create_data
+++ a/sound/core/info.c
@@ -949,20 +949,20 @@ EXPORT_SYMBOL(snd_info_free_entry);
 int snd_info_register(struct snd_info_entry * entry)
 {
 	struct proc_dir_entry *root, *p = NULL;
+	const struct file_operations *fops = NULL;
 
 	if (snd_BUG_ON(!entry))
 		return -ENXIO;
 	root = entry->parent == NULL ? snd_proc_root : entry->parent->p;
 	mutex_lock(&info_mutex);
-	p = create_proc_entry(entry->name, entry->mode, root);
+	if (!S_ISDIR(entry->mode))
+		fops = &snd_info_entry_operations;
+	p = proc_create_data(entry->name, entry->mode, root, fops, entry);
 	if (!p) {
 		mutex_unlock(&info_mutex);
 		return -ENOMEM;
 	}
-	if (!S_ISDIR(entry->mode))
-		p->proc_fops = &snd_info_entry_operations;
 	p->size = entry->size;
-	p->data = entry;
 	entry->p = p;
 	if (entry->parent)
 		list_add_tail(&entry->list, &entry->parent->children);
_

Patches currently in -mm which might be from nzimmer@sgi.com are

linux-next.patch
timer_list-split-timer_list_show_tickdevices.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v5.patch
procfs-improve-scaling-in-proc.patch
procfs-improve-scaling-in-proc-v5.patch

