From: akpm@linux-foundation.org
Subject: + kprobes-ensure-blacklist-data-is-aligned.patch added to -mm
 tree
Date: Wed, 07 May 2014 12:16:39 -0700
Message-ID: <536a8697.3QCr+FjRMKOHXKDF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbaEGTQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 15:16:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@kernel.org, mingo@elte.hu, masami.hiramatsu.pt@hitachi.com, vgupta@synopsys.com

Subject: + kprobes-ensure-blacklist-data-is-aligned.patch added to -mm tree
To: vgupta@synopsys.com,masami.hiramatsu.pt@hitachi.com,mingo@elte.hu,mingo@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 12:16:39 -0700


The patch titled
     Subject: kprobes: ensure blacklist data is aligned
has been added to the -mm tree.  Its filename is
     kprobes-ensure-blacklist-data-is-aligned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kprobes-ensure-blacklist-data-is-aligned.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kprobes-ensure-blacklist-data-is-aligned.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vineet Gupta <vgupta@synopsys.com>
Subject: kprobes: ensure blacklist data is aligned

ARC Linux (not supporting native unaligned access) was failing to boot
because __start_kprobe_blacklist was not aligned.

This was because per generated vmlinux.lds it was emitted right next to
.rodata with strings etc hence could be randomly unaligned.

Fix that by ensuring a word alignment.  While 4 would suffice for 32bit
arches and problem at hand, it is probably better to put 8.

| Path: (null) CPU: 0 PID: 1 Comm: swapper Not tainted
| 3.15.0-rc3-next-20140430 #2
| task: 8f044000 ti: 8f01e000 task.ti: 8f01e000
|
| [ECR   ]: 0x00230400 => Misaligned r/w from 0x800fb0d3
| [EFA   ]: 0x800fb0d3
| [BLINK ]: do_one_initcall+0x86/0x1bc
| [ERET  ]: init_kprobes+0x52/0x120

Fixes

commit 376e242429bf8539ef39a080ac113c8799840b13
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu Apr 17 17:17:05 2014 +0900
Commit:     Ingo Molnar <mingo@kernel.org>
CommitDate: Thu Apr 24 10:02:56 2014 +0200

    kprobes: Introduce NOKPROBE_SYMBOL() macro to maintain kprobes blacklist

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/vmlinux.lds.h~kprobes-ensure-blacklist-data-is-aligned include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~kprobes-ensure-blacklist-data-is-aligned
+++ a/include/asm-generic/vmlinux.lds.h
@@ -110,7 +110,8 @@
 #endif
 
 #ifdef CONFIG_KPROBES
-#define KPROBE_BLACKLIST()	VMLINUX_SYMBOL(__start_kprobe_blacklist) = .; \
+#define KPROBE_BLACKLIST()	. = ALIGN(8);				      \
+				VMLINUX_SYMBOL(__start_kprobe_blacklist) = .; \
 				*(_kprobe_blacklist)			      \
 				VMLINUX_SYMBOL(__stop_kprobe_blacklist) = .;
 #else
_

Patches currently in -mm which might be from vgupta@synopsys.com are

arc-call-find_vma-with-the-mmap_sem-held.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
linux-next.patch
kprobes-ensure-blacklist-data-is-aligned.patch

