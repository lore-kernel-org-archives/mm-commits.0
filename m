From: akpm@linux-foundation.org
Subject: + sound-convert-snd_info_register-to-use-proc_create_data.patch added to -mm tree
Date: Wed, 13 Mar 2013 14:14:48 -0700
Message-ID: <20130313211448.7257F5A43CB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:55799 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931Ab3CMVOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Mar 2013 17:14:49 -0400
Received: by mail-ve0-f202.google.com with SMTP id m1so151913ves.3
        for <mm-commits@vger.kernel.org>; Wed, 13 Mar 2013 14:14:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nzimmer@sgi.com, perex@perex.cz, tiwai@suse.de


The patch titled
     Subject: sound: convert snd_info_register() to use proc_create_data()
has been added to the -mm tree.  Its filename is
     sound-convert-snd_info_register-to-use-proc_create_data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -954,20 +954,20 @@ EXPORT_SYMBOL(snd_info_free_entry);
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
sound-convert-snd_info_register-to-use-proc_create_data.patch
timer_list-split-timer_list_show_tickdevices.patch
timer_list-split-timer_list_show_tickdevices-v4.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
procfs-improve-scaling-in-proc.patch
procfs-improve-scaling-in-proc-v5.patch

