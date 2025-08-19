Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1FA288DA
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 21:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640029; cv=none; b=NRiddH9TJPpouFdWKsdko5IPO85juNKYadaJFvaFE/wIAvalb0UqJwrsuzhqTZi9TCx4f8dA2UT6zdENTEdB6iYj2+0L+w4cSSJ2vCXtXNpHoh2d1zPyfxaNLdT7LYPLMI6cd42O2nCUeXNTDbQOh6mbcv41DLtx4ec4YbP+RkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640029; c=relaxed/simple;
	bh=epszjEjNKsCUC9O9RgbC5l33IZdk5KfoReox405EfZU=;
	h=Date:To:From:Subject:Message-Id; b=qLCQbkJXz20HBW0is0QGj2ENeR1ltJSRJ2wj2S+EHgd+N+5RAbiSjsRd08KoNdHqcYfGP78L7I0xfD2PP7WJtyEdPIxDJnzEPMGOEMjpKjYtRcZ5myvePfB5scMJjqx58ZfMq3oM5EaLIc8NNcbNUAykZ9QmQhb97nIX1nPTRnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cXfYVBJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cXfYVBJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6835EC4CEF1;
	Tue, 19 Aug 2025 21:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755640028;
	bh=epszjEjNKsCUC9O9RgbC5l33IZdk5KfoReox405EfZU=;
	h=Date:To:From:Subject:From;
	b=cXfYVBJU1BtZPgDP618fKq+82sJHo6w7nMwwMzvwbBGfLLGkaV/uzlvTecKrZDGHq
	 219zGF/r+Jy93DjbYLizv5FvML23IpdpwTqMNPr/wU1ssQGCyGlJgdrqescfwZRJEp
	 Nct2P7OHdfhV56vI5DkOa2HqXLj9RyX8E5AShlVY=
Date: Tue, 19 Aug 2025 14:47:07 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,gaoxiang17@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-add-available-count-and-total-count-to-trace_cma_alloc_start.patch added to mm-new branch
Message-Id: <20250819214708.6835EC4CEF1@smtp.kernel.org>
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
From: gaoxiang17 <gaoxiang17@xiaomi.com>
Subject: mm/cma: add 'available count' and 'total count' to trace_cma_alloc_start
Date: Tue, 19 Aug 2025 21:48:17 +0800

This makes cma info more intuitive during debugging.

Link: https://lkml.kernel.org/r/20250819134817.247495-1-gxxa03070307@gmail.com
Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/cma.h |   17 ++++++++++++-----
 mm/cma.c                   |    2 +-
 2 files changed, 13 insertions(+), 6 deletions(-)

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
+		__entry->count = request_count;
+		__entry->available_count = available_count;
+		__entry->total_count = total_count;
 		__entry->align = align;
 	),
 
 	TP_printk("name=%s count=%lu align=%u",
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

Patches currently in -mm which might be from gaoxiang17@xiaomi.com are

mm-cma-add-available-count-and-total-count-to-trace_cma_alloc_start.patch

