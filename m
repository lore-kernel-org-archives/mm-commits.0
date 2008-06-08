From: akpm@linux-foundation.org
Subject: - pagemap-return-einval-not-eio-for-unaligned-reads-of-kpagecount-or-kpageflags-v2-of-series.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:49:21 -0700
Message-ID: <200806081949.m58JnLAJ017674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754614AbYFHTuF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:50:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ttuttle@google.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     pagemap: return EINVAL, not EIO, for unaligned reads of kpagecount or kpageflags
has been removed from the -mm tree.  Its filename was
     pagemap-return-einval-not-eio-for-unaligned-reads-of-kpagecount-or-kpageflags-v2-of-series.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagemap: return EINVAL, not EIO, for unaligned reads of kpagecount or kpageflags
From: "Thomas Tuttle" <ttuttle@google.com>

If the user tries to read from a position that is not a multiple of 8, or
read a number of bytes that is not a multiple of 8, they have passed an
invalid argument to read, for the purpose of reading these files.  It's
not an IO error because we didn't encounter any trouble finding the data
they asked for.

Signed-off-by: Thomas Tuttle <ttuttle@google.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/proc_misc.c~pagemap-return-einval-not-eio-for-unaligned-reads-of-kpagecount-or-kpageflags-v2-of-series fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~pagemap-return-einval-not-eio-for-unaligned-reads-of-kpagecount-or-kpageflags-v2-of-series
+++ a/fs/proc/proc_misc.c
@@ -716,7 +716,7 @@ static ssize_t kpagecount_read(struct fi
 	pfn = src / KPMSIZE;
 	count = min_t(size_t, count, (max_pfn * KPMSIZE) - src);
 	if (src & KPMMASK || count & KPMMASK)
-		return -EIO;
+		return -EINVAL;
 
 	while (count > 0) {
 		ppage = NULL;
@@ -782,7 +782,7 @@ static ssize_t kpageflags_read(struct fi
 	pfn = src / KPMSIZE;
 	count = min_t(unsigned long, count, (max_pfn * KPMSIZE) - src);
 	if (src & KPMMASK || count & KPMMASK)
-		return -EIO;
+		return -EINVAL;
 
 	while (count > 0) {
 		ppage = NULL;
_

Patches currently in -mm which might be from ttuttle@google.com are

origin.patch

