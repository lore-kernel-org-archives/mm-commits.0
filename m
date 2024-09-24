Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5101814F9D0;
	Tue, 24 Sep 2024 22:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727218023; cv=none; b=d/KC6URiIaz6ZffDCcE9WksTfrZMQ6ZZl9vtJNnyNq3Y0d57pEPuaXCeDZPFB5NDe1wb3nwlWuLrqvWnmdxKGfMAgtKGF8ogKkgZemLvEBWtpNaTFqT84ueHSa82TdUWaCS8TGZCUaTjawTiVtDl3/+FW6kifdxS7/rlCyLMd+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727218023; c=relaxed/simple;
	bh=dpq2+c2jgsrmGjcEwkpMySA5s8CWB9zh3viGbGdpqdk=;
	h=Date:To:From:Subject:Message-Id; b=FtRrd1ITsWdgrmKWGpw5m8fOu/33b5Fmy4cg2XqjL1HdQWkFOLMmOsXSQAiwwQcnw1+JvVjUlzE+5TaTJQPSt/pfYhA+v12C2UIdYviq0qkDTREzlBoi8bu3EIWHMafkiI3oyXV5z4DuQeIkykNrrp2PiBZzYrZmen8tDzPDiZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RS+DkPU0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RS+DkPU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E050EC4CEC4;
	Tue, 24 Sep 2024 22:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727218023;
	bh=dpq2+c2jgsrmGjcEwkpMySA5s8CWB9zh3viGbGdpqdk=;
	h=Date:To:From:Subject:From;
	b=RS+DkPU0DVxpn3kfc4IfqzCIvsbmfTTBmB7Uh9yIhH2J702JiJIPuVzXzjBqCkkHq
	 CtdZXYyWibEshzWc+fz5OtjcGJ7vWTj8ImgqSMya2yYdnjohEn0mlrol3DkwgUR4Ij
	 LQbnVoBLBD5AF65nmzEvbccWZ0B2Cj+bLHPUwXdw=
Date: Tue, 24 Sep 2024 15:47:02 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,peterz@infradead.org,jpoimboe@kernel.org,yangtiezhu@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + compilerh-specify-correct-attribute-for-rodatac_jump_table.patch added to mm-hotfixes-unstable branch
Message-Id: <20240924224702.E050EC4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: compiler.h: specify correct attribute for .rodata..c_jump_table
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     compilerh-specify-correct-attribute-for-rodatac_jump_table.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compilerh-specify-correct-attribute-for-rodatac_jump_table.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

compilerh-specify-correct-attribute-for-rodatac_jump_table.patch

