From: akpm@linux-foundation.org
Subject: [merged]
 scripts-decodecode-fix-trapping-instruction-formatting.patch removed from
 -mm tree
Date: Fri, 08 May 2020 15:32:29 -0700
Message-ID: <20200508223229.tRuuM_BRm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727849AbgEHWca (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 May 2020 18:32:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@suse.de, colona@arista.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/decodecode: fix trapping instruction formatting
has been removed from the -mm tree.  Its filename was
     scripts-decodecode-fix-trapping-instruction-formatting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ivan Delalande <colona@arista.com>
Subject: scripts/decodecode: fix trapping instruction formatting

If the trapping instruction contains a ':', for a memory access through
segment registers for example, the sed substitution will insert the '*'
marker in the middle of the instruction instead of the line address:

	2b:   65 48 0f c7 0f          cmpxchg16b %gs:*(%rdi)          <-- trapping instruction

I started to think I had forgotten some quirk of the assembly syntax
before noticing that it was actually coming from the script.  Fix it to
add the address marker at the right place for these instructions:

	28:   49 8b 06                mov    (%r14),%rax
	2b:*  65 48 0f c7 0f          cmpxchg16b %gs:(%rdi)           <-- trapping instruction
	30:   0f 94 c0                sete   %al

Link: http://lkml.kernel.org/r/20200419223653.GA31248@visor
Fixes: 18ff44b189e2 ("scripts/decodecode: make faulting insn ptr more robust")
Signed-off-by: Ivan Delalande <colona@arista.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decodecode |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/decodecode~scripts-decodecode-fix-trapping-instruction-formatting
+++ a/scripts/decodecode
@@ -126,7 +126,7 @@ faultlinenum=$(( $(wc -l $T.oo  | cut -d
 faultline=`cat $T.dis | head -1 | cut -d":" -f2-`
 faultline=`echo "$faultline" | sed -e 's/\[/\\\[/g; s/\]/\\\]/g'`
 
-cat $T.oo | sed -e "${faultlinenum}s/^\(.*:\)\(.*\)/\1\*\2\t\t<-- trapping instruction/"
+cat $T.oo | sed -e "${faultlinenum}s/^\([^:]*:\)\(.*\)/\1\*\2\t\t<-- trapping instruction/"
 echo
 cat $T.aa
 cleanup
_

Patches currently in -mm which might be from colona@arista.com are
