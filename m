From: akpm@linux-foundation.org
Subject: + drivers-media-dvb-use-dst_type-field-instead-of-type_flags.patch added to -mm tree
Date: Mon, 27 Jul 2009 14:11:13 -0700
Message-ID: <200907272111.n6RLBDf8009877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754836AbZG0VL5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jul 2009 17:11:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, mchehab@infradead.org


The patch titled
     drivers/media/dvb: Use dst_type field instead of type_flags
has been added to the -mm tree.  Its filename is
     drivers-media-dvb-use-dst_type-field-instead-of-type_flags.patch

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

origin.patch
linux-next.patch
drivers-media-dvb-use-dst_type-field-instead-of-type_flags.patch
drivers-ata-use-resource_size.patch
drivers-video-imxfbc-fix-resource-size-off-by-1-error.patch
edac-fix-resource-size-calculation.patch
drivers-vlynq-vlynqc-fix-resource-size-off-by-1-error.patch

