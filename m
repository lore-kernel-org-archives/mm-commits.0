From: akpm@linux-foundation.org
Subject: + slob-sparsemem-support.patch added to -mm tree
Date: Fri, 13 Jul 2007 16:31:03 -0700
Message-ID: <200707132331.l6DNV3dZ028556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34466 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758191AbXGMXb3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 19:31:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, clameter@sgi.com, mpm@selenic.com, penberg@cs.helsinki.fi


The patch titled
     slob: sparsemem support
has been added to the -mm tree.  Its filename is
     slob-sparsemem-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slob: sparsemem support
From: Paul Mundt <lethal@linux-sh.org>

Currently slob is disabled if we're using sparsemem, due to an earlier
patch from Goto-san.  Slob and static sparsemem work without any trouble as
it is, and the only hiccup is a missing slab_is_available() in the case of
sparsemem extreme.  With this, we're rid of the last set of restrictions
for slob usage.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Matt Mackall <mpm@selenic.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 mm/slob.c    |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff -puN init/Kconfig~slob-sparsemem-support init/Kconfig
--- a/init/Kconfig~slob-sparsemem-support
+++ a/init/Kconfig
@@ -576,7 +576,7 @@ config SLUB
 	   and has enhanced diagnostics.
 
 config SLOB
-	depends on EMBEDDED && !SPARSEMEM
+	depends on EMBEDDED
 	bool "SLOB (Simple Allocator)"
 	help
 	   SLOB replaces the SLAB allocator with a drastically simpler
diff -puN mm/slob.c~slob-sparsemem-support mm/slob.c
--- a/mm/slob.c~slob-sparsemem-support
+++ a/mm/slob.c
@@ -634,6 +634,14 @@ int kmem_ptr_validate(struct kmem_cache 
 	return 0;
 }
 
+static unsigned int slob_ready __read_mostly;
+
+int slab_is_available(void)
+{
+	return slob_ready;
+}
+
 void __init kmem_cache_init(void)
 {
+	slob_ready = 1;
 }
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
git-sh.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
numa-mempolicy-dynamic-interleave-map-for-system-init.patch
numa-mempolicy-trivial-debug-fixes.patch
mm-more-__meminit-annotations.patch
slob-initial-numa-support.patch
slob-sparsemem-support.patch
generic-bug-use-show_regs-instead-of-dump_stack.patch
pvr2fb-fix-pseudo_palette-array-overrun-and-typecast.patch
fb-epson1355fb-kill-off-dead-sh-support.patch
