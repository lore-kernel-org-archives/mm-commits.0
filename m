From: akpm@linux-foundation.org
Subject: +
 kexec-use-list_for_each_entry_safe-in-kimage_free_page_list.patch added to
 -mm tree
Date: Tue, 08 Dec 2015 14:55:54 -0800
Message-ID: <56675ffa.Nsh51nOajZMOEXTK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbbLHWzz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 17:55:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, dyoung@redhat.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/kexec_core.c: use list_for_each_entry_safe in kimage_free_page_list
has been added to the -mm tree.  Its filename is
     kexec-use-list_for_each_entry_safe-in-kimage_free_page_list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-use-list_for_each_entry_safe-in-kimage_free_page_list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-use-list_for_each_entry_safe-in-kimage_free_page_list.patch

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
Subject: kernel/kexec_core.c: use list_for_each_entry_safe in kimage_free_page_list

Use list_for_each_entry_safe() instead of list_for_each_safe() to
simplify the code.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN kernel/kexec_core.c~kexec-use-list_for_each_entry_safe-in-kimage_free_page_list kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-use-list_for_each_entry_safe-in-kimage_free_page_list
+++ a/kernel/kexec_core.c
@@ -310,12 +310,9 @@ static void kimage_free_pages(struct pag
 
 void kimage_free_page_list(struct list_head *list)
 {
-	struct list_head *pos, *next;
+	struct page *page, *next;
 
-	list_for_each_safe(pos, next, list) {
-		struct page *page;
-
-		page = list_entry(pos, struct page, lru);
+	list_for_each_entry_safe(page, next, list, lru) {
 		list_del(&page->lru);
 		kimage_free_pages(page);
 	}
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
mm-zbud-use-list_last_entry-instead-of-list_tail_entry.patch
hfs-use-list_for_each_entry-in-hfs_cat_delete.patch
kexec-use-list_for_each_entry_safe-in-kimage_free_page_list.patch
dma-mapping-use-offset_in_page-macro.patch

