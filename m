From: akpm@linux-foundation.org
Subject: + rapidio-use-kobj_to_dev.patch added to -mm tree
Date: Thu, 07 Jan 2016 15:40:50 -0800
Message-ID: <568ef782.5c6tJ6w2xWKF3DrY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34310 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbcAGXkv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2016 18:40:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, Alexandre.Bounine@idt.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio: use kobj_to_dev()
has been added to the -mm tree.  Its filename is
     rapidio-use-kobj_to_dev.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-use-kobj_to_dev.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-use-kobj_to_dev.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: rapidio: use kobj_to_dev()

Use kobj_to_dev() instead of open-coding it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-sysfs.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/rapidio/rio-sysfs.c~rapidio-use-kobj_to_dev drivers/rapidio/rio-sysfs.c
--- a/drivers/rapidio/rio-sysfs.c~rapidio-use-kobj_to_dev
+++ a/drivers/rapidio/rio-sysfs.c
@@ -125,8 +125,7 @@ rio_read_config(struct file *filp, struc
 		struct bin_attribute *bin_attr,
 		char *buf, loff_t off, size_t count)
 {
-	struct rio_dev *dev =
-	    to_rio_dev(container_of(kobj, struct device, kobj));
+	struct rio_dev *dev = to_rio_dev(kobj_to_dev(kobj));
 	unsigned int size = 0x100;
 	loff_t init_off = off;
 	u8 *data = (u8 *) buf;
@@ -197,8 +196,7 @@ rio_write_config(struct file *filp, stru
 		 struct bin_attribute *bin_attr,
 		 char *buf, loff_t off, size_t count)
 {
-	struct rio_dev *dev =
-	    to_rio_dev(container_of(kobj, struct device, kobj));
+	struct rio_dev *dev = to_rio_dev(kobj_to_dev(kobj));
 	unsigned int size = count;
 	loff_t init_off = off;
 	u8 *data = (u8 *) buf;
_

Patches currently in -mm which might be from geliangtang@163.com are

fsnotify-use-list_next_entry-in-fsnotify_unmount_inodes.patch
mm-slab-use-list_first_entry_or_null.patch
mm-slab-use-list_for_each_entry-in-cache_flusharray.patch
mm-slabc-add-a-helper-function-get_first_slab.patch
mm-vmalloc-use-list_nextfirst_entry.patch
mm-thp-use-list_first_entry_or_null.patch
mm-page_allocc-use-list_firstlast_entry-instead-of-list_entry.patch
mm-page_allocc-use-list_for_each_entry-in-mark_free_pages.patch
mm-swapfilec-use-list_nextfirst_entry.patch
mm-readaheadc-mm-vmscanc-use-lru_to_page-instead-of-list_to_page.patch
mm-ksmc-use-list_for_each_entry_safe.patch
mm-swapfilec-use-list_for_each_entry_safe-in-free_swap_count_continuations.patch
mm-move-lru_to_page-to-mm_inlineh.patch
mm-zbud-use-list_last_entry-instead-of-list_tail_entry.patch
hfs-use-list_for_each_entry-in-hfs_cat_delete.patch
kexec-use-list_for_each_entry_safe-in-kimage_free_page_list.patch
rapidio-use-kobj_to_dev.patch
dma-mapping-use-offset_in_page-macro.patch

