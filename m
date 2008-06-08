From: akpm@linux-foundation.org
Subject: - pagemap-return-map-count-not-reference-count-in-proc-kpagecount-v2-of-series.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:49:19 -0700
Message-ID: <200806081949.m58JnJC7017671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754584AbYFHTt6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:49:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ttuttle@google.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     pagemap: return map count, not reference count, in /proc/kpagecount
has been removed from the -mm tree.  Its filename was
     pagemap-return-map-count-not-reference-count-in-proc-kpagecount-v2-of-series.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagemap: return map count, not reference count, in /proc/kpagecount
From: "Thomas Tuttle" <ttuttle@google.com>

Since pagemap is all about examining pages mapped into processes' memory
spaces, it makes sense for kpagecount to return the map counts, not the
reference counts.

Signed-off-by: Thomas Tuttle <ttuttle@google.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/proc_misc.c~pagemap-return-map-count-not-reference-count-in-proc-kpagecount-v2-of-series fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~pagemap-return-map-count-not-reference-count-in-proc-kpagecount-v2-of-series
+++ a/fs/proc/proc_misc.c
@@ -726,7 +726,7 @@ static ssize_t kpagecount_read(struct fi
 		if (!ppage)
 			pcount = 0;
 		else
-			pcount = atomic_read(&ppage->_count);
+			pcount = page_mapcount(ppage);
 
 		if (put_user(pcount, out++)) {
 			ret = -EFAULT;
_

Patches currently in -mm which might be from ttuttle@google.com are

origin.patch

