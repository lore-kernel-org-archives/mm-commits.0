From: akpm@linux-foundation.org
Subject: - e1000e-fix-double-release-of-mutex.patch removed from -mm tree
Date: Mon, 15 Dec 2008 12:02:24 -0800
Message-ID: <200812152002.mBFK2Oiq030918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978AbYLOUDE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 15:03:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffrey.t.kirsher@intel.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     e1000e: fix double release of mutex
has been removed from the -mm tree.  Its filename was
     e1000e-fix-double-release-of-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

