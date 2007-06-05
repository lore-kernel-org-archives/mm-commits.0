From: akpm@linux-foundation.org
Subject: + uml-fix-kernel-stack-size-on-x86_64.patch added to -mm tree
Date: Tue, 05 Jun 2007 16:59:05 -0700
Message-ID: <200706052359.l55Nx5Fu005540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55948 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764805AbXFEX7N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 19:59:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: fix kernel stack size on x86_64
has been added to the -mm tree.  Its filename is
     uml-fix-kernel-stack-size-on-x86_64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix kernel stack size on x86_64
From: Jeff Dike <jdike@addtoit.com>

Having KERNEL_STACK_ORDER in defconfig overrides the value provided by
Kconfig, breaking UML/x86_64, which wants 2 page stacks.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/defconfig |    1 -
 1 files changed, 1 deletion(-)

diff -puN arch/um/defconfig~uml-fix-kernel-stack-size-on-x86_64 arch/um/defconfig
--- a/arch/um/defconfig~uml-fix-kernel-stack-size-on-x86_64
+++ a/arch/um/defconfig
@@ -86,7 +86,6 @@ CONFIG_MCONSOLE=y
 # CONFIG_MAGIC_SYSRQ is not set
 CONFIG_NEST_LEVEL=0
 # CONFIG_HIGHMEM is not set
-CONFIG_KERNEL_STACK_ORDER=0
 CONFIG_UML_REAL_TIME_CLOCK=y
 
 #
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-fix-kernel-stack-size-on-x86_64.patch
hostfs-convert-to-new-aops.patch
uml-fix-request-sector-update.patch
