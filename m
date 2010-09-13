From: akpm@linux-foundation.org
Subject: + mm-export-account_page_dirty.patch added to -mm tree
Date: Mon, 13 Sep 2010 15:48:50 -0700
Message-ID: <201009132248.o8DMmori025722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049Ab0IMWtG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Sep 2010 18:49:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mrubin@google.com, axboe@kernel.dk, david@fromorbit.com, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au


The patch titled
     mm: export account_page_dirty()
has been added to the -mm tree.  Its filename is
     mm-export-account_page_dirty.patch

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
Subject: mm: export account_page_dirty()
From: Michael Rubin <mrubin@google.com>

To help developers and applications gain visibility into writeback
behaviour this patch adds two counters to /proc/vmstat.

  # grep nr_dirtied /proc/vmstat
  nr_dirtied 3747
  # grep nr_written /proc/vmstat
  nr_written 3618

These entries allow user apps to understand writeback behaviour over time
and learn how it is impacting their performance.  Currently there is no
way to inspect dirty and writeback speed over time.  It's not possible for
nr_dirty/nr_writeback.

These entries are necessary to give visibility into writeback behaviour. 
We have /proc/diskstats which lets us understand the io in the block
layer.  We have blktrace for more in depth understanding.  We have
e2fsprogs and debugsfs to give insight into the file systems behaviour,
but we don't offer our users the ability understand what writeback is
doing.  There is no way to know how active it is over the whole system, if
it's falling behind or to quantify it's efforts.  With these values
exported users can easily see how much data applications are sending
through writeback and also at what rates writeback is processing this
data.  Comparing the rates of change between the two allow developers to
see when writeback is not able to keep up with incoming traffic and the
rate of dirty memory being sent to the IO back end.  This allows folks to
understand their io workloads and track kernel issues.  Non kernel
engineers at Google often use these counters to solve puzzling performance
problems.

Patch #4 adds a pernode vmstat file with nr_dirtied and nr_written

Patch #5 add writeback thresholds to /proc/vmstat

Currently these values are in debugfs. But they should be promoted to
/proc since they are useful for developers who are writing databases
and file servers and are not debugging the kernel.

The output is as below:

 # grep threshold /proc/vmstat
 nr_pages_dirty_threshold 409111
 nr_pages_dirty_background_threshold 818223



This patch:

Export account_page_dirty().  This allows code outside of the mm core to
safely manipulate page state and not worry about the other accounting. 
Not using these routines means that some code will lose track of the
accounting and we get bugs.  This has happened once already.

Signed-off-by: Michael Rubin <mrubin@google.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page-writeback.c~mm-export-account_page_dirty mm/page-writeback.c
--- a/mm/page-writeback.c~mm-export-account_page_dirty
+++ a/mm/page-writeback.c
@@ -682,6 +682,7 @@ void throttle_vm_writeout(gfp_t gfp_mask
 			break;
         }
 }
+EXPORT_SYMBOL(account_page_dirtied);
 
 /*
  * sysctl handler for /proc/sys/vm/dirty_writeback_centisecs
_

Patches currently in -mm which might be from mrubin@google.com are

vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
mm-export-account_page_dirty.patch
mm-add-account_page_writeback.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-fix.patch
writeback-add-sys-devices-system-node-node-vmstat.patch
writeback-report-dirty-thresholds-in-proc-vmstat.patch

