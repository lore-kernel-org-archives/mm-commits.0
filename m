From: akpm@linux-foundation.org
Subject: - uml-fix-kernel-stack-size-on-x86_64.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:56:51 -0700
Message-ID: <200706121856.l5CIup7Q018426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43499 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756280AbXFLS5E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 14:57:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix kernel stack size on x86_64
has been removed from the -mm tree.  Its filename was
     uml-fix-kernel-stack-size-on-x86_64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix kernel stack size on x86_64
From: Jeff Dike <jdike@addtoit.com>

Force KERNEL_STACK_ORDER to be at least 1 on UML/x86_64, to avoid overflows.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig |    1 +
 1 files changed, 1 insertion(+)

diff -puN arch/um/Kconfig~uml-fix-kernel-stack-size-on-x86_64 arch/um/Kconfig
--- a/arch/um/Kconfig~uml-fix-kernel-stack-size-on-x86_64
+++ a/arch/um/Kconfig
@@ -278,6 +278,7 @@ config HIGHMEM
 config KERNEL_STACK_ORDER
 	int "Kernel stack size order"
 	default 1 if 64BIT
+	range 1 10 if 64BIT
 	default 0 if !64BIT
 	help
 	This option determines the size of UML kernel stacks.  They will
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
hostfs-convert-to-new-aops.patch
uml-fix-request-sector-update.patch
