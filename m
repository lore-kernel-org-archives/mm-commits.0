From: akpm@linux-foundation.org
Subject: + rfcomm-corec-avoid-dangling-pointer-check-session-exists.patch added to -mm tree
Date: Tue, 24 May 2011 12:19:23 -0700
Message-ID: <201105241919.p4OJJOAV009853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756092Ab1EXTUJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 15:20:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, David@fries.net, linville@tuxdriver.com, marcel@holtmann.org, padovan@profusion.mobi


The patch titled
     rfcomm/core.c: avoid dangling pointer, check session exists
has been added to the -mm tree.  Its filename is
     rfcomm-corec-avoid-dangling-pointer-check-session-exists.patch

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
Subject: rfcomm/core.c: avoid dangling pointer, check session exists
From: David Fries <david@fries.net>

rfcomm_process_sessions is calling rfcomm_process_rx, but in this case the
session is closed and freed leaving a dangling pointer that blows up when
rfcomm_process_rx returns and rfcomm_process_dlcs is called with the now
dangling session pointer.  Check to see if the entry is still in the list.

Signed-off-by: David Fries <David@Fries.net>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/rfcomm/core.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN net/bluetooth/rfcomm/core.c~rfcomm-corec-avoid-dangling-pointer-check-session-exists net/bluetooth/rfcomm/core.c
--- a/net/bluetooth/rfcomm/core.c~rfcomm-corec-avoid-dangling-pointer-check-session-exists
+++ a/net/bluetooth/rfcomm/core.c
@@ -1955,6 +1955,12 @@ static inline void rfcomm_process_sessio
 
 		default:
 			rfcomm_process_rx(s);
+			/* The current session can be closed as part of rx
+			 * in which case s is now dangling.  Check if it
+			 * has been removed.
+			 */
+			if(n->prev != p)
+				continue;
 			break;
 		}
 
_

Patches currently in -mm which might be from david@fries.net are

rfcomm-corec-avoid-dangling-pointer-check-session-exists.patch

