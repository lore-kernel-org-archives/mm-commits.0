From: akpm@linux-foundation.org
Subject: + osd-fs-__r4w_get_page-rely-on-pageuptodate-for-uptodate.patch
 added to -mm tree
Date: Thu, 05 Nov 2015 02:50:05 -0800
Message-ID: <563b345d.4+Yu7NtOTavhV2gq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031975AbbKEKuG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 05:50:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, bhalevy@primarydata.com, cl@linux.com, ooo@electrozaur.com, trond.myklebust@primarydata.com, mm-commits@vger.kernel.org


The patch titled
     Subject: osd fs: __r4w_get_page rely on PageUptodate for uptodate
has been added to the -mm tree.  Its filename is
     osd-fs-__r4w_get_page-rely-on-pageuptodate-for-uptodate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/osd-fs-__r4w_get_page-rely-on-pageuptodate-for-uptodate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/osd-fs-__r4w_get_page-rely-on-pageuptodate-for-uptodate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: osd fs: __r4w_get_page rely on PageUptodate for uptodate

The forthcoming patch "mm: migrate dirty page without
clear_page_dirty_for_io etc" simplifies the migration of a PageDirty
pagecache page: one stat needs moving from zone to zone and that's about
all.

It's convenient and safest for it to shift the PageDirty bit from old page
to new, just before updating the zone stats: before copying data and
marking the new PageUptodate.  This is all done while both pages are
isolated and locked, just as before; and just as before, there's a moment
when the new page is visible in the radix_tree, but not yet PageUptodate. 
What's new is that it may now be briefly visible as PageDirty before it is
PageUptodate.

When I scoured the tree to see if this could cause a problem anywhere, the
only places I found were in two similar functions __r4w_get_page(): which
look up a page with find_get_page() (not using page lock), then claim it's
uptodate if it's PageDirty or PageWriteback or PageUptodate.

I'm not sure whether that was right before, but now it might be wrong (on
rare occasions): only claim the page is uptodate if PageUptodate.  Or
perhaps the page in question could never be migratable anyway?

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Boaz Harrosh <ooo@electrozaur.com>
Cc: Benny Halevy <bhalevy@primarydata.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exofs/inode.c             |    5 +----
 fs/nfs/objlayout/objio_osd.c |    5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff -puN fs/exofs/inode.c~osd-fs-__r4w_get_page-rely-on-pageuptodate-for-uptodate fs/exofs/inode.c
--- a/fs/exofs/inode.c~osd-fs-__r4w_get_page-rely-on-pageuptodate-for-uptodate
+++ a/fs/exofs/inode.c
@@ -592,10 +592,7 @@ static struct page *__r4w_get_page(void 
 			}
 			unlock_page(page);
 		}
-		if (PageDirty(page) || PageWriteback(page))
-			*uptodate = true;
-		else
-			*uptodate = PageUptodate(page);
+		*uptodate = PageUptodate(page);
 		EXOFS_DBGMSG2("index=0x%lx uptodate=%d\n", index, *uptodate);
 		return page;
 	} else {
diff -puN fs/nfs/objlayout/objio_osd.c~osd-fs-__r4w_get_page-rely-on-pageuptodate-for-uptodate fs/nfs/objlayout/objio_osd.c
--- a/fs/nfs/objlayout/objio_osd.c~osd-fs-__r4w_get_page-rely-on-pageuptodate-for-uptodate
+++ a/fs/nfs/objlayout/objio_osd.c
@@ -476,10 +476,7 @@ static struct page *__r4w_get_page(void 
 		}
 		unlock_page(page);
 	}
-	if (PageDirty(page) || PageWriteback(page))
-		*uptodate = true;
-	else
-		*uptodate = PageUptodate(page);
+	*uptodate = PageUptodate(page);
 	dprintk("%s: index=0x%lx uptodate=%d\n", __func__, index, *uptodate);
 	return page;
 }
_

Patches currently in -mm which might be from hughd@google.com are

mm-hugetlb-proc-add-hugetlb-related-fields-to-proc-pid-smaps-fix.patch
memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2.patch
osd-fs-__r4w_get_page-rely-on-pageuptodate-for-uptodate.patch
mm-documentation-undoc-non-linear-vmas.patch
mm-rmap-use-pte-lock-not-mmap_sem-to-set-pagemlocked.patch
mm-page-migration-fix-pagemlocked-on-migrated-pages.patch
mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page.patch
mm-correct-a-couple-of-page-migration-comments.patch
mm-page-migration-use-the-put_new_page-whenever-necessary.patch
mm-page-migration-trylock-newpage-at-same-level-as-oldpage.patch
mm-page-migration-remove_migration_ptes-at-lockunlock-level.patch
mm-simplify-page-migrations-anon_vma-comment-and-flow.patch
mm-page-migration-use-migration-entry-for-swapcache-too.patch
mm-page-migration-avoid-touching-newpage-until-no-going-back.patch
mm-migrate-dirty-page-without-clear_page_dirty_for_io-etc.patch
tmpfs-avoid-a-little-creat-and-stat-slowdown.patch
mm-documentation-a-little-tidying-in-proctxt.patch
mm-use-unsigned-int-for-page-order-fix-2.patch

