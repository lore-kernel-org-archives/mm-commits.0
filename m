From: akpm@linux-foundation.org
Subject: + debugging-keep-track-of-page-owners-fix-2-fix-fix.patch added to -mm tree
Date: Mon, 14 Jan 2013 16:36:56 -0800
Message-ID: <20130115003657.3083382004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:51287 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684Ab3AOAg6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 19:36:58 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so485744vbi.3
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 16:36:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, dave@linux.vnet.ibm.com, mina86@mina86.com


The patch titled
     Subject: Enhance read_block of page_owner.c
has been added to the -mm tree.  Its filename is
     debugging-keep-track-of-page-owners-fix-2-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch
mm-prevent-addition-of-pages-to-swap-if-may_writepage-is-unset.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix.patch

