From: akpm@linux-foundation.org
Subject: + mtd-nand_base-fix-kernel-doc-warnings-typos.patch added to -mm tree
Date: Thu, 27 May 2010 13:05:07 -0700
Message-ID: <201005272005.o4RK58eU011380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754897Ab0E0UFR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 May 2010 16:05:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, dwmw2@infradead.org


The patch titled
     mtd/nand_base: fix kernel-doc warnings & typos
has been added to the -mm tree.  Its filename is
     mtd-nand_base-fix-kernel-doc-warnings-typos.patch

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
Subject: mtd/nand_base: fix kernel-doc warnings & typos
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix mtd/nand_base.c kernel-doc warnings and typos.

Warning(drivers/mtd/nand/nand_base.c:893): No description found for parameter 'mtd'
Warning(drivers/mtd/nand/nand_base.c:893): No description found for parameter 'ofs'
Warning(drivers/mtd/nand/nand_base.c:893): No description found for parameter 'len'
Warning(drivers/mtd/nand/nand_base.c:893): No description found for parameter 'invert'
Warning(drivers/mtd/nand/nand_base.c:930): No description found for parameter 'mtd'
Warning(drivers/mtd/nand/nand_base.c:930): No description found for parameter 'ofs'
Warning(drivers/mtd/nand/nand_base.c:930): No description found for parameter 'len'
Warning(drivers/mtd/nand/nand_base.c:987): No description found for parameter 'mtd'
Warning(drivers/mtd/nand/nand_base.c:987): No description found for parameter 'ofs'
Warning(drivers/mtd/nand/nand_base.c:987): No description found for parameter 'len'
Warning(drivers/mtd/nand/nand_base.c:2087): No description found for parameter 'len'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/nand_base.c |   39 ++++++++++++++++-----------------
 scripts/kernel-doc           |    2 +
 2 files changed, 22 insertions(+), 19 deletions(-)

diff -puN drivers/mtd/nand/nand_base.c~mtd-nand_base-fix-kernel-doc-warnings-typos drivers/mtd/nand/nand_base.c
--- a/drivers/mtd/nand/nand_base.c~mtd-nand_base-fix-kernel-doc-warnings-typos
+++ a/drivers/mtd/nand/nand_base.c
@@ -876,17 +876,17 @@ static int nand_wait(struct mtd_info *mt
 }
 
 /**
- * __nand_unlock - [REPLACABLE] unlocks specified locked blockes
+ * __nand_unlock - [REPLACEABLE] unlocks specified locked blocks
  *
- * @param mtd - mtd info
- * @param ofs - offset to start unlock from
- * @param len - length to unlock
- * @invert -  when = 0, unlock the range of blocks within the lower and
+ * @mtd: mtd info
+ * @ofs: offset to start unlock from
+ * @len: length to unlock
+ * @invert:   when = 0, unlock the range of blocks within the lower and
  *                      upper boundary address
- *            whne = 1, unlock the range of blocks outside the boundaries
+ *            when = 1, unlock the range of blocks outside the boundaries
  *                      of the lower and upper boundary address
  *
- * @return - unlock status
+ * return - unlock status
  */
 static int __nand_unlock(struct mtd_info *mtd, loff_t ofs,
 					uint64_t len, int invert)
@@ -918,13 +918,13 @@ static int __nand_unlock(struct mtd_info
 }
 
 /**
- * nand_unlock - [REPLACABLE] unlocks specified locked blockes
+ * nand_unlock - [REPLACEABLE] unlocks specified locked blocks
  *
- * @param mtd - mtd info
- * @param ofs - offset to start unlock from
- * @param len - length to unlock
+ * @mtd: mtd info
+ * @ofs: offset to start unlock from
+ * @len: length to unlock
  *
- * @return - unlock status
+ * return - unlock status
  */
 int nand_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 {
@@ -969,16 +969,16 @@ out:
 }
 
 /**
- * nand_lock - [REPLACABLE] locks all blockes present in the device
+ * nand_lock - [REPLACEABLE] locks all blocks present in the device
  *
- * @param mtd - mtd info
- * @param ofs - offset to start unlock from
- * @param len - length to unlock
+ * @mtd: mtd info
+ * @ofs: offset to start unlock from
+ * @len: length to unlock
  *
- * @return - lock status
+ * return - lock status
  *
- * This feature is not support in many NAND parts. 'Micron' NAND parts
- * do have this feature, but it allows only to lock all blocks not for
+ * This feature is not supported in many NAND parts. 'Micron' NAND parts
+ * do have this feature, but it allows only to lock all blocks, not for
  * specified range for block.
  *
  * Implementing 'lock' feature by making use of 'unlock', for now.
@@ -2080,6 +2080,7 @@ static int nand_write_page(struct mtd_in
  * nand_fill_oob - [Internal] Transfer client buffer to oob
  * @chip:	nand chip structure
  * @oob:	oob data buffer
+ * @len:	oob data write length
  * @ops:	oob ops structure
  */
 static uint8_t *nand_fill_oob(struct nand_chip *chip, uint8_t *oob, size_t len,
diff -puN scripts/kernel-doc~mtd-nand_base-fix-kernel-doc-warnings-typos scripts/kernel-doc
--- a/scripts/kernel-doc~mtd-nand_base-fix-kernel-doc-warnings-typos
+++ a/scripts/kernel-doc
@@ -1454,6 +1454,8 @@ sub dump_enum($$) {
     my $file = shift;
 
     $x =~ s@/\*.*?\*/@@gos;	# strip comments.
+    $x =~ s/^#\s*define\s+.*$//; # strip #define macros inside enums
+
     if ($x =~ /enum\s+(\w+)\s*{(.*)}/) {
 	$declaration_name = $1;
 	my $members = $2;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
documentation-submittingdrivers-resources.patch
memcg-update-documentation-v8.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
linux-next.patch
compal-laptop-uses-hwmon-interfaces-depends-on-hwmon.patch
dib3000mc-reduce-large-stack-usage-fix.patch
media-ak881x-needs-slabh.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
scsi-fix-pmcraid-build-errors.patch
scsi-fix-be2iscsi-build.patch
scsi-fix-bnx2i-build-errors.patch
virtio_9ph-include-linux-typesh.patch
fusion-fix-kernel-doc-warnings.patch
fs-super-fix-kernel-doc-warning.patch
timerc-fix-kernel-doc-warning.patch
mtd-nand_base-fix-kernel-doc-warnings-typos.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

