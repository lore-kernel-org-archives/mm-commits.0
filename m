From: akpm@linux-foundation.org
Subject: + cpumask-fix-slab-corruption-caused-by-alloc_cpumask_var_node.patch added to -mm tree
Date: Thu, 02 Apr 2009 14:41:28 -0700
Message-ID: <200904022141.n32LfST3014920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751454AbZDBVqU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 17:46:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com, mingo@elte.hu, rusty@rustcorp.com.au, sfr@canb.auug.org.au, stable@kernel.org


The patch titled
     cpumask: fix slab corruption caused by alloc_cpumask_var_node()
has been added to the -mm tree.  Its filename is
     cpumask-fix-slab-corruption-caused-by-alloc_cpumask_var_node.patch

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
Subject: cpumask: fix slab corruption caused by alloc_cpumask_var_node()
From: Jack Steiner <steiner@sgi.com>

Fix for slab corruption caused by alloc_cpumask_var_node() overwriting
the tail end of an off-stack cpumask.

The pointer arithmetic in the memset() is designed to operate on
byte-sized pointers, but cpumask_bits() returns `long *' type, so the
offset of 4x or 8x too large.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Acked-by: Mike Travis <travis.sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
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
sgi-gru-exclude-uv-definitions-on-32-bit-x86.patch
sgi-gru-add-definitions-of-x86_64-gru-mmrs.patch
sgi-gru-add-definitions-of-ia64-gru-mmrs.patch
sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts.patch
sgi-gru-misc-gru-cleanup.patch
sgi-gru-improvements-to-gru-debug-messages-statistics.patch
sgi-gru-change-gru-cch-commands-from-inline-functions-to-outofline-functions.patch
sgi-gru-add-statistics-to-the-gru-context-management-functions.patch
sgi-gru-add-support-for-a-user-to-explicitly-unload-a-gru-context.patch
sgi-gru-asid-context-management-bug-fixes.patch
sgi-gru-restructure-the-gru-vtop-functions.patch
sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts.patch
sgi-gru-macro-for-scanning-all-gru-chiplets.patch
sgi-gru-fix-bugs-related-to-module-unload-of-the-gru-driver.patch
sgi-gru-support-multiple-pagesizes-in-gru.patch
remove-sgi_gru-as-a-valid-config-option-for-ia64-configs-with-sgi_uv.patch
cpumask-fix-slab-corruption-caused-by-alloc_cpumask_var_node.patch

