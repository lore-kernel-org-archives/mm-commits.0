From: akpm@linux-foundation.org
Subject: + microblaze-extable-sort-the-exception-table-at-build-time.patch added to -mm tree
Date: Fri, 20 Dec 2013 15:33:33 -0800
Message-ID: <52b4d3cd.4/k9eDSKDr1OUYZs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab3LTXde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Dec 2013 18:33:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, david.daney@cavium.com, catalin.marinas@arm.com, michal.simek@xilinx.com

Subject: + microblaze-extable-sort-the-exception-table-at-build-time.patch added to -mm tree
To: michal.simek@xilinx.com,catalin.marinas@arm.com,david.daney@cavium.com,will.deacon@arm.com
From: akpm@linux-foundation.org
Date: Fri, 20 Dec 2013 15:33:33 -0800


The patch titled
     Subject: microblaze: extable: sort the exception table at build time
has been added to the -mm tree.  Its filename is
     microblaze-extable-sort-the-exception-table-at-build-time.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/microblaze-extable-sort-the-exception-table-at-build-time.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/microblaze-extable-sort-the-exception-table-at-build-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

maintainers-set-up-proper-record-for-xilinx-zynq.patch
microblaze-extable-sort-the-exception-table-at-build-time.patch
linux-next.patch

