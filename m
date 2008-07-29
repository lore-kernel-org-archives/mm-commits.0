From: akpm@linux-foundation.org
Subject: + drivers-net-ehea-ehea_mainc-release-mutex-in-error-handling-code.patch added to -mm tree
Date: Mon, 28 Jul 2008 20:54:25 -0700
Message-ID: <200807290354.m6T3sPFk012815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752234AbYG2D4J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 23:56:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, jeff@garzik.org, ossthema@de.ibm.com, themann@de.ibm.com, tklein@de.ibm.com


The patch titled
     drivers/net/ehea/ehea_main.c: release mutex in error handling code
has been added to the -mm tree.  Its filename is
     drivers-net-ehea-ehea_mainc-release-mutex-in-error-handling-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/ehea/ehea_main.c: release mutex in error handling code
From: Julia Lawall <julia@diku.dk>

The mutex is released on a successful return, so it would seem that it
should be released on an error return as well.

The semantic patch finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression l;
@@

mutex_lock(l);
... when != mutex_unlock(l)
    when any
    when strict
(
if (...) { ... when != mutex_unlock(l)
+   mutex_unlock(l);
    return ...;
}
|
mutex_unlock(l);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Jan-Bernd Themann <themann@de.ibm.com>
Cc: Thomas Klein <tklein@de.ibm.com>
Cc: Jan-Bernd Themann <ossthema@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ehea/ehea_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/ehea/ehea_main.c~drivers-net-ehea-ehea_mainc-release-mutex-in-error-handling-code drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c~drivers-net-ehea-ehea_mainc-release-mutex-in-error-handling-code
+++ a/drivers/net/ehea/ehea_main.c
@@ -2937,9 +2937,9 @@ static void ehea_rereg_mrs(struct work_s
 				}
 			}
 		}
-       mutex_unlock(&dlpar_mem_lock);
-       ehea_info("re-initializing driver complete");
+	ehea_info("re-initializing driver complete");
 out:
+	mutex_unlock(&dlpar_mem_lock);
 	return;
 }
 
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-net-ehea-ehea_mainc-release-mutex-in-error-handling-code.patch
net-ieee80211-adjust-error-handling.patch

