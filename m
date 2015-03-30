From: akpm@linux-foundation.org
Subject: +
 document-interaction-between-compaction-and-the-unevictable-lru.patch added to -mm tree
Date: Mon, 30 Mar 2015 15:09:48 -0700
Message-ID: <5519c9ac.qbWUxoscAWZN+qYf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbbC3WJt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Mar 2015 18:09:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emunson@akamai.com, cl@linux.com, mgorman@suse.de, mhocko@suse.cz, peterz@infradead.org, riel@redhat.com, rientjes@google.com, tglx@linutronix.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/vm/unevictable-lru.txt: document interaction between compaction and the unevictable LRU
has been added to the -mm tree.  Its filename is
     document-interaction-between-compaction-and-the-unevictable-lru.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/document-interaction-between-compaction-and-the-unevictable-lru.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/document-interaction-between-compaction-and-the-unevictable-lru.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric B Munson <emunson@akamai.com>
Subject: Documentation/vm/unevictable-lru.txt: document interaction between compaction and the unevictable LRU

The memory compaction code uses the migration code to do most of the work
in compaction.  However, the compaction code interacts with the
unevictable LRU differently than migration code and this difference should
be noted in the documentation.

Signed-off-by: Eric B Munson <emunson@akamai.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/unevictable-lru.txt |   11 +++++++++++
 1 file changed, 11 insertions(+)

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
@@ -450,6 +451,16 @@ list because of a race between munlock a
 putback_lru_page() function to add migrated pages back to the LRU.
 
 
+COMPACTING MLOCKED PAGES
+------------------------
+
+The unevictable LRU can be scanned for compactable regions and the default
+behavior is to do so.  There is a sysctl to control this behavior (see
+Documentation/sysctl/vm.txt).  Once scanning of the unevictable LRU is
+enabled, the work of compaction is mostly handled by the page migration code
+and the same work flow as described in MIGRATING MLOCKED PAGES will apply.
+
+
 mmap(MAP_LOCKED) SYSTEM CALL HANDLING
 -------------------------------------
 
_

Patches currently in -mm which might be from emunson@akamai.com are

allow-compaction-of-unevictable-pages.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
document-interaction-between-compaction-and-the-unevictable-lru-fix.patch
mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory.patch
mm-selftests-test-return-value-of-munmap-for-map_hugetlb-memory.patch

