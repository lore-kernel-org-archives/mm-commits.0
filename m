From: akpm@linux-foundation.org
Subject: [merged]
 microblaze-extable-sort-the-exception-table-at-build-time.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 10:58:19 -0800
Message-ID: <52e2b7cb.UYMftQH3zKV2IRxl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaAXS6T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:58:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, david.daney@cavium.com, catalin.marinas@arm.com, michal.simek@xilinx.com

Subject: [merged] microblaze-extable-sort-the-exception-table-at-build-time.patch removed from -mm tree
To: michal.simek@xilinx.com,catalin.marinas@arm.com,david.daney@cavium.com,will.deacon@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:58:19 -0800


The patch titled
     Subject: microblaze: extable: sort the exception table at build time
has been removed from the -mm tree.  Its filename was
     microblaze-extable-sort-the-exception-table-at-build-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Simek <michal.simek@xilinx.com>
Subject: microblaze: extable: sort the exception table at build time

Sort the exception table at build-time rather than during boot.

Microblaze is the same case as AARCH64 that's why EM_MICROBLAZE
conditional check was added to allow cross-compilation on machines which
are not running the latest libc-dev.

Inspired by AARCH64 commit adace89562c7a9645b ("arm64: extable: sort the
exception table at build time").

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Acked-by: David Daney <david.daney@cavium.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/Kconfig |    1 +
 scripts/sortextable.c   |    5 +++++
 2 files changed, 6 insertions(+)

diff -puN arch/microblaze/Kconfig~microblaze-extable-sort-the-exception-table-at-build-time arch/microblaze/Kconfig
--- a/arch/microblaze/Kconfig~microblaze-extable-sort-the-exception-table-at-build-time
+++ a/arch/microblaze/Kconfig
@@ -30,6 +30,7 @@ config MICROBLAZE
 	select MODULES_USE_ELF_RELA
 	select CLONE_BACKWARDS3
 	select CLKSRC_OF
+	select BUILDTIME_EXTABLE_SORT
 
 config SWAP
 	def_bool n
diff -puN scripts/sortextable.c~microblaze-extable-sort-the-exception-table-at-build-time scripts/sortextable.c
--- a/scripts/sortextable.c~microblaze-extable-sort-the-exception-table-at-build-time
+++ a/scripts/sortextable.c
@@ -39,6 +39,10 @@
 #define EM_AARCH64	183
 #endif
 
+#ifndef EM_MICROBLAZE
+#define EM_MICROBLAZE	189
+#endif
+
 static int fd_map;	/* File descriptor for file being modified. */
 static int mmap_failed; /* Boolean flag. */
 static void *ehdr_curr; /* current ElfXX_Ehdr *  for resource cleanup */
@@ -275,6 +279,7 @@ do_file(char const *const fname)
 	case EM_ARCOMPACT:
 	case EM_ARM:
 	case EM_AARCH64:
+	case EM_MICROBLAZE:
 	case EM_MIPS:
 		break;
 	}  /* end switch */
_

Patches currently in -mm which might be from michal.simek@xilinx.com are

origin.patch
linux-next.patch

