From: akpm@linux-foundation.org
Subject: + hvsi-messed-up-error-checking-getting-state-name.patch added to -mm tree
Date: Fri, 16 Apr 2010 15:18:13 -0700
Message-ID: <201004162218.o3GMIDtH029917@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932646Ab0DPWSY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Apr 2010 18:18:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-phil.2.carmody@nokia.com, benh@kernel.crashing.org, grant.likely@secretlab.ca, roel.kluin@gmail.com


The patch titled
     hvsi: fix messed up error checking getting state name
has been added to the -mm tree.  Its filename is
     hvsi-messed-up-error-checking-getting-state-name.patch

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
Subject: hvsi: fix messed up error checking getting state name
From: Phil Carmody <ext-phil.2.carmody@nokia.com>

Handle out-of-range indices before reading what they refer to.  And don't
access the one-past-the-end element of the array either.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Roel Kluin <roel.kluin@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hvsi.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/char/hvsi.c~hvsi-messed-up-error-checking-getting-state-name drivers/char/hvsi.c
--- a/drivers/char/hvsi.c~hvsi-messed-up-error-checking-getting-state-name
+++ a/drivers/char/hvsi.c
@@ -194,10 +194,8 @@ static inline void print_state(struct hv
 		"HVSI_WAIT_FOR_MCTRL_RESPONSE",
 		"HVSI_FSP_DIED",
 	};
-	const char *name = state_names[hp->state];
