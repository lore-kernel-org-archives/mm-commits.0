From: akpm@linux-foundation.org
Subject: [merged] mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:36:15 -0700
Message-ID: <200906171836.n5HIaF3I002249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758337AbZFQSiE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:38:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, hch@infradead.org, minchan.kim@gmail.com, penberg@cs.helsinki.fi, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: add a gfp-translate script to help understand page allocation failure reports
has been removed from the -mm tree.  Its filename was
     mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: clarify an error message]
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
+	die "Could not locate kernel source directory or it is invalid"
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

origin.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
add-debugging-aid-for-memory-initialisation-problems.patch

