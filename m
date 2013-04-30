From: akpm@linux-foundation.org
Subject: [merged] swap-redirty-page-if-page-write-fails-on-swap-file.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:50:06 -0700
Message-ID: <20130430185006.84A7B31C2DD@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:52357 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247Ab3D3SuH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:50:07 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so85969yen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:50:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmarchan@redhat.com, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: swap: redirty page if page write fails on swap file
has been removed from the -mm tree.  Its filename was
     swap-redirty-page-if-page-write-fails-on-swap-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: <stable@vger.kernel.org>	[3.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/page_io.c~swap-redirty-page-if-page-write-fails-on-swap-file mm/page_io.c
--- a/mm/page_io.c~swap-redirty-page-if-page-write-fails-on-swap-file
+++ a/mm/page_io.c
@@ -231,6 +231,8 @@ int __swap_writepage(struct page *page,
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

origin.patch
inotify-invalid-mask-should-return-a-error-number-but-not-set-it.patch
inotify-invalid-mask-should-return-a-error-number-but-not-set-it-fix.patch

