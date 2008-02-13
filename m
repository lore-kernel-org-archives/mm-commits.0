From: akpm@linux-foundation.org
Subject: + remove-sparse-warning-for-mmzoneh.patch added to -mm tree
Date: Wed, 13 Feb 2008 15:10:21 -0800
Message-ID: <200802132310.m1DNAMVA018812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50089 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbYBMXK4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 18:10:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     remove sparse warning for mmzone.h
has been added to the -mm tree.  Its filename is
     remove-sparse-warning-for-mmzoneh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove sparse warning for mmzone.h
From: Harvey Harrison <harvey.harrison@gmail.com>

include/linux/mmzone.h:640:22: warning: potentially expensive pointer subtraction

Calculate the offset into the node_zones array rather than the index
using casts to (char *) and comparing against the index * sizeof(struct zone).

On X86_32 this saves a sar, but code size increases by one byte per
is_highmem() use due to 32-bit cmps rather than 16 bit cmps.

Before:
 207:   2b 80 8c 07 00 00       sub    0x78c(%eax),%eax
 20d:   c1 f8 0b                sar    $0xb,%eax
 210:   83 f8 02                cmp    $0x2,%eax
 213:   74 16                   je     22b <kmap_atomic_prot+0x144>
 215:   83 f8 03                cmp    $0x3,%eax
 218:   0f 85 8f 00 00 00       jne    2ad <kmap_atomic_prot+0x1c6>
 21e:   83 3d 00 00 00 00 02    cmpl   $0x2,0x0
 225:   0f 85 82 00 00 00       jne    2ad <kmap_atomic_prot+0x1c6>
 22b:   64 a1 00 00 00 00       mov    %fs:0x0,%eax

After:
 207:   2b 80 8c 07 00 00       sub    0x78c(%eax),%eax
 20d:   3d 00 10 00 00          cmp    $0x1000,%eax
 212:   74 18                   je     22c <kmap_atomic_prot+0x145>
 214:   3d 00 18 00 00          cmp    $0x1800,%eax
 219:   0f 85 8f 00 00 00       jne    2ae <kmap_atomic_prot+0x1c7>
 21f:   83 3d 00 00 00 00 02    cmpl   $0x2,0x0
 226:   0f 85 82 00 00 00       jne    2ae <kmap_atomic_prot+0x1c7>
 22c:   64 a1 00 00 00 00       mov    %fs:0x0,%eax

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN include/linux/mmzone.h~remove-sparse-warning-for-mmzoneh include/linux/mmzone.h
--- a/include/linux/mmzone.h~remove-sparse-warning-for-mmzoneh
+++ a/include/linux/mmzone.h
@@ -637,9 +637,10 @@ static inline int is_normal_idx(enum zon
 static inline int is_highmem(struct zone *zone)
 {
 #ifdef CONFIG_HIGHMEM
-	int zone_idx = zone - zone->zone_pgdat->node_zones;
-	return zone_idx == ZONE_HIGHMEM ||
-		(zone_idx == ZONE_MOVABLE && zone_movable_is_highmem());
+	int zone_off = (char *)zone - (char *)zone->zone_pgdat->node_zones;
+	return zone_off == ZONE_HIGHMEM * sizeof(*zone) ||
+	       (zone_off == ZONE_MOVABLE * sizeof(*zone) &&
+	        zone_movable_is_highmem());
 #else
 	return 0;
 #endif
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
include-linux-remove-all-users-of-fastcall-macro.patch
rcupdate-fix-comment.patch
remove-final-fastcall-users.patch
final-removal-of-fastcall-fastcall.patch
git-x86.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
remove-sparse-warning-for-mmzoneh.patch
