From: akpm@linux-foundation.org
Subject: + alpha-strncpy-strncat-fixes.patch added to -mm tree
Date: Tue, 11 Dec 2007 12:44:18 -0800
Message-ID: <200712112044.lBBKiIrE008144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35379 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752174AbXLKUpY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 15:45:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, kay.sievers@vrfy.org, mcree@orcon.net.nz, rct@frus.com, rjw@sisk.pl, rth@twiddle.net


The patch titled
     alpha: strncpy/strncat fixes
has been added to the -mm tree.  Its filename is
     alpha-strncpy-strncat-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: alpha: strncpy/strncat fixes
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

First of all, thanks to Bob Tracy <rct@frus.com> and
Michael Cree <mcree@orcon.net.nz> for testing.
Especially to Bob, as he has done titanic multi-day git-bisect
work that finally helped to reproduce and nail down the bug
(http://bugzilla.kernel.org/show_bug.cgi?id=9457).

[ev6-]stxncpy.S: it's t12, not t2 register that is supposed to contain
the last byte offset upon return. As a result of wrong register use
(which was my fault back in 2003, IIRC), under some circumstances extra
terminating zero bytes were added to destination string. This particularly
led to incorrect DEVPATH strings generated in uevent and therefore to udev
problems.

strncpy.S: unrelated bug I found while testing the above fix - destination
is not properly zero-padded then a byte count exceeds source length.
Actually this is addition to strncpy fix from last year.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Bob Tracy <rct@frus.com>
Cc: Michael Cree <mcree@orcon.net.nz>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/lib/ev6-stxncpy.S |   14 +++++++-------
 arch/alpha/lib/strncpy.S     |    2 +-
 arch/alpha/lib/stxncpy.S     |   14 +++++++-------
 3 files changed, 15 insertions(+), 15 deletions(-)

diff -puN arch/alpha/lib/ev6-stxncpy.S~alpha-strncpy-strncat-fixes arch/alpha/lib/ev6-stxncpy.S
--- a/arch/alpha/lib/ev6-stxncpy.S~alpha-strncpy-strncat-fixes
+++ a/arch/alpha/lib/ev6-stxncpy.S
@@ -362,10 +362,10 @@ $unaligned:
 
 	extql	t2, a1, t2	# U :
 	cmpbge	zero, t1, t8	# E : is there a zero?
-	andnot	t2, t6, t12	# E : dest mask for a single word copy
+	andnot	t2, t6, t2	# E : dest mask for a single word copy
 	or	t8, t10, t5	# E : test for end-of-count too
 
-	cmpbge	zero, t12, t3	# E :
+	cmpbge	zero, t2, t3	# E :
 	cmoveq	a2, t5, t8	# E : Latency=2, extra map slot
 	nop			# E : keep with cmoveq
 	andnot	t8, t3, t8	# E : (stall)
@@ -379,13 +379,13 @@ $unaligned:
 	negq	t8, t6		# E : build bitmask of bytes <= zero
 	mskqh	t1, t4, t1	# U :
 
-	and	t6, t8, t2	# E :
-	subq	t2, 1, t6	# E : (stall)
-	or	t6, t2, t8	# E : (stall)
-	zapnot	t12, t8, t12	# U : prepare source word; mirror changes (stall)
+	and	t6, t8, t12	# E :
+	subq	t12, 1, t6	# E : (stall)
+	or	t6, t12, t8	# E : (stall)
+	zapnot	t2, t8, t2	# U : prepare source word; mirror changes (stall)
 
 	zapnot	t1, t8, t1	# U : to source validity mask
-	andnot	t0, t12, t0	# E : zero place for source to reside
+	andnot	t0, t2, t0	# E : zero place for source to reside
 	or	t0, t1, t0	# E : and put it there (stall both t0, t1)
 	stq_u	t0, 0(a0)	# L : (stall)
 
diff -puN arch/alpha/lib/strncpy.S~alpha-strncpy-strncat-fixes arch/alpha/lib/strncpy.S
--- a/arch/alpha/lib/strncpy.S~alpha-strncpy-strncat-fixes
+++ a/arch/alpha/lib/strncpy.S
@@ -35,7 +35,7 @@ strncpy:
 
 	or	$3, $24, $3	# clear the bits between the last
 	or	$4, $27, $4	# written byte and the last byte in COUNT
-	andnot	$4, $3, $4
+	andnot	$3, $4, $4
 	zap	$1, $4, $1
 
 	stq_u	$1, 0($16)
diff -puN arch/alpha/lib/stxncpy.S~alpha-strncpy-strncat-fixes arch/alpha/lib/stxncpy.S
--- a/arch/alpha/lib/stxncpy.S~alpha-strncpy-strncat-fixes
+++ a/arch/alpha/lib/stxncpy.S
@@ -315,9 +315,9 @@ $unaligned:
 
 	extql	t2, a1, t2	# e0    :
 	cmpbge	zero, t1, t8	# .. e1 : is there a zero?
-	andnot	t2, t6, t12	# e0    : dest mask for a single word copy
+	andnot	t2, t6, t2	# e0    : dest mask for a single word copy
 	or	t8, t10, t5	# .. e1 : test for end-of-count too
-	cmpbge	zero, t12, t3	# e0    :
+	cmpbge	zero, t2, t3	# e0    :
 	cmoveq	a2, t5, t8	# .. e1 :
 	andnot	t8, t3, t8	# e0    :
 	beq	t8, $u_head	# .. e1 (zdb)
@@ -330,14 +330,14 @@ $unaligned:
 	ldq_u	t0, 0(a0)	# e0    :
 	negq	t8, t6		# .. e1 : build bitmask of bytes <= zero
 	mskqh	t1, t4, t1	# e0    :
-	and	t6, t8, t2	# .. e1 :
-	subq	t2, 1, t6	# e0    :
-	or	t6, t2, t8	# e1    :
+	and	t6, t8, t12	# .. e1 :
+	subq	t12, 1, t6	# e0    :
+	or	t6, t12, t8	# e1    :
 
-	zapnot	t12, t8, t12	# e0    : prepare source word; mirror changes
+	zapnot	t2, t8, t2	# e0    : prepare source word; mirror changes
 	zapnot	t1, t8, t1	# .. e1 : to source validity mask
 
-	andnot	t0, t12, t0	# e0    : zero place for source to reside
+	andnot	t0, t2, t0	# e0    : zero place for source to reside
 	or	t0, t1, t0	# e1    : and put it there
 	stq_u	t0, 0(a0)	# e0    :
 	ret	(t9)		# .. e1 :
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

alpha-strncpy-strncat-fixes.patch
iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits.patch
arch-alpha-removed-duplicate-includes.patch
alpha-atomic_add_return-should-return-int.patch
alpha-kill-deprecated-virt_to_bus.patch
alpha-doesnt-use-socketcall.patch
agp-alpha-nopage.patch
alpha-parisc-removing-config-variable-debug_rwlock.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg64-and-cmpxchg64_local-to-alpha.patch
make-sure-nobodys-leaking-resources.patch
