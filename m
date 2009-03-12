From: akpm@linux-foundation.org
Subject: + nommu-ramfs-pages-allocated-to-an-inodes-pagecache-may-get-wrongly-discarded.patch added to -mm tree
Date: Wed, 11 Mar 2009 17:12:58 -0700
Message-ID: <200903120012.n2C0Cxul020931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754475AbZCLAP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 20:15:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Enrik.Berkhan@ge.com, a.p.zijlstra@chello.nl, dhowells@redhat.com, hannes@cmpxchg.org, nickpiggin@yahoo.com.au


The patch titled
     nommu: ramfs: pages allocated to an inode's pagecache may get wrongly discarded
has been added to the -mm tree.  Its filename is
     nommu-ramfs-pages-allocated-to-an-inodes-pagecache-may-get-wrongly-discarded.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -113,6 +113,9 @@ int ramfs_nommu_expand_for_mapping(struc
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
nommu-ramfs-pages-allocated-to-an-inodes-pagecache-may-get-wrongly-discarded.patch
nommu-ramfs-pages-allocated-to-an-inodes-pagecache-may-get-wrongly-discarded-fix.patch
nommu-ramfs-dont-leak-pages-when-adding-to-page-cache-fails.patch

