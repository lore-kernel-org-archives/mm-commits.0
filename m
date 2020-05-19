From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 arm-fix-the-flush_icache_range-arguments-in-set_fiq_handler.patch added to
 -mm tree
Date: Mon, 18 May 2020 18:12:38 -0700
Message-ID: <20200519011238.scL_qWl91%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbgESBMm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 21:12:42 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@kernel.org, akpm@linux-foundation.org, alexander.shishkin@linux.intel.com, anton.ivanov@cambridgegreys.com, aou@eecs.berkeley.edu, arnd@arndb.de, ast@kernel.org, bcain@codeaurora.org, benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com, chris@zankel.net, dalias@libc.org, dan.j.williams@intel.com, daniel@iogearbox.net, dave.jiang@intel.com, davem@davemloft.net, deanbo422@gmail.com, fenghua.yu@intel.com, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, gxt@pku.edu.cn, hch@lst.de, hpa@zytor.com, ink@jurassic.park.msu.ru, ira.weiny@intel.com, jacquiot.aurelien@gmail.com, jcmvbkbc@gmail.com, jdike@addtoit.com, jeyu@kernel.org, jolsa@redhat.com, jonas@southpole.se, kafai@fb.com, keith.busch@intel.com, linux@armlinux.org.uk, mark.rutland@arm.com, mat


The patch titled
     Subject: arm: fix the flush_icache_range arguments in set_fiq_handler
has been added to the -mm tree.  Its filename is
     arm-fix-the-flush_icache_range-arguments-in-set_fiq_handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-fix-the-flush_icache_range-arguments-in-set_fiq_handler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-fix-the-flush_icache_range-arguments-in-set_fiq_handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Andrew Morton <akpm@linux-foundation.org>
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

Patches currently in -mm which might be from hch@lst.de are

x86-hyperv-use-vmalloc_exec-for-the-hypercall-page.patch
x86-fix-vmap-arguments-in-map_irq_stack.patch
staging-android-ion-use-vmap-instead-of-vm_map_ram.patch
staging-media-ipu3-use-vmap-instead-of-reimplementing-it.patch
dma-mapping-use-vmap-insted-of-reimplementing-it.patch
powerpc-add-an-ioremap_phb-helper.patch
powerpc-remove-__ioremap_at-and-__iounmap_at.patch
mm-remove-__get_vm_area.patch
mm-unexport-unmap_kernel_range_noflush.patch
mm-rename-config_pgtable_mapping-to-config_zsmalloc_pgtable_mapping.patch
mm-only-allow-page-table-mappings-for-built-in-zsmalloc.patch
mm-pass-addr-as-unsigned-long-to-vb_free.patch
mm-remove-vmap_page_range_noflush-and-vunmap_page_range.patch
mm-rename-vmap_page_range-to-map_kernel_range.patch
mm-dont-return-the-number-of-pages-from-map_kernel_range_noflush.patch
mm-remove-map_vm_range.patch
mm-remove-unmap_vmap_area.patch
mm-remove-the-prot-argument-from-vm_map_ram.patch
mm-enforce-that-vmap-cant-map-pages-executable.patch
gpu-drm-remove-the-powerpc-hack-in-drm_legacy_sg_alloc.patch
mm-remove-the-pgprot-argument-to-__vmalloc.patch
mm-remove-the-prot-argument-to-__vmalloc_node.patch
mm-remove-both-instances-of-__vmalloc_node_flags.patch
mm-remove-__vmalloc_node_flags_caller.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node.patch
mm-remove-vmalloc_user_node_flags.patch
arm64-use-__vmalloc_node-in-arch_alloc_vmap_stack.patch
powerpc-use-__vmalloc_node-in-alloc_vm_stack.patch
s390-use-__vmalloc_node-in-stack_alloc.patch
exec-simplify-the-copy_strings_kernel-calling-convention.patch
exec-open-code-copy_string_kernel.patch
amdgpu-a-null-mm-does-not-mean-a-thread-is-a-kthread.patch
kernel-move-use_mm-unuse_mm-to-kthreadc.patch
kernel-move-use_mm-unuse_mm-to-kthreadc-v2.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract.patch
kernel-better-document-the-use_mm-unuse_mm-api-contract-v2.patch
kernel-set-user_ds-in-kthread_use_mm.patch
arm-fix-the-flush_icache_range-arguments-in-set_fiq_handler.patch
nds32-unexport-flush_icache_page.patch
powerpc-unexport-flush_icache_user_range.patch
unicore32-remove-flush_cache_user_range.patch
asm-generic-fix-the-inclusion-guards-for-cacheflushh.patch
asm-generic-dont-include-linux-mmh-in-cacheflushh.patch
asm-generic-improve-the-flush_dcache_page-stub.patch
alpha-use-asm-generic-cacheflushh.patch
arm64-use-asm-generic-cacheflushh.patch
c6x-use-asm-generic-cacheflushh.patch
hexagon-use-asm-generic-cacheflushh.patch
ia64-use-asm-generic-cacheflushh.patch
microblaze-use-asm-generic-cacheflushh.patch
m68knommu-use-asm-generic-cacheflushh.patch
openrisc-use-asm-generic-cacheflushh.patch
powerpc-use-asm-generic-cacheflushh.patch
riscv-use-asm-generic-cacheflushh.patch
armsparcunicore32-remove-flush_icache_user_range.patch
mm-rename-flush_icache_user_range-to-flush_icache_user_page.patch
asm-generic-add-a-flush_icache_user_range-stub.patch
sh-implement-flush_icache_user_range.patch
xtensa-implement-flush_icache_user_range.patch
arm-rename-flush_cache_user_range-to-flush_icache_user_range.patch
m68k-implement-flush_icache_user_range.patch
exec-only-build-read_code-when-needed.patch
exec-use-flush_icache_user_range-in-read_code.patch
binfmt_flat-use-flush_icache_user_range.patch
nommu-use-flush_icache_user_range-in-brk-and-mmap.patch
module-move-the-set_fs-hack-for-flush_icache_range-to-m68k.patch
