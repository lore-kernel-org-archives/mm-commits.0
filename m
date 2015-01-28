From: akpm@linux-foundation.org
Subject: + eventfd-dont-take-the-spinlock-in-eventfd_poll-fix.patch added
 to -mm tree
Date: Wed, 28 Jan 2015 14:19:03 -0800
Message-ID: <54c96057.XyRpO+Zbk0wYYhJu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46104 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722AbbA2B5U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Jan 2015 20:57:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, clm@fb.com, mm-commits@vger.kernel.org


The patch titled
     Subject: eventfs: avoid unused variable warning
has been added to the -mm tree.  Its filename is
     eventfd-dont-take-the-spinlock-in-eventfd_poll-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/eventfd-dont-take-the-spinlock-in-eventfd_poll-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/eventfd-dont-take-the-spinlock-in-eventfd_poll-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: eventfs: avoid unused variable warning

An optimization patch from Chris Mason causes build warnings about an
unused variable.

The patch that broke this is currently in the akpm-current series, so this
fixup can be folded into the original patch.  I was expecting multiple
people to send a patch for this, so I waited a bit at first.

Fixes: 567162b87a5c5f  ("eventfd: don't take the spinlock in eventfd_poll")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Mason <clm@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventfd.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/eventfd.c~eventfd-dont-take-the-spinlock-in-eventfd_poll-fix fs/eventfd.c
--- a/fs/eventfd.c~eventfd-dont-take-the-spinlock-in-eventfd_poll-fix
+++ a/fs/eventfd.c
@@ -118,7 +118,6 @@ static unsigned int eventfd_poll(struct
 {
 	struct eventfd_ctx *ctx = file->private_data;
 	unsigned int events = 0;
-	unsigned long flags;
 	unsigned int count;
 
 	poll_wait(file, &ctx->wqh, wait);
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-export-high_memory-symbol-on-mmu.patch
asm-generic-drop-unused-pte_file-helpers.patch
linux-typesh-always-use-unsigned-long-for-pgoff_t.patch
rtc-rtc-isl12057-add-isilirq2-can-wakeup-machine-property-for-in-tree-users.patch
arm-mvebu-isl12057-rtc-chip-can-now-wake-up-rn102-rn102-and-rn2120.patch
of-add-vendor-prefix-for-abracon-corporation.patch
rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip.patch
rtc-rtc-ab-b5ze-s3-add-sub-minute-alarm-support.patch
kexec-fix-make-headers_check.patch
kexec-simplify-conditional.patch
kexec-add-bit-definitions-for-kimage-entry-flags.patch
kexec-add-ind_flags-macro.patch
eventfd-dont-take-the-spinlock-in-eventfd_poll-fix.patch
linux-next.patch
rtc-isl12022-deprecate-use-of-isl-in-compatible-string-for-isil.patch
rtc-isl12057-deprecate-use-of-isl-in-compatible-string-for-isil.patch
staging-iio-isl29028-deprecate-use-of-isl-in-compatible-string-for-isil.patch
arm-dts-zynq-update-isl9305-compatible-string-to-use-isil-vendor-prefix.patch

