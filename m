From: akpm@linux-foundation.org
Subject: + dvb-negative-internal-sub_range-wont-get-noticed.patch added to -mm tree
Date: Mon, 26 Jan 2009 22:40:48 -0800
Message-ID: <200901270640.n0R6emcD000600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751655AbZA0Gk5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 01:40:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, mchehab@infradead.org


The patch titled
     dvb: negative internal->sub_range won't get noticed
has been added to the -mm tree.  Its filename is
     dvb-negative-internal-sub_range-wont-get-noticed.patch

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
Subject: dvb: negative internal->sub_range won't get noticed
From: Roel Kluin <roel.kluin@gmail.com>

internal->sub_range is unsigned, a negative won't get noticed.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/stb0899_algo.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/media/dvb/frontends/stb0899_algo.c~dvb-negative-internal-sub_range-wont-get-noticed drivers/media/dvb/frontends/stb0899_algo.c
--- a/drivers/media/dvb/frontends/stb0899_algo.c~dvb-negative-internal-sub_range-wont-get-noticed
+++ a/drivers/media/dvb/frontends/stb0899_algo.c
@@ -467,13 +467,14 @@ static void next_sub_range(struct stb089
 
 	if (internal->sub_dir > 0) {
 		old_sub_range = internal->sub_range;
-		internal->sub_range = MIN((internal->srch_range / 2) -
+		if (internal->tuner_offst + internal->sub_range / 2 >=
+				internal->srch_range / 2)
+			internal->sub_range = 0;
+		else
+			internal->sub_range = MIN((internal->srch_range / 2) -
 					  (internal->tuner_offst + internal->sub_range / 2),
 					   internal->sub_range);
 
-		if (internal->sub_range < 0)
-			internal->sub_range = 0;
