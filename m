From: akpm@linux-foundation.org
Subject: [merged]
 documentation-describe-the-shared-memory-usage-accounting.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:00:09 -0800
Message-ID: <569e95c9.sFcNEW0b2SsMHO8H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbcASUAK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:00:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rfreire@redhat.com, hughd@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/filesystems: describe the shared memory usage/accounting
has been removed from the -mm tree.  Its filename was
     documentation-describe-the-shared-memory-usage-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rodrigo Freire <rfreire@redhat.com>
Subject: Documentation/filesystems: describe the shared memory usage/accounting

The Shared Memory accounting support is present in Kernel since commit
4b02108ac1b3 ("mm: oom analysis: add shmem vmstat") and in userland
free(1) since 2014.  This patch updates the Documentation to reflect this
change.

Signed-off-by: Rodrigo Freire <rfreire@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt  |    2 ++
 Documentation/filesystems/tmpfs.txt |    8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN Documentation/filesystems/proc.txt~documentation-describe-the-shared-memory-usage-accounting Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~documentation-describe-the-shared-memory-usage-accounting
+++ a/Documentation/filesystems/proc.txt
@@ -855,6 +855,7 @@ Dirty:             968 kB
 Writeback:           0 kB
 AnonPages:      861800 kB
 Mapped:         280372 kB
+Shmem:             644 kB
 Slab:           284364 kB
 SReclaimable:   159856 kB
 SUnreclaim:     124508 kB
@@ -911,6 +912,7 @@ MemAvailable: An estimate of how much me
    AnonPages: Non-file backed pages mapped into userspace page tables
 AnonHugePages: Non-file backed huge pages mapped into userspace page tables
       Mapped: files which have been mmaped, such as libraries
+       Shmem: Total memory used by shared memory (shmem) and tmpfs
         Slab: in-kernel data structures cache
 SReclaimable: Part of Slab, that might be reclaimed, such as caches
   SUnreclaim: Part of Slab, that cannot be reclaimed on memory pressure
diff -puN Documentation/filesystems/tmpfs.txt~documentation-describe-the-shared-memory-usage-accounting Documentation/filesystems/tmpfs.txt
--- a/Documentation/filesystems/tmpfs.txt~documentation-describe-the-shared-memory-usage-accounting
+++ a/Documentation/filesystems/tmpfs.txt
@@ -17,10 +17,10 @@ RAM, where you have to create an ordinar
 cannot swap and you do not have the possibility to resize them. 
 
 Since tmpfs lives completely in the page cache and on swap, all tmpfs
-pages currently in memory will show up as cached. It will not show up
-as shared or something like that. Further on you can check the actual
-RAM+swap use of a tmpfs instance with df(1) and du(1).
