From: akpm@linux-foundation.org
Subject: + m32r-define-cpu_big_endian.patch added to -mm tree
Date: Mon, 25 Sep 2017 15:40:46 -0700
Message-ID: <59c985ee.0b1/n0QuJrp0oPa5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52594 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934254AbdIYWkr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2017 18:40:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: define CPU_BIG_ENDIAN
has been added to the -mm tree.  Its filename is
     m32r-define-cpu_big_endian.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m32r-define-cpu_big_endian.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m32r-define-cpu_big_endian.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: m32r: define CPU_BIG_ENDIAN

The build of m32r allmodconfig is giving lots of build warnings about:
include/linux/byteorder/big_endian.h:7:2:
	warning: #warning inconsistent configuration,
		needs CONFIG_CPU_BIG_ENDIAN [-Wcpp]
	#warning inconsistent configuration, needs CONFIG_CPU_BIG_ENDIAN

Define CPU_BIG_ENDIAN like the way CPU_LITTLE_ENDIAN is defined.

Link: http://lkml.kernel.org/r/1505678083-10320-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/m32r/Kconfig~m32r-define-cpu_big_endian arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~m32r-define-cpu_big_endian
+++ a/arch/m32r/Kconfig
@@ -194,6 +194,10 @@ config TIMER_DIVIDE
 	int "Timer divider (integer)"
 	default "128"
 
+config CPU_BIG_ENDIAN
+        bool "Generate big endian code"
+	default n
+
 config CPU_LITTLE_ENDIAN
         bool "Generate little endian code"
 	default n
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

m32r-define-cpu_big_endian.patch

