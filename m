From: akpm@linux-foundation.org
Subject: [merged]
 bitmap-fix-undefined-shift-in-__bitmap_shift_leftright.patch removed from
 -mm tree
Date: Thu, 30 Oct 2014 13:27:43 -0700
Message-ID: <54529f3f.Gc/MkKK8TLI7iHiC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161185AbaJ3U1m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Oct 2014 16:27:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, linux@rasmusvillemoes.dk, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: fix undefined shift in __bitmap_shift_{left|right}()
has been removed from the -mm tree.  Its filename was
     bitmap-fix-undefined-shift-in-__bitmap_shift_leftright.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: lib/bitmap.c: fix undefined shift in __bitmap_shift_{left|right}()

If __bitmap_shift_left() or __bitmap_shift_right() are asked to shift by a
multiple of BITS_PER_LONG, they will try to shift a long value by
BITS_PER_LONG bits which is undefined.  Change the functions to avoid the
undefined shift.

Coverity id: 1192175
Coverity id: 1192174

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN lib/bitmap.c~bitmap-fix-undefined-shift-in-__bitmap_shift_leftright lib/bitmap.c
--- a/lib/bitmap.c~bitmap-fix-undefined-shift-in-__bitmap_shift_leftright
+++ a/lib/bitmap.c
@@ -131,7 +131,9 @@ void __bitmap_shift_right(unsigned long
 		lower = src[off + k];
 		if (left && off + k == lim - 1)
 			lower &= mask;
-		dst[k] = upper << (BITS_PER_LONG - rem) | lower >> rem;
+		dst[k] = lower >> rem;
+		if (rem)
+			dst[k] |= upper << (BITS_PER_LONG - rem);
 		if (left && k == lim - 1)
 			dst[k] &= mask;
 	}
@@ -172,7 +174,9 @@ void __bitmap_shift_left(unsigned long *
 		upper = src[k];
 		if (left && k == lim - 1)
 			upper &= (1UL << left) - 1;
-		dst[k + off] = lower  >> (BITS_PER_LONG - rem) | upper << rem;
+		dst[k + off] = upper << rem;
+		if (rem)
+			dst[k + off] |= lower >> (BITS_PER_LONG - rem);
 		if (left && k + off == lim - 1)
 			dst[k + off] &= (1UL << left) - 1;
 	}
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fallocate-create-fan_modify-and-in_modify-events.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-fix-xattr-check-in-ocfs2_get_xattr_nolock.patch
ocfs2-remove-bogus-test-from-ocfs2_read_locked_inode.patch
ocfs2-report-error-from-o2hb_do_disk_heartbeat-to-user.patch
ocfs2-remove-pointless-assignment-in-ocfs2_init.patch
char_dev-remove-pointless-assignment-from-__register_chrdev_region.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
ncpfs-return-proper-error-from-ncp_ioc_setroot-ioctl.patch
befs-remove-dead-code.patch
linux-next.patch
mm-add-strictlimit-knob-v2.patch

