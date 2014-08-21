From: akpm@linux-foundation.org
Subject: +
 x86-purgatory-use-approprate-m64-32-build-flag-for-arch-x86-purgatory.patch added to -mm tree
Date: Thu, 21 Aug 2014 14:10:37 -0700
Message-ID: <53f6604d.L2aY/d+A7vTzgtSw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:61399 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbaHUVKi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Aug 2014 17:10:38 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so2062452oah.2
        for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2014 14:10:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@redhat.com, hpa@zytor.com, thomas@glanzmann.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/purgatory: use approprate -m64/-32 build flag for arch/x86/purgatory
has been added to the -mm tree.  Its filename is
     x86-purgatory-use-approprate-m64-32-build-flag-for-arch-x86-purgatory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-purgatory-use-approprate-m64-32-build-flag-for-arch-x86-purgatory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-purgatory-use-approprate-m64-32-build-flag-for-arch-x86-purgatory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

resource-fix-the-case-of-null-pointer-access.patch
kexec-create-a-new-config-option-config_kexec_file-for-new-syscall.patch
kexec-remove-config_kexec-dependency-on-crypto.patch
x86-purgatory-use-approprate-m64-32-build-flag-for-arch-x86-purgatory.patch

