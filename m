From: akpm@linux-foundation.org
Subject: - drivers-net-appletalk-use-time_before-time_before_eq-etc.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:41:33 -0700
Message-ID: <200804261641.m3QGfXDf031133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756720AbYDZQmF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:42:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     drivers/net/appletalk: use time_before, time_before_eq, etc
has been removed from the -mm tree.  Its filename was
     drivers-net-appletalk-use-time_before-time_before_eq-etc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/appletalk: use time_before, time_before_eq, etc
From: Julia Lawall <julia@diku.dk>

The functions time_before, time_before_eq, time_after, and time_after_eq
are more robust for comparing jiffies against other values.

A simplified version of the semantic patch making this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ change_compare_np @
expression E;
@@

(
- jiffies <= E
+ time_before_eq(jiffies,E)
|
- jiffies >= E
+ time_after_eq(jiffies,E)
|
- jiffies < E
+ time_before(jiffies,E)
|
- jiffies > E
+ time_after(jiffies,E)
)

@ include depends on change_compare_np @
@@

#include <linux/jiffies.h>

@ no_include depends on !include && change_compare_np @
@@

  #include <linux/...>
+ #include <linux/jiffies.h>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/appletalk/cops.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/appletalk/cops.c~drivers-net-appletalk-use-time_before-time_before_eq-etc drivers/net/appletalk/cops.c
--- a/drivers/net/appletalk/cops.c~drivers-net-appletalk-use-time_before-time_before_eq-etc
+++ a/drivers/net/appletalk/cops.c
@@ -69,6 +69,7 @@ static const char *version =
 #include <linux/atalk.h>
 #include <linux/spinlock.h>
 #include <linux/bitops.h>
+#include <linux/jiffies.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -503,7 +504,7 @@ static void cops_reset(struct net_device
                         long snap=jiffies;
 
 			/* Let card finish initializing, about 1/3 second */
-	                while(jiffies-snap<HZ/3)
+			while (time_before(jiffies, snap + HZ/3))
                                 schedule();
                 }
                 else
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
drivers-scsi-use-time_before-time_before_eq-etc.patch
fs-affs-filec-use-bug_on.patch
drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0.patch
serial-use-time_before-time_before_eq-etc.patch
drivers-char-rtcc-use-time_before-time_before_eq-etc.patch
fbdev-use-div_round_up-or-roundup.patch
drivers-md-use-time_before-time_before_eq-etc.patch
drivers-md-use-time_before-time_before_eq-etc-checkpatch-fixes.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch
drivers-char-ds1286c-use-time_before-time_before_eq-etc.patch

