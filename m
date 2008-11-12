From: akpm@linux-foundation.org
Subject: + drivers-message-fusion-use-array_size.patch added to -mm tree
Date: Wed, 12 Nov 2008 15:34:09 -0800
Message-ID: <200811122334.mACNYAIo025712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754677AbYKLXfG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 18:35:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, Eric.Moore@lsil.com


The patch titled
     drivers/message/fusion: use ARRAY_SIZE
has been added to the -mm tree.  Its filename is
     drivers-message-fusion-use-array_size.patch

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
Subject: drivers/message/fusion: use ARRAY_SIZE
From: Julia Lawall <julia@diku.dk>

ARRAY_SIZE is more concise to use when the size of an array is divided by
the size of its type or the size of its first element.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@i@
@@

#include <linux/kernel.h>

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(E[...]))
+ ARRAY_SIZE(E)

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(T))
+ ARRAY_SIZE(E)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~drivers-message-fusion-use-array_size drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~drivers-message-fusion-use-array_size
+++ a/drivers/message/fusion/mptbase.c
@@ -4562,7 +4562,7 @@ WaitForDoorbellReply(MPT_ADAPTER *ioc, i
 			failcnt++;
 		hword = le16_to_cpu(CHIPREG_READ32(&ioc->chip->Doorbell) & 0x0000FFFF);
 		/* don't overflow our IOC hs_reply[] buffer! */
-		if (u16cnt < sizeof(ioc->hs_reply) / sizeof(ioc->hs_reply[0]))
+		if (u16cnt < ARRAY_SIZE(ioc->hs_reply))
 			hs_reply[u16cnt] = hword;
 		CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
 	}
@@ -7173,7 +7173,7 @@ union loginfo_type {
 
 	sas_loginfo.loginfo = log_info;
 	if ((sas_loginfo.dw.bus_type != 3 /*SAS*/) &&
-	    (sas_loginfo.dw.originator < sizeof(originator_str)/sizeof(char*)))
+	    (sas_loginfo.dw.originator < ARRAY_SIZE(originator_str)))
 		return;
 
 	originator_desc = originator_str[sas_loginfo.dw.originator];
@@ -7182,21 +7182,21 @@ union loginfo_type {
 
 		case 0:  /* IOP */
 			if (sas_loginfo.dw.code <
-			    sizeof(iop_code_str)/sizeof(char*))
+			    ARRAY_SIZE(iop_code_str))
 				code_desc = iop_code_str[sas_loginfo.dw.code];
 			break;
 		case 1:  /* PL */
 			if (sas_loginfo.dw.code <
-			    sizeof(pl_code_str)/sizeof(char*))
+			    ARRAY_SIZE(pl_code_str))
 				code_desc = pl_code_str[sas_loginfo.dw.code];
 			break;
 		case 2:  /* IR */
 			if (sas_loginfo.dw.code >=
-			    sizeof(ir_code_str)/sizeof(char*))
+			    ARRAY_SIZE(ir_code_str))
 				break;
 			code_desc = ir_code_str[sas_loginfo.dw.code];
 			if (sas_loginfo.dw.subcode >=
-			    sizeof(raid_sub_code_str)/sizeof(char*))
+			    ARRAY_SIZE(raid_sub_code_str))
 			break;
 			if (sas_loginfo.dw.code == 0)
 				sub_code_desc =
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-media-use-array_size.patch
drivers-isdn-misdn-use-array_size.patch
drivers-message-fusion-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
crypto-md4c-use-array_size.patch

