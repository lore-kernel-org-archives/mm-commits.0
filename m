From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch removed
 from -mm tree
Date: Wed, 31 Jan 2018 15:59:08 -0800
Message-ID: <5a72584c.zBa+90IgYrtJISCr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57696 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbeAaX7K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 18:59:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jinli.zjl@alibaba-inc.com, mgorman@techsingularity.net, shidao.ytt@alibaba-inc.com, zhiche.yy@alibaba-inc.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix
has been removed from the -mm tree.  Its filename was
     mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch

This patch was dropped because it was folded into mm-fadvise-discard-partial-page-if-endbyte-is-also-eof.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix

tweak code comment

Cc: Caspar Zhang <jinli.zjl@alibaba-inc.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Oliver Yang <zhiche.yy@alibaba-inc.com>
Cc: shidao.ytt <shidao.ytt@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/fadvise.c~mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix mm/fadvise.c
--- a/mm/fadvise.c~mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix
+++ a/mm/fadvise.c
@@ -128,12 +128,11 @@ SYSCALL_DEFINE4(fadvise64_64, int, fd, l
 		start_index = (offset+(PAGE_SIZE-1)) >> PAGE_SHIFT;
 		end_index = (endbyte >> PAGE_SHIFT);
 		/*
-		 * page at end_index will be inclusively discarded according
-		 * to invalidate_mapping_pages() implementation, thus, minus
-		 * end_index by 1 means we would skip the last page.
-		 * Yet, if endbyte is page-aligned, or it is at the end of
-		 * file, we should not skip, discarding the last page is just
-		 * safe enough.
+		 * The page at end_index will be inclusively discarded according
+		 * by invalidate_mapping_pages(), so subtracting 1 from
+		 * end_index means we will skip the last page.  But if endbyte
+		 * is page aligned or is at the end of file, we should not skip
+		 * that page - discarding the last page is safe enough.
 		 */
 		if ((endbyte & ~PAGE_MASK) != ~PAGE_MASK &&
 				endbyte != inode->i_size - 1) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof.patch
mm-page_owner-clean-up-init_pages_in_zone-v3-fix.patch
tools-vm-new-option-to-specify-kpageflags-file-fix.patch

