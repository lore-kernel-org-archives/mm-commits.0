From: akpm@linux-foundation.org
Subject: - qla3xxx-convert-byte-order-of-constant-instead-of-variable.patch removed from -mm tree
Date: Wed, 26 Mar 2008 11:39:53 -0700
Message-ID: <200803261839.m2QIdrI9028572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755035AbYCZSj4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 14:39:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, ron.mercer@qlogic.com, mm-commits@vger.kernel.org


The patch titled
     qla3xxx: convert byte order of constant instead of variable
has been removed from the -mm tree.  Its filename was
     qla3xxx-convert-byte-order-of-constant-instead-of-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-jfs.patch
git-udf.patch
git-net.patch
ntfs-le_add_cpu-conversion.patch
git-sched.patch
scsi-le_add_cpu-conversion.patch
git-cryptodev.patch
ext2-le_add_cpu-conversion.patch
ext2-convert-byte-order-of-constant-instead-of-variable.patch
ext3-convert-byte-order-of-constant-instead-of-variable.patch
ufs-e_add_cpu-conversion.patch
ufs-remove-unused-fs64_add-and-fs64_sub.patch
reiserfs-le_add_cpu-conversion.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch
quota-le_add_cpu-conversion.patch
sysv-e_add_cpu-conversion.patch

