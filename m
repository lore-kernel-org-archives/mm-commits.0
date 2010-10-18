From: akpm@linux-foundation.org
Subject: + vmlinuxldsh-gather-datashared_aligned-sections-in-data_data.patch added to -mm tree
Date: Mon, 18 Oct 2010 16:57:34 -0700
Message-ID: <201010182357.o9INvYfE009283__15662.4044561342$1287446269$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753931Ab0JRX5n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Oct 2010 19:57:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, alan-jenkins@tuffmail.co.uk, jeremy@xensource.com, linux-arch@vger.kernel.org, rusty@rustcorp.com.au, sam@ravnborg.org


The patch titled
     vmlinux.lds.h: gather .data..shared_aligned sections in DATA_DATA
has been added to the -mm tree.  Its filename is
     vmlinuxldsh-gather-datashared_aligned-sections-in-data_data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmlinux.lds.h: gather .data..shared_aligned sections in DATA_DATA
From: Mike Frysinger <vapier@gentoo.org>

With the recent change "net: remove time limit in process_backlog()", the
softnet_data variable changed from "DEFINE_PER_CPU()" to
"DEFINE_PER_CPU_ALIGNED()" which moved it from the .data section to the
.data.shared_align section.  I'm not saying this patch is wrong, just that
is what caused me to notice this larger problem.  No one else in the
kernel is using this aligned macro variant, so I imagine that's why no one
has noticed yet.

Since .data.shared_align isnt declared in any vmlinux files that I can
see, the linker just places it last.  This "just works" for most
people, but when building a ROM kernel on Blackfin systems, it causes
section overlap errors:
bfin-uclinux-ld.real:
	section .init.data [00000000202e06b8 -> 00000000202e48b7] overlaps
	section .data.shared_aligned [00000000202e06b8 -> 00000000202e0723]
I imagine other arches which support the ROM config option and thus do
funky placement would see similar issues ...

On x86, it is stuck in a dedicated section at the end:
 [8] .data             PROGBITS ffffffff810ec000 2ec0000303a8 00 WA 0 0 4096
 [9] .data.shared_alig PROGBITS ffffffff8111c3c0 31c3c00000c8 00 WA 0 0 64

So make sure we include this section in the DATA_DATA macro so that it is
placed in the right location.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-generic/vmlinux.lds.h~vmlinuxldsh-gather-datashared_aligned-sections-in-data_data include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~vmlinuxldsh-gather-datashared_aligned-sections-in-data_data
+++ a/include/asm-generic/vmlinux.lds.h
@@ -150,6 +150,7 @@
 #define DATA_DATA							\
 	*(.data)							\
 	*(.ref.data)							\
+	*(.data..shared_aligned) /* percpu related */			\
 	DEV_KEEP(init.data)						\
 	DEV_KEEP(exit.data)						\
 	CPU_KEEP(init.data)						\
_

Patches currently in -mm which might be from vapier@gentoo.org are

drivers-misc-ad525x_dpot-fix-typo-in-spi-write16-and-write24-transfer-counts.patch
linux-next.patch
m68knommu-blackfin-remove-old-assembler-only-flags-bit-definitions.patch
vmlinuxldsh-gather-datashared_aligned-sections-in-data_data.patch
drivers-misc-ad525x_dpot-fix-part-name-typos-in-defines.patch
drivers-misc-ad525x_dpot-new-features.patch
misc-devices-do-not-enable-by-default.patch
rtc-bfin-shrink-optimize-interrupt-handler-a-bit.patch
rtc-bfin-add-debug-markers-to-suspend-resume-paths.patch
gpio-adp5588-gpio-support-interrupt-controller.patch
gpio-adp5588-gpio-gpio_start-must-be-signed.patch
ptrace-cleanup-arch_ptrace-and-friends-on-blackfin.patch

