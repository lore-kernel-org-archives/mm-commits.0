From: akpm@linux-foundation.org
Subject: + proc-use-null-instead-of-0-for-pointer.patch added to -mm tree
Date: Wed, 12 Sep 2012 12:05:08 -0700
Message-ID: <20120912190508.AD0121E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:37767 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab2ILTFJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 15:05:09 -0400
Received: by vcbfy27 with SMTP id fy27so89757vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 12:05:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org


The patch titled
     Subject: fs/proc/root.c: use NULL instead of 0 for pointer
has been added to the -mm tree.  Its filename is
     proc-use-null-instead-of-0-for-pointer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: fs/proc/root.c: use NULL instead of 0 for pointer

This cleanup also fixes the following sparse warning:
fs/proc/root.c:64:45: warning: Using plain integer as NULL pointer

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/root.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/root.c~proc-use-null-instead-of-0-for-pointer fs/proc/root.c
--- a/fs/proc/root.c~proc-use-null-instead-of-0-for-pointer
+++ a/fs/proc/root.c
@@ -61,7 +61,7 @@ static int proc_parse_options(char *opti
 		if (!*p)
 			continue;
 
-		args[0].to = args[0].from = 0;
+		args[0].to = args[0].from = NULL;
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_gid:
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

linux-next.patch
drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
proc-use-null-instead-of-0-for-pointer.patch

