From: akpm@linux-foundation.org
Subject: + dma-debug-prevent-early-callers-from-crashing.patch added to
 -mm tree
Date: Tue, 18 Nov 2014 14:42:59 -0800
Message-ID: <546bcb73.WrvTvygU8q44ILmS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37561 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620AbaKRWnA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Nov 2014 17:43:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: f.fainelli@gmail.com, computersforpeace@gmail.com, dan.j.williams@intel.com, horia.geanta@freescale.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-debug: prevent early callers from crashing
has been added to the -mm tree.  Its filename is
     dma-debug-prevent-early-callers-from-crashing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-debug-prevent-early-callers-from-crashing.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/dma-debug-prevent-early-callers-from-crashing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: dma-debug: prevent early callers from crashing

dma_debug_init() is called by architecture specific code at different
levels, but typically as a fs_initcall due to the debugfs initialization. 
Some platforms may have early callers of the DMA-API, running prior to the
fs_initcall() level, which is not much of an issue unless
CONFIG_DMA_API_DEBUG is set.  Whe the DMA-API debugging facilities are
turned on a caller will go through:

debug_dma_map_{single,page}
	-> dma_mapping_error (inline function usually)
		-> debug_dma_mapping_error
			-> get_hash_bucket

Calling get_hash_bucket() returns a valid hash value since we hash on high
bits of the dma_addr cookie, but we will grab an unitialized spinlock,
which typically won't crash but produce a warning, the real crash will
however happen during the bucket list traversal because the list has not
been initialized yet.

An obvious solution is of course to move some of the offenders to run
after the fs_initcall level, but since this might not always be an option,
we add a flag "dma_debug_initialized" which is set to false by default,
and set to true once dma_debug_init() has had a chance to run.

The dma_debug_disabled() helper function previously introduced just needs
to check for dma_debug_initialized to allow the caller to proceed or not.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Horia Geanta <horia.geanta@freescale.com>
Cc: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN lib/dma-debug.c~dma-debug-prevent-early-callers-from-crashing lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-prevent-early-callers-from-crashing
+++ a/lib/dma-debug.c
@@ -102,9 +102,12 @@ static DEFINE_SPINLOCK(free_entries_lock
 /* Global disable flag - will be set in case of an error */
 static u32 global_disable __read_mostly;
 
+/* Early initialization disable flag, set at the end of dma_debug_init */
+static bool dma_debug_initialized __read_mostly;
+
 static inline bool dma_debug_disabled(void)
 {
-	return global_disable;
+	return global_disable || !dma_debug_initialized;
 }
 
 /* Global error count */
@@ -999,7 +1002,10 @@ void dma_debug_init(u32 num_entries)
 {
 	int i;
 
-	if (dma_debug_disabled())
+	/* Do not use dma_debug_initialized here, since we really want to be
+	 * called to set dma_debug_initialized
+	 */
+	if (global_disable)
 		return;
 
 	for (i = 0; i < HASH_SIZE; ++i) {
@@ -1026,6 +1032,8 @@ void dma_debug_init(u32 num_entries)
 
 	nr_total_entries = num_free_entries;
 
+	dma_debug_initialized = true;
+
 	pr_info("DMA-API: debugging enabled by kernel config\n");
 }
 
_

Patches currently in -mm which might be from f.fainelli@gmail.com are

dma-debug-introduce-dma_debug_disabled.patch
dma-debug-prevent-early-callers-from-crashing.patch
linux-next.patch

