From: akpm@linux-foundation.org
Subject: + x86-_end-symbol-missing-from-symbolmap.patch added to -mm tree
Date: Wed, 19 Aug 2009 09:37:09 -0700
Message-ID: <200908191637.n7JGb9JF019253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753207AbZHSQij (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Aug 2009 12:38:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hare@suse.de, mingo@elte.hu, sam@ravnborg.org, stable@kernel.org


The patch titled
     x86: _end symbol missing from Symbol.map
has been added to the -mm tree.  Its filename is
     x86-_end-symbol-missing-from-symbolmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: _end symbol missing from Symbol.map
From: Hannes Reinecke <hare@suse.de>

With 2.6.31 'crash' on x86_64 falls flat on its face as the '_end' symbol
is missing from the System.map file.

The culprit is commit 091e52c3551d3031343df24b573b770b4c6c72b6, which
moved the '_end' symbol into it's own section.  Apparently this causes
kallsyms to not reference it properly.

So either we'd need to revert part of the patch to not include _end in
it's own section.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/vmlinux.lds.S |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/x86/kernel/vmlinux.lds.S~x86-_end-symbol-missing-from-symbolmap arch/x86/kernel/vmlinux.lds.S
--- a/arch/x86/kernel/vmlinux.lds.S~x86-_end-symbol-missing-from-symbolmap
+++ a/arch/x86/kernel/vmlinux.lds.S
@@ -376,9 +376,7 @@ SECTIONS
 		__brk_limit = .;
 	}
 
-	.end : AT(ADDR(.end) - LOAD_OFFSET) {
-		_end = .;
-	}
+	_end = .;
 
         STABS_DEBUG
         DWARF_DEBUG
_

Patches currently in -mm which might be from hare@suse.de are

linux-next.patch
x86-_end-symbol-missing-from-symbolmap.patch

