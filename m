From: akpm@linux-foundation.org
Subject: + udf-reduce-stack-usage-of-udf_load_pvoldesc.patch added to -mm tree
Date: Tue, 18 Nov 2008 16:18:13 -0800
Message-ID: <200811190018.mAJ0IDUN017907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844AbYKSASs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 19:18:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, jack@suse.cz


The patch titled
     udf: reduce stack usage of udf_load_pvoldesc
has been added to the -mm tree.  Its filename is
     udf-reduce-stack-usage-of-udf_load_pvoldesc.patch

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
Subject: udf: reduce stack usage of udf_load_pvoldesc
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Allocate strings with kmalloc.

Checkstack output:
Before: udf_process_sequence:      712
After:  udf_process_sequence:      200

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/super.c |   36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff -puN fs/udf/super.c~udf-reduce-stack-usage-of-udf_load_pvoldesc fs/udf/super.c
--- a/fs/udf/super.c~udf-reduce-stack-usage-of-udf_load_pvoldesc
+++ a/fs/udf/super.c
@@ -902,14 +902,23 @@ static int udf_find_fileset(struct super
 static int udf_load_pvoldesc(struct super_block *sb, sector_t block)
 {
 	struct primaryVolDesc *pvoldesc;
-	struct ustr instr;
-	struct ustr outstr;
+	struct ustr *instr, *outstr;
 	struct buffer_head *bh;
 	uint16_t ident;
+	int ret = 1;
+
+	instr = kmalloc(sizeof(struct ustr), GFP_NOFS);
+	if (!instr)
+		return 1;
+
+	outstr = kmalloc(sizeof(struct ustr), GFP_NOFS);
+	if (!outstr)
+		goto out1;
 
 	bh = udf_read_tagged(sb, block, block, &ident);
 	if (!bh)
-		return 1;
+		goto out2;
+
 	BUG_ON(ident != TAG_IDENT_PVD);
 
 	pvoldesc = (struct primaryVolDesc *)bh->b_data;
@@ -925,20 +934,25 @@ static int udf_load_pvoldesc(struct supe
 #endif
 	}
 
-	if (!udf_build_ustr(&instr, pvoldesc->volIdent, 32))
-		if (udf_CS0toUTF8(&outstr, &instr)) {
-			strncpy(UDF_SB(sb)->s_volume_ident, outstr.u_name,
-				outstr.u_len > 31 ? 31 : outstr.u_len);
+	if (!udf_build_ustr(instr, pvoldesc->volIdent, 32))
+		if (udf_CS0toUTF8(outstr, instr)) {
+			strncpy(UDF_SB(sb)->s_volume_ident, outstr->u_name,
+				outstr->u_len > 31 ? 31 : outstr->u_len);
 			udf_debug("volIdent[] = '%s'\n",
 					UDF_SB(sb)->s_volume_ident);
 		}
 
-	if (!udf_build_ustr(&instr, pvoldesc->volSetIdent, 128))
-		if (udf_CS0toUTF8(&outstr, &instr))
-			udf_debug("volSetIdent[] = '%s'\n", outstr.u_name);
+	if (!udf_build_ustr(instr, pvoldesc->volSetIdent, 128))
+		if (udf_CS0toUTF8(outstr, instr))
+			udf_debug("volSetIdent[] = '%s'\n", outstr->u_name);
 
 	brelse(bh);
-	return 0;
+	ret = 0;
+out2:
+	kfree(outstr);
+out1:
+	kfree(instr);
+	return ret;
 }
 
 static int udf_load_metadata_files(struct super_block *sb, int partition)
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

udf-reduce-stack-usage-of-udf_load_pvoldesc.patch
udf-reduce-stack-usage-of-udf_get_filename.patch

