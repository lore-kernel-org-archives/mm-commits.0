From: akpm@linux-foundation.org
Subject: - use-build-id-ld-option.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:02:52 -0700
Message-ID: <200707192002.l6JK2qLi019793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47397 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760422AbXGSUer (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:34:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, ak@suse.de, benh@kernel.crashing.org, heiko.carstens@de.ibm.com, ink@jurassic.park.msu.ru, paulus@samba.org, rth@twiddle.net, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Use --build-id ld option
has been removed from the -mm tree.  Its filename was
     use-build-id-ld-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use --build-id ld option
From: Roland McGrath <roland@redhat.com>

This change passes the --build-id when linking the kernel and when linking
modules, if ld supports it.  This is a new GNU ld option that synthesizes an
ELF note section inside the read-only data.  The note in this section contains
unique identifying bits called the "build ID", which are generated so as to be
different for any two linked ELF files that aren't identical.  The build ID
can be recovered from stripped files, memory dumps, etc.  and used to look up
the original program built, locate debuginfo or other details or history
associated with it.  For normal program linking, the compiler passes
--build-id to ld by default, but the option is needed when using ld directly
as we do.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN Makefile~use-build-id-ld-option Makefile
--- a/Makefile~use-build-id-ld-option
+++ a/Makefile
@@ -514,6 +514,12 @@ CFLAGS += $(call cc-option,-Wdeclaration
 # disable pointer signed / unsigned warnings in gcc 4.0
 CFLAGS += $(call cc-option,-Wno-pointer-sign,)
 
+# Use --build-id when available.
+LDFLAGS_BUILD_ID = $(patsubst -Wl$(comma)%,%,\
+			      $(call ld-option, -Wl$(comma)--build-id,))
+LDFLAGS_MODULE += $(LDFLAGS_BUILD_ID)
+LDFLAGS_vmlinux += $(LDFLAGS_BUILD_ID)
+
 # Default kernel image to build when no specific target is given.
 # KBUILD_IMAGE may be overruled on the command line or
 # set in the environment
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
xen-disable-vdso-nosegneg-on-native-boot.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
