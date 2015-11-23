From: akpm@linux-foundation.org
Subject: +
 powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch added to -mm tree
Date: Mon, 23 Nov 2015 15:56:21 -0800
Message-ID: <5653a7a5.N/U8+tJscEnOn1TT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbbKWX4W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 18:56:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, gregkh@linuxfoundation.org, mpe@ellerman.id.au, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/fadump: rename cpu_online_mask member of struct fadump_crash_info_header
has been added to the -mm tree.  Its filename is
     powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: powerpc/fadump: rename cpu_online_mask member of struct fadump_crash_info_header

The four cpumasks cpu_{possible,online,present,active}_bits are exposed
readonly via the corresponding const variables cpu_xyz_mask.  But they are
also accessible for arbitrary writing via the exposed functions
set_cpu_xyz.  There's quite a bit of code throughout the kernel which
iterates over or otherwise accesses these bitmaps, and having the access
go via the cpu_xyz_mask variables is nowadays [1] simply a useless
indirection.

It may be that any problem in CS can be solved by an extra level of
indirection, but that doesn't mean every extra indirection solves a
problem.  In this case, it even necessitates some minor ugliness (see
4/6).

Patch 1/6 is new in v2, and fixes a build failure on ppc by renaming a
struct member, to avoid problems when the identifier cpu_online_mask
becomes a macro later in the series.  The next four patches eliminate the
cpu_xyz_mask variables by simply exposing the actual bitmaps, after
renaming them to discourage direct access - that still happens through
cpu_xyz_mask, which are now simply macros with the same type and value as
they used to have.

After that, there's no longer any reason to have the setter functions be
out-of-line: The boolean parameter is almost always a literal true or
false, so by making them static inlines they will usually compile to one
or two instructions.

For a defconfig build on x86_64, bloat-o-meter says we save ~3000 bytes. 
We also save a little stack (stackdelta says 127 functions have a 16 byte
smaller stack frame, while two grow by that amount).  Mostly because, when
iterating over the mask, gcc typically loads the value of cpu_xyz_mask
into a callee-saved register and from there into %rdi before each
find_next_bit call - now it can just load the appropriate immediate
address into %rdi before each call.

[1] See Rusty's kind explanation
http://thread.gmane.org/gmane.linux.kernel/2047078/focus=2047722 for
some historic context.


This patch (of 6):

As preparation for eliminating the indirect access to the various global
cpu_*_bits bitmaps via the pointer variables cpu_*_mask, rename the
cpu_online_mask member of struct fadump_crash_info_header to simply
online_mask, thus allowing cpu_online_mask to become a macro.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/fadump.h |    2 +-
 arch/powerpc/kernel/fadump.c      |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/include/asm/fadump.h~powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header arch/powerpc/include/asm/fadump.h
--- a/arch/powerpc/include/asm/fadump.h~powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header
+++ a/arch/powerpc/include/asm/fadump.h
@@ -191,7 +191,7 @@ struct fadump_crash_info_header {
 	u64		elfcorehdr_addr;
 	u32		crashing_cpu;
 	struct pt_regs	regs;
-	struct cpumask	cpu_online_mask;
+	struct cpumask	online_mask;
 };
 
 /* Crash memory ranges */
diff -puN arch/powerpc/kernel/fadump.c~powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header arch/powerpc/kernel/fadump.c
--- a/arch/powerpc/kernel/fadump.c~powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header
+++ a/arch/powerpc/kernel/fadump.c
@@ -415,7 +415,7 @@ void crash_fadump(struct pt_regs *regs,
 	else
 		ppc_save_regs(&fdh->regs);
 
-	fdh->cpu_online_mask = *cpu_online_mask;
+	fdh->online_mask = *cpu_online_mask;
 
 	/* Call ibm,os-term rtas call to trigger firmware assisted dump */
 	rtas_os_term((char *)str);
@@ -646,7 +646,7 @@ static int __init fadump_build_cpu_notes
 		}
 		/* Lower 4 bytes of reg_value contains logical cpu id */
 		cpu = be64_to_cpu(reg_entry->reg_value) & FADUMP_CPU_ID_MASK;
-		if (fdh && !cpumask_test_cpu(cpu, &fdh->cpu_online_mask)) {
+		if (fdh && !cpumask_test_cpu(cpu, &fdh->online_mask)) {
 			SKIP_TO_NEXT_CPU(reg_entry);
 			continue;
 		}
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch
kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
kernel-cpuc-export-__cpu__mask.patch
drivers-base-cpuc-use-__cpu__mask-directly.patch
kernel-cpuc-eliminate-cpu__mask.patch
kernel-cpuc-make-set_cpu_-static-inlines.patch

