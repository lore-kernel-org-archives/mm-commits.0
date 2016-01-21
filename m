From: akpm@linux-foundation.org
Subject: [merged]
 kexec-use-list_for_each_entry_safe-in-kimage_free_page_list.patch removed
 from -mm tree
Date: Thu, 21 Jan 2016 15:00:15 -0800
Message-ID: <56a162ff.Y1j2Zk7r8yZJ8bOr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbcAUXAQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:00:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, bhe@redhat.com, dyoung@redhat.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/kexec_core.c: use list_for_each_entry_safe in kimage_free_page_list
has been removed from the -mm tree.  Its filename was
     kexec-use-list_for_each_entry_safe-in-kimage_free_page_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: kernel/kexec_core.c: use list_for_each_entry_safe in kimage_free_page_list

Use list_for_each_entry_safe() instead of list_for_each_safe() to
simplify the code.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
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
