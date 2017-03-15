From: akpm@linux-foundation.org
Subject: + hpet-make-cmd-parameter-of-hpet_ioctl_common-unsigned.patch
 added to -mm tree
Date: Wed, 15 Mar 2017 15:07:18 -0700
Message-ID: <58c9bb16.0I71FZapQHXoaMRI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55630 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753490AbdCOWHV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2017 18:07:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mka@chromium.org, arnd@arndb.de, clemens@ladisch.de, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/char/hpet.c: make cmd parameter of hpet_ioctl_common() unsigned
has been added to the -mm tree.  Its filename is
     hpet-make-cmd-parameter-of-hpet_ioctl_common-unsigned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hpet-make-cmd-parameter-of-hpet_ioctl_common-unsigned.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hpet-make-cmd-parameter-of-hpet_ioctl_common-unsigned.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthias Kaehlcke <mka@chromium.org>
Subject: drivers/char/hpet.c: make cmd parameter of hpet_ioctl_common() unsigned

The value passed by the two callers of the function is unsigned anyway.

Making the parameter unsigned fixes the following warning when building
with clang:

drivers/char/hpet.c:588:7: error: overflow converting case value to switch condition type (2149083139 to 18446744071563667459) [-Werror,-Wswitch]
        case HPET_INFO:
             ^
include/uapi/linux/hpet.h:18:19: note: expanded from macro 'HPET_INFO'
                        ^
include/uapi/asm-generic/ioctl.h:77:28: note: expanded from macro '_IOR'
                                ^
include/uapi/asm-generic/ioctl.h:66:2: note: expanded from macro '_IOC'
        (((dir)  << _IOC_DIRSHIFT) | \

Link: http://lkml.kernel.org/r/20170313185725.144873-1-mka@chromium.org
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Acked-by: Clemens Ladisch <clemens@ladisch.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/hpet.c~hpet-make-cmd-parameter-of-hpet_ioctl_common-unsigned drivers/char/hpet.c
--- a/drivers/char/hpet.c~hpet-make-cmd-parameter-of-hpet_ioctl_common-unsigned
+++ a/drivers/char/hpet.c
@@ -575,7 +575,7 @@ static inline unsigned long hpet_time_di
 }
 
 static int
-hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg,
+hpet_ioctl_common(struct hpet_dev *devp, unsigned int cmd, unsigned long arg,
 		  struct hpet_info *info)
 {
 	struct hpet_timer __iomem *timer;
_

Patches currently in -mm which might be from mka@chromium.org are

hpet-make-cmd-parameter-of-hpet_ioctl_common-unsigned.patch

