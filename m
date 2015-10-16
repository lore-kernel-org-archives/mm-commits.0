From: akpm@linux-foundation.org
Subject: + tools-vm-slabinfo-cosmetic-globals-cleanup.patch added to -mm
 tree
Date: Fri, 16 Oct 2015 15:36:05 -0700
Message-ID: <56217bd5.eBuQ7dQq/HpAeYzQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbbJPWgG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Oct 2015 18:36:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/slabinfo: cosmetic globals cleanup
has been added to the -mm tree.  Its filename is
     tools-vm-slabinfo-cosmetic-globals-cleanup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-vm-slabinfo-cosmetic-globals-cleanup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-slabinfo-cosmetic-globals-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

maintainers-add-myself-as-zsmalloc-reviewer.patch
tools-vm-slabinfo-use-getopt-no_argument-optional_argument.patch
tools-vm-slabinfo-limit-the-number-of-reported-slabs.patch
tools-vm-slabinfo-sort-slabs-by-loss.patch
tools-vm-slabinfo-fix-alternate-opts-names.patch
tools-vm-slabinfo-introduce-extended-totals-mode.patch
tools-vm-slabinfo-output-sizes-in-bytes.patch
tools-vm-slabinfo-cosmetic-globals-cleanup.patch
tools-vm-slabinfo-gnuplot-slabifo-extended-stat.patch
zram-keep-the-exact-overcommited-value-in-mem_used_max.patch
mm-zsmalloc-constify-struct-zs_pool-name.patch
zsmalloc-use-preempth-for-in_interrupt.patch

