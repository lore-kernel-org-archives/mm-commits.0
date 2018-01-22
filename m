From: akpm@linux-foundation.org
Subject: [merged]
 scripts-decodecode-fix-decoding-for-aarch64-arm64-instructions.patch
 removed from -mm tree
Date: Mon, 22 Jan 2018 12:54:36 -0800
Message-ID: <20180122205436.cBmolEzsD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51958 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751030AbeAVUyh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Jan 2018 15:54:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Dave.Martin@arm.com, mm-commits@vger.kernel.org, mmarek@suse.cz, will.deacon@arm.com


The patch titled
     Subject: scripts/decodecode: fix decoding for AArch64 (arm64) instructions
has been removed from the -mm tree.  Its filename was
     scripts-decodecode-fix-decoding-for-aarch64-arm64-instructions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: scripts/decodecode: fix decoding for AArch64 (arm64) instructions

There are a couple of problems with the decodecode script and arm64:

1. AArch64 objdump refuses to disassemble .4byte directives as instructions,
   insisting that they are data values and displaying them as:

	a94153f3	.word	0xa94153f3		<-- trapping instruction

   This is resolved by using the .inst directive instead.

2. Disassembly of branch instructions attempts to provide the target as
   an offset from a symbol, e.g.:

   0:	34000082	cbz	w2, 10 <.text+0x10>

  however this falls foul of the grep -v, which matches lines containing
  ".text" and ends up removing all branch instructions from the dump.

This patch resolves both issues by using the .inst directive for 4-byte
quantities on arm64 and stripping the resulting binaries (as is done on
arm already) to remove the mapping symbols.

Link: http://lkml.kernel.org/r/1506596147-23630-1-git-send-email-will.deacon@arm.com
Signed-off-by: Will Deacon <will.deacon@arm.com>
Reviewed-by: Dave Martin <Dave.Martin@arm.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decodecode |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN scripts/decodecode~scripts-decodecode-fix-decoding-for-aarch64-arm64-instructions scripts/decodecode
--- a/scripts/decodecode~scripts-decodecode-fix-decoding-for-aarch64-arm64-instructions
+++ a/scripts/decodecode
@@ -59,6 +59,14 @@ disas() {
 		${CROSS_COMPILE}strip $1.o
 	fi
 
+	if [ "$ARCH" = "arm64" ]; then
+		if [ $width -eq 4 ]; then
+			type=inst
+		fi
+
+		${CROSS_COMPILE}strip $1.o
+	fi
+
 	${CROSS_COMPILE}objdump $OBJDUMPFLAGS -S $1.o | \
 		grep -v "/tmp\|Disassembly\|\.text\|^$" > $1.dis 2>&1
 }
_

Patches currently in -mm which might be from will.deacon@arm.com are


