From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_owner-use-stackdepot-to-store-stacktrace-v3.patch removed from -mm
 tree
Date: Tue, 26 Jul 2016 14:55:40 -0700
Message-ID: <5797dc5c.4uSbmkPq294iLLlq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161250AbcGZVzl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 17:55:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, glider@google.com, hughd@google.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_owner-use-stackdepot-to-store-stacktrace-v3
has been removed from the -mm tree.  Its filename was
     mm-page_owner-use-stackdepot-to-store-stacktrace-v3.patch

This patch was dropped because it was folded into mm-page_owner-use-stackdepot-to-store-stacktrace.patch

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm-page_owner-use-stackdepot-to-store-stacktrace-v3

Link: http://lkml.kernel.org/r/1464230275-25791-6-git-send-email-iamjoonsoo.kim@lge.com
Link: http://lkml.kernel.org/r/1466150259-27727-7-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c            |    4 ++++
 tools/vm/page_owner_sort.c |    9 +++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff -puN mm/page_owner.c~mm-page_owner-use-stackdepot-to-store-stacktrace-v3 mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-use-stackdepot-to-store-stacktrace-v3
+++ a/mm/page_owner.c
@@ -11,6 +11,10 @@
 
 #include "internal.h"
 
+/*
+ * TODO: teach PAGE_OWNER_STACK_DEPTH (__dump_page_owner and save_stack)
+ * to use off stack temporal storage
+ */
 #define PAGE_OWNER_STACK_DEPTH (16)
 
 static bool page_owner_disabled = true;
diff -puN tools/vm/page_owner_sort.c~mm-page_owner-use-stackdepot-to-store-stacktrace-v3 tools/vm/page_owner_sort.c
--- a/tools/vm/page_owner_sort.c~mm-page_owner-use-stackdepot-to-store-stacktrace-v3
+++ a/tools/vm/page_owner_sort.c
@@ -79,12 +79,12 @@ static void add_list(char *buf, int len)
 	}
 }
 
-#define BUF_SIZE	1024
+#define BUF_SIZE	(128 * 1024)
 
 int main(int argc, char **argv)
 {
 	FILE *fin, *fout;
-	char buf[BUF_SIZE];
+	char *buf;
 	int ret, i, count;
 	struct block_list *list2;
 	struct stat st;
@@ -107,6 +107,11 @@ int main(int argc, char **argv)
 	max_size = st.st_size / 100; /* hack ... */
 
 	list = malloc(max_size * sizeof(*list));
+	buf = malloc(BUF_SIZE);
+	if (!list || !buf) {
+		printf("Out of memory\n");
+		exit(1);
+	}
 
 	for ( ; ; ) {
 		ret = read_block(buf, BUF_SIZE, fin);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-compaction-split-freepages-without-holding-the-zone-lock.patch
mm-page_owner-initialize-page-owner-without-holding-the-zone-lock.patch
mm-page_owner-copy-last_migrate_reason-in-copy_page_owner.patch
mm-page_owner-introduce-split_page_owner-and-replace-manual-handling.patch
tools-vm-page_owner-increase-temporary-buffer-size.patch
mm-page_owner-use-stackdepot-to-store-stacktrace.patch
mm-page_alloc-introduce-post-allocation-processing-on-page-allocator.patch
mm-page_alloc-introduce-post-allocation-processing-on-page-allocator-v3.patch
mm-page_isolation-clean-up-confused-code.patch

