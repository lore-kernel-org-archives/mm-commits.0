From: akpm@linux-foundation.org
Subject: + swap-redirty-page-if-page-write-fails-on-swap-file.patch added to -mm tree
Date: Mon, 22 Apr 2013 13:38:06 -0700
Message-ID: <20130422203806.7FAB05A40F3@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:51683 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab3DVUiH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 16:38:07 -0400
Received: by mail-gg0-f201.google.com with SMTP id q6so737359ggc.4
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 13:38:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmarchan@redhat.com, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, stable@vger.kernel.org


The patch titled
     Subject: swap: redirty page if page write fails on swap file
has been added to the -mm tree.  Its filename is
     swap-redirty-page-if-page-write-fails-on-swap-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jerome Marchand <jmarchan@redhat.com>
Subject: swap: redirty page if page write fails on swap file

Since 62c230b ("mm: add support for a filesystem to activate swap files
and use direct_IO for writing swap pages"), swap_writepage() calls
direct_IO on swap files.  However, in that case the page isn't redirtied
if I/O fails, and is therefore handled afterwards as if it has been
successfully written to the swap file, leading to memory corruption when
the page is eventually swapped back in.

This patch sets the page dirty when direct_IO() fails.  It fixes a memory
corruption that happened while using swap-over-NFS.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/page_io.c~swap-redirty-page-if-page-write-fails-on-swap-file mm/page_io.c
--- a/mm/page_io.c~swap-redirty-page-if-page-write-fails-on-swap-file
+++ a/mm/page_io.c
@@ -230,6 +230,8 @@ int __swap_writepage(struct page *page,
 		if (ret == PAGE_SIZE) {
 			count_vm_event(PSWPOUT);
 			ret = 0;
+		} else {
+			set_page_dirty(page);
 		}
 		return ret;
 	}
_

Patches currently in -mm which might be from jmarchan@redhat.com are

swap-redirty-page-if-page-write-fails-on-swap-file.patch

