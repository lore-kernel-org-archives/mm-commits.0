From: akpm@linux-foundation.org
Subject: + flat-tweak-default-stack-alignment.patch added to -mm tree
Date: Mon, 07 Jun 2010 16:39:55 -0700
Message-ID: <201006072339.o57Ndt8F002197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894Ab0FGXop (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jun 2010 19:44:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, David.Woodhouse@intel.com, davidm@snapgear.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, lethal@linux-sh.org, monstr@monstr.eu, penberg@cs.helsinki.fi, takata@linux-m32r.org


The patch titled
     flat: tweak default stack alignment
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
Subject: flat: tweak default stack alignment
From: Mike Frysinger <vapier@gentoo.org>

The recent commit 1f0ce8b3dd667dca7 ("mm: Move ARCH_SLAB_MINALIGN and
ARCH_KMALLOC_MINALIGN to <linux/slab_def.h>") which moved the
ARCH_SLAB_MINALIGN default into the global header inadvertently broke FLAT
for a bunch of systems.  Blackfin systems now fail on any FLAT exec with:
Unable to read code+data+bss, errno 14 When your /init is a FLAT binary,
obviously this can be annoying ;).

This stems from the alignment usage in the FLAT loader.  The behavior
before was that FLAT would default to ARCH_SLAB_MINALIGN only if it was
defined, and this was only defined by arches when they wanted a larger
alignment value.  Otherwise it'd default to pointer alignment.  Arguably,
this is kind of hokey that the FLAT is semi-abusing defines it shouldn't.

So let's merge the two alignment requirements so the floor is never 0.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: David McCullough <davidm@snapgear.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_flat.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN fs/binfmt_flat.c~flat-tweak-default-stack-alignment fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~flat-tweak-default-stack-alignment
+++ a/fs/binfmt_flat.c
@@ -68,11 +68,7 @@
  * Here we can be a bit looser than the data sections since this
  * needs to only meet arch ABI requirements.
  */
-#ifdef ARCH_SLAB_MINALIGN
-#define FLAT_STACK_ALIGN	(ARCH_SLAB_MINALIGN)
-#else
-#define FLAT_STACK_ALIGN	(sizeof(void *))
-#endif
+#define FLAT_STACK_ALIGN	max_t(unsigned long, sizeof(void *), ARCH_SLAB_MINALIGN)
 
 #define RELOC_FAILED 0xff00ff01		/* Relocation incorrect somewhere */
 #define UNLOADED_LIB 0x7ff000ff		/* Placeholder for unused library */
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
nommu-add-label-to-proc-pid-maps-output.patch
flat-tweak-default-stack-alignment.patch
asm-generic-ioh-add-big-endian-versions-of-ioreadwrite1632.patch

