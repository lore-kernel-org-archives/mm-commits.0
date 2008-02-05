From: akpm@linux-foundation.org
Subject: - uml-fix-command-line-cflags-and-ldflags-support.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:37:04 -0800
Message-ID: <200802052236.m15Majel012730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41903 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760933AbYBEWl3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fx command-line CFLAGS and LDFLAGS support
has been removed from the -mm tree.  Its filename was
     uml-fix-command-line-cflags-and-ldflags-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: fx command-line CFLAGS and LDFLAGS support
From: Jeff Dike <jdike@addtoit.com>

UML still needed some work in order to allow CFLAGS to be passed in from the
command line.

USER_CFLAGS is produced from KBUILD_CFLAGS in part by removing all the -I
switches.  This is so that kernel headers don't accidentally get pulled into
libc files.  However, a common use of command-line CFLAGS would be to add -I
switches to the build.  This patch specifically adds any command-line -I flags
back to USER_CFLAGS.

I also corrected the spelling of LFLAGS to LDFLAGS.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/um/Makefile~uml-fix-command-line-cflags-and-ldflags-support arch/um/Makefile
--- a/arch/um/Makefile~uml-fix-command-line-cflags-and-ldflags-support
+++ a/arch/um/Makefile
@@ -49,7 +49,7 @@ SYS_DIR		:= $(ARCH_DIR)/include/sysdep-$
 #
 # These apply to USER_CFLAGS to.
 
-KBUILD_CFLAGS += $(CFLAGS-y) -D__arch_um__ -DSUBARCH=\"$(SUBARCH)\"	\
+KBUILD_CFLAGS += $(CFLAGS) $(CFLAGS-y) -D__arch_um__ -DSUBARCH=\"$(SUBARCH)\" \
 	$(ARCH_INCLUDE) $(MODE_INCLUDE) -Dvmap=kernel_vmap	\
 	-Din6addr_loopback=kernel_in6addr_loopback \
 	-Din6addr_any=kernel_in6addr_any
@@ -58,7 +58,7 @@ KBUILD_AFLAGS += $(ARCH_INCLUDE)
 
 USER_CFLAGS = $(patsubst $(KERNEL_DEFINES),,$(patsubst -D__KERNEL__,,\
 	$(patsubst -I%,,$(KBUILD_CFLAGS)))) $(ARCH_INCLUDE) $(MODE_INCLUDE) \
-	-D_FILE_OFFSET_BITS=64
+	$(filter -I%,$(CFLAGS)) -D_FILE_OFFSET_BITS=64
 
 include $(srctree)/$(ARCH_DIR)/Makefile-$(SUBARCH)
 
@@ -130,7 +130,7 @@ CPPFLAGS_vmlinux.lds = -U$(SUBARCH) -DST
 # The wrappers will select whether using "malloc" or the kernel allocator.
 LINK_WRAPS = -Wl,--wrap,malloc -Wl,--wrap,free -Wl,--wrap,calloc
 
-LD_FLAGS_CMDLINE = $(foreach opt,$(LFLAGS),-Wl,$(opt))
+LD_FLAGS_CMDLINE = $(foreach opt,$(LDFLAGS),-Wl,$(opt))
 
 CFLAGS_vmlinux := $(LINK-y) $(LINK_WRAPS) $(LD_FLAGS_CMDLINE)
 define cmd_vmlinux__
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
