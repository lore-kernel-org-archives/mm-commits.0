From: akpm@linux-foundation.org
Subject: + fadvise-only-initiate-writeback-for-specified-range-with-fadv_dontneed.patch added to -mm tree
Date: Tue, 22 Nov 2011 15:44:49 -0800
Message-ID: <201111222344.pAMNinDx015393@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:46138 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab1KVXow (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 18:44:52 -0500
Received: by vcbfo14 with SMTP id fo14so146898vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 15:44:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sbohrer@rgmadvisors.com, jweiner@redhat.com


The patch titled
     Subject: fadvise: only initiate writeback for specified range with FADV_DONTNEED
has been added to the -mm tree.  Its filename is
     fadvise-only-initiate-writeback-for-specified-range-with-fadv_dontneed.patch

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
Subject: Subject: fadvise: only initiate writeback for specified range with FADV_DONTNEED

Patches currently in -mm which might be from sbohrer@rgmadvisors.com are

fadvise-only-initiate-writeback-for-specified-range-with-fadv_dontneed.patch

