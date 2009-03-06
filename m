From: akpm@linux-foundation.org
Subject: + udf-fix-novrs-mount-option.patch added to -mm tree
Date: Fri, 06 Mar 2009 15:04:49 -0800
Message-ID: <200903062304.n26N4n0A009734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792AbZCFXFl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 18:05:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clemens@ladisch.de, jack@ucw.cz, stable@kernel.org


The patch titled
     udf: fix novrs mount option
has been added to the -mm tree.  Its filename is
     udf-fix-novrs-mount-option.patch

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
Subject: udf: fix novrs mount option
From: Clemens Ladisch <clemens@ladisch.de>

The novrs mount option was broken due to a missing break.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Cc: Jan Kara <jack@ucw.cz>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/super.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/udf/super.c~udf-fix-novrs-mount-option fs/udf/super.c
--- a/fs/udf/super.c~udf-fix-novrs-mount-option
+++ a/fs/udf/super.c
@@ -439,6 +439,7 @@ static int udf_parse_options(char *optio
 		switch (token) {
 		case Opt_novrs:
 			uopt->novrs = 1;
+			break;
 		case Opt_bs:
 			if (match_int(&args[0], &option))
 				return 0;
_

Patches currently in -mm which might be from clemens@ladisch.de are

linux-next.patch
udf-fix-novrs-mount-option.patch

