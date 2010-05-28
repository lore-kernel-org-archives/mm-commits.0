From: akpm@linux-foundation.org
Subject: + flat-tweak-default-stack-alignment.patch added to -mm tree
Date: Fri, 28 May 2010 15:36:27 -0700
Message-ID: <201005282236.o4SMaRwq018448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121Ab0E1Wl5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 May 2010 18:41:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, David.Woodhouse@intel.com, davidm@snapgear.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, herbert@gondor.hengli.com.au, jie@codesourcery.com, lethal@linux-sh.org, monstr@monstr.eu, penberg@cs.helsinki.fi, takata@linux-m32r.org, ysato@users.sourceforge.jp


The patch titled
     fs/binfmt_flat.c: tweak default stack alignment
has been added to the -mm tree.  Its filename is
     flat-tweak-default-stack-alignment.patch

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
Subject: fs/binfmt_flat.c: tweak default stack alignment
From: Mike Frysinger <vapier@gentoo.org>

The recent commit 1f0ce8b3dd667dca7 ("mm: Move ARCH_SLAB_MINALIGN and
ARCH_KMALLOC_MINALIGN to <linux/slab_def.h>") which moved the
ARCH_SLAB_MINALIGN default into the global header inadvertently broke FLAT
for a bunch of systems.  Blackfin systems now fail on any FLAT exec with:

Unable to read code+data+bss, errno 14

When your /init is a FLAT binary, obviously this can be annoying ;).

This stems from the alignment usage in the FLAT loader.  The behavior
before was that FLAT would default to ARCH_SLAB_MINALIGN only if it was
defined, and this was only defined by arches when they wanted a larger
alignment value.  Otherwise it'd default to pointer alignment.  Arguably,
this is kind of hokey that the FLAT is semi-abusing defines it shouldn't.

But let's ignore that and simply ignore min alignment values of 0.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: David McCullough <davidm@snapgear.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jie Zhang <jie@codesourcery.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_flat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/binfmt_flat.c~flat-tweak-default-stack-alignment fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~flat-tweak-default-stack-alignment
+++ a/fs/binfmt_flat.c
@@ -68,7 +68,7 @@
  * Here we can be a bit looser than the data sections since this
  * needs to only meet arch ABI requirements.
  */
-#ifdef ARCH_SLAB_MINALIGN
+#if defined(ARCH_SLAB_MINALIGN) && ARCH_SLAB_MINALIGN != 0
 #define FLAT_STACK_ALIGN	(ARCH_SLAB_MINALIGN)
 #else
 #define FLAT_STACK_ALIGN	(sizeof(void *))
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
flat-split-the-stack-data-alignments.patch
flat-tweak-default-stack-alignment.patch

