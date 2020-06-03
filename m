From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 119/131] tools/vm/page_owner_sort.c: filter out
 unneeded line
Date: Wed, 03 Jun 2020 16:03:22 -0700
Message-ID: <20200603230322.JNHaLaumS%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgFCXIj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:08:39 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ch0.han@lge.com, corbet@lwn.net, iamjoonsoo.kim@lge.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz

From: Changhee Han <ch0.han@lge.com>
Subject: tools/vm/page_owner_sort.c: filter out unneeded line

To see a sorted result from page_owner, there must be a tiresome
preprocessing step before running page_owner_sort.  This patch simply
filters out lines which start with "PFN" while reading the page owner
report.

Link: http://lkml.kernel.org/r/20200429052940.16968-1-ch0.han@lge.com
Signed-off-by: Changhee Han <ch0.han@lge.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    3 +--
 tools/vm/page_owner_sort.c      |    5 +++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/vm/page_owner.rst~tools-vm-page_owner_sort-filter-out-unneeded-line
+++ a/Documentation/vm/page_owner.rst
@@ -83,8 +83,7 @@ Usage
 4) Analyze information from page owner::
 
 	cat /sys/kernel/debug/page_owner > page_owner_full.txt
-	grep -v ^PFN page_owner_full.txt > page_owner.txt
-	./page_owner_sort page_owner.txt sorted_page_owner.txt
+	./page_owner_sort page_owner_full.txt sorted_page_owner.txt
 
    See the result about who allocated each page
    in the ``sorted_page_owner.txt``.
--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sort-filter-out-unneeded-line
+++ a/tools/vm/page_owner_sort.c
@@ -4,8 +4,7 @@
  *
  * Example use:
  * cat /sys/kernel/debug/page_owner > page_owner_full.txt
- * grep -v ^PFN page_owner_full.txt > page_owner.txt
- * ./page_owner_sort page_owner.txt sorted_page_owner.txt
+ * ./page_owner_sort page_owner_full.txt sorted_page_owner.txt
  *
  * See Documentation/vm/page_owner.rst
 */
@@ -38,6 +37,8 @@ int read_block(char *buf, int buf_size,
 	while (buf_end - curr > 1 && fgets(curr, buf_end - curr, fin)) {
 		if (*curr == '\n') /* empty line */
 			return curr - buf;
+		if (!strncmp(curr, "PFN", 3))
+			continue;
 		curr += strlen(curr);
 	}
 
_
