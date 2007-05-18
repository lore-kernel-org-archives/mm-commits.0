From: akpm@linux-foundation.org
Subject: + make-input-layer-use-seq_list_xxx-helpers.patch added to -mm tree
Date: Fri, 18 May 2007 10:37:44 -0700
Message-ID: <200705181737.l4IHbiZD019860@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from [207.189.120.14] ([207.189.120.14]:56841 "EHLO
	smtp2.linux-foundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753742AbXERRl0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 13:41:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@sw.ru, dtor@mail.ru, xemul@openvz.org


The patch titled
     Make input layer use seq_list_xxx helpers
has been added to the -mm tree.  Its filename is
     make-input-layer-use-seq_list_xxx-helpers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

make-common-helpers-for-seq_files-that-work-with-list_head-s.patch
make-afs-use-seq_list_xxx-helpers.patch
make-atm-driver-use-seq_list_xxx-helpers.patch
make-block-layer-proc-files-use-seq_list_xxx-helpers.patch
make-crypto-api-use-seq_list_xxx-helpers.patch
make-input-layer-use-seq_list_xxx-helpers.patch
make-isdn-capi-use-seq_list_xxx-helpers.patch
make-proc-misc-use-seq_list_xxx-helpers.patch
make-proc-modules-use-seq_list_xxx-helpers.patch
make-some-network-related-proc-files-use-seq_list_xxx.patch
make-some-netfilter-related-proc-files-use-seq_list_xxx.patch
make-nfs-client-use-seq_list_xxx-helpers.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
make-proc-self-mountstats-use-seq_list_xxx-helpers.patch
