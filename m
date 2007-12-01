From: akpm@linux-foundation.org
Subject: - uml-build-fix.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:20:52 -0800
Message-ID: <200712010020.lB10Kqbo031722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756269AbXLAAWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:22:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jdike@karaya.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     UML: build fix
has been removed from the -mm tree.  Its filename was
     uml-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: UML: build fix
From: WANG Cong <xiyou.wangcong@gmail.com>

include/asm-um/arch points to the non-existed include/asm-i386 directory.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Jeff Dike <jdike@karaya.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/Makefile~uml-build-fix arch/um/Makefile
--- a/arch/um/Makefile~uml-build-fix
+++ a/arch/um/Makefile
@@ -168,7 +168,7 @@ ifneq ($(KBUILD_SRC),)
 	$(Q)mkdir -p $(objtree)/include/asm-um
 	$(Q)ln -fsn $(srctree)/include/asm-$(HEADER_ARCH) include/asm-um/arch
 else
-	$(Q)cd $(TOPDIR)/include/asm-um && ln -fsn ../asm-$(SUBARCH) arch
+	$(Q)cd $(TOPDIR)/include/asm-um && ln -fsn ../asm-$(HEADER_ARCH) arch
 endif
 
 $(objtree)/$(ARCH_DIR)/include:
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
mm-sparsec-check-the-return-value-of-sparse_index_alloc.patch
mm-sparsec-improve-the-error-handling-for-sparse_add_one_section.patch
uml-code-tidying-under-arch-um-os-linux.patch
uml-const-and-other-tidying.patch
time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem.patch
