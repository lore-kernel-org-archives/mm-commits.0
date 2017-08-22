From: akpm@linux-foundation.org
Subject: [merged] kbuild-use-fshort-wchar-globally.patch removed
 from -mm tree
Date: Tue, 22 Aug 2017 13:54:59 -0700
Message-ID: <20170822205459.F3Qc5NMcC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36366 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751085AbdHVUzA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Aug 2017 16:55:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, boris.ostrovsky@oracle.com, david.vrabel@citrix.com, jgross@suse.com, mm-commits@vger.kernel.org, mmarek@suse.com, yamada.masahiro@socionext.com


The patch titled
     Subject: Kbuild: use -fshort-wchar globally
has been removed from the -mm tree.  Its filename was
     kbuild-use-fshort-wchar-globally.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: Kbuild: use -fshort-wchar globally

A previous patch added the --no-wchar-size-warning to the Makefile to
avoid this harmless warning:

arm-linux-gnueabi-ld: warning: drivers/xen/efi.o uses 2-byte wchar_t yet the output is to use 4-byte wchar_t; use of wchar_t values across objects may fail

Changing kbuild to use thin archives instead of recursive linking
unfortunately brings the same warning back during the final link.

The kernel does not use wchar_t string literals at this point, and xen
does not use wchar_t at all (only efi_char16_t), so the flag has no
effect, but as pointed out by Jan Beulich, adding a wchar_t string literal
would be bad here.

Since wchar_t is always defined as u16, independent of the toolchain
default, always passing -fshort-wchar is correct and lets us remove the
Xen specific hack along with fixing the warning.

Link: http://lkml.kernel.org/r/20170726133655.2137437-1-arnd@arndb.de
Link: https://patchwork.kernel.org/patch/9275217/
Fixes: 971a69db7dc0 ("Xen: don't warn about 2-byte wchar_t in efi")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: David Vrabel <david.vrabel@citrix.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Michal Marek <mmarek@suse.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile             |    2 +-
 drivers/xen/Makefile |    3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff -puN Makefile~kbuild-use-fshort-wchar-globally Makefile
--- a/Makefile~kbuild-use-fshort-wchar-globally
+++ a/Makefile
@@ -396,7 +396,7 @@ LINUXINCLUDE    := \
 KBUILD_CPPFLAGS := -D__KERNEL__
 
 KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
-		   -fno-strict-aliasing -fno-common \
+		   -fno-strict-aliasing -fno-common -fshort-wchar \
 		   -Werror-implicit-function-declaration \
 		   -Wno-format-security \
 		   -std=gnu89 $(call cc-option,-fno-PIE)
diff -puN drivers/xen/Makefile~kbuild-use-fshort-wchar-globally drivers/xen/Makefile
--- a/drivers/xen/Makefile~kbuild-use-fshort-wchar-globally
+++ a/drivers/xen/Makefile
@@ -7,9 +7,6 @@ obj-y	+= xenbus/
 nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_features.o			:= $(nostackp)
 
-CFLAGS_efi.o				+= -fshort-wchar
-LDFLAGS					+= $(call ld-option, --no-wchar-size-warning)
