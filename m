From: akpm@linux-foundation.org
Subject: +
 drivers-misc-sgi-gru-grufaultc-fix-a-sanity-test-in-gru_set_context_option.patch added to -mm tree
Date: Fri, 31 May 2013 14:28:55 -0700
Message-ID: <51a91617./yEssEK6/sX0nQys%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab3EaV24 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 17:28:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, holt@sgi.com, dan.carpenter@oracle.com, sivanich@sgi.com

Subject: + drivers-misc-sgi-gru-grufaultc-fix-a-sanity-test-in-gru_set_context_option.patch added to -mm tree
To: sivanich@sgi.com,dan.carpenter@oracle.com,holt@sgi.com
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 14:28:55 -0700


The patch titled
     Subject: drivers/misc/sgi-gru/grufault.c: fix a sanity test in gru_set_context_option()
has been added to the -mm tree.  Its filename is
     drivers-misc-sgi-gru-grufaultc-fix-a-sanity-test-in-gru_set_context_option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dimitri Sivanich <sivanich@sgi.com>
Subject: drivers/misc/sgi-gru/grufault.c: fix a sanity test in gru_set_context_option()

"req.val1 == -1" is valid but it doesn't make sense to check gru_base[-1].
 gru_base[] is a global array.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~drivers-misc-sgi-gru-grufaultc-fix-a-sanity-test-in-gru_set_context_option drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~drivers-misc-sgi-gru-grufaultc-fix-a-sanity-test-in-gru_set_context_option
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -876,8 +876,9 @@ int gru_set_context_option(unsigned long
 	switch (req.op) {
 	case sco_blade_chiplet:
 		/* Select blade/chiplet for GRU context */
-		if (req.val1 < -1 || req.val1 >= GRU_MAX_BLADES || !gru_base[req.val1] ||
-		    req.val0 < -1 || req.val0 >= GRU_CHIPLETS_PER_HUB) {
+		if (req.val0 < -1 || req.val0 >= GRU_CHIPLETS_PER_HUB ||
+		    req.val1 < -1 || req.val1 >= GRU_MAX_BLADES ||
+		    (req.val1 >= 0 && !gru_base[req.val1])) {
 			ret = -EINVAL;
 		} else {
 			gts->ts_user_blade_id = req.val1;
_

Patches currently in -mm which might be from sivanich@sgi.com are

drivers-misc-sgi-gru-grufilec-fix-info-leak-in-gru_get_config_info.patch
drivers-misc-sgi-gru-grufaultc-fix-a-sanity-test-in-gru_set_context_option.patch

