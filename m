From: akpm@linux-foundation.org
Subject: [merged] mm-documentation-a-little-tidying-in-proctxt.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:17:23 -0800
Message-ID: <563d0ad3.enxugw255tzgm8mW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162916AbbKFURX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/filesystems/proc.txt: a little tidying
has been removed from the -mm tree.  Its filename was
     mm-documentation-a-little-tidying-in-proctxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: Documentation/filesystems/proc.txt: a little tidying

There's an odd line about "Locked" at the head of the description of
/proc/meminfo: it seems to have strayed from /proc/PID/smaps, so lead it
back there.  Move "Swap" and "SwapPss" descriptions down above it, to
match the order in the file (though "PageSize"s still undescribed).

The example of "Locked: 374 kB" (the same as Pss, neither Rss nor Size) is
so unlikely as to be misleading: just make it 0, this is /bin/bash text;
which would be "dw" (disabled write) not "de" (do not expand).

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-documentation-a-little-tidying-in-proctxt Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-documentation-a-little-tidying-in-proctxt
+++ a/Documentation/filesystems/proc.txt
@@ -433,8 +433,8 @@ Swap:                  0 kB
 SwapPss:               0 kB
 KernelPageSize:        4 kB
 MMUPageSize:           4 kB
-Locked:              374 kB
-VmFlags: rd ex mr mw me de
+Locked:                0 kB
+VmFlags: rd ex mr mw me dw
 
 the first of these lines shows the same information as is displayed for the
 mapping in /proc/PID/maps.  The remaining lines show the size of the mapping
@@ -454,13 +454,13 @@ accessed.
 "Anonymous" shows the amount of memory that does not belong to any file.  Even
 a mapping associated with a file may contain anonymous pages: when MAP_PRIVATE
 and a page is modified, the file page is replaced by a private anonymous copy.
-"Swap" shows how much would-be-anonymous memory is also used, but out on
-swap.
-"SwapPss" shows proportional swap share of this mapping.
 "AnonHugePages" shows the ammount of memory backed by transparent hugepage.
 "Shared_Hugetlb" and "Private_Hugetlb" show the ammounts of memory backed by
 hugetlbfs page which is *not* counted in "RSS" or "PSS" field for historical
 reasons. And these are not included in {Shared,Private}_{Clean,Dirty} field.
+"Swap" shows how much would-be-anonymous memory is also used, but out on swap.
+"SwapPss" shows proportional swap share of this mapping.
+"Locked" indicates whether the mapping is locked in memory or not.
 
 "VmFlags" field deserves a separate description. This member represents the kernel
 flags associated with the particular virtual memory area in two letter encoded
@@ -824,9 +824,6 @@ varies by architecture and compile optio
 
 > cat /proc/meminfo
 
-The "Locked" indicates whether the mapping is locked in memory or not.
-
