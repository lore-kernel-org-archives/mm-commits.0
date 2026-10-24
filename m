Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832326;
	b=ZVwqOF0pRqu40tbprnBunlz2uvWTBsKoZEJjpL2BxKsd4UgUGAom+ZBgkx2SKoOXp4T5
	 lrIta/BT7Bk4S9TauRZrn2el34Q4fIJZj1+d86GZOXCL+t3MvKRp69b7UKD/iKWAelIF0
	 mApzVCJk+Mr44XHUvQ0+n0GT2cAjOP+W5ufS8mVmqegPFBHYH1UF/cG2xzR2Y2XdJxUae
	 mwxRk9PzLnDsbfA6JUpPdRnGOZydDsvHKVY0r9sDla8ham5qwL2ZMv71i9qI2SEKbiOTS
	 undEG79jDQfeYE/xtf3RcoGdW1Wdim+6QwdNUJhLl8fMNA8HyLht2vb/buOHluyg0ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832326;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=WRVkloSt0RB5S5eXRTzOJ9tjcf1Ic/NjGRMhON0hMfI=;
	b=juMdwZ65jLrYPkHr/H7zPs62EslOSHsDM58IVBfB3eUWAS/T4GznW1HsSgBC7EHLZid7
	 TBJmrd+N5+YnAraUW980ypp1JZCCg3wwDi+7cbl1QK+ih4M14pBeNeVYIStR8yb8Jo/RR
	 xy5TDIcs0+JTBKK8nA12aaGffI+TINYupcPyJM8wWWvvBKUKgUxaZhU6FH/4FjAODu8uL
	 CzfSk2JImraNo0dbTLeMQO4U7+M4fU0j+k05lgoqOUD8LW2e/EDqTzMm6Z2bQ9SMgClkb
	 c6r+2MU0Lzz3qKlmlesLM5cID/k0VVPLKeG/N7gpb+LtYuL1ameCsD73+3jQ7bUmfKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ngGWgaHO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F81606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ngGWgaHO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F201F01828;
	Sat, 24 Oct 2026 08:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832325;
	bh=WRVkloSt0RB5S5eXRTzOJ9tjcf1Ic/NjGRMhON0hMfI=;
	h=Date:To:From:Subject;
	b=ngGWgaHOrvp3bEIOn0UtIb7ulwZ8VE4/dxAqHUzb39pELG9ACzxjN1Ju/BmQQELMd
	 zS4GfugvjTKkwJgLSa1/xnDjvQxZMeWvBFxkeWb3wXXWc/0gP7MbLfcXfCMPSIyLZL
	 WUl5/mTPSw+Cu3E+dUTrA7O7XE7lPLSZGNSo58vc=
Date: Sat, 24 Oct 2026 01:58:45 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,glaubitz@physik.fu-berlin.de,dalias@libc.org,arnd@arndb.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-mm-remove-numac.patch removed from -mm tree
Message-Id: <20261024085845.C7F201F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: sh: mm: remove numa.c
has been removed from the -mm tree.  Its filename was
     sh-mm-remove-numac.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: sh: mm: remove numa.c
Date: Sun, 10 May 2026 16:55:38 +0300

Since CONFIG_NUMA is removed, numa.c won't be ever compiled.

Remove it.

Link: https://lore.kernel.org/20260510135546.13554-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---

 arch/sh/mm/Makefile |    1 
 arch/sh/mm/numa.c   |   53 ------------------------------------------
 2 files changed, 54 deletions(-)

--- a/arch/sh/mm/Makefile~sh-mm-remove-numac
+++ a/arch/sh/mm/Makefile
@@ -37,7 +37,6 @@ endif
 obj-$(CONFIG_DEBUG_FS)		+= $(debugfs-y)
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
 obj-$(CONFIG_PMB)		+= pmb.o
-obj-$(CONFIG_NUMA)		+= numa.o
 obj-$(CONFIG_IOREMAP_FIXED)	+= ioremap_fixed.o
 obj-$(CONFIG_UNCACHED_MAPPING)	+= uncached.o
 obj-$(CONFIG_HAVE_SRAM_POOL)	+= sram.o
diff --git a/arch/sh/mm/numa.c a/arch/sh/mm/numa.c
deleted file mode 100644
--- a/arch/sh/mm/numa.c
+++ /dev/null
@@ -1,53 +0,0 @@
-/*
- * arch/sh/mm/numa.c - Multiple node support for SH machines
- *
- *  Copyright (C) 2007  Paul Mundt
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-#include <linux/module.h>
-#include <linux/memblock.h>
-#include <linux/mm.h>
-#include <linux/numa.h>
-#include <linux/pfn.h>
-#include <asm/sections.h>
-
-/*
- * On SH machines the conventional approach is to stash system RAM
- * in node 0, and other memory blocks in to node 1 and up, ordered by
- * latency. Each node's pgdat is node-local at the beginning of the node,
- * immediately followed by the node mem map.
- */
-void __init setup_bootmem_node(int nid, unsigned long start, unsigned long end)
-{
-	unsigned long start_pfn, end_pfn;
-
-	/* Don't allow bogus node assignment */
-	BUG_ON(nid >= MAX_NUMNODES || nid <= 0);
-
-	start_pfn = PFN_DOWN(start);
-	end_pfn = PFN_DOWN(end);
-
-	pmb_bolt_mapping((unsigned long)__va(start), start, end - start,
-			 PAGE_KERNEL);
-
-	memblock_add(start, end - start);
-
-	__add_active_range(nid, start_pfn, end_pfn);
-
-	/* Node-local pgdat */
-	NODE_DATA(nid) = memblock_alloc_node(sizeof(struct pglist_data),
-					     SMP_CACHE_BYTES, nid);
-	if (!NODE_DATA(nid))
-		panic("%s: Failed to allocate %zu bytes align=0x%x nid=%d\n",
-		      __func__, sizeof(struct pglist_data), SMP_CACHE_BYTES,
-		      nid);
-
-	NODE_DATA(nid)->node_start_pfn = start_pfn;
-	NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
-
-	/* It's up */
-	node_set_online(nid);
-}
_

Patches currently in -mm which might be from rppt@kernel.org are


