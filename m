From: akpm@linux-foundation.org
Subject: + drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch added to -mm tree
Date: Thu, 25 Aug 2011 16:57:06 -0700
Message-ID: <201108252357.p7PNv66g021081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409Ab1HYX5Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Aug 2011 19:57:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wferi@niif.hu, kashyap.desai@lsi.com


The patch titled
     drivers/message/fusion/mptbase.c: ensure NUL-termination of MptCallbacksName elements
has been added to the -mm tree.  Its filename is
     drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch

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
Subject: drivers/message/fusion/mptbase.c: ensure NUL-termination of MptCallbacksName elements
From: Ferenc Wagner <wferi@niif.hu>

unchangelogged

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
Cc: Desai <kashyap.desai@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |    5 ++---
 drivers/message/fusion/mptbase.h |    1 +
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements
+++ a/drivers/message/fusion/mptbase.c
@@ -115,7 +115,7 @@ module_param(mpt_fwfault_debug, int, 060
 MODULE_PARM_DESC(mpt_fwfault_debug,
 		 "Enable detection of Firmware fault and halt Firmware on fault - (default=0)");
 
-static char	MptCallbacksName[MPT_MAX_PROTOCOL_DRIVERS][50];
+static char	MptCallbacksName[MPT_MAX_PROTOCOL_DRIVERS][MPT_MAX_CALLBACKNAME_LEN+1];
 
 #ifdef MFCNT
 static int mfcounter = 0;
@@ -717,8 +717,7 @@ mpt_register(MPT_CALLBACK cbfunc, MPT_DR
 			MptDriverClass[cb_idx] = dclass;
 			MptEvHandlers[cb_idx] = NULL;
 			last_drv_idx = cb_idx;
-			memcpy(MptCallbacksName[cb_idx], func_name,
-			    strlen(func_name) > 50 ? 50 : strlen(func_name));
+			strlcpy(MptCallbacksName[cb_idx], func_name, MPT_MAX_CALLBACKNAME_LEN+1);
 			break;
 		}
 	}
diff -puN drivers/message/fusion/mptbase.h~drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements drivers/message/fusion/mptbase.h
--- a/drivers/message/fusion/mptbase.h~drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements
+++ a/drivers/message/fusion/mptbase.h
@@ -89,6 +89,7 @@
  */
 #define MPT_MAX_ADAPTERS		18
 #define MPT_MAX_PROTOCOL_DRIVERS	16
+#define MPT_MAX_CALLBACKNAME_LEN	49
 #define MPT_MAX_BUS			1	/* Do not change */
 #define MPT_MAX_FC_DEVICES		255
 #define MPT_MAX_SCSI_DEVICES		16
_

Patches currently in -mm which might be from wferi@niif.hu are

drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch

