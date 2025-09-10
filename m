Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26D915E5D4
	for <mm-commits@vger.kernel.org>; Wed, 10 Sep 2025 02:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757471030; cv=none; b=WaHr9WOn78X2DYUYcTLMrwDb86R2Ndwy637zniwp0p5JVaFGcwYEcGoXrDiMuJgFG0Ip0VmEW1ZsjKCluI2PRPK2Wf8dKGC3CK1eu6yu8x7ehPTATIavSUnMMHGZztKfX9KRHhkSQkeD5EeqVUtEObbXKJtNd4V4x8mf0L2B0Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757471030; c=relaxed/simple;
	bh=ziK2RNUXiMQO+5tq6rBAcYB9fD/VbM5EYatQcjQzrm0=;
	h=Date:To:From:Subject:Message-Id; b=Me20ffYU4yxRdDEEgSqmaSusU7mQNL3MqF8a4nhQqGD4Ll6dL4F3PwhgAjEthHJmzTGvifh1ingAU2b2zJ47QGaT/0SStOjIyl/t/fl8npk/3SKXboD+ziRvOfktuklJm+6CF5ySFuo/pTdZWhOe+d2GIRL+GkPWOwR3CRzIwVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cBNZ1jz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cBNZ1jz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B841C4CEF4;
	Wed, 10 Sep 2025 02:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757471030;
	bh=ziK2RNUXiMQO+5tq6rBAcYB9fD/VbM5EYatQcjQzrm0=;
	h=Date:To:From:Subject:From;
	b=cBNZ1jz8Ngn1uIuaYnWYRMS77FAtx2br2HAAkaUNAGMP3seXYtOMeiRRwqVI5vt7V
	 PZbJmrwd2A3Hus/MTiyrYRpi47+NJDCc/1sHsSIkQIpRxudRax4CoQ9vQ90tpr0ab7
	 Ku12ey6PLmFCBDxO0ZPlPIfWEMIOwHbIe/Ffm5WM=
Date: Tue, 09 Sep 2025 19:23:49 -0700
To: mm-commits@vger.kernel.org,kernel@pankajraghav.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + readahead-add-trace-points-v2.patch added to mm-new branch
Message-Id: <20250910022350.3B841C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: readahead-add-trace-points-v2
has been added to the -mm mm-new branch.  Its filename is
     readahead-add-trace-points-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/readahead-add-trace-points-v2.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: readahead-add-trace-points-v2
Date: Tue, 9 Sep 2025 16:58:50 +0200

Move tracepoint from do_page_cache_ra() to page_cache_ra_unbounded() as
that is a more standard function.

Link: https://lkml.kernel.org/r/20250909145849.5090-2-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Pankaj Raghav <kernel@pankajraghav.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/readahead.h |    2 +-
 mm/readahead.c                   |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/include/trace/events/readahead.h~readahead-add-trace-points-v2
+++ a/include/trace/events/readahead.h
@@ -11,7 +11,7 @@
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 
-TRACE_EVENT(do_page_cache_ra,
+TRACE_EVENT(page_cache_ra_unbounded,
 	TP_PROTO(struct inode *inode, pgoff_t index, unsigned long nr_to_read,
 		 unsigned long lookahead_size),
 
--- a/mm/readahead.c~readahead-add-trace-points-v2
+++ a/mm/readahead.c
@@ -228,6 +228,8 @@ void page_cache_ra_unbounded(struct read
 	 */
 	unsigned int nofs = memalloc_nofs_save();
 
+	trace_page_cache_ra_unbounded(mapping->host, index, nr_to_read,
+				      lookahead_size);
 	filemap_invalidate_lock_shared(mapping);
 	index = mapping_align_index(mapping, index);
 
@@ -317,7 +319,6 @@ static void do_page_cache_ra(struct read
 	loff_t isize = i_size_read(inode);
 	pgoff_t end_index;	/* The last page we want to read */
 
-	trace_do_page_cache_ra(inode, index, nr_to_read, lookahead_size);
 	if (isize == 0)
 		return;
 
_

Patches currently in -mm which might be from jack@suse.cz are

readahead-add-trace-points.patch
readahead-add-trace-points-v2.patch

