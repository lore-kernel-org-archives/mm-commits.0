Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57812773F6
	for <mm-commits@vger.kernel.org>; Wed, 20 Aug 2025 22:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755729849; cv=none; b=XYJhM26XwIauJqIUmAeE9HzSOS/UJ+nE5wOKDev8OQrpL81qFk7nBHh7jTVmYRvm+7gTMQ63Be2abNWXV+WQekIelmXIMqXGIQjuNMcAGTftTe5ir7Yjfryx1lceTxX/j0j2dN8Ru4u1twUOwljsWkwWcCzaWCJtXlnUyD7/DBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755729849; c=relaxed/simple;
	bh=xvYgJau4tQzWJcNRA0182N4am7EU8UiVgJTNwcp8Aks=;
	h=Date:To:From:Subject:Message-Id; b=rq/QstrxTfV7H+hzunid4cPfUWLWDKsruGtwxyRfbGR1oKxiXwZZFPTqAA+3OXzo3/2XVIeLzp4mJv43EjZ9uUbNVgZsH4OFu03KKKz6TnEU4NnmogNW0sxCCcxFhyHU264ny9PySpYYFwLev88WkaL675DOqmEYRG5xYxDiFLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nk2McgDc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nk2McgDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02164C4CEE7;
	Wed, 20 Aug 2025 22:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755729849;
	bh=xvYgJau4tQzWJcNRA0182N4am7EU8UiVgJTNwcp8Aks=;
	h=Date:To:From:Subject:From;
	b=Nk2McgDcNnv9IgWvUeRMv898NfzaNn6ZnQcXTRK160cyszugX9FXCE0QDhXTE55h1
	 nbcuvreI6EY9VWvA9rHe8Q/or68aHrEnoWlOuquxdXyKYt3l5i7A0gxn/wgZ1bPjV9
	 lpj5XUj3G1AG2SJ59VFSaznqNtOQ1KmFvjBkX2lc=
Date: Wed, 20 Aug 2025 15:44:08 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,gaoxiang17@xiaomi.com,david@redhat.com,gxxa03070307@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-add-available-count-and-total-count-to-trace_cma_alloc_start.patch added to mm-new branch
Message-Id: <20250820224409.02164C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: add 'available count' and 'total count' to trace_cma_alloc_start
has been added to the -mm mm-new branch.  Its filename is
     mm-cma-add-available-count-and-total-count-to-trace_cma_alloc_start.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-add-available-count-and-total-count-to-trace_cma_alloc_start.patch

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
From: Xiang Gao <gxxa03070307@gmail.com>
Subject: mm/cma: add 'available count' and 'total count' to trace_cma_alloc_start
Date: Thu, 21 Aug 2025 06:38:55 +0800


This makes cma info more intuitive during debugging.

Show up in the trace as:

	279.814717: cma_alloc_start: name=reserved request_count=4 available_count=8096 total_count=8192 align=0
	309.790580: cma_alloc_start: name=reserved request_count=4 available_count=8092 total_count=8192 align=0
	317.046609: cma_alloc_start: name=reserved request_count=4 available_count=8088 total_count=8192 align=0

Link: https://lkml.kernel.org/r/8a79284879c529f467478552825154b018076e95.1755729178.git.gaoxiang17@xiaomi.com
Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/cma.h |   19 +++++++++++++------
 mm/cma.c                   |    2 +-
 2 files changed, 14 insertions(+), 7 deletions(-)

--- a/include/trace/events/cma.h~mm-cma-add-available-count-and-total-count-to-trace_cma_alloc_start
+++ a/include/trace/events/cma.h
@@ -38,25 +38,32 @@ TRACE_EVENT(cma_release,
 
 TRACE_EVENT(cma_alloc_start,
 
-	TP_PROTO(const char *name, unsigned long count, unsigned int align),
+	TP_PROTO(const char *name, unsigned long request_count, unsigned long available_count,
+		unsigned long total_count, unsigned int align),
 
-	TP_ARGS(name, count, align),
+	TP_ARGS(name, request_count, available_count, total_count, align),
 
 	TP_STRUCT__entry(
 		__string(name, name)
-		__field(unsigned long, count)
+		__field(unsigned long, request_count)
+		__field(unsigned long, available_count)
+		__field(unsigned long, total_count)
 		__field(unsigned int, align)
 	),
 
 	TP_fast_assign(
 		__assign_str(name);
-		__entry->count = count;
+		__entry->request_count = request_count;
+		__entry->available_count = available_count;
+		__entry->total_count = total_count;
 		__entry->align = align;
 	),
 
-	TP_printk("name=%s count=%lu align=%u",
+	TP_printk("name=%s request_count=%lu available_count=%lu total_count=%lu align=%u",
 		  __get_str(name),
-		  __entry->count,
+		  __entry->request_count,
+		  __entry->available_count,
+		  __entry->total_count,
 		  __entry->align)
 );
 
--- a/mm/cma.c~mm-cma-add-available-count-and-total-count-to-trace_cma_alloc_start
+++ a/mm/cma.c
@@ -864,7 +864,7 @@ static struct page *__cma_alloc(struct c
 	if (!count)
 		return page;
 
-	trace_cma_alloc_start(name, count, align);
+	trace_cma_alloc_start(name, count, cma->available_count, cma->count, align);
 
 	for (r = 0; r < cma->nranges; r++) {
 		page = NULL;
_

Patches currently in -mm which might be from gxxa03070307@gmail.com are

mm-cma-add-available-count-and-total-count-to-trace_cma_alloc_start.patch

