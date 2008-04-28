From: akpm@linux-foundation.org
Subject: - drivers-md-use-time_before-time_before_eq-etc.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:00:04 -0700
Message-ID: <200804282200.m3SM04WV018661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965509AbYD1WAK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:00:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/md: use time_before, time_before_eq, etc
has been removed from the -mm tree.  Its filename was
     drivers-md-use-time_before-time_before_eq-etc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/md: use time_before, time_before_eq, etc
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

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid6algos.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/md/raid6algos.c~drivers-md-use-time_before-time_before_eq-etc drivers/md/raid6algos.c
--- a/drivers/md/raid6algos.c~drivers-md-use-time_before-time_before_eq-etc
+++ a/drivers/md/raid6algos.c
@@ -121,7 +121,8 @@ int __init raid6_select_algo(void)
 			j0 = jiffies;
 			while ( (j1 = jiffies) == j0 )
 				cpu_relax();
-			while ( (jiffies-j1) < (1 << RAID6_TIME_JIFFIES_LG2) ) {
+			while (time_before(jiffies,
+					    j1 + (1<<RAID6_TIME_JIFFIES_LG2))) {
 				(*algo)->gen_syndrome(disks, PAGE_SIZE, dptrs);
 				perf++;
 			}
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
drivers-scsi-use-time_before-time_before_eq-etc.patch
fs-affs-filec-use-bug_on.patch
drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0.patch
fs-ext4-use-bug_on.patch
drivers-char-ds1286c-use-time_before-time_before_eq-etc.patch

