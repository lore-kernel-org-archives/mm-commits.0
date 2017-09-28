From: akpm@linux-foundation.org
Subject: +
 scripts-decodecode-fix-decoding-for-aarch64-arm64-instructions.patch added
 to -mm tree
Date: Thu, 28 Sep 2017 13:40:12 -0700
Message-ID: <59cd5e2c.jnE9zedmWefgpsUZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45614 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751484AbdI1UkN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Sep 2017 16:40:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.deacon@arm.com, Dave.Martin@arm.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/decodecode: fix decoding for AArch64 (arm64) instructions
has been added to the -mm tree.  Its filename is
     scripts-decodecode-fix-decoding-for-aarch64-arm64-instructions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-decodecode-fix-decoding-for-aarch64-arm64-instructions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-decodecode-fix-decoding-for-aarch64-arm64-instructions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -58,6 +58,14 @@ disas() {
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

scripts-decodecode-fix-decoding-for-aarch64-arm64-instructions.patch

