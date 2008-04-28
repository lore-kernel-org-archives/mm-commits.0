From: akpm@linux-foundation.org
Subject: - remove-sparse-warning-for-mmzoneh.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:50:40 -0700
Message-ID: <200804282150.m3SLoeGW017494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934614AbYD1Vum (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:50:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     remove sparse warning for mmzone.h
has been removed from the -mm tree.  Its filename was
     remove-sparse-warning-for-mmzoneh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: coding-style fixes]
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
+		zone_movable_is_highmem());
 #else
 	return 0;
 #endif
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
power-replace-remaining-__function__-occurrences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
kernel-add-common-infrastructure-for-unaligned-access.patch
kernel-move-arches-to-use-common-unaligned-access.patch
drivers-block-use-get_unaligned_-helpers.patch
hid-core-use-get_unaligned_-helpers.patch
char-use-get_unaligned_-helpers.patch
input-use-get_unaligned_-helpers.patch
mmc-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
pcmcia-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch
video-use-get-put_unaligned_-helpers.patch
fat-use-get-put_unaligned_-helpers.patch
hfsplus-use-get-put_unaligned_-helpers.patch
isofs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

