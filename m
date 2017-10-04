From: akpm@linux-foundation.org
Subject: [merged] m32r-define-cpu_big_endian.patch removed from -mm
 tree
Date: Wed, 04 Oct 2017 12:40:55 -0700
Message-ID: <20171004194055.eBwMG-2MX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33494 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDTk4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:40:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sudipm.mukherjee@gmail.com


The patch titled
     Subject: m32r: define CPU_BIG_ENDIAN
has been removed from the -mm tree.  Its filename was
     m32r-define-cpu_big_endian.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


