From: akpm@linux-foundation.org
Subject: [merged]
 scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances.patch
 removed from -mm tree
Date: Tue, 28 Feb 2017 12:51:21 -0800
Message-ID: <58b5e2c9.VfX4fAR9/hT7+tJw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52760 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751880AbdB1Uvg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "efective" pattern and fix typo instances
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "efective" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  efective||effective

While we are here, fix the "addres" as well in the touched line in
arch/openrisc/kernel/entry.S.

Link: http://lkml.kernel.org/r/1481573103-11329-10-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/ifpsp060/src/isp.S |    2 +-
 arch/openrisc/kernel/entry.S |    2 +-
 scripts/spelling.txt         |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/m68k/ifpsp060/src/isp.S~scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances arch/m68k/ifpsp060/src/isp.S
--- a/arch/m68k/ifpsp060/src/isp.S~scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances
+++ a/arch/m68k/ifpsp060/src/isp.S
@@ -3814,7 +3814,7 @@ CAS2W2_FILLER:
 #	(3) Save current DFC/SFC (ASSUMED TO BE EQUAL!!!); Then set	#
 #	    SFC/DFC according to whether exception occurred in user or	#
 #	    supervisor mode.						#
-#	(4) Use "plpaw" instruction to pre-load ATC with efective	#
+#	(4) Use "plpaw" instruction to pre-load ATC with effective	#
 #	    address page(s). THIS SHOULD NOT FAULT!!! The relevant	#
 #	    page(s) should have been made resident prior to entering	#
 #	    this routine.						#
diff -puN arch/openrisc/kernel/entry.S~scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances arch/openrisc/kernel/entry.S
--- a/arch/openrisc/kernel/entry.S~scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances
+++ a/arch/openrisc/kernel/entry.S
@@ -332,7 +332,7 @@ EXCEPTION_ENTRY(_alignment_handler)
 
 #if 0
 EXCEPTION_ENTRY(_alignment_handler)
-//        l.mfspr r2,r0,SPR_EEAR_BASE     /* Load the efective addres */
+//        l.mfspr r2,r0,SPR_EEAR_BASE     /* Load the effective address */
 	l.addi	r2,r4,0
 //        l.mfspr r5,r0,SPR_EPCR_BASE     /* Load the insn address */
 	l.lwz   r5,PT_PC(r1)
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -381,6 +381,7 @@ easilly||easily
 ecspecially||especially
 edditable||editable
 editting||editing
+efective||effective
 efficently||efficiently
 ehther||ether
 eigth||eight
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch

