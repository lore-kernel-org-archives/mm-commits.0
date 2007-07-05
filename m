From: akpm@linux-foundation.org
Subject: + fix-slab-redzone-alignment.patch added to -mm tree
Date: Thu, 05 Jul 2007 14:29:21 -0700
Message-ID: <200707052129.l65LTLCH020717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43807 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760008AbXGEV3j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 17:29:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwmw2@infradead.org, clameter@sgi.com, michal.k.k.piotrowski@gmail.com, penberg@cs.helsinki.fi


The patch titled
     Fix slab redzone alignment
has been added to the -mm tree.  Its filename is
     fix-slab-redzone-alignment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix slab redzone alignment
From: David Woodhouse <dwmw2@infradead.org>

Commit b46b8f19c9cd435ecac4d9d12b39d78c137ecd66 fixed a couple of bugs by
switching the redzone to 64 bits.  Unfortunately, it neglected to ensure
that the _second_ redzone, after the slab object, is aligned correctly. 
This caused illegal instruction faults on sparc32, which for some reason
not entirely clear to me are not trapped and fixed up.

Two things need to be done to fix this:
  - increase the object size, rounding up to alignof(long long) so
    that the second redzone can be aligned correctly.
  - If SLAB_STORE_USER is set but alignof(long long)==8, allow a
    full 64 bits of space for the user word at the end of the buffer,
    even though we may not _use_ the whole 64 bits.

This patch should be a no-op on any 64-bit architecture or any 32-bit
architecture where alignof(long long) == 4. Of the others, it's tested
on ppc32 by myself and a very similar patch was tested on sparc32 by
Mark Fortescue, who reported the new problem.

Also, fix the conditions for FORCED_DEBUG, which hadn't been adjusted to
the new sizes. Again noticed by Mark.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   32 +++++++++++++++++++++++---------
 1 files changed, 23 insertions(+), 9 deletions(-)

diff -puN mm/slab.c~fix-slab-redzone-alignment mm/slab.c
--- a/mm/slab.c~fix-slab-redzone-alignment
+++ a/mm/slab.c
@@ -137,6 +137,7 @@
 
 /* Shouldn't this be in a header file somewhere? */
 #define	BYTES_PER_WORD		sizeof(void *)
+#define	REDZONE_ALIGN		max(BYTES_PER_WORD, __alignof__(unsigned long long))
 
 #ifndef cache_line_size
 #define cache_line_size()	L1_CACHE_BYTES
@@ -547,7 +548,7 @@ static unsigned long long *dbg_redzone2(
 	if (cachep->flags & SLAB_STORE_USER)
 		return (unsigned long long *)(objp + cachep->buffer_size -
 					      sizeof(unsigned long long) -
-					      BYTES_PER_WORD);
+					      REDZONE_ALIGN);
 	return (unsigned long long *) (objp + cachep->buffer_size -
 				       sizeof(unsigned long long));
 }
@@ -2178,7 +2179,8 @@ kmem_cache_create (const char *name, siz
 	 * above the next power of two: caches with object sizes just above a
 	 * power of two have a significant amount of internal fragmentation.
 	 */
-	if (size < 4096 || fls(size - 1) == fls(size-1 + 3 * BYTES_PER_WORD))
+	if (size < 4096 || fls(size - 1) == fls(size-1 + REDZONE_ALIGN +
+						2 * sizeof(unsigned long long)))
 		flags |= SLAB_RED_ZONE | SLAB_STORE_USER;
 	if (!(flags & SLAB_DESTROY_BY_RCU))
 		flags |= SLAB_POISON;
@@ -2219,12 +2221,20 @@ kmem_cache_create (const char *name, siz
 	}
 
 	/*
-	 * Redzoning and user store require word alignment. Note this will be
-	 * overridden by architecture or caller mandated alignment if either
-	 * is greater than BYTES_PER_WORD.
+	 * Redzoning and user store require word alignment or possibly larger.
+	 * Note this will be overridden by architecture or caller mandated
+	 * alignment if either is greater than BYTES_PER_WORD.
 	 */
-	if (flags & SLAB_RED_ZONE || flags & SLAB_STORE_USER)
-		ralign = __alignof__(unsigned long long);
+	if (flags & SLAB_STORE_USER)
+		ralign = BYTES_PER_WORD;
+
+	if (flags & SLAB_RED_ZONE) {
+		ralign = REDZONE_ALIGN;
+		/* If redzoning, ensure that the second redzone is suitably
+		 * aligned, by adjusting the object size accordingly. */
+		size += REDZONE_ALIGN - 1;
+		size &= ~(REDZONE_ALIGN - 1);
+	}
 
 	/* 2) arch mandated alignment */
 	if (ralign < ARCH_SLAB_MINALIGN) {
@@ -2261,9 +2271,13 @@ kmem_cache_create (const char *name, siz
 	}
 	if (flags & SLAB_STORE_USER) {
 		/* user store requires one word storage behind the end of
-		 * the real object.
+		 * the real object. But if the second red zone needs to be
+		 * aligned to 64 bits, we must allow that much space.
 		 */
-		size += BYTES_PER_WORD;
+		if (flags & SLAB_RED_ZONE)
+			size += REDZONE_ALIGN;
+		else
+			size += BYTES_PER_WORD;
 	}
 #if FORCED_DEBUG && defined(CONFIG_DEBUG_PAGEALLOC)
 	if (size >= malloc_sizes[INDEX_L3 + 1].cs_size
_

Patches currently in -mm which might be from dwmw2@infradead.org are

x86_64-fix-headers_install.patch
fix-slab-redzone-alignment.patch
git-powerpc.patch
powerpc-enable-arbitary-speed-tty-ioctls-and-split.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
git-ubi.patch
git-battery.patch
git-nfs.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used-fix.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used-fix-fix.patch
jffs2-convert-to-new-aops.patch
char-n_r3964-use-wait_event_interruptible.patch
introduce-compat_u64-and-compat_s64-types.patch
gitignore-update.patch
mismatching-declarations-of-revision-strings-in-hisax.patch
