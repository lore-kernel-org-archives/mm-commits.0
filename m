From: akpm@linux-foundation.org
Subject: [merged]
 document-interaction-between-compaction-and-the-unevictable-lru.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:51:36 -0700
Message-ID: <552fe898.udN3zdb7ghVbJt5q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42633 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbbDPQqH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:46:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, cl@linux.com, mgorman@suse.de, mhocko@suse.cz, peterz@infradead.org, riel@redhat.com, rientjes@google.com, tglx@linutronix.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/vm/unevictable-lru.txt: document interaction between compaction and the unevictable LRU
has been removed from the -mm tree.  Its filename was
     document-interaction-between-compaction-and-the-unevictable-lru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric B Munson <emunson@akamai.com>
Subject: Documentation/vm/unevictable-lru.txt: document interaction between compaction and the unevictable LRU

The memory compaction code uses the migration code to do most of the work
in compaction.  However, the compaction code interacts with the
unevictable LRU differently than migration code and this difference should
be noted in the documentation.

[akpm@linux-foundation.org: identify /proc/sys/vm/compact_unevictable directly]
Signed-off-by: Eric B Munson <emunson@akamai.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/unevictable-lru.txt |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN Documentation/vm/unevictable-lru.txt~document-interaction-between-compaction-and-the-unevictable-lru Documentation/vm/unevictable-lru.txt
--- a/Documentation/vm/unevictable-lru.txt~document-interaction-between-compaction-and-the-unevictable-lru
+++ a/Documentation/vm/unevictable-lru.txt
@@ -22,6 +22,7 @@ CONTENTS
      - Filtering special vmas.
      - munlock()/munlockall() system call handling.
      - Migrating mlocked pages.
+     - Compacting mlocked pages.
      - mmap(MAP_LOCKED) system call handling.
      - munmap()/exit()/exec() system call handling.
      - try_to_unmap().
@@ -450,6 +451,17 @@ list because of a race between munlock a
 putback_lru_page() function to add migrated pages back to the LRU.
 
 
+COMPACTING MLOCKED PAGES
+------------------------
+
+The unevictable LRU can be scanned for compactable regions and the default
+behavior is to do so.  /proc/sys/vm/compact_unevictable_allowed controls
+this behavior (see Documentation/sysctl/vm.txt).  Once scanning of the
+unevictable LRU is enabled, the work of compaction is mostly handled by
+the page migration code and the same work flow as described in MIGRATING
+MLOCKED PAGES will apply.
+
+
 mmap(MAP_LOCKED) SYSTEM CALL HANDLING
 -------------------------------------
 
_

Patches currently in -mm which might be from emunson@akamai.com are

origin.patch

