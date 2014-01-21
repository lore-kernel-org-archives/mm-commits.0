From: akpm@linux-foundation.org
Subject: + cris-provide-inout_p.patch added to -mm tree
Date: Tue, 21 Jan 2014 11:53:00 -0800
Message-ID: <52ded01c.r67F+hPNvn6N41Tw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaAUTxB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 14:53:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, starvik@axis.com, jesper.nilsson@axis.com, geert@linux-m68k.org

Subject: + cris-provide-inout_p.patch added to -mm tree
To: geert@linux-m68k.org,jesper.nilsson@axis.com,starvik@axis.com
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 11:53:00 -0800


The patch titled
     Subject: cris: provide {in,out}[wl]_p()
has been added to the -mm tree.  Its filename is
     cris-provide-inout_p.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cris-provide-inout_p.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cris-provide-inout_p.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: cris: provide {in,out}[wl]_p()

drivers/staging/comedi/drivers/das6402.c: In function 'intr_handler':
drivers/staging/comedi/drivers/das6402.c:164:3: error: implicit declaration of function 'outw_p' [-Werror=implicit-function-declaration]
drivers/staging/speakup/speakup_dtlk.c: In function 'synth_probe':
drivers/staging/speakup/speakup_dtlk.c:362:2: error: implicit declaration of function 'inw_p' [-Werror=implicit-function-declaration]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/asm/io.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/cris/include/asm/io.h~cris-provide-inout_p arch/cris/include/asm/io.h
--- a/arch/cris/include/asm/io.h~cris-provide-inout_p
+++ a/arch/cris/include/asm/io.h
@@ -169,7 +169,11 @@ static inline void outsl(unsigned int po
 }
 
 #define inb_p(port)             inb(port)
+#define inw_p(port)             inw(port)
+#define inl_p(port)             inl(port)
 #define outb_p(val, port)       outb((val), (port))
+#define outw_p(val, port)       outw((val), (port))
+#define outl_p(val, port)       outl((val), (port))
 
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
cris-provide-inout_p.patch
arch-sh-kernel-kgdbc-add-missing-include-linux-schedh.patch
mm-make-setpage_address-static-inline-if-want_page_virtual.patch
asm-typesh-remove-include-asm-generic-int-l64h.patch
maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch
init-mainc-remove-unused-declaration-of-tc_init.patch
rtc-rtc-cmos-remove-superfluous-name-cast.patch
rtc-disable-rtc_drv_cmos-on-atari.patch
drivers-rtc-rtc-s5mc-s5m_rtc_suspendresume-should-depend-on-config_pm_sleep.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
linux-next.patch

