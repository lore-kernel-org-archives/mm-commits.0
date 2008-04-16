From: akpm@linux-foundation.org
Subject: + drivers-char-keyboardc-use-time_before-time_before_eq-etc.patch added to -mm tree
Date: Tue, 15 Apr 2008 21:44:39 -0700
Message-ID: <200804160444.m3G4idIF032528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759261AbYDPEpF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 00:45:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, dtor@mail.ru


The patch titled
     drivers/char/keyboard.c: use time_before, time_before_eq, etc
has been added to the -mm tree.  Its filename is
     drivers-char-keyboardc-use-time_before-time_before_eq-etc.patch

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
Subject: drivers/char/keyboard.c: use time_before, time_before_eq, etc
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
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/keyboard.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/char/keyboard.c~drivers-char-keyboardc-use-time_before-time_before_eq-etc drivers/char/keyboard.c
--- a/drivers/char/keyboard.c~drivers-char-keyboardc-use-time_before-time_before_eq-etc
+++ a/drivers/char/keyboard.c
@@ -42,6 +42,7 @@
 #include <linux/input.h>
 #include <linux/reboot.h>
 #include <linux/notifier.h>
+#include <linux/jiffies.h>
 
 extern void ctrl_alt_del(void);
 
@@ -928,7 +929,8 @@ static void k_brl(struct vc_data *vc, un
 	if (up_flag) {
 		if (brl_timeout) {
 			if (!committing ||
-			    jiffies - releasestart > (brl_timeout * HZ) / 1000) {
+			    time_after(jiffies,
+				       releasestart + (brl_timeout*HZ)/1000)) {
 				committing = pressed;
 				releasestart = jiffies;
 			}
_

Patches currently in -mm which might be from julia@diku.dk are

git-alsa-tiwai.patch
git-powerpc.patch
git-gfs2-nmw.patch
git-infiniband.patch
drivers-char-keyboardc-use-time_before-time_before_eq-etc.patch
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

