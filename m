From: akpm@linux-foundation.org
Subject: [folded-merged]
 debugging-keep-track-of-page-owners-fix-2-fix-fix.patch removed from -mm
 tree
Date: Fri, 15 Nov 2013 14:24:06 -0800
Message-ID: <52869f06.fycK/yBSSqOG2cpG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab3KOWYH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 17:24:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mina86@mina86.com, dave@linux.vnet.ibm.com, minchan@kernel.org

Subject: [folded-merged] debugging-keep-track-of-page-owners-fix-2-fix-fix.patch removed from -mm tree
To: minchan@kernel.org,dave@linux.vnet.ibm.com,mina86@mina86.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 14:24:06 -0800


The patch titled
     Subject: Enhance read_block of page_owner.c
has been removed from the -mm tree.  Its filename was
     debugging-keep-track-of-page-owners-fix-2-fix-fix.patch

This patch was dropped because it was folded into debugging-keep-track-of-page-owners.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: Enhance read_block of page_owner.c

The read_block reads char one by one until meeting two newline.
It's not good for the performance and current code isn't good shape
for readability.

This patch enhances speed and clean up.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/page_owner.c |   35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff -puN Documentation/page_owner.c~debugging-keep-track-of-page-owners-fix-2-fix-fix Documentation/page_owner.c
--- a/Documentation/page_owner.c~debugging-keep-track-of-page-owners-fix-2-fix-fix
+++ a/Documentation/page_owner.c
@@ -28,27 +28,17 @@ static int max_size;
 
 struct block_list *block_head;
 
-int read_block(char *buf, FILE *fin)
+int read_block(char *buf, int buf_size, FILE *fin)
 {
-	int ret = 0;
-	int hit = 0;
-	char *curr = buf;
-
-	for (;;) {
-		int val = getc(fin);
-
-		if (val == EOF)
-			return -1;
-		*curr = val;
-		ret++;
-		if (*curr == '\n' && hit == 1)
-			return ret - 1;
-		else if (*curr == '\n')
-			hit = 1;
-		else
-			hit = 0;
-		curr++;
+	char *curr = buf, *const buf_end = buf + buf_size;
+
+	while (buf_end - curr > 1 && fgets(curr, buf_end - curr, fin)) {
+		if (*curr == '\n') /* empty line */
+			return curr - buf;
+		curr += strlen(curr);
 	}
+
+	return -1; /* EOF or no space left in buf. */
 }
 
 static int compare_txt(struct block_list *l1, struct block_list *l2)
@@ -85,10 +75,12 @@ static void add_list(char *buf, int len)
 	}
 }
 
+#define BUF_SIZE	1024
+
 int main(int argc, char **argv)
 {
 	FILE *fin, *fout;
-	char buf[1024];
+	char buf[BUF_SIZE];
 	int ret, i, count;
 	struct block_list *list2;
 	struct stat st;
@@ -107,11 +99,10 @@ int main(int argc, char **argv)
 	list = malloc(max_size * sizeof(*list));
 
 	for(;;) {
-		ret = read_block(buf, fin);
+		ret = read_block(buf, BUF_SIZE, fin);
 		if (ret < 0)
 			break;
 
-		buf[ret] = '\0';
 		add_list(buf, ret);
 	}
 
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
swap-fix-setting-page_size-blocksize-during-swapoff-swapon-race.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

