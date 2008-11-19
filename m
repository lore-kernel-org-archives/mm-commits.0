From: akpm@linux-foundation.org
Subject: + udf-reduce-stack-usage-of-udf_get_filename.patch added to -mm tree
Date: Tue, 18 Nov 2008 16:19:56 -0800
Message-ID: <200811190019.mAJ0JufA018762@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033AbYKSAU3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 19:20:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, jack@suse.cz


The patch titled
     udf: reduce stack usage of udf_get_filename
has been added to the -mm tree.  Its filename is
     udf-reduce-stack-usage-of-udf_get_filename.patch

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
Subject: udf: reduce stack usage of udf_get_filename
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Allocate strings with kmalloc.

Checkstack output:
Before: udf_get_filename:          600
After:  udf_get_filename:          136

(akpm: use GFP_KERNEL?)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/unicode.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff -puN fs/udf/unicode.c~udf-reduce-stack-usage-of-udf_get_filename fs/udf/unicode.c
--- a/fs/udf/unicode.c~udf-reduce-stack-usage-of-udf_get_filename
+++ a/fs/udf/unicode.c
@@ -324,34 +324,43 @@ try_again:
 int udf_get_filename(struct super_block *sb, uint8_t *sname, uint8_t *dname,
 		     int flen)
 {
-	struct ustr filename, unifilename;
-	int len;
+	struct ustr *filename, *unifilename;
+	int len = 0;
 
-	if (udf_build_ustr_exact(&unifilename, sname, flen))
+	filename = kmalloc(sizeof(struct ustr), GFP_NOFS);
+	if (!filename)
 		return 0;
 
+	unifilename = kmalloc(sizeof(struct ustr), GFP_NOFS);
+	if (!unifilename)
+		goto out1;
+
+	if (udf_build_ustr_exact(unifilename, sname, flen))
+		goto out2;
+
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8)) {
-		if (!udf_CS0toUTF8(&filename, &unifilename)) {
+		if (!udf_CS0toUTF8(filename, unifilename)) {
 			udf_debug("Failed in udf_get_filename: sname = %s\n",
 				  sname);
-			return 0;
+			goto out2;
 		}
 	} else if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP)) {
-		if (!udf_CS0toNLS(UDF_SB(sb)->s_nls_map, &filename,
-				  &unifilename)) {
+		if (!udf_CS0toNLS(UDF_SB(sb)->s_nls_map, filename,
+				  unifilename)) {
 			udf_debug("Failed in udf_get_filename: sname = %s\n",
 				  sname);
-			return 0;
+			goto out2;
 		}
 	} else
-		return 0;
