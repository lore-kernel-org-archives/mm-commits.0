From: akpm@linux-foundation.org
Subject: [merged] tools-vm-page_owner-increase-temporary-buffer-size.patch removed from -mm tree
Date: Wed, 27 Jul 2016 12:00:55 -0700
Message-ID: <579904e7.ycD80WkcjzwwwCCB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbcG0TA4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:00:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, glider@google.com, hughd@google.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner: increase temporary buffer size
has been removed from the -mm tree.  Its filename was
     tools-vm-page_owner-increase-temporary-buffer-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: tools/vm/page_owner: increase temporary buffer size

Page owner will be changed to store more deep stacktrace so current
temporary buffer size isn't enough.  Increase it.

Link: http://lkml.kernel.org/r/1464230275-25791-5-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN tools/vm/page_owner_sort.c~tools-vm-page_owner-increase-temporary-buffer-size tools/vm/page_owner_sort.c
--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner-increase-temporary-buffer-size
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


