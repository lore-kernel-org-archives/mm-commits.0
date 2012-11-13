From: akpm@linux-foundation.org
Subject: + bnx2x-use-prandom_bytes.patch added to -mm tree
Date: Tue, 13 Nov 2012 11:54:28 -0800
Message-ID: <20121113195428.712FE100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:43379 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab2KMTya (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 14:54:30 -0500
Received: by mail-qa0-f74.google.com with SMTP id g40so404205qab.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 11:54:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, adrian.hunter@intel.com, david.laight@aculab.com, dedekind1@gmail.com, dwmw2@infradead.org, eilong@broadcom.com, robert.w.love@intel.com, tytso@mit.edu, valdis.kletnieks@vt.edu, walken@google.com


The patch titled
     Subject: bnx2x: use prandom_bytes()
has been added to the -mm tree.  Its filename is
     bnx2x-use-prandom_bytes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: bnx2x: use prandom_bytes()

Use prandom_bytes() to fill rss key with pseudo-random bytes.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Eilon Greenstein <eilong@broadcom.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Laight <david.laight@aculab.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Robert Love <robert.w.love@intel.com>
Cc: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c~bnx2x-use-prandom_bytes drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c~bnx2x-use-prandom_bytes
+++ a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -1815,7 +1815,6 @@ int bnx2x_config_rss_pf(struct bnx2x *bp
 			bool config_hash)
 {
 	struct bnx2x_config_rss_params params = {NULL};
-	int i;
 
 	/* Although RSS is meaningless when there is a single HW queue we
 	 * still need it enabled in order to have HW Rx hash generated.
@@ -1847,9 +1846,7 @@ int bnx2x_config_rss_pf(struct bnx2x *bp
 
 	if (config_hash) {
 		/* RSS keys */
-		for (i = 0; i < sizeof(params.rss_key) / 4; i++)
-			params.rss_key[i] = random32();
