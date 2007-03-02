From: akpm@linux-foundation.org
Subject: + fix-radeon-blanking-return-value.patch added to -mm tree
Date: Thu, 01 Mar 2007 18:36:38 -0800
Message-ID: <200703020236.l222aci0030184@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35970 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422650AbXCBCgt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 21:36:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, adaplas@gmail.com


The patch titled
     Fix radeon blanking return value
has been added to the -mm tree.  Its filename is
     fix-radeon-blanking-return-value.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix radeon blanking return value
From: David Miller <davem@davemloft.net>

Over a year ago, I pointed out that the current Radeon driver erroneously
returns -EINVAL for valid blanking codes, here is a link to that thread:

	http://lkml.org/lkml/2006/1/28/6

No other driver does this, and it confuses the X server into thinking that
the device does not support blanking properly.

As a result I have to switch to a console VC and back to the X server to
unblank the screen, which is rediculious.

I've had to do this for more than 3 years and I'm really tired of this
problem still being around :-)

I looked again and there is simply no reason for the Radeon driver to
return -EINVAL for FB_BLANK_NORMAL.  It claims it wants to do this in order
to convince fbcon to blank in software, right here:

			if (fb_blank(info, blank))
				fbcon_generic_blank(vc, info, blank);

to software blank the screen.  But it only causes that to happen in the
FB_BLANK_NORMAL case.

That makes no sense because the Radeon code does this:

		val |= CRTC_DISPLAY_DIS;

in the FB_BLANK_NORMAL case so should be blanking the hardware, and there
is therefore no reason to SW blank by returning -EINVAL.

Therefore I propose we finally apply the following patch.  No other fbdev
driver does this madness, and as I've shown above there is no justification
for the behavior at all :-)

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_base.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/video/aty/radeon_base.c~fix-radeon-blanking-return-value drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~fix-radeon-blanking-return-value
+++ a/drivers/video/aty/radeon_base.c
@@ -1026,8 +1026,7 @@ int radeon_screen_blank(struct radeonfb_
 		break;
 	}
 
-	/* let fbcon do a soft blank for us */
-	return (blank == FB_BLANK_NORMAL) ? -EINVAL : 0;
+	return 0;
 }
 
 static int radeonfb_blank (int blank, struct fb_info *info)
_

Patches currently in -mm which might be from davem@davemloft.net are

bug-in-mm_rb-debugging.patch
fix-radeon-blanking-return-value.patch
8139too-fix-irq-problem-with-napi-netpoll.patch
git-net.patch
cisco_ioctl-initialise-header_cache_update.patch
resend-iphase-64bit-cleanup.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph.patch
simplify-the-stacktrace-code.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
ipvs-flush-defense_work-before-module-unload.patch
unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
local_t-sparc64-cleanup.patch
