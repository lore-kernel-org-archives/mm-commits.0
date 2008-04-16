From: akpm@linux-foundation.org
Subject: + drivers-char-ds1286c-use-time_before-time_before_eq-etc.patch added to -mm tree
Date: Tue, 15 Apr 2008 21:38:42 -0700
Message-ID: <200804160438.m3G4cg3k032341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830AbYDPEjS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 00:39:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, jirislaby@gmail.com


The patch titled
     drivers/char/ds1286.c: use time_before, time_before_eq, etc
has been added to the -mm tree.  Its filename is
     drivers-char-ds1286c-use-time_before-time_before_eq-etc.patch

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
Subject: drivers/char/ds1286.c: use time_before, time_before_eq, etc
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
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ds1286.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/ds1286.c~drivers-char-ds1286c-use-time_before-time_before_eq-etc drivers/char/ds1286.c
--- a/drivers/char/ds1286.c~drivers-char-ds1286c-use-time_before-time_before_eq-etc
+++ a/drivers/char/ds1286.c
@@ -39,6 +39,7 @@
 #include <linux/spinlock.h>
 #include <linux/bcd.h>
 #include <linux/proc_fs.h>
+#include <linux/jiffies.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -451,7 +452,7 @@ static void ds1286_get_time(struct rtc_t
 	 */
 
 	if (ds1286_is_updating() != 0)
-		while (jiffies - uip_watchdog < 2*HZ/100)
+		while (time_before(jiffies, uip_watchdog + 2*HZ/100))
 			barrier();
 
 	/*
_

Patches currently in -mm which might be from julia@diku.dk are

git-alsa-tiwai.patch
git-powerpc.patch
git-gfs2-nmw.patch
git-infiniband.patch
git-udf.patch
git-net.patch
drivers-atm-use-time_before-time_before_eq-etc.patch
git-ocfs2.patch
fs-affs-filec-use-bug_on.patch
drivers-misc-elide-a-non-zero-test-on-a-result-that-is-never-0.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch
drivers-char-ds1286c-use-time_before-time_before_eq-etc.patch

