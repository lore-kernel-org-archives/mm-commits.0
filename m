From: akpm@linux-foundation.org
Subject: [merged]
 x86-purgatory-use-approprate-m64-32-build-flag-for-arch-x86-purgatory.patch removed from -mm tree
Date: Wed, 03 Sep 2014 10:57:43 -0700
Message-ID: <54075697.rVmScb7czAaw59yB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbaICR5o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 13:57:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, hpa@zytor.com, thomas@glanzmann.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/purgatory: use approprate -m64/-32 build flag for arch/x86/purgatory
has been removed from the -mm tree.  Its filename was
     x86-purgatory-use-approprate-m64-32-build-flag-for-arch-x86-purgatory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vivek Goyal <vgoyal@redhat.com>
Subject: x86/purgatory: use approprate -m64/-32 build flag for arch/x86/purgatory

Thomas reported that build of x86_64 kernel was failing for him.  He is
using 32bit tool chain.

Problem is that while compiling purgatory, I have not specified -m64 flag.
 And 32bit tool chain must be assuming -m32 by default.

Following is error message.

(mini) [~/work/linux-2.6] make
scripts/kconfig/conf --silentoldconfig Kconfig
  CHK     include/config/kernel.release
  UPD     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  CC      arch/x86/purgatory/purgatory.o
arch/x86/purgatory/purgatory.c:1:0: error: code model 'large' not supported in
the 32 bit mode

Fix it by explicitly passing appropriate -m64/-m32 build flag for
purgatory.

Reported-by: Thomas Glanzmann <thomas@glanzmann.de>
Tested-by: Thomas Glanzmann <thomas@glanzmann.de>
Suggested-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/purgatory/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/purgatory/Makefile~x86-purgatory-use-approprate-m64-32-build-flag-for-arch-x86-purgatory arch/x86/purgatory/Makefile
--- a/arch/x86/purgatory/Makefile~x86-purgatory-use-approprate-m64-32-build-flag-for-arch-x86-purgatory
+++ a/arch/x86/purgatory/Makefile
@@ -11,6 +11,7 @@ targets += purgatory.ro
 # sure how to relocate those. Like kexec-tools, use custom flags.
 
 KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -fno-builtin -ffreestanding -c -MD -Os -mcmodel=large
+KBUILD_CFLAGS += -m$(BITS)
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)
_

Patches currently in -mm which might be from vgoyal@redhat.com are

try-to-use-automatic-variable-in-kexec-purgatory-makefile.patch
linux-next.patch

