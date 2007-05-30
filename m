From: akpm@linux-foundation.org
Subject: - fix-possible-null-ptr-deref-in-kallsyms_lookup.patch removed from -mm tree
Date: Wed, 30 May 2007 16:28:17 -0700
Message-ID: <200705302328.l4UNSGNJ007741@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758554AbXE3X3A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 19:29:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kyle@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     fix possible null ptr deref in kallsyms_lookup
has been removed from the -mm tree.  Its filename was
     fix-possible-null-ptr-deref-in-kallsyms_lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix possible null ptr deref in kallsyms_lookup
From: Kyle McMartin <kyle@parisc-linux.org>

ugh, this function gets called by our unwinder. recursive backtrace for
the win... bisection to find this one was "fun."

Signed-off-by: Kyle McMartin <kyle@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kallsyms.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/kallsyms.c~fix-possible-null-ptr-deref-in-kallsyms_lookup kernel/kallsyms.c
--- a/kernel/kallsyms.c~fix-possible-null-ptr-deref-in-kallsyms_lookup
+++ a/kernel/kallsyms.c
@@ -257,7 +257,8 @@ const char *kallsyms_lookup(unsigned lon
 		pos = get_symbol_pos(addr, symbolsize, offset);
 		/* Grab name */
 		kallsyms_expand_symbol(get_symbol_offset(pos), namebuf);
-		*modname = NULL;
+		if (modname)
+			*modname = NULL;
 		return namebuf;
 	}
 
_

Patches currently in -mm which might be from kyle@parisc-linux.org are

origin.patch
git-parisc.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
