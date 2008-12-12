From: akpm@linux-foundation.org
Subject: + e1000e-fix-double-release-of-mutex.patch added to -mm tree
Date: Thu, 11 Dec 2008 19:24:59 -0800
Message-ID: <200812120324.mBC3OxjM004704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838AbYLLDZI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Dec 2008 22:25:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffrey.t.kirsher@intel.com, stable@kernel.org


The patch titled
     e1000e: fix double release of mutex
has been added to the -mm tree.  Its filename is
     e1000e-fix-double-release-of-mutex.patch

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
Subject: e1000e: fix double release of mutex
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

During a reset, releasing the swflag after it failed to be acquired would
cause a double unlock of the mutex.  Instead, test whether acquisition of
the swflag was successful and if not, do not release the swflag.  The
reset must still be done to bring the device to a quiescent state.

This resolves [BUG 12200] BUG: bad unlock balance detected! e1000e
http://bugzilla.kernel.org/show_bug.cgi?id=12200

Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000e/ich8lan.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/net/e1000e/ich8lan.c~e1000e-fix-double-release-of-mutex drivers/net/e1000e/ich8lan.c
--- a/drivers/net/e1000e/ich8lan.c~e1000e-fix-double-release-of-mutex
+++ a/drivers/net/e1000e/ich8lan.c
@@ -1939,12 +1939,17 @@ static s32 e1000_reset_hw_ich8lan(struct
 		ctrl |= E1000_CTRL_PHY_RST;
 	}
 	ret_val = e1000_acquire_swflag_ich8lan(hw);
+	/* Whether or not the swflag was acquired, we need to reset the part */
 	hw_dbg(hw, "Issuing a global reset to ich8lan\n");
 	ew32(CTRL, (ctrl | E1000_CTRL_RST));
 	msleep(20);
 
-	/* release the swflag because it is not reset by hardware reset */
-	e1000_release_swflag_ich8lan(hw);
+	if (!ret_val) {
+		/* release the swflag because it is not reset by
+		 * hardware reset
+		 */
+		e1000_release_swflag_ich8lan(hw);
+	}
 
 	ret_val = e1000e_get_auto_rd_done(hw);
 	if (ret_val) {
_

Patches currently in -mm which might be from jeffrey.t.kirsher@intel.com are

linux-next.patch
e1000e-fix-double-release-of-mutex.patch

