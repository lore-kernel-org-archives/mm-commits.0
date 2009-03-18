From: akpm@linux-foundation.org
Subject: [merged] nommu-ramfs-pages-allocated-to-an-inodes-pagecache-may-get-wrongly-discarded.patch removed from -mm tree
Date: Wed, 18 Mar 2009 15:47:39 -0700
Message-ID: <200903182247.n2IMldcK020179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030AbZCRWwU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Mar 2009 18:52:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Enrik.Berkhan@ge.com, a.p.zijlstra@chello.nl, dhowells@redhat.com, hannes@cmpxchg.org, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     nommu: ramfs: pages allocated to an inode's pagecache may get wrongly discarded
has been removed from the -mm tree.  Its filename was
     nommu-ramfs-pages-allocated-to-an-inodes-pagecache-may-get-wrongly-discarded.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: ramfs: pages allocated to an inode's pagecache may get wrongly discarded
From: Enrik Berkhan <Enrik.Berkhan@ge.com>

The pages attached to a ramfs inode's pagecache by truncation from nothing
- as done by SYSV SHM for example - may get discarded under memory
pressure.

The problem is that the pages are not marked dirty.  Anything that creates
data in an MMU-based ramfs will cause the pages holding that data will
cause the set_page_dirty() aop to be called.

For the NOMMU-based mmap, set_page_dirty() may be called by write(), but
it won't be called by page-writing faults on writable mmaps, and it isn't
called by ramfs_nommu_expand_for_mapping() when a file is being truncated
from nothing to allocate a contiguous run.

The solution is to mark the pages dirty at the point of allocation by the
truncation code.

Signed-off-by: Enrik Berkhan <Enrik.Berkhan@ge.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/ramfs/file-nommu.c~nommu-ramfs-pages-allocated-to-an-inodes-pagecache-may-get-wrongly-discarded fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~nommu-ramfs-pages-allocated-to-an-inodes-pagecache-may-get-wrongly-discarded
+++ a/fs/ramfs/file-nommu.c
@@ -114,6 +114,9 @@ int ramfs_nommu_expand_for_mapping(struc
 		if (!pagevec_add(&lru_pvec, page))
 			__pagevec_lru_add_file(&lru_pvec);
 
+		/* prevent the page from being discarded on memory pressure */
+		SetPageDirty(page);
+
 		unlock_page(page);
 	}
 
_

Patches currently in -mm which might be from Enrik.Berkhan@ge.com are

origin.patch
nommu-there-is-no-mlock-for-nommu-so-dont-provide-the-bits.patch
nommu-make-config_unevictable_lru-available-when-config_mmu=n.patch

