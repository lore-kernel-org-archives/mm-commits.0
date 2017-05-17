From: akpm@linux-foundation.org
Subject: + frv-remove-wrapper-header-for-asm-deviceh.patch added to -mm
 tree
Date: Wed, 17 May 2017 14:25:33 -0700
Message-ID: <591cbfcd.OQpq3SC+bgA7uBeT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47604 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751676AbdEQVZe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2017 17:25:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tklauser@distanz.ch, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: frv: remove wrapper header for asm/device.h
has been added to the -mm tree.  Its filename is
     frv-remove-wrapper-header-for-asm-deviceh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/frv-remove-wrapper-header-for-asm-deviceh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/frv-remove-wrapper-header-for-asm-deviceh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tobias Klauser <tklauser@distanz.ch>
Subject: frv: remove wrapper header for asm/device.h

frv's asm/device.h is merely including asm-generic/device.h.  Thus, the
arch specific header can be omitted and the generic header can be used
directly.

Link: http://lkml.kernel.org/r/20170517124915.26904-1-tklauser@distanz.ch
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/Kbuild   |    1 +
 arch/frv/include/asm/device.h |    7 -------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff -puN arch/frv/include/asm/Kbuild~frv-remove-wrapper-header-for-asm-deviceh arch/frv/include/asm/Kbuild
--- a/arch/frv/include/asm/Kbuild~frv-remove-wrapper-header-for-asm-deviceh
+++ a/arch/frv/include/asm/Kbuild
@@ -1,5 +1,6 @@
 
 generic-y += clkdev.h
+generic-y += device.h
 generic-y += exec.h
 generic-y += extable.h
 generic-y += irq_work.h
diff -puN arch/frv/include/asm/device.h~frv-remove-wrapper-header-for-asm-deviceh /dev/null
--- a/arch/frv/include/asm/device.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/*
- * Arch specific extensions to struct device
- *
- * This file is released under the GPLv2
- */
-#include <asm-generic/device.h>
