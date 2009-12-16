From: akpm@linux-foundation.org
Subject: [merged] x86-_end-symbol-missing-from-symbolmap.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:41:48 -0800
Message-ID: <200912162041.nBGKfm5P013845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964842AbZLPUmq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:42:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hare@suse.de, mingo@elte.hu, sam@ravnborg.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     x86: _end symbol missing from Symbol.map
has been removed from the -mm tree.  Its filename was
     x86-_end-symbol-missing-from-symbolmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -319,9 +319,7 @@ SECTIONS
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

origin.patch

