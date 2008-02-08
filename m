From: akpm@linux-foundation.org
Subject: - udf-check-if-udf_load_logicalvol-failed.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:17:11 -0800
Message-ID: <200802082016.m18KGqtM010763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36942 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755306AbYBHVDD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:03:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, bfennema@falcon.csc.calpoly.edu, hch@infradead.org, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     udf: check if udf_load_logicalvol failed
has been removed from the -mm tree.  Its filename was
     udf-check-if-udf_load_logicalvol-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: udf: check if udf_load_logicalvol failed
From: Marcin Slusarz <marcin.slusarz@gmail.com>

udf_load_logicalvol may fail eg in out of memory conditions - check it
and propagate error further

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/super.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/udf/super.c~udf-check-if-udf_load_logicalvol-failed fs/udf/super.c
--- a/fs/udf/super.c~udf-check-if-udf_load_logicalvol-failed
+++ a/fs/udf/super.c
@@ -1263,7 +1263,10 @@ static int udf_process_sequence(struct s
 			if (i == VDS_POS_PRIMARY_VOL_DESC) {
 				udf_load_pvoldesc(sb, bh);
 			} else if (i == VDS_POS_LOGICAL_VOL_DESC) {
-				udf_load_logicalvol(sb, bh, fileset); /* TODO: check return value */
+				if (udf_load_logicalvol(sb, bh, fileset)) {
+					brelse(bh);
+					return 1;
+				}
 			} else if (i == VDS_POS_PARTITION_DESC) {
 				struct buffer_head *bh2 = NULL;
 				if (udf_load_partdesc(sb, bh)) {
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
