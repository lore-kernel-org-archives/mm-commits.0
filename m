From: akpm@linux-foundation.org
Subject: + usb-serial-safe_serial-move-__inline__-before-return-type.patch added to -mm tree
Date: Wed, 05 Jul 2017 13:45:30 -0700
Message-ID: <595d4fea.qoli5K77o+QYNNRP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54696 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753487AbdGEUpb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 16:45:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, gregkh@linuxfoundation.org, johan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: USB: serial: safe_serial: move __inline__ before return type
has been added to the -mm tree.  Its filename is
     usb-serial-safe_serial-move-__inline__-before-return-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/usb-serial-safe_serial-move-__inline__-before-return-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/usb-serial-safe_serial-move-__inline__-before-return-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: USB: serial: safe_serial: move __inline__ before return type

Make the code like the rest of the kernel.
Also use inline instead of __inline__.

Link: http://lkml.kernel.org/r/a5072b74b6c293e6ec93c4900482e9d3267f15b2.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/safe_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/serial/safe_serial.c~usb-serial-safe_serial-move-__inline__-before-return-type drivers/usb/serial/safe_serial.c
--- a/drivers/usb/serial/safe_serial.c~usb-serial-safe_serial-move-__inline__-before-return-type
+++ a/drivers/usb/serial/safe_serial.c
@@ -180,7 +180,7 @@ static const __u16 crc10_table[256] = {
  * Perform a memcpy and calculate fcs using ppp 10bit CRC algorithm. Return
  * new 10 bit FCS.
  */
-static __u16 __inline__ fcs_compute10(unsigned char *sp, int len, __u16 fcs)
+static inline __u16 fcs_compute10(unsigned char *sp, int len, __u16 fcs)
 {
 	for (; len-- > 0; fcs = CRC10_FCS(fcs, *sp++));
 	return fcs;
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-the-unnecessary-oom-message-test.patch
checkpatch-warn-when-a-maintainers-entry-isnt-t.patch
checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block.patch
checkpatch-improve-tests-for-multiple-line-function-definitions.patch
checkpatch-improve-macro-reuse-test.patch
checkpatch-improve-multi-line-alignment-test.patch
checkpatch-improve-the-storage_class-test.patch
arm-kvm-move-asmlinkage-before-type.patch
arm-hp-jornada-7xx-move-inline-before-return-type.patch
cris-gpio-move-inline-before-return-type.patch
frv-tlbflush-move-asmlinkage-before-return-type.patch
ia64-move-inline-before-return-type.patch
ia64-sn-pci-move-inline-before-type.patch
m68k-coldfire-move-inline-before-return-type.patch
mips-smp-move-asmlinkage-before-return-type.patch
sh-move-inline-before-return-type.patch
x86-efi-move-asmlinkage-before-return-type.patch
drivers-s390-move-static-and-inline-before-return-type.patch
drivers-tty-serial-move-inline-before-return-type.patch
usb-serial-safe_serial-move-__inline__-before-return-type.patch
video-fbdev-intelfb-move-inline-before-return-type.patch
video-fbdev-omap-move-inline-before-return-type.patch
arm-samsung-usb-ohci-move-inline-before-return-type.patch
alsa-opl4-move-inline-before-return-type.patch

