From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-micro-optimize-zs_object_copy.patch removed
 from -mm tree
Date: Thu, 16 Apr 2015 09:54:00 -0700
Message-ID: <552fe928.ae0oRreTFWz0p40i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbbDPQsb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:48:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: micro-optimize zs_object_copy()
has been removed from the -mm tree.  Its filename was
     zsmalloc-micro-optimize-zs_object_copy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc: micro-optimize zs_object_copy()

A micro-optimization.  Avoid additional branching and reduce (a bit)
registry pressure (f.e.  s_off += size; d_off += size; may be calculated
twise: first for >= PAGE_SIZE check and later for offset update in "else"
clause).

scripts/bloat-o-meter shows some improvement

add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-10 (-10)
function                          old     new   delta
zs_object_copy                    550     540     -10

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-micro-optimize-zs_object_copy mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-micro-optimize-zs_object_copy
+++ a/mm/zsmalloc.c
@@ -1537,7 +1537,12 @@ static void zs_object_copy(unsigned long
 		if (written == class->size)
 			break;
 
-		if (s_off + size >= PAGE_SIZE) {
+		s_off += size;
+		s_size -= size;
+		d_off += size;
+		d_size -= size;
+
+		if (s_off >= PAGE_SIZE) {
 			kunmap_atomic(d_addr);
 			kunmap_atomic(s_addr);
 			s_page = get_next_page(s_page);
@@ -1546,21 +1551,15 @@ static void zs_object_copy(unsigned long
 			d_addr = kmap_atomic(d_page);
 			s_size = class->size - written;
 			s_off = 0;
-		} else {
-			s_off += size;
-			s_size -= size;
 		}
 
-		if (d_off + size >= PAGE_SIZE) {
+		if (d_off >= PAGE_SIZE) {
 			kunmap_atomic(d_addr);
 			d_page = get_next_page(d_page);
 			BUG_ON(!d_page);
 			d_addr = kmap_atomic(d_page);
 			d_size = class->size - written;
 			d_off = 0;
-		} else {
-			d_off += size;
-			d_size -= size;
 		}
 	}
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch
zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
zram-use-idr-instead-of-zram_devices-array.patch
zram-factor-out-device-reset-from-reset_store.patch
zram-reorganize-code-layout.patch
zram-add-dynamic-device-add-remove-functionality.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-value-from-zram_add.patch
zram-introduce-automatic-device_id-generation.patch
zram-introduce-automatic-device_id-generation-fix.patch
zram-do-not-let-user-enforce-new-device-dev_id.patch
cpumask-dont-perform-while-loop-in-cpumask_next_and.patch

