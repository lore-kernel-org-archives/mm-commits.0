From: akpm@linux-foundation.org
Subject: + error-for-gcc-4101.patch added to -mm tree
Date: Wed, 31 Dec 2008 14:55:00 -0800
Message-ID: <200812312255.mBVMt0co027072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752326AbYLaW4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Dec 2008 17:56:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, dave@hiauly1.hia.nrc.ca, deller@gmx.de, ian.campbell@citrix.com, jeremy.fitzhardinge@citrix.com, kyle@mcmartin.ca, mingo@elte.hu, randolph@tausq.org, rdreier@cisco.com, rusty@rustcorp.com.au, sam@ravnborg.org, torvalds@linux-foundation.org


The patch titled
     #error for gcc 4.1.{0,1}
has been added to the -mm tree.  Its filename is
     error-for-gcc-4101.patch

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
Subject: #error for gcc 4.1.{0,1}
From: Adrian Bunk <bunk@kernel.org>

gcc 4.1.0 and 4.1.1 are known to miscompile the kernel:
  http://gcc.gnu.org/bugzilla/show_bug.cgi?id=27781

Usage of weak functions has become a common pattern in the kernel, and
usages get added in each kernel version increasing the probability of
bugs with each kernel release.

This miscompilation of weak functions can result in subtle runtime
errors.

#error for gcc 4.1.0 and 4.1.1 to prevent users from running into
this bug.

Note:
We already printed a #warning for gcc 4.1.0 due to a different bug.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Randolph Chung <randolph@tausq.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: John David Anglin <dave@hiauly1.hia.nrc.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN init/main.c~error-for-gcc-4101 init/main.c
--- a/init/main.c~error-for-gcc-4101
+++ a/init/main.c
@@ -81,8 +81,9 @@
  * trouble.
  */
 
-#if __GNUC__ == 4 && __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ == 0
-#warning gcc-4.1.0 is known to miscompile the kernel.  A different compiler version is recommended.
+/*  due to http://gcc.gnu.org/bugzilla/show_bug.cgi?id=27781  */
+#if __GNUC__ == 4 && __GNUC_MINOR__ == 1 && (__GNUC_PATCHLEVEL__ == 0 || __GNUC_PATCHLEVEL__ == 1)
+#error gcc 4.1.0 and 4.1.1 are known to miscompile the kernel.
 #endif
 
 static int kernel_init(void *);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-kernel-smpbootc-must-include-linux-cpuh.patch
if-0-ses_match_host.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
m68knommu-set-no_dma.patch
error-for-gcc-4101.patch
reiser4.patch

