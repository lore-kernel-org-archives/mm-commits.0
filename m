From: akpm@linux-foundation.org
Subject: [merged] crc32-removed-two-instances-of-trailing-whitespaces.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:30:36 -0700
Message-ID: <20120326193036.87FADA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:35450 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab2CZTah (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:30:37 -0400
Received: by mail-vx0-f202.google.com with SMTP id fk26so831445vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:30:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpearson@systemfabricworks.com, djwong@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: crc32: remove two instances of trailing whitespaces
has been removed from the -mm tree.  Its filename was
     crc32-removed-two-instances-of-trailing-whitespaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bob Pearson <rpearson@systemfabricworks.com>
Subject: crc32: remove two instances of trailing whitespaces

This patchset (re)uses Bob Pearson's crc32 slice-by-8 code to stamp out a
software crc32c implementation.  It removes the crc32c implementation in
crypto/ in favor of using the stamped-out one in lib/.  There is also a
change to Kconfig so that the kernel builder can pick an implementation
best suited for the hardware.

The motivation for this patchset is that I am working on adding full
metadata checksumming to ext4.  As far as performance impact of adding
checksumming goes, I see nearly no change with a standard mail server ffsb
simulation.  On a test that involves only file creation and deletion and
extent tree writes, I see a drop of about 50 pcercent with the current
kernel crc32c implementation; this improves to a drop of about 20 percent
with the enclosed crc32c code.

When metadata is usually a small fraction of total IO, this new
implementation doesn't help much because metadata is usually a small
fraction of total IO.  However, when we are doing IO that is almost all
metadata (such as rm -rf'ing a tree), then this patch speeds up the
operation substantially.

Incidentally, given that iscsi, sctp, and btrfs also use crc32c, this
patchset should improve their speed as well.  I have not yet quantified
that, however.  This latest submission combines Bob's patches from late
August 2011 with mine so that they can be one coherent patch set.  Please
excuse my inability to combine some of the patches; I've been advised to
leave Bob's patches alone and build atop them instead.  :/

Since the last posting, I've also collected some crc32c test results on a
bunch of different x86/powerpc/sparc platforms.  The results can be viewed
here: http://goo.gl/sgt3i ; the "crc32-kern-le" and "crc32c" columns
describe the performance of the kernel's current crc32 and crc32c software
implementations.  The "crc32c-by8-le" column shows crc32c performance with
this patchset applied.  I expect crc32 performance to be roughly the same.

The two _boost columns at the right side of the spreadsheet shows how much
faster the new implementation is over the old one.  As you can see, crc32
rises substantially, and crc32c experiences a huge increase.


This patch:

- remove trailing whitespace from lib/crc32.c
- remove trailing whitespace from lib/crc32defs.h

[djwong@us.ibm.com: changelog tweaks]
Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c     |    2 +-
 lib/crc32defs.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/crc32.c~crc32-removed-two-instances-of-trailing-whitespaces lib/crc32.c
--- a/lib/crc32.c~crc32-removed-two-instances-of-trailing-whitespaces
+++ a/lib/crc32.c
@@ -317,7 +317,7 @@ EXPORT_SYMBOL(crc32_be);
  * in the correct multiple to subtract, we can shift a byte at a time.
  * This produces a 40-bit (rather than a 33-bit) intermediate remainder,
  * but again the multiple of the polynomial to subtract depends only on
- * the high bits, the high 8 bits in this case.  
+ * the high bits, the high 8 bits in this case.
  *
  * The multiple we need in that case is the low 32 bits of a 40-bit
  * value whose high 8 bits are given, and which is a multiple of the
diff -puN lib/crc32defs.h~crc32-removed-two-instances-of-trailing-whitespaces lib/crc32defs.h
--- a/lib/crc32defs.h~crc32-removed-two-instances-of-trailing-whitespaces
+++ a/lib/crc32defs.h
@@ -8,7 +8,7 @@
 
 /* How many bits at a time to use.  Requires a table of 4<<CRC_xx_BITS bytes. */
 /* For less performance-sensitive, use 4 */
-#ifndef CRC_LE_BITS 
+#ifndef CRC_LE_BITS
 # define CRC_LE_BITS 8
 #endif
 #ifndef CRC_BE_BITS
_

Patches currently in -mm which might be from rpearson@systemfabricworks.com are

origin.patch

