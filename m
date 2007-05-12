From: akpm@linux-foundation.org
Subject: - uml-shrink-kernel-stacks.patch removed from -mm tree
Date: Fri, 11 May 2007 22:33:33 -0700
Message-ID: <200705120533.l4C5XXJr002111@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809AbXELFdg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:33:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: shrink kernel stacks
has been removed from the -mm tree.  Its filename was
     uml-shrink-kernel-stacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: shrink kernel stacks
From: Jeff Dike <jdike@addtoit.com>

Make kernel stacks be 1 page on i386 and 2 pages on x86_64.  These match the
host values.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig   |    3 ++-
 arch/um/defconfig |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/um/Kconfig~uml-shrink-kernel-stacks arch/um/Kconfig
--- a/arch/um/Kconfig~uml-shrink-kernel-stacks
+++ a/arch/um/Kconfig
@@ -277,7 +277,8 @@ config HIGHMEM
 
 config KERNEL_STACK_ORDER
 	int "Kernel stack size order"
-	default 2
+	default 1 if 64BIT
+	default 0 if !64BIT
 	help
 	This option determines the size of UML kernel stacks.  They will
 	be 1 << order pages.  The default is OK unless you're running Valgrind
diff -puN arch/um/defconfig~uml-shrink-kernel-stacks arch/um/defconfig
--- a/arch/um/defconfig~uml-shrink-kernel-stacks
+++ a/arch/um/defconfig
@@ -86,7 +86,7 @@ CONFIG_MCONSOLE=y
 # CONFIG_MAGIC_SYSRQ is not set
 CONFIG_NEST_LEVEL=0
 # CONFIG_HIGHMEM is not set
-CONFIG_KERNEL_STACK_ORDER=2
+CONFIG_KERNEL_STACK_ORDER=0
 CONFIG_UML_REAL_TIME_CLOCK=y
 
 #
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
