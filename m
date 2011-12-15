From: akpm@linux-foundation.org
Subject: [alternative-merged] drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch removed from -mm tree
Date: Thu, 15 Dec 2011 13:28:01 -0800
Message-ID: <20111215212801.D37B710004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:49478 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab1LOV2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2011 16:28:03 -0500
Received: by yenm5 with SMTP id m5so275361yen.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2011 13:28:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wferi@niif.hu, kashyap.desai@lsi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/message/fusion/mptbase.c: ensure NUL-termination of MptCallbacksName elements
has been removed from the -mm tree.  Its filename was
     drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Ferenc Wagner <wferi@niif.hu>
Subject: drivers/message/fusion/mptbase.c: ensure NUL-termination of MptCallbacksName elements

I just stumbled upon this while pondering over
https://bugzilla.kernel.org/show_bug.cgi?id=26692 and thought this could
be made better.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Ferenc Wagner <wferi@niif.hu>
Cc: Desai <kashyap.desai@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |    7 ++++---
 drivers/message/fusion/mptbase.h |    1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements
+++ a/drivers/message/fusion/mptbase.c
@@ -115,7 +115,8 @@ module_param(mpt_fwfault_debug, int, 060
 MODULE_PARM_DESC(mpt_fwfault_debug,
 		 "Enable detection of Firmware fault and halt Firmware on fault - (default=0)");
 
-static char	MptCallbacksName[MPT_MAX_PROTOCOL_DRIVERS][50];
+static char
+MptCallbacksName[MPT_MAX_PROTOCOL_DRIVERS][MPT_MAX_CALLBACKNAME_LEN + 1];
 
 #ifdef MFCNT
 static int mfcounter = 0;
@@ -717,8 +718,8 @@ mpt_register(MPT_CALLBACK cbfunc, MPT_DR
 			MptDriverClass[cb_idx] = dclass;
 			MptEvHandlers[cb_idx] = NULL;
 			last_drv_idx = cb_idx;
-			memcpy(MptCallbacksName[cb_idx], func_name,
-			    strlen(func_name) > 50 ? 50 : strlen(func_name));
+			strlcpy(MptCallbacksName[cb_idx], func_name,
+				MPT_MAX_CALLBACKNAME_LEN+1);
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

linux-next.patch

