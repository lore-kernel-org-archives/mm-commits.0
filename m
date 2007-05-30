From: akpm@linux-foundation.org
Subject: + fix-possible-null-ptr-deref-in-kallsyms_lookup.patch added to -mm tree
Date: Wed, 30 May 2007 12:11:52 -0700
Message-ID: <200705301911.l4UJBqg7002495@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752782AbXE3TMj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 15:12:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyle@parisc-linux.org


The patch titled
     fix possible null ptr deref in kallsyms_lookup
has been added to the -mm tree.  Its filename is
     fix-possible-null-ptr-deref-in-kallsyms_lookup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fix-possible-null-ptr-deref-in-kallsyms_lookup.patch
git-parisc.patch
