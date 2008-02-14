From: akpm@linux-foundation.org
Subject: + qla3xxx-convert-byte-order-of-constant-instead-of-variable.patch added to -mm tree
Date: Thu, 14 Feb 2008 14:21:38 -0800
Message-ID: <200802142221.m1EMLc9P005960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42881 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756158AbYBNWWN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 17:22:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, ron.mercer@qlogic.com


The patch titled
     qla3xxx: convert byte order of constant instead of variable
has been added to the -mm tree.  Its filename is
     qla3xxx-convert-byte-order-of-constant-instead-of-variable.patch

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
Subject: qla3xxx: convert byte order of constant instead of variable
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Convert byte order of constant instead of variable which can be done at
compile time (vs run time)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Ron Mercer <ron.mercer@qlogic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/qla3xxx.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/net/qla3xxx.c~qla3xxx-convert-byte-order-of-constant-instead-of-variable drivers/net/qla3xxx.c
--- a/drivers/net/qla3xxx.c~qla3xxx-convert-byte-order-of-constant-instead-of-variable
+++ a/drivers/net/qla3xxx.c
@@ -2472,8 +2472,7 @@ static int ql_send_map(struct ql3_adapte
 
 	if (seg_cnt == 1) {
 		/* Terminate the last segment. */
-		oal_entry->len =
-		    cpu_to_le32(le32_to_cpu(oal_entry->len) | OAL_LAST_ENTRY);
+		oal_entry->len |= cpu_to_le32(OAL_LAST_ENTRY);
 	} else {
 		oal = tx_cb->oal;
 		for (completed_segs=0; completed_segs<frag_cnt; completed_segs++,seg++) {
@@ -2530,8 +2529,7 @@ static int ql_send_map(struct ql3_adapte
 					  frag->size);
 		}
 		/* Terminate the last segment. */
-		oal_entry->len =
-		    cpu_to_le32(le32_to_cpu(oal_entry->len) | OAL_LAST_ENTRY);
+		oal_entry->len |= cpu_to_le32(OAL_LAST_ENTRY);
 	}
 
 	return NETDEV_TX_OK;
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
udf-fix-directory-offset-handling.patch
udf-fix-udf_add_free_space.patch
git-gfs2-nmw.patch
jfs-le_add_cpu-conversion.patch
qla3xxx-convert-byte-order-of-constant-instead-of-variable.patch
ntfs-le_add_cpu-conversion.patch
ocfs2-le_add_cpu-conversion.patch
scsi-le_add_cpu-conversion.patch
ipw2200-le_add_cpu-conversion.patch
ext2-le_add_cpu-conversion.patch
ext2-convert-byte-order-of-constant-instead-of-variable.patch
ext3-convert-byte-order-of-constant-instead-of-variable.patch
ufs-e_add_cpu-conversion.patch
ufs-e_add_cpu-conversion-in-return.patch
reiserfs-le_add_cpu-conversion.patch
ext4-le_add_cpu-conversion.patch
ext4-convert-byte-order-of-constant-instead-of-variable.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
quota-le_add_cpu-conversion.patch
sysv-e_add_cpu-conversion.patch
