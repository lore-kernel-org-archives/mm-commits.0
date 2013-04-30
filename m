From: akpm@linux-foundation.org
Subject: [merged] scripts-decodecode-make-faulting-insn-ptr-more-robust.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:43:57 -0700
Message-ID: <20130430184357.C70985A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:42266 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720Ab3D3Sn7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:43:59 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so84529vcb.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:43:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@suse.de, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/decodecode: make faulting insn ptr more robust
has been removed from the -mm tree.  Its filename was
     scripts-decodecode-make-faulting-insn-ptr-more-robust.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Borislav Petkov <bp@suse.de>
Subject: scripts/decodecode: make faulting insn ptr more robust

It can accidentally happen that the faulting insn (the exact instruction
bytes) is repeated a little further on in the trace.  This causes that
same instruction to be tagged twice, see example below.

What we want to do, however, is to track back from the end of the whole
disassembly so many lines as the slice which starts with the faulting
instruction is long.  This leads us to the actual faulting instruction and
*then* we tag it.

While we're at it, we can drop the sed "g" flag because we address only
this one line.

Also, if we point to an instruction which changes decoding depending on
the slice being objdumped, like a Jcc insn, for example, we do not even
tag it as a faulting instruction because the instruction decode changes in
the second slice but we use that second format as a regex on the fsrst
disassembled buffer and more often than not that instruction doesn't
match.

Again, simply tag the line which is deduced from the original "<>" marking
we've received from the kernel.

This also solves the pathologic issue of multiple tagging like this:

  29:*  0f 0b                   ud2         <-- trapping instruction
  2b:*  0f 0b                   ud2         <-- trapping instruction
  2d:*  0f 0b                   ud2         <-- trapping instruction

Double tagging example:

Code: 34 dd 40 30 ad 81 48 c7 c0 80 f6 00 00 48 8b 3c 30 48 01 c6 b8 ff ff ff ff 48 8d 57 f0 48 39 f7 74 2f 49 8b 4c 24 08 48 8b 47 f0 <48> 39 48 08 75 0e eb 2a 66 90 48 8b 40 f0 48 39 48 08 74 1e 48
All code
========
   0:   34 dd                   xor    $0xdd,%al
   2:   40 30 ad 81 48 c7 c0    xor    %bpl,-0x3f38b77f(%rbp)
   9:   80 f6 00                xor    $0x0,%dh
   c:   00 48 8b                add    %cl,-0x75(%rax)
   f:   3c 30                   cmp    $0x30,%al
  11:   48 01 c6                add    %rax,%rsi
  14:   b8 ff ff ff ff          mov    $0xffffffff,%eax
  19:   48 8d 57 f0             lea    -0x10(%rdi),%rdx
  1d:   48 39 f7                cmp    %rsi,%rdi
  20:   74 2f                   je     0x51
  22:   49 8b 4c 24 08          mov    0x8(%r12),%rcx
  27:   48 8b 47 f0             mov    -0x10(%rdi),%rax
  2b:*  48 39 48 08             cmp    %rcx,0x8(%rax)     <-- trapping instruction
  2f:   75 0e                   jne    0x3f
  31:   eb 2a                   jmp    0x5d
  33:   66 90                   xchg   %ax,%ax
  35:   48 8b 40 f0             mov    -0x10(%rax),%rax
  39:*  48 39 48 08             cmp    %rcx,0x8(%rax)     <-- trapping instruction
  3d:   74 1e                   je     0x5d
  3f:   48                      rex.W

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decodecode |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN scripts/decodecode~scripts-decodecode-make-faulting-insn-ptr-more-robust scripts/decodecode
--- a/scripts/decodecode~scripts-decodecode-make-faulting-insn-ptr-more-robust
+++ a/scripts/decodecode
@@ -89,10 +89,16 @@ echo $code >> $T.s
 disas $T
 cat $T.dis >> $T.aa
 
+# (lines of whole $T.oo) - (lines of $T.aa, i.e. "Code starting") + 3,
+# i.e. the title + the "===..=" line (sed is counting from 1, 0 address is
+# special)
+faultlinenum=$(( $(wc -l $T.oo  | cut -d" " -f1) - \
+		 $(wc -l $T.aa  | cut -d" " -f1) + 3))
+
 faultline=`cat $T.dis | head -1 | cut -d":" -f2-`
 faultline=`echo "$faultline" | sed -e 's/\[/\\\[/g; s/\]/\\\]/g'`
 
-cat $T.oo | sed -e "s/\($faultline\)/\*\1     <-- trapping instruction/g"
+cat $T.oo | sed -e "${faultlinenum}s/^\(.*:\)\(.*\)/\1\*\2\t\t<-- trapping instruction/"
 echo
 cat $T.aa
 cleanup
_

Patches currently in -mm which might be from bp@suse.de are

origin.patch
linux-next.patch

