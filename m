From: akpm@linux-foundation.org
Subject: [patch 059/126] tools/vm/page_owner: increase temporary buffer
 size
Date: Tue, 26 Jul 2016 15:23:52 -0700
Message-ID: <5797e2f8.ZCjwtYpMnFgpv45H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758191AbcGZWXx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:23:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, glider@google.com, hughd@google.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, vbabka@suse.cz

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
