From: akpm@linux-foundation.org
Subject: + scsi-do-not-call-do_div-with-a-64-bit-divisor.patch added to
 -mm tree
Date: Mon, 04 Nov 2013 13:15:25 -0800
Message-ID: <52780e6d.5af8TpqOeKoQRB8O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab3KDVP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 16:15:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org

Subject: + scsi-do-not-call-do_div-with-a-64-bit-divisor.patch added to -mm tree
To: geert@linux-m68k.org
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 13:15:25 -0800


The patch titled
     Subject: scsi: do not call do_div() with a 64-bit divisor
has been added to the -mm tree.  Its filename is
     scsi-do-not-call-do_div-with-a-64-bit-divisor.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scsi-do-not-call-do_div-with-a-64-bit-divisor.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scsi-do-not-call-do_div-with-a-64-bit-divisor.patch

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
Subject: scsi: do not call do_div() with a 64-bit divisor

do_div() is meant for divisions of 64-bit number by 32-bit numbers. 
Passing 64-bit divisor types caused issues in the past on 32-bit
platforms, cfr.  commit ea077b1b96e073eac5c ("m68k: Truncate base in
do_div()").

As scsi_device.sector_size is unsigned (int), factor should be unsigned
int, too.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/sd.c~scsi-do-not-call-do_div-with-a-64-bit-divisor drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~scsi-do-not-call-do_div-with-a-64-bit-divisor
+++ a/drivers/scsi/sd.c
@@ -1607,7 +1607,7 @@ static unsigned int sd_completed_bytes(s
 		end_lba <<= 1;
 	} else {
 		/* be careful ... don't want any overflows */
-		u64 factor = scmd->device->sector_size / 512;
+		unsigned int factor = scmd->device->sector_size / 512;
 		do_div(start_lba, factor);
 		do_div(end_lba, factor);
 	}
_

Patches currently in -mm which might be from geert@linux-m68k.org are

genirq-correct-fuzzy-and-fragile-irq_retval-definition.patch
scsi-do-not-call-do_div-with-a-64-bit-divisor.patch
block-do-not-call-sector_div-with-a-64-bit-divisor.patch
syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
scripts-mod-modpostc-handle-non-abs-crc-symbols.patch
kernel-sysc-remove-obsolete-include-linux-kexech.patch
inith-document-the-existence-of-__initconst.patch
init-make-init-failures-more-explicit.patch
linux-next.patch
x86-add-missed-pgtable_pmd_page_ctor-dtor-calls-for-preallocated-pmds.patch
m68k-handle-pgtable_page_ctor-fail.patch
m68k-handle-pgtable_page_ctor-fail-fix.patch
m68k-handle-pgtable_page_ctor-fail-fix-fix.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page.patch

