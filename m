From: akpm@linux-foundation.org
Subject: [merged] m32r-fix-endianness-constraints.patch removed
 from -mm tree
Date: Thu, 16 Nov 2017 11:58:41 -0800
Message-ID: <20171116195841.7zPitM5_-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45662 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751140AbdKPT6m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 14:58:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mm-commits@vger.kernel.org, sudipm.mukherjee@gmail.com


The patch titled
     Subject: m32r: fix endianness constraints
has been removed from the -mm tree.  Its filename was
     m32r-fix-endianness-constraints.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: m32r: fix endianness constraints

The m32r Kconfig provides both CPU_BIG_ENDIAN and CPU_LITTLE_ENDIAN
configuration options.  As they are user-selectable and independent, this
allows invalid configurations:

  - All m32r defconfigs build a big endian kernel, but CPU_BIG_ENDIAN is
    not set, causing compiler warnings like:

	include/linux/byteorder/big_endian.h:7:2: warning: #warning inconsistent configuration, needs CONFIG_CPU_BIG_ENDIAN [-Wcpp]
	 #warning inconsistent configuration, needs CONFIG_CPU_BIG_ENDIAN
	  ^

  - Since commit 5bdfca6435b82944 ("m32r: define CPU_BIG_ENDIAN"),
    building an allmodconfig or allyesconfig enables both
    CONFIG_CPU_BIG_ENDIAN and CONFIG_CPU_LITTLE_ENDIAN.
    While this did get rid of the warning above, both options are
    obviously mutually exclusive.

Fix this by making only CPU_LITTLE_ENDIAN configurable by the user, as
before, and by making sure exactly one of CPU_BIG_ENDIAN and
CPU_LITTLE_ENDIAN is always enabled.

Link: http://lkml.kernel.org/r/1509361505-18150-1-git-send-email-geert@linux-m68k.org
Fixes: 5bdfca6435b82944 ("m32r: define CPU_BIG_ENDIAN")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/m32r/Kconfig~m32r-fix-endianness-constraints arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~m32r-fix-endianness-constraints
+++ a/arch/m32r/Kconfig
@@ -196,8 +196,8 @@ config TIMER_DIVIDE
 	default "128"
 
 config CPU_BIG_ENDIAN
-        bool "Generate big endian code"
-	default n
+	bool
+	default !CPU_LITTLE_ENDIAN
 
 config CPU_LITTLE_ENDIAN
         bool "Generate little endian code"
_

Patches currently in -mm which might be from geert@linux-m68k.org are

lib-add-module-support-to-string-tests.patch

