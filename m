From: akpm@linux-foundation.org
Subject: - error-for-gcc-4101.patch removed from -mm tree
Date: Sun, 04 Jan 2009 22:27:46 -0800
Message-ID: <200901050627.n056RkIl026865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339AbZAEG2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 01:28:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, dave@hiauly1.hia.nrc.ca, deller@gmx.de, ian.campbell@citrix.com, jeremy.fitzhardinge@citrix.com, kyle@mcmartin.ca, mingo@elte.hu, randolph@tausq.org, rdreier@cisco.co


The patch titled
     #error for gcc 4.1.{0,1}
has been removed from the -mm tree.  Its filename was
     error-for-gcc-4101.patch

This patch was dropped because an alternative patch was merged

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

