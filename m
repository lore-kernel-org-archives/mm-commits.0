From: akpm@linux-foundation.org
Subject: [merged] drivers-media-dvb-use-dst_type-field-instead-of-type_flags.patch removed from -mm tree
Date: Fri, 21 Aug 2009 14:06:42 -0700
Message-ID: <200908212106.n7LL6gm8007772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932672AbZHUVHV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Aug 2009 17:07:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/dvb: Use dst_type field instead of type_flags
has been removed from the -mm tree.  Its filename was
     drivers-media-dvb-use-dst_type-field-instead-of-type_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/dvb: Use dst_type field instead of type_flags
From: Julia Lawall <julia@diku.dk>

It seems from other code that it is the dst_type field rather than the
type_flags field that contains values of the form DST_TYPE_IS...
The type_flags field contains values of the form DST_TYPE_HAS...

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ struct dst_state E; @@

(
*E.type_flags ==
  \( DST_TYPE_IS_SAT\|DST_TYPE_IS_TERR\|DST_TYPE_IS_CABLE\|DST_TYPE_IS_ATSC \)
|
*E.type_flags !=
  \( DST_TYPE_IS_SAT\|DST_TYPE_IS_TERR\|DST_TYPE_IS_CABLE\|DST_TYPE_IS_ATSC \)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/bt8xx/dst.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/dvb/bt8xx/dst.c~drivers-media-dvb-use-dst_type-field-instead-of-type_flags drivers/media/dvb/bt8xx/dst.c
--- a/drivers/media/dvb/bt8xx/dst.c~drivers-media-dvb-use-dst_type-field-instead-of-type_flags
+++ a/drivers/media/dvb/bt8xx/dst.c
@@ -1059,7 +1059,7 @@ static int dst_get_tuner_info(struct dst
 		dprintk(verbose, DST_ERROR, 1, "DST type has TS=188");
 	}
 	if (state->board_info[0] == 0xbc) {
-		if (state->type_flags != DST_TYPE_IS_ATSC)
+		if (state->dst_type != DST_TYPE_IS_ATSC)
 			state->type_flags |= DST_TYPE_HAS_TS188;
 		else
 			state->type_flags |= DST_TYPE_HAS_NEWTUNE_2;
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-ata-use-resource_size.patch
drivers-md-introduce-missing-kfree.patch
drivers-rtc-correct-error-handling-code.patch
drivers-rtc-introduce-missing-kfree.patch
drivers-video-add-kmalloc-null-tests.patch
drivers-video-add-kmalloc-null-tests-fix.patch
edac-fix-resource-size-calculation.patch
fs-romfs-correct-error-handling-code.patch
drivers-vlynq-vlynqc-fix-resource-size-off-by-1-error.patch

