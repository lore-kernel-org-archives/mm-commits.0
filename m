From: akpm@linux-foundation.org
Subject: - documentation-clarify-dirty_ratio-and-dirty_background_ratio-description-v2.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:34:03 -0700
Message-ID: <200810202034.m9KKY3fu010761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754194AbYJTUqr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: righi.andrea@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     documentation: clarify dirty_ratio and dirty_background_ratio description
has been removed from the -mm tree.  Its filename was
     documentation-clarify-dirty_ratio-and-dirty_background_ratio-description-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: documentation: clarify dirty_ratio and dirty_background_ratio description
From: Andrea Righi <righi.andrea@gmail.com>

The current documentation of dirty_ratio and dirty_background_ratio is a
bit misleading.

In the documentation we say that they are "a percentage of total system
memory", but the current page writeback policy, intead, is to apply the
percentages to the dirtyable memory, that means free pages + reclaimable
pages.

Better to be more explicit to clarify this concept.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN Documentation/filesystems/proc.txt~documentation-clarify-dirty_ratio-and-dirty_background_ratio-description-v2 Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~documentation-clarify-dirty_ratio-and-dirty_background_ratio-description-v2
+++ a/Documentation/filesystems/proc.txt
@@ -1384,15 +1384,18 @@ causes the kernel to prefer to reclaim d
 dirty_background_ratio
 ----------------------
 
-Contains, as a percentage of total system memory, the number of pages at which
-the pdflush background writeback daemon will start writing out dirty data.
+Contains, as a percentage of the dirtyable system memory (free pages + mapped
+pages + file cache, not including locked pages and HugePages), the number of
+pages at which the pdflush background writeback daemon will start writing out
+dirty data.
 
 dirty_ratio
 -----------------
 
-Contains, as a percentage of total system memory, the number of pages at which
-a process which is generating disk writes will itself start writing out dirty
-data.
+Contains, as a percentage of the dirtyable system memory (free pages + mapped
+pages + file cache, not including locked pages and HugePages), the number of
+pages at which a process which is generating disk writes will itself start
+writing out dirty data.
 
 dirty_writeback_centisecs
 -------------------------
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

origin.patch
linux-next.patch
memrlimit-add-memrlimit-controller-accounting-and-control-fix-task_lock-recursive-locking-v2.patch

