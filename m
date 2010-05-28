From: akpm@linux-foundation.org
Subject: + vt-fix-region-clearing.patch added to -mm tree
Date: Fri, 28 May 2010 16:10:20 -0700
Message-ID: <201005282310.o4SNAKjT019783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188Ab0E1XKt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 May 2010 19:10:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: frankpzh@gmail.com, alan@linux.intel.com, catalin.marinas@arm.com, daniel@caiaq.de, gregkh@suse.de


The patch titled
     vt: fix region clearing
has been added to the -mm tree.  Its filename is
     vt-fix-region-clearing.patch

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
Subject: vt: fix region clearing
From: Frank Pan <frankpzh@gmail.com>

The code uses vc->vc_cols instead of vc->vc_size_row by mistake, it will
cause half of the region which is going to clear remain uncleared.  The
issue happens in background consoles, so it's hard to observe.

Signed-off-by: Frank Pan <frankpzh@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Daniel Mack <daniel@caiaq.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/vt.c~vt-fix-region-clearing drivers/char/vt.c
--- a/drivers/char/vt.c~vt-fix-region-clearing
+++ a/drivers/char/vt.c
@@ -304,7 +304,7 @@ static void scrup(struct vc_data *vc, un
 	d = (unsigned short *)(vc->vc_origin + vc->vc_size_row * t);
 	s = (unsigned short *)(vc->vc_origin + vc->vc_size_row * (t + nr));
 	scr_memmovew(d, s, (b - t - nr) * vc->vc_size_row);
-	scr_memsetw(d + (b - t - nr) * vc->vc_cols, vc->vc_video_erase_char,
+	scr_memsetw(d + (b - t - nr) * vc->vc_size_row, vc->vc_video_erase_char,
 		    vc->vc_size_row * nr);
 }
 
_

Patches currently in -mm which might be from frankpzh@gmail.com are

vt-fix-region-clearing.patch

