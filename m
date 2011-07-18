From: akpm@linux-foundation.org
Subject: + panic-panic=-1-for-immediate-reboot.patch added to -mm tree
Date: Mon, 18 Jul 2011 15:40:23 -0700
Message-ID: <201107182240.p6IMeORR032501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933Ab1GRWlS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Jul 2011 18:41:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@chromium.org, airlied@gmail.com, ak@linux.intel.com, alan@lxorguk.ukuu.org.uk, gregkh@suse.de, hughd@google.com, jbarnes@virtuousgeek.org, msb@chromium.org, olaf@aepfle.de, ying.huang@intel.com


The patch titled
     panic: panic=-1 for immediate reboot
has been added to the -mm tree.  Its filename is
     panic-panic=-1-for-immediate-reboot.patch

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
Subject: panic: panic=-1 for immediate reboot
From: Hugh Dickins <hughd@chromium.org>

When kernel BUG or oops occurs, ChromeOS intends to panic and immediately
reboot, with stacktrace and other messages preserved in RAM across reboot.
 But the longer we delay, the more likely the user is to poweroff and lose
the info.

panic_timeout (seconds before rebooting) is set by panic= boot option or
sysctl or /proc/sys/kernel/panic; but 0 means wait forever, so at present
we have to delay at least 1 second.

Let a negative number mean reboot immediately (with the small cosmetic
benefit of suppressing that newline-less "Rebooting in %d seconds.."
message).

Signed-off-by: Hugh Dickins <hughd@chromium.org>
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Olaf Hering <olaf@aepfle.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    4 +++-
 kernel/panic.c                      |    2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN Documentation/kernel-parameters.txt~panic-panic=-1-for-immediate-reboot Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~panic-panic=-1-for-immediate-reboot
+++ a/Documentation/kernel-parameters.txt
@@ -1851,7 +1851,9 @@ bytes respectively. Such letter suffixes
 			See Documentation/sound/oss/oss-parameters.txt
 
 	panic=		[KNL] Kernel behaviour on panic: delay <timeout>
-			seconds before rebooting
+			timeout > 0: seconds before rebooting
+			timeout = 0: wait forever
+			timeout < 0: reboot immediately
 			Format: <timeout>
 
 	parkbd.port=	[HW] Parallel port number the keyboard adapter is
diff -puN kernel/panic.c~panic-panic=-1-for-immediate-reboot kernel/panic.c
--- a/kernel/panic.c~panic-panic=-1-for-immediate-reboot
+++ a/kernel/panic.c
@@ -119,6 +119,8 @@ NORET_TYPE void panic(const char * fmt, 
 			}
 			mdelay(PANIC_TIMER_STEP);
 		}
+	}
+	if (panic_timeout != 0) {
 		/*
 		 * This will not be a clean reboot, with everything
 		 * shutting down.  But if there is a chance of
_

Patches currently in -mm which might be from hughd@chromium.org are

panic-panic=-1-for-immediate-reboot.patch

