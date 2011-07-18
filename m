From: akpm@linux-foundation.org
Subject: + panic-vt-do-not-force-oops-output-when-panic_timeout-0.patch added to -mm tree
Date: Mon, 18 Jul 2011 15:40:26 -0700
Message-ID: <201107182240.p6IMeQW8032507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894Ab1GRWlL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Jul 2011 18:41:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: msb@chromium.org, airlied@gmail.com, ak@linux.intel.com, alan@lxorguk.ukuu.org.uk, gregkh@suse.de, hughd@google.com, jbarnes@virtuousgeek.org, olaf@aepfle.de, ying.huang@intel.com


The patch titled
     panic, vt: do not force oops output when panic_timeout < 0
has been added to the -mm tree.  Its filename is
     panic-vt-do-not-force-oops-output-when-panic_timeout-0.patch

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
Subject: panic, vt: do not force oops output when panic_timeout < 0
From: Mandeep Singh Baines <msb@chromium.org>

Don't force output if you intend to reboot immediately.

In this patch, I'm disabling the functionality enabled by
vc->vc_panic_force_write if panic_timeout < 0 (i.e.  no timeout). 
vc_panic_force_write is only enabled for fb video consoles if the
FBINFO_CAN_FORCE_OUTPUT flag is set.

For our application, we're using ram_oops to preserved the panic in
memory.  We want to reliably, and as fast as possible, machine_restart. 
The vc_panic_force_write flag results in a bunch of graphics driver code
to be invoked which slows down restart and decreases reliability.  Since
we're already storing the panic in RAM and are going to reboot
immediately, there is no benefit in mode switching back to the vc in order
to display the panic output.  The log buffer will get flushed by the
console_unblank() call so remote management consoles should see all
output.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Olaf Hering <olaf@aepfle.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vt_kern.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/vt_kern.h~panic-vt-do-not-force-oops-output-when-panic_timeout-0 include/linux/vt_kern.h
--- a/include/linux/vt_kern.h~panic-vt-do-not-force-oops-output-when-panic_timeout-0
+++ a/include/linux/vt_kern.h
@@ -137,7 +137,7 @@ int vty_init(const struct file_operation
 
 static inline bool vt_force_oops_output(struct vc_data *vc)
 {
-	if (oops_in_progress && vc->vc_panic_force_write)
+	if (oops_in_progress && vc->vc_panic_force_write  && panic_timeout >= 0)
 		return true;
 	return false;
 }
_

Patches currently in -mm which might be from msb@chromium.org are

linux-next.patch
panic-panic=-1-for-immediate-reboot.patch
panic-vt-do-not-force-oops-output-when-panic_timeout-0.patch

