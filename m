From: akpm@linux-foundation.org
Subject: + mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports.patch added to -mm tree
Date: Mon, 08 Jun 2009 16:38:08 -0700
Message-ID: <200906082338.n58Nc8oJ020391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757355AbZFHXjj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jun 2009 19:39:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, hch@infradead.org, minchan.kim@gmail.com, penberg@cs.helsinki.fi, riel@redhat.com


The patch titled
     mm: add a gfp-translate script to help understand page allocation failure reports
has been added to the -mm tree.  Its filename is
     mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports.patch

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
Subject: mm: add a gfp-translate script to help understand page allocation failure reports
From: Mel Gorman <mel@csn.ul.ie>

The page allocation failure messages include a line that looks like

page allocation failure. order:1, mode:0x4020

The mode is easy to translate but irritating for the lazy and a bit error
prone.  This patch adds a very simple helper script gfp-translate for the
mode: portion of the page allocation failure messages.  An example usage
looks like

  mel@machina:~/linux-2.6 $ scripts/gfp-translate 0x4020
  Source: /home/mel/linux-2.6
  Parsing: 0x4020
  #define __GFP_HIGH	(0x20)	/* Should access emergency pools? */
  #define __GFP_COMP	(0x4000) /* Add compound page metadata */

The script is not a work of art but it has come in handy for me a few
times so I thought I would share.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gfp-translate |   81 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff -puN /dev/null scripts/gfp-translate
--- /dev/null
+++ a/scripts/gfp-translate
@@ -0,0 +1,81 @@
+#!/bin/bash
+# Translate the bits making up a GFP mask
+# (c) 2009, Mel Gorman <mel@csn.ul.ie>
+# Licensed under the terms of the GNU GPL License version 2
+SOURCE=
+GFPMASK=none
+
+# Helper function to report failures and exit
+die() {
+	echo ERROR: $@
+	if [ "$TMPFILE" != "" ]; then
+		rm -f $TMPFILE
+	fi
+	exit -1
+}
+
+usage() {
+	echo "usage: gfp-translate [-h] [ --source DIRECTORY ] gfpmask"
+	exit 0
+}
+
+# Parse command-line arguements
+while [ $# -gt 0 ]; do
+	case $1 in
+		--source)
+			SOURCE=$2
+			shift 2
+			;;
+		-h)
+			usage
+			;;
+		--help)
+			usage
+			;;
+		*)
+			GFPMASK=$1
+			shift
+			;;
+	esac
+done
+
+# Guess the kernel source directory if it's not set. Preference is in order of
+# o current directory
+# o /usr/src/linux
+if [ "$SOURCE" = "" ]; then
+	if [ -r "/usr/src/linux/Makefile" ]; then
+		SOURCE=/usr/src/linux
+	fi
+	if [ -r "`pwd`/Makefile" ]; then
+		SOURCE=`pwd`
+	fi
+fi
+
+# Confirm that a source directory exists
+if [ ! -r "$SOURCE/Makefile" ]; then
+	die "Could not locate source directory or it is invalid"
+fi
+
+# Confirm that a GFP mask has been specified
+if [ "$GFPMASK" = "none" ]; then
+	usage
+fi
+
+# Extract GFP flags from the kernel source
+TMPFILE=`mktemp -t gfptranslate-XXXXXX` || exit 1
+grep "^#define __GFP" $SOURCE/include/linux/gfp.h | sed -e 's/(__force gfp_t)//' | sed -e 's/u)/)/' | grep -v GFP_BITS | sed -e 's/)\//) \//' > $TMPFILE
+
+# Parse the flags
+IFS="
+"
+echo Source: $SOURCE
+echo Parsing: $GFPMASK
+for LINE in `cat $TMPFILE`; do
+	MASK=`echo $LINE | awk '{print $3}'`
+	if [ $(($GFPMASK&$MASK)) -ne 0 ]; then
+		echo $LINE
+	fi
+done
+
+rm -f $TMPFILE
+exit 0
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch
mm-alloc_large_system_hash-check-order.patch
page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch
page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch
page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch
page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-calculate-the-migratetype-for-allocation-only-once.patch
page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-inline-__rmqueue_smallest.patch
page-allocator-inline-buffered_rmqueue.patch
page-allocator-inline-__rmqueue_fallback.patch
page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch
page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch
page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch
page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array.patch
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-update-nr_free_pages-only-as-necessary-fix.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
page-allocator-move-free_page_mlock-to-page_allocc.patch
page-allocator-sanity-check-order-in-the-page-allocator-slow-path.patch
mm-use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator-fix-gfp-zone-patch.patch
page-allocator-clean-up-functions-related-to-pages_min.patch
oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
oom-avoid-unnecessary-mm-locking-and-scanning-for-oom_disable.patch
oom-invoke-oom-killer-for-__gfp_nofail.patch
page-allocator-clear-n_high_memory-map-before-se-set-it-again.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports-fix.patch
add-debugging-aid-for-memory-initialisation-problems.patch

