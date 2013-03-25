From: akpm@linux-foundation.org
Subject: + mm-export-split_page.patch added to -mm tree
Date: Mon, 25 Mar 2013 15:47:38 -0700
Message-ID: <20130325224738.71C8F31C174@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:48021 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758655Ab3CYWrj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 18:47:39 -0400
Received: by mail-gg0-f202.google.com with SMTP id q1so124364ggn.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 15:47:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kys@microsoft.com, greg@kroah.com, mhocko@suse.cz


The patch titled
     Subject:  mm: export split_page()
has been added to the -mm tree.  Its filename is
     mm-export-split_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject:  mm: export split_page()

This symbol will be used in the Hyper-V balloon driver to support 2M
allocations.

Signed-off-by: K.  Y.  Srinivasan <kys@microsoft.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page_alloc.c~mm-export-split_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-export-split_page
+++ a/mm/page_alloc.c
@@ -1398,6 +1398,7 @@ void split_page(struct page *page, unsig
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
 }
+EXPORT_SYMBOL_GPL(split_page);
 
 static int __isolate_free_page(struct page *page, unsigned int order)
 {
_

Patches currently in -mm which might be from kys@microsoft.com are

linux-next.patch
mm-export-split_page.patch
drivers-video-add-hyper-v-synthetic-video-frame-buffer-driver.patch
drivers-video-add-hyper-v-synthetic-video-frame-buffer-driver-fix.patch

