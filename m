From: akpm@linux-foundation.org
Subject: [merged] cpumask-fix-slab-corruption-caused-by-alloc_cpumask_var_node.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:38:52 -0700
Message-ID: <200904061938.n36Jcq7c013561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753014AbZDFU3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:29:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mingo@elte.hu, rusty@rustcorp.com.au, sfr@canb.auug.org.au, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cpumask: fix slab corruption caused by alloc_cpumask_var_node()
has been removed from the -mm tree.  Its filename was
     cpumask-fix-slab-corruption-caused-by-alloc_cpumask_var_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpumask: fix slab corruption caused by alloc_cpumask_var_node()
From: Jack Steiner <steiner@sgi.com>

Fix slab corruption caused by alloc_cpumask_var_node() overwriting the
tail end of an off-stack cpumask.

The function zeros out cpumask bits beyond the last possible cpu.  The
starting point for zeroing should be the beginning of the mask offset by a
byte count derived from the number of possible cpus.  The offset was
calculated in bits instead of bytes.  This resulted in overwriting the end
of the cpumask.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Acked-by: Mike Travis <travis.sgi.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: <stable@kernel.org>		[2.6.29.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cpumask.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/cpumask.c~cpumask-fix-slab-corruption-caused-by-alloc_cpumask_var_node lib/cpumask.c
--- a/lib/cpumask.c~cpumask-fix-slab-corruption-caused-by-alloc_cpumask_var_node
+++ a/lib/cpumask.c
@@ -109,10 +109,10 @@ bool alloc_cpumask_var_node(cpumask_var_
 #endif
 	/* FIXME: Bandaid to save us from old primitives which go to NR_CPUS. */
 	if (*mask) {
+		unsigned char *ptr = (unsigned char *)cpumask_bits(*mask);
 		unsigned int tail;
 		tail = BITS_TO_LONGS(NR_CPUS - nr_cpumask_bits) * sizeof(long);
-		memset(cpumask_bits(*mask) + cpumask_size() - tail,
-		       0, tail);
+		memset(ptr + cpumask_size() - tail, 0, tail);
 	}
 
 	return *mask != NULL;
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

