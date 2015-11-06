From: akpm@linux-foundation.org
Subject: [merged] tools-vm-slabinfo-cosmetic-globals-cleanup.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:06:54 -0800
Message-ID: <563d085e.YE/+45ht72Pls1Wa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161856AbbKFUGz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:06:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/slabinfo: cosmetic globals cleanup
has been removed from the -mm tree.  Its filename was
     tools-vm-slabinfo-cosmetic-globals-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: tools/vm/slabinfo: cosmetic globals cleanup

checkpatch.pl complains about globals being explicitly zeroed
out: "ERROR: do not initialise globals to 0 or NULL".

New globals, introduced in this patch set, have no explicit 0
initialization; clean up the old ones to make it less hairy.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/slabinfo.c |   54 +++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff -puN tools/vm/slabinfo.c~tools-vm-slabinfo-cosmetic-globals-cleanup tools/vm/slabinfo.c
--- a/tools/vm/slabinfo.c~tools-vm-slabinfo-cosmetic-globals-cleanup
+++ a/tools/vm/slabinfo.c
@@ -53,43 +53,43 @@ struct aliasinfo {
 	struct slabinfo *slab;
 } aliasinfo[MAX_ALIASES];
 
-int slabs = 0;
-int actual_slabs = 0;
-int aliases = 0;
-int alias_targets = 0;
-int highest_node = 0;
+int slabs;
+int actual_slabs;
+int aliases;
+int alias_targets;
+int highest_node;
 
 char buffer[4096];
 
-int show_empty = 0;
-int show_report = 0;
-int show_alias = 0;
-int show_slab = 0;
+int show_empty;
+int show_report;
+int show_alias;
+int show_slab;
 int skip_zero = 1;
-int show_numa = 0;
-int show_track = 0;
-int show_first_alias = 0;
-int validate = 0;
-int shrink = 0;
-int show_inverted = 0;
-int show_single_ref = 0;
-int show_totals = 0;
-int sort_size = 0;
-int sort_active = 0;
-int set_debug = 0;
-int show_ops = 0;
-int show_activity = 0;
+int show_numa;
+int show_track;
+int show_first_alias;
+int validate;
+int shrink;
+int show_inverted;
+int show_single_ref;
+int show_totals;
+int sort_size;
+int sort_active;
+int set_debug;
+int show_ops;
+int show_activity;
 int output_lines = -1;
 int sort_loss;
 int extended_totals;
 int show_bytes;
 
 /* Debug options */
-int sanity = 0;
-int redzone = 0;
-int poison = 0;
-int tracking = 0;
-int tracing = 0;
+int sanity;
+int redzone;
+int poison;
+int tracking;
+int tracing;
 
 int page_size;
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-keep-the-exact-overcommited-value-in-mem_used_max.patch
mm-zsmalloc-constify-struct-zs_pool-name.patch
zsmalloc-use-preempth-for-in_interrupt.patch

