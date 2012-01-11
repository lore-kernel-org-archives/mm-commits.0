From: akpm@linux-foundation.org
Subject: [merged] fadvise-only-initiate-writeback-for-specified-range-with-fadv_dontneed.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:27:07 -0800
Message-ID: <20120111212707.A06EF1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:58611 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933502Ab2AKV1I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:27:08 -0500
Received: by mail-yw0-f74.google.com with SMTP id p56so153744yhp.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:27:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sbohrer@rgmadvisors.com, jweiner@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fadvise: only initiate writeback for specified range with FADV_DONTNEED
has been removed from the -mm tree.  Its filename was
     fadvise-only-initiate-writeback-for-specified-range-with-fadv_dontneed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: fadvise: only initiate writeback for specified range with FADV_DONTNEED

Previously POSIX_FADV_DONTNEED would start writeback for the entire file
when the bdi was not write congested.  This negatively impacts performance
if the file contians dirty pages outside of the requested range.  This
change uses __filemap_fdatawrite_range() to only initiate writeback for
the requested range.

Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
Acked-by: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/fadvise.c~fadvise-only-initiate-writeback-for-specified-range-with-fadv_dontneed mm/fadvise.c
--- a/mm/fadvise.c~fadvise-only-initiate-writeback-for-specified-range-with-fadv_dontneed
+++ a/mm/fadvise.c
@@ -117,7 +117,8 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
 		break;
 	case POSIX_FADV_DONTNEED:
 		if (!bdi_write_congested(mapping->backing_dev_info))
-			filemap_flush(mapping);
+			__filemap_fdatawrite_range(mapping, offset, endbyte,
+						   WB_SYNC_NONE);
 
 		/* First and last FULL page! */
 		start_index = (offset+(PAGE_CACHE_SIZE-1)) >> PAGE_CACHE_SHIFT;
_

Patches currently in -mm which might be from sbohrer@rgmadvisors.com are

origin.patch

