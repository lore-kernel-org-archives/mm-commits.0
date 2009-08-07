From: akpm@linux-foundation.org
Subject: [merged] xtensa-variant-specific-code.patch removed from -mm tree
Date: Fri, 07 Aug 2009 12:19:03 -0700
Message-ID: <200908071919.n77JJ3iN003723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933106AbZHGTT7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2009 15:19:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jw@emlix.com, chris@zankel.net, dg@emlix.com, os@emlix.com, mm-commits@vger.kernel.org


The patch titled
     xtensa: variant-specific code
has been removed from the -mm tree.  Its filename was
     xtensa-variant-specific-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: variant-specific code
From: Johannes Weiner <jw@emlix.com>

Allow the variant to provide own code.  Add empty dummy Makefiles for
the existing variants.

The s6000 has circuits that require own drivers.  Allow these to live
in the variant-specific directory.

Signed-off-by: Johannes Weiner <jw@emlix.com>
Cc: Oskar Schirmer <os@emlix.com>
Cc: Daniel Glockner <dg@emlix.com>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/Makefile                 |    4 ++++
 arch/xtensa/variants/dc232b/Makefile |    1 +
 arch/xtensa/variants/fsf/Makefile    |    1 +
 3 files changed, 6 insertions(+)

diff -puN arch/xtensa/Makefile~xtensa-variant-specific-code arch/xtensa/Makefile
--- a/arch/xtensa/Makefile~xtensa-variant-specific-code
+++ a/arch/xtensa/Makefile
@@ -75,6 +75,10 @@ LIBGCC := $(shell $(CC) $(KBUILD_CFLAGS)
 
 head-y		:= arch/xtensa/kernel/head.o
 core-y		+= arch/xtensa/kernel/ arch/xtensa/mm/
+ifneq ($(VARIANT),)
+core-y		+= arch/xtensa/variants/$(VARIANT)/
+endif
+ifneq ($(PLATFORM),)
 core-y		+= $(buildvar) $(buildplf)
 
 libs-y		+= arch/xtensa/lib/ $(LIBGCC)
diff -puN /dev/null arch/xtensa/variants/dc232b/Makefile
--- /dev/null
+++ a/arch/xtensa/variants/dc232b/Makefile
@@ -0,0 +1 @@
+# dc232b Makefile
diff -puN /dev/null arch/xtensa/variants/fsf/Makefile
--- /dev/null
+++ a/arch/xtensa/variants/fsf/Makefile
@@ -0,0 +1 @@
+# fsf Makefile
_

Patches currently in -mm which might be from jw@emlix.com are

xtensa-variant-specific-code.patch
xtensa-use-generic-sys_pipe.patch

