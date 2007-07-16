From: akpm@linux-foundation.org
Subject: - slob-sparsemem-support.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:49:51 -0700
Message-ID: <200707162049.l6GKnpE9001200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57555 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763825AbXGPVf0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:35:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, clameter@sgi.com, mpm@selenic.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     slob: sparsemem support
has been removed from the -mm tree.  Its filename was
     slob-sparsemem-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
nohz-fix-nohz-x86-dyntick-idle-handling.patch
pvr2fb-fix-pseudo_palette-array-overrun-and-typecast.patch
fb-epson1355fb-kill-off-dead-sh-support.patch
