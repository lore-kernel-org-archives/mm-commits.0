From: akpm@linux-foundation.org
Subject: [patch 112/142] mm/swap: fix kernel message in swap_info_get()
Date: Wed, 22 Feb 2017 15:45:19 -0800
Message-ID: <58ae228f.+hYGQzoMM91JNJek%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49272 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934382AbdBVXpV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:45:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ying.huang@intel.com, aarcange@redhat.com, aaron.lu@intel.com, ak@linux.intel.com, borntraeger@de.ibm.com, corbet@lwn.net, dave.hansen@intel.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@linux.intel.com, vdavydov.dev@gmail.com

From: "Huang, Ying" <ying.huang@intel.com>
Subject: mm/swap: fix kernel message in swap_info_get()

Patch series "mm/swap: Regular page swap optimizations", v5.

Times have changed.  Coming generation of Solid state Block device
latencies are getting down to sub 100 usec, which is within an order of
magnitude of DRAM, and their performance is orders of magnitude higher
than the single- spindle rotational media we've swapped to historically.

This could benefit many usage scenearios.  For example cloud providers who
overcommit their memory (as VM don't use all the memory provisioned). 
Having a fast swap will allow them to be more aggressive in memory
overcommit and fit more VMs to a platform.

In our testing [see footnote], the median latency that the kernel adds to
a page fault is 15 usec, which comes quite close to the amount that will
be contributed by the underlying I/O devices.

The software latency comes mostly from contentions on the locks protecting
the radix tree of the swap cache and also the locks protecting the
individual swap devices.  The lock contentions already consumed 35% of cpu
cycles in our test.  In the very near future, software latency will become
the bottleneck to swap performnace as block device I/O latency gets within
the shouting distance of DRAM speed.

This patch set, reduced the median page fault latency from 15 usec to 4
usec (375% reduction) for DRAM based pmem block device.


This patch (of 9):

swap_info_get() is used not only in swap free code path but also in
page_swapcount(), etc.  So the original kernel message in swap_info_get()
is not correct now.  Fix it via replacing "swap_free" to "swap_info_get"
in the message.

Link: http://lkml.kernel.org/r/9b5f8bd6266f9da978c373f2384c8044df5e262c.1484082593.git.tim.c.chen@linux.intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net> escreveu:
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shaohua Li <shli@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/swapfile.c~mm-swap-fix-kernel-message-in-swap_info_get mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-fix-kernel-message-in-swap_info_get
+++ a/mm/swapfile.c
@@ -753,16 +753,16 @@ static struct swap_info_struct *swap_inf
 	return p;
 
 bad_free:
-	pr_err("swap_free: %s%08lx\n", Unused_offset, entry.val);
+	pr_err("swap_info_get: %s%08lx\n", Unused_offset, entry.val);
 	goto out;
 bad_offset:
-	pr_err("swap_free: %s%08lx\n", Bad_offset, entry.val);
+	pr_err("swap_info_get: %s%08lx\n", Bad_offset, entry.val);
 	goto out;
 bad_device:
-	pr_err("swap_free: %s%08lx\n", Unused_file, entry.val);
+	pr_err("swap_info_get: %s%08lx\n", Unused_file, entry.val);
 	goto out;
 bad_nofile:
-	pr_err("swap_free: %s%08lx\n", Bad_file, entry.val);
+	pr_err("swap_info_get: %s%08lx\n", Bad_file, entry.val);
 out:
 	return NULL;
 }
_
