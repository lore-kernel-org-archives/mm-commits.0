From: akpm@linux-foundation.org
Subject: + m32r-fix-endianness-constraints.patch added to -mm tree
Date: Wed, 01 Nov 2017 14:20:38 -0700
Message-ID: <59fa3aa6.tAgaVSo02DZQvjpj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41316 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933385AbdKAVUj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2017 17:20:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, sudipm.mukherjee@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: fix endianness constraints
has been added to the -mm tree.  Its filename is
     m32r-fix-endianness-constraints.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m32r-fix-endianness-constraints.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m32r-fix-endianness-constraints.patch

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
@@ -195,8 +195,8 @@ config TIMER_DIVIDE
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

m32r-fix-endianness-constraints.patch
lib-add-module-support-to-string-tests.patch

