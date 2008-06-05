From: akpm@linux-foundation.org
Subject: + pagemap-return-einval-not-eio-for-unaligned-reads-of-kpagecount-or-kpageflags-v2-of-series.patch added to -mm tree
Date: Thu, 05 Jun 2008 13:11:56 -0700
Message-ID: <200806052011.m55KBu8W027654@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827AbYFEUM0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 16:12:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ttuttle@google.com, mpm@selenic.com


The patch titled
     pagemap: return EINVAL, not EIO, for unaligned reads of kpagecount or kpageflags
has been added to the -mm tree.  Its filename is
     pagemap-return-einval-not-eio-for-unaligned-reads-of-kpagecount-or-kpageflags-v2-of-series.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -732,7 +732,7 @@ static ssize_t kpagecount_read(struct fi
 	pfn = src / KPMSIZE;
 	count = min_t(size_t, count, (max_pfn * KPMSIZE) - src);
 	if (src & KPMMASK || count & KPMMASK)
-		return -EIO;
+		return -EINVAL;
 
 	while (count > 0) {
 		ppage = NULL;
@@ -798,7 +798,7 @@ static ssize_t kpageflags_read(struct fi
 	pfn = src / KPMSIZE;
 	count = min_t(unsigned long, count, (max_pfn * KPMSIZE) - src);
 	if (src & KPMMASK || count & KPMMASK)
-		return -EIO;
+		return -EINVAL;
 
 	while (count > 0) {
 		ppage = NULL;
_

Patches currently in -mm which might be from ttuttle@google.com are

pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series.patch
pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series-checkpatch-fixes.patch
pagemap-return-map-count-not-reference-count-in-proc-kpagecount-v2-of-series.patch
pagemap-return-einval-not-eio-for-unaligned-reads-of-kpagecount-or-kpageflags-v2-of-series.patch
pagemap-add-documentation-for-pagemap.patch

