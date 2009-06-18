From: akpm@linux-foundation.org
Subject: + bootmemc-avoid-c90-declaration-warning.patch added to -mm tree
Date: Thu, 18 Jun 2009 13:25:06 -0700
Message-ID: <200906182025.n5IKP65l003584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbZFRU0r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 16:26:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, benh@kernel.crashing.org, hannes@cmpxchg.org, penberg@cs.helsinki.fi, tj@kernel.org


The patch titled
     bootmem.c: avoid c90 declaration warning
has been added to the -mm tree.  Its filename is
     bootmemc-avoid-c90-declaration-warning.patch

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
Subject: bootmem.c: avoid c90 declaration warning
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/bootmem.c~bootmemc-avoid-c90-declaration-warning mm/bootmem.c
--- a/mm/bootmem.c~bootmemc-avoid-c90-declaration-warning
+++ a/mm/bootmem.c
@@ -536,11 +536,13 @@ static void * __init alloc_arch_preferre
 		return kzalloc(size, GFP_NOWAIT);
 
 #ifdef CONFIG_HAVE_ARCH_BOOTMEM
+	{
 	bootmem_data_t *p_bdata;
 
 	p_bdata = bootmem_arch_preferred_node(bdata, size, align, goal, limit);
 	if (p_bdata)
 		return alloc_bootmem_core(p_bdata, size, align, goal, limit);
+	}
 #endif
 	return NULL;
 }
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-fbdev-is-orphaned.patch
bootmemc-avoid-c90-declaration-warning.patch

