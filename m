From: akpm@linux-foundation.org
Subject: [withdrawn] nvdimm-avoid-bogus-wmaybe-uninitialized-warning.patch removed from -mm tree
Date: Wed, 02 Aug 2017 15:29:12 -0700
Message-ID: <59825238.DMRQiic6/zATGBws%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49302 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdHBW3N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 18:29:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, dan.j.williams@intel.com, hch@infradead.org, jthumshirn@suse.de, toshi.kani@hpe.com, vishal.l.verma@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nvdimm: avoid bogus -Wmaybe-uninitialized warning
has been removed from the -mm tree.  Its filename was
     nvdimm-avoid-bogus-wmaybe-uninitialized-warning.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: nvdimm: avoid bogus -Wmaybe-uninitialized warning

Removing the btt_rw_page/pmem_rw_page functions has a surprising
side-effect of introducing a false-positive warning in another function,
due to changed inlining decisions in gcc:

In file included from drivers/nvdimm/pmem.c:36:0:
drivers/nvdimm/pmem.c: In function 'pmem_make_request':
drivers/nvdimm/nd.h:407:2: error: 'start' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/nvdimm/pmem.c:174:16: note: 'start' was declared here
In file included from drivers/nvdimm/btt.c:27:0:
drivers/nvdimm/btt.c: In function 'btt_make_request':
drivers/nvdimm/nd.h:407:2: error: 'start' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/nvdimm/btt.c:1202:16: note: 'start' was declared here

The problem is that gcc fails to track the value of the 'do_acct' variable
here and has to read it back from stack, but it does remember that 'start'
may be uninitialized sometimes.

This shuts up the warning by making nd_iostat_start() always initialize
the 'start' variable.  In those cases that gcc successfully tracks the
state of the variable, this will have no effect.

[akpm@linux-foundation.org: add comment]
Link: http://lkml.kernel.org/r/20170801114926.1171418-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvdimm/nd.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/nvdimm/nd.h~nvdimm-avoid-bogus-wmaybe-uninitialized-warning drivers/nvdimm/nd.h
--- a/drivers/nvdimm/nd.h~nvdimm-avoid-bogus-wmaybe-uninitialized-warning
+++ a/drivers/nvdimm/nd.h
@@ -392,8 +392,10 @@ static inline bool nd_iostat_start(struc
 {
 	struct gendisk *disk = bio->bi_bdev->bd_disk;
 
-	if (!blk_queue_io_stat(disk->queue))
+	if (!blk_queue_io_stat(disk->queue)) {
+		*start = 0;	/* Suppress bogus warning */
 		return false;
+	}
 
 	*start = jiffies;
 	generic_start_io_acct(bio_data_dir(bio),
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-avoid-wmaybe-uninitialized-warning-v3.patch
adfs-use-unsigned-types-for-memcpy-length.patch
fs-proc-remove-priv-argument-from-is_stack-fix.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch
iopoll-avoid-wint-in-bool-context-warning.patch
kbuild-use-fshort-wchar-globally.patch

