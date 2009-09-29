From: akpm@linux-foundation.org
Subject: + drivers-char-ipmi-use-kcs_idle_state.patch added to -mm tree
Date: Tue, 29 Sep 2009 14:11:29 -0700
Message-ID: <200909292111.n8TLBTsQ007905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751610AbZI2VMA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 17:12:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, minyard@acm.org


The patch titled
     drivers/char/ipmi: Use KCS_IDLE_STATE
has been added to the -mm tree.  Its filename is
     drivers-char-ipmi-use-kcs_idle_state.patch

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

linux-next.patch
drivers-md-introduce-missing-kfree.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-char-ipmi-use-kcs_idle_state.patch

