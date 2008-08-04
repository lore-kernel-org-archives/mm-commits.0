From: akpm@linux-foundation.org
Subject: - drivers-net-ehea-ehea_mainc-release-mutex-in-error-handling-code.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:07:28 -0700
Message-ID: <200808042007.m74K7Sd1027788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359AbYHDUIb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:08:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, jeff@garzik.org, ossthema@de.ibm.com, themann@de.ibm.com, tklein@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     drivers/net/ehea/ehea_main.c: release mutex in error handling code
has been removed from the -mm tree.  Its filename was
     drivers-net-ehea-ehea_mainc-release-mutex-in-error-handling-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
net-ieee80211-adjust-error-handling.patch
drivers-video-fsl-diu-fbc-add-missing-of_node_put.patch

