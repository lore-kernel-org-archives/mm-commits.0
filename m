From: akpm@linux-foundation.org
Subject: +
 scripts-decodecode-fix-trapping-instruction-formatting.patch added to -mm
 tree
Date: Mon, 20 Apr 2020 15:12:43 -0700
Message-ID: <20200420221243.cEgtla35E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgDTWMo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 18:12:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@suse.de, colona@arista.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/decodecode: fix trapping instruction formatting
has been added to the -mm tree.  Its filename is
     scripts-decodecode-fix-trapping-instruction-formatting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-decodecode-fix-trapping-instruction-formatting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-decodecode-fix-trapping-instruction-formatting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

scripts-decodecode-fix-trapping-instruction-formatting.patch
