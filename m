From: akpm@linux-foundation.org
Subject: + ad525x_dpot-use-correct-rdac-channel-for-ad5251-ad5252.patch added to -mm tree
Date: Thu, 21 Oct 2010 14:49:39 -0700
Message-ID: <201010212149.o9LLnduK005674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758099Ab0JUVtp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 17:49:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: realmz6@gmail.com, chrisv@cyberswitching.com, michael.hennerich@analog.com, vapier@gentoo.org


The patch titled
     ad525x_dpot: use correct rdac channel for ad5251/ad5252
has been added to the -mm tree.  Its filename is
     ad525x_dpot-use-correct-rdac-channel-for-ad5251-ad5252.patch

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
Subject: ad525x_dpot: use correct rdac channel for ad5251/ad5252
From: steven miao <realmz6@gmail.com>

The ad5251/ad5252 devices have rdac1 and rdac3, but no rdac0.  So make
sure we use the right channels so userspace gets correct data and not just
garbage.

Signed-off-by: steven miao <realmz6@gmail.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Chris Verges <chrisv@cyberswitching.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ad525x_dpot.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/misc/ad525x_dpot.h~ad525x_dpot-use-correct-rdac-channel-for-ad5251-ad5252 drivers/misc/ad525x_dpot.h
--- a/drivers/misc/ad525x_dpot.h~ad525x_dpot-use-correct-rdac-channel-for-ad5251-ad5252
+++ a/drivers/misc/ad525x_dpot.h
@@ -47,9 +47,9 @@ enum dpot_devid {
 	AD5258_ID = DPOT_CONF(F_RDACS_RW_TOL, BRDAC0, 6, 0), /* I2C */
 	AD5259_ID = DPOT_CONF(F_RDACS_RW_TOL, BRDAC0, 8, 1),
 	AD5251_ID = DPOT_CONF(F_RDACS_RW_TOL | F_CMD_INC,
-			BRDAC0 | BRDAC3, 6, 2),
+			BRDAC1 | BRDAC3, 6, 2),
 	AD5252_ID = DPOT_CONF(F_RDACS_RW_TOL | F_CMD_INC,
-			BRDAC0 | BRDAC3, 8, 3),
+			BRDAC1 | BRDAC3, 8, 3),
 	AD5253_ID = DPOT_CONF(F_RDACS_RW_TOL | F_CMD_INC,
 			BRDAC0 | BRDAC1 | BRDAC2 | BRDAC3, 6, 4),
 	AD5254_ID = DPOT_CONF(F_RDACS_RW_TOL | F_CMD_INC,
_

Patches currently in -mm which might be from realmz6@gmail.com are

linux-next.patch
ad525x_dpot-use-correct-rdac-channel-for-ad5251-ad5252.patch

