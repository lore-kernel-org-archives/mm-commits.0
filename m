From: akpm@linux-foundation.org
Subject: [patch 22/51] m32r: define CPU_BIG_ENDIAN
Date: Tue, 03 Oct 2017 16:15:23 -0700
Message-ID: <59d41a0b.GpWuJYxu4S6WS5pC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58598 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXPY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:15:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sudipm.mukherjee@gmail.com

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
