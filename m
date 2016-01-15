From: akpm@linux-foundation.org
Subject: [merged]
 mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem.patch removed from -mm tree
Date: Fri, 15 Jan 2016 14:33:06 -0800
Message-ID: <569973a2.i7HVGP+roupFLMAn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59309 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbcAOWdH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:33:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hughd@google.com, jmarchan@redhat.com, khlebnikov@yandex-team.ru, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, documentation: clarify /proc/pid/status VmSwap limitations for shmem
has been removed from the -mm tree.  Its filename was
     mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, documentation: clarify /proc/pid/status VmSwap limitations for shmem

This series is based on Jerome Marchand's [1] so let me quote the first
paragraph from there:

There are several shortcomings with the accounting of shared memory (sysV
shm, shared anonymous mapping, mapping to a tmpfs file).  The values in
/proc/<pid>/status and statm don't allow to distinguish between shmem
memory and a shared mapping to a regular file, even though their
implications on memory usage are quite different: at reclaim, file mapping
can be dropped or written back on disk while shmem needs a place in swap. 
As for shmem pages that are swapped-out or in swap cache, they aren't
accounted at all.

The original motivation for myself is that a customer found (IMHO
rightfully) confusing that e.g.  top output for process swap usage is
unreliable with respect to swapped out shmem pages, which are not
accounted for.

The fundamental difference between private anonymous and shmem pages is
that the latter has PTE's converted to pte_none, and not swapents.  As
such, they are not accounted to the number of swapents visible e.g.  in
/proc/pid/status VmSwap row.  It might be theoretically possible to use
swapents when swapping out shmem (without extra cost, as one has to change
all mappers anyway), and on swap in only convert the swapent for the
faulting process, leaving swapents in other processes until they also
fault (so again no extra cost).  But I don't know how many assumptions
this would break, and it would be too disruptive change for a relatively
small benefit.

Instead, my approach is to document the limitation of VmSwap, and provide
means to determine the swap usage for shmem areas for those who are
interested and willing to pay the price, using /proc/pid/smaps.  Because
outside of ipcs, I don't think it's possible to currently to determine the
usage at all.  The previous patchset [1] did introduce new shmem-specific
fields into smaps output, and functions to determine the values.  I take a
simpler approach, noting that smaps output already has a "Swap: X kB"
line, where currently X == 0 always for shmem areas.  I think we can just
consider this a bug and provide the proper value by consulting the radix
tree, as e.g.  mincore_page() does.  In the patch changelog I explain why
this is also not perfect (and cannot be without swapents), but still
arguably much better than showing a 0.

The last two patches are adapted from Jerome's patchset and provide a
VmRSS breakdown to RssAnon, RssFile and RssShm in /proc/pid/status.  Hugh
noted that this is a welcome addition, and I agree that it might help e.g.
 debugging process memory usage at albeit non-zero, but still rather low
cost of extra per-mm counter and some page flag checks.

[1] http://lwn.net/Articles/611966/



This patch (of 6):

The documentation for /proc/pid/status does not mention that the value of
VmSwap counts only swapped out anonymous private pages, and not swapped
out pages of the underlying shmem objects (for shmem mappings).  This is
not obvious, so document this limitation.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/proc.txt~mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem
+++ a/Documentation/filesystems/proc.txt
@@ -238,7 +238,8 @@ Table 1-2: Contents of the status files
  VmLib                       size of shared library code
  VmPTE                       size of page table entries
  VmPMD                       size of second level page tables
- VmSwap                      size of swap usage (the number of referred swapents)
+ VmSwap                      amount of swap used by anonymous private data
+                             (shmem swap usage is not included)
  HugetlbPages                size of hugetlb memory portions
  Threads                     number of threads
  SigQ                        number of signals queued/max. number for queue
_

Patches currently in -mm which might be from vbabka@suse.cz are


