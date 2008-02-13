From: akpm@linux-foundation.org
Subject: + udf-fix-udf_add_free_space.patch added to -mm tree
Date: Tue, 12 Feb 2008 23:13:15 -0800
Message-ID: <200802130714.m1D7EaFH013483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34875 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754234AbYBMHOn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 02:14:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, gorcunov@gmail.com, jack@suse.cz


The patch titled
     udf: fix udf_add_free_space
has been added to the -mm tree.  Its filename is
     udf-fix-udf_add_free_space.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: udf: fix udf_add_free_space
From: Marcin Slusarz <marcin.slusarz@gmail.com>

In commit 742ba02a51c8d0bf5446b154531179760c1ed0a2 (udf: create common
function for changing free space counter) by accident I reversed safety
condition which lead to null pointer dereference in case of media error and
wrong counting of free space in normal situation

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/balloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/udf/balloc.c~udf-fix-udf_add_free_space fs/udf/balloc.c
--- a/fs/udf/balloc.c~udf-fix-udf_add_free_space
+++ a/fs/udf/balloc.c
@@ -145,7 +145,7 @@ static bool udf_add_free_space(struct ud
 {
 	struct logicalVolIntegrityDesc *lvid;
 
-	if (sbi->s_lvid_bh)
+	if (sbi->s_lvid_bh == NULL)
 		return false;
 
 	lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
udf-fix-directory-offset-handling.patch
udf-fix-udf_add_free_space.patch
