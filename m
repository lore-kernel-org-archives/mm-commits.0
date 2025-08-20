Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F77288A2
	for <mm-commits@vger.kernel.org>; Wed, 20 Aug 2025 00:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755649891; cv=none; b=rId5ash0pRmyCUeLTrg8g23XeGYhW1FPplXcKC6ObEiIU22dt5NG5HT4uAI/0LHQfRN6rJWOfVPTxBtSsZhU3axVxW3vJIja9tLb7GuwSzXtWNcJbolMn2bntopOKdEdrg2i5FxPO4e1UE2qxvYYO+X66B3Rgunr034guwTT16g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755649891; c=relaxed/simple;
	bh=KCZ1AdUc5KzL6h57l3ShxwgomLf80cGMx/pLtkg8VJI=;
	h=Date:To:From:Subject:Message-Id; b=WKTtVf1/IdWFpPbVVlnM+hGXBmqSCXEwpR6lYdpOTJCHW8Z96EjaPH05K8ngKeeKk18s4pZAI4IM7ro6/Y8NATRmLQP/Omx1CXSN/6tsB7qkEaPypSamG20fzP8NjDNsr6azS5pPIOHR3HojhtkQASUanhaL9AQ+xzTbjo6xcDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k7rlVDrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k7rlVDrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8A0C4CEF1;
	Wed, 20 Aug 2025 00:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755649891;
	bh=KCZ1AdUc5KzL6h57l3ShxwgomLf80cGMx/pLtkg8VJI=;
	h=Date:To:From:Subject:From;
	b=k7rlVDrGXQr31QJ4lDF8kk0hIq+Uv/L8c0e2Hj6e9tbKhmig881TJquXZbYjvf2eP
	 QOz3D8td1KqV2DKzkZ3609JVAvqlJK5sdKsza1gFyeZQqjYm8yu5hJkjujTM5quGGy
	 zyXeMOHKDBXn9L33JIbdWWwPoS5i8wlPaU43MOYc=
Date: Tue, 19 Aug 2025 17:31:30 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,gaoxiang17@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-cma-add-available-count-and-total-count-to-trace_cma_alloc_start.patch removed from -mm tree
Message-Id: <20250820003131.8A8A0C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: add 'available count' and 'total count' to trace_cma_alloc_start
has been removed from the -mm tree.  Its filename was
     mm-cma-add-available-count-and-total-count-to-trace_cma_alloc_start.patch

This patch was dropped because it had testing failures

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


