From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 25/54] arm: fix the flush_icache_range arguments
 in set_fiq_handler
Date: Sun, 07 Jun 2020 21:41:25 -0700
Message-ID: <20200608044125.byBvpN4Jo%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgFHEl2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:41:28 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@kernel.org, akpm@linux-foundation.org, alexander.shishkin@linux.intel.com, anton.ivanov@cambridgegreys.com, aou@eecs.berkeley.edu, arnd@arndb.de, ast@kernel.org, bcain@codeaurora.org, benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com, chris@zankel.net, dalias@libc.org, dan.j.williams@intel.com, daniel@iogearbox.net, dave.jiang@intel.com, davem@davemloft.net, deanbo422@gmail.com, fenghua.yu@intel.com, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, gxt@pku.edu.cn, hch@lst.de, hpa@zytor.com, ink@jurassic.park.msu.ru, ira.weiny@intel.com, jacquiot.aurelien@gmail.com, jcmvbkbc@gmail.com, jdike@addtoit.com, jeyu@kernel.org, jolsa@redhat.com, jonas@southpole.se, kafai@fb.com, keith.busch@intel.com, linux-mm@kvack.org, linux@armlinux.org.uk, mark.

From: Christoph Hellwig <hch@lst.de>
Subject: arm: fix the flush_icache_range arguments in set_fiq_handler

Patch series "sort out the flush_icache_range mess", v2.

flush_icache_range is mostly used for kernel address, except for the
following cases:

 - the nommu brk and mmap implementations,
 - the read_code helper that is only used for binfmt_flat, binfmt_elf_fdpic,
   and binfmt_aout including the broken ia32 compat version
 - binfmt_flat itself,

none of which really are used by a typical MMU enabled kernel, as a.out
can only be build for alpha and m68k to start with.

But strangely enough commit ae92ef8a4424 ("PATCH] flush icache in correct
context") added a "set_fs(KERNEL_DS)" around the flush_icache_range call
in the module loader, because apparently m68k assumed user pointers.

This series first cleans up the cacheflush implementations, largely by
switching as much as possible to the asm-generic version after a few
preparations, then moves the misnamed current flush_icache_user_range to a
new name, to finally introduce a real flush_icache_user_range to be used
for the above use cases to flush the instruction cache for a userspace
address range.  The last patch then drops the set_fs in the module code
and moves it into the m68k implementation.


This patch (of 29):

The arguments passed look bogus, try to fix them to something that seems
to make sense.

Link: http://lkml.kernel.org/r/20200515143646.3857579-1-hch@lst.de
Link: http://lkml.kernel.org/r/20200515143646.3857579-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Aurelien Jacquiot <jacquiot.aurelien@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Palmer Dabbelt <palmer@sifive.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Song Liu <songliubraving@fb.com>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yonghong Song <yhs@fb.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/fiq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/kernel/fiq.c~arm-fix-the-flush_icache_range-arguments-in-set_fiq_handler
+++ a/arch/arm/kernel/fiq.c
@@ -98,8 +98,8 @@ void set_fiq_handler(void *start, unsign
 
 	memcpy(base + offset, start, length);
 	if (!cache_is_vipt_nonaliasing())
-		flush_icache_range((unsigned long)base + offset, offset +
-				   length);
+		flush_icache_range((unsigned long)base + offset,
+				   (unsigned long)base + offset + length);
 	flush_icache_range(0xffff0000 + offset, 0xffff0000 + offset + length);
 }
 
_
