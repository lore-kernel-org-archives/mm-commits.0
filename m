Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4861B184544;
	Thu, 26 Sep 2024 21:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384661; cv=none; b=PF/Y+ZtdvEvoqcHQGNKKIsc2VLwhrfN7b8EU//SeuykCa8aCxtkAPTZYI1OLOnyPdzfNZPvnBcp6iR6pEQ5XhvOs4MvFMvqUPzOooilox7TZZ5N8sabt+F91qcl52leoToVHxAdTamAB5kbWynNXllEVnqjjbEIMBkMCbde62a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384661; c=relaxed/simple;
	bh=2QiXmwATO2PQRl8qp/YEt04Lq/XRjvzs4kEBezlAi+Y=;
	h=Date:To:From:Subject:Message-Id; b=AZxzCXYaLmoth5jn2XTMcMnKFtg2tLWYbJQdYE9GrggS2QxBMXaZofTy2XLBGVIH3LmKKpGQ71/MGxm/1YiPzfIsUnwVCFJC341ZSIRjtrd468a7RLtkobuTZQLK7xmwSg4QvnOeThtB8tBA1uTJvbMN0LVhBE2azUoBcW1ZDBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CeaFFzZ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CeaFFzZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4D1C4CEC5;
	Thu, 26 Sep 2024 21:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727384661;
	bh=2QiXmwATO2PQRl8qp/YEt04Lq/XRjvzs4kEBezlAi+Y=;
	h=Date:To:From:Subject:From;
	b=CeaFFzZ07K/QpYxOcHstbPHS0cxUELGu26jJxl2F1VadGClCZlEJcs43xQ2YCjPK+
	 9SPiPfCrsHNef4fY6yfA3FsUBqhXB+1T3umM3gyVH0xkMwt1vDyB3cuJj1n7KcZlIw
	 o0AD/+ezcYBguEgj51nuSVZWlhgBEHOt986RXy2M=
Date: Thu, 26 Sep 2024 14:04:20 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,peterz@infradead.org,jpoimboe@kernel.org,yangtiezhu@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] compilerh-specify-correct-attribute-for-rodatac_jump_table.patch removed from -mm tree
Message-Id: <20240926210421.1C4D1C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: compiler.h: specify correct attribute for .rodata..c_jump_table
has been removed from the -mm tree.  Its filename was
     compilerh-specify-correct-attribute-for-rodatac_jump_table.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: compiler.h: specify correct attribute for .rodata..c_jump_table
Date: Tue, 24 Sep 2024 14:27:10 +0800

Currently, there is an assembler message when generating kernel/bpf/core.o
under CONFIG_OBJTOOL with LoongArch compiler toolchain:

  Warning: setting incorrect section attributes for .rodata..c_jump_table

This is because the section ".rodata..c_jump_table" should be readonly,
but there is a "W" (writable) part of the flags:

  $ readelf -S kernel/bpf/core.o | grep -A 1 "rodata..c"
  [34] .rodata..c_j[...] PROGBITS         0000000000000000  0000d2e0
       0000000000000800  0000000000000000  WA       0     0     8

There is no above issue on x86 due to the generated section flag is only
"A" (allocatable). In order to silence the warning on LoongArch, specify
the attribute like ".rodata..c_jump_table,\"a\",@progbits #" explicitly,
then the section attribute of ".rodata..c_jump_table" must be readonly
in the kernel/bpf/core.o file.

Before:

  $ objdump -h kernel/bpf/core.o | grep -A 1 "rodata..c"
   21 .rodata..c_jump_table 00000800  0000000000000000  0000000000000000  0000d2e0  2**3
                  CONTENTS, ALLOC, LOAD, RELOC, DATA

After:

  $ objdump -h kernel/bpf/core.o | grep -A 1 "rodata..c"
   21 .rodata..c_jump_table 00000800  0000000000000000  0000000000000000  0000d2e0  2**3
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, DATA

By the way, AFAICT, maybe the root cause is related with the different
compiler behavior of various archs, so to some extent this change is a
workaround for LoongArch, and also there is no effect for x86 which is the
only port supported by objtool before LoongArch with this patch.

Link: https://lkml.kernel.org/r/20240924062710.1243-1-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>	[6.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/compiler.h~compilerh-specify-correct-attribute-for-rodatac_jump_table
+++ a/include/linux/compiler.h
@@ -133,7 +133,7 @@ void ftrace_likely_update(struct ftrace_
 #define annotate_unreachable() __annotate_unreachable(__COUNTER__)
 
 /* Annotate a C jump table to allow objtool to follow the code flow */
-#define __annotate_jump_table __section(".rodata..c_jump_table")
+#define __annotate_jump_table __section(".rodata..c_jump_table,\"a\",@progbits #")
 
 #else /* !CONFIG_OBJTOOL */
 #define annotate_reachable()
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are


