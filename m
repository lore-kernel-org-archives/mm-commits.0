From: akpm@linux-foundation.org
Subject: [merged] mm-fix-page-leak-at-nfs_symlink.patch removed from -mm
 tree
Date: Tue, 11 Feb 2014 11:23:44 -0800
Message-ID: <52fa78c0.ZclqAQW8cdnXmu7s%akpm__25072.2563163892$1392146643$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbaBKTXp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 14:23:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, trond.myklebust@primarydata.com, stable@vger.kernel.org, riel@redhat.com, mgorman@suse.de, jstancek@redhat.com, jlayton@redhat.com, aquini@redhat.com

Subject: [merged] mm-fix-page-leak-at-nfs_symlink.patch removed from -mm tree
To: aquini@redhat.com,jlayton@redhat.com,jstancek@redhat.com,mgorman@suse.de,riel@redhat.com,stable@vger.kernel.org,trond.myklebust@primarydata.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 11:23:44 -0800


The patch titled
     Subject: mm: fix page leak at nfs_symlink()
has been removed from the -mm tree.  Its filename was
     mm-fix-page-leak-at-nfs_symlink.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: mm: fix page leak at nfs_symlink()

Changes committed by a0b8cab3 ("mm: remove lru parameter from
__pagevec_lru_add and remove parts of pagevec API") have introduced a call
to add_to_page_cache_lru() which causes a leak in nfs_symlink() as now the
page gets an extra refcount that is not dropped.

Jan Stancek observed and reported the leak effect while running test8 from
Connectathon Testsuite.  After several iterations over the test case,
which creates several symlinks on a NFS mountpoint, the test system was
quickly getting into an out-of-memory scenario.

This patch fixes the page leak by dropping that extra refcount
add_to_page_cache_lru() is grabbing.

Signed-off-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: <stable@vger.kernel.org>	[3.11.x+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/dir.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/nfs/dir.c~mm-fix-page-leak-at-nfs_symlink fs/nfs/dir.c
--- a/fs/nfs/dir.c~mm-fix-page-leak-at-nfs_symlink
+++ a/fs/nfs/dir.c
@@ -1846,6 +1846,11 @@ int nfs_symlink(struct inode *dir, struc
 							GFP_KERNEL)) {
 		SetPageUptodate(page);
 		unlock_page(page);
+		/*
+		 * add_to_page_cache_lru() grabs an extra page refcount.
+		 * Drop it here to avoid leaking this page later.
+		 */
+		page_cache_release(page);
 	} else
 		__free_page(page);
 
_

Patches currently in -mm which might be from aquini@redhat.com are

origin.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
linux-next.patch

