From: akpm@linux-foundation.org
Subject: [merged] drivers-char-ipmi-use-kcs_idle_state.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:39:00 -0800
Message-ID: <200912162039.nBGKd0jc013494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964980AbZLPUjG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:39:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     drivers/char/ipmi: Use KCS_IDLE_STATE
has been removed from the -mm tree.  Its filename was
     drivers-char-ipmi-use-kcs_idle_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/ipmi: Use KCS_IDLE_STATE
From: Julia Lawall <julia@diku.dk>

KCS_IDLE and KCS_IDLE state have the same value, but in this function the
constants ending in _STATE are compared to the state variable.

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_kcs_sm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_kcs_sm.c~drivers-char-ipmi-use-kcs_idle_state drivers/char/ipmi/ipmi_kcs_sm.c
--- a/drivers/char/ipmi/ipmi_kcs_sm.c~drivers-char-ipmi-use-kcs_idle_state
+++ a/drivers/char/ipmi/ipmi_kcs_sm.c
@@ -370,7 +370,7 @@ static enum si_sm_result kcs_event(struc
 			return SI_SM_IDLE;
 
 	case KCS_START_OP:
-		if (state != KCS_IDLE) {
+		if (state != KCS_IDLE_STATE) {
 			start_error_recovery(kcs,
 					     "State machine not idle at start");
 			break;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-media-video-move-dereference-after-null-test.patch
drivers-isdn-eliminate-duplicated-test.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-block-dac960c-use-dac960_v2_controller.patch
drivers-usb-wusbcore-introduce-missing-usb_free_urb.patch
drivers-edac-introduce-missing-kfree.patch

