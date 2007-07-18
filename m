From: akpm@linux-foundation.org
Subject: - make-input-layer-use-seq_list_xxx-helpers.patch removed from -mm tree
Date: Wed, 18 Jul 2007 11:52:12 -0700
Message-ID: <200707181852.l6IIqCgV023645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56982 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759495AbXGRSxc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 14:53:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@sw.ru, dtor@mail.ru, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Make input layer use seq_list_xxx helpers
has been removed from the -mm tree.  Its filename was
     make-input-layer-use-seq_list_xxx-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make input layer use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

This is essentially just a renaming of the existing functions as the
seq_list_start() and seq_list_next() copies already exist in the input.c file.
Now we have them in the generic place.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/input.c |   29 ++++-------------------------
 1 files changed, 4 insertions(+), 25 deletions(-)

diff -puN drivers/input/input.c~make-input-layer-use-seq_list_xxx-helpers drivers/input/input.c
--- a/drivers/input/input.c~make-input-layer-use-seq_list_xxx-helpers
+++ a/drivers/input/input.c
@@ -471,37 +471,16 @@ static unsigned int input_proc_devices_p
 	return 0;
 }
 
-static struct list_head *list_get_nth_element(struct list_head *list, loff_t *pos)
-{
-	struct list_head *node;
-	loff_t i = 0;
-
-	list_for_each(node, list)
-		if (i++ == *pos)
-			return node;
-
-	return NULL;
-}
-
-static struct list_head *list_get_next_element(struct list_head *list, struct list_head *element, loff_t *pos)
-{
-	if (element->next == list)
-		return NULL;
-
-	++(*pos);
-	return element->next;
-}
-
 static void *input_devices_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	/* acquire lock here ... Yes, we do need locking, I knowi, I know... */
 
-	return list_get_nth_element(&input_dev_list, pos);
+	return seq_list_start(&input_dev_list, *pos);
 }
 
 static void *input_devices_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	return list_get_next_element(&input_dev_list, v, pos);
+	return seq_list_next(v, &input_dev_list, pos);
 }
 
 static void input_devices_seq_stop(struct seq_file *seq, void *v)
@@ -592,13 +571,13 @@ static void *input_handlers_seq_start(st
 {
 	/* acquire lock here ... Yes, we do need locking, I knowi, I know... */
 	seq->private = (void *)(unsigned long)*pos;
-	return list_get_nth_element(&input_handler_list, pos);
+	return seq_list_start(&input_handler_list, *pos);
 }
 
 static void *input_handlers_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	seq->private = (void *)(unsigned long)(*pos + 1);
-	return list_get_next_element(&input_handler_list, v, pos);
+	return seq_list_next(v, &input_handler_list, pos);
 }
 
 static void input_handlers_seq_stop(struct seq_file *seq, void *v)
_

Patches currently in -mm which might be from xemul@sw.ru are

origin.patch
git-input.patch
