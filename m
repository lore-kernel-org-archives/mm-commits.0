Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A982905
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126205; cv=none; b=pnUcGYHWT75c1eM6q3nPT13Dr0SAMdDxNo6v4H2ITxtPPFqyzPHpSz1PipHauFJ96f0Y0F0nOzhHB4E5+78R4f3mDtpm8ibSvur5ZugB3HuhM1EghgCxtPlvdezCVB7riYRGtZkabW1IRXaO3pBYFyusO6io2TeXpCftF28sMWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126205; c=relaxed/simple;
	bh=9/78KhLxRh/FOFo+IYsdpeilbbvfPG+E/03s01M8hZI=;
	h=Date:To:From:Subject:Message-Id; b=GnPGKPvnIVCYJdEAqaLzPsQfN/H6/5UBSj3TW6WqfxQ7Dhqx6RQ4OZ8QawNWPtooKFDs9NrgQU+eFlKksVhCGJB9tLZnPSx8QOwRxQHCfY4zn8f4tP7eDo1WCNwLoBQ8//t0K/hnpxPtZ8qI2Esq3gsskwW9BiV2ofgd2d4NGGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1wW1KkWi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1wW1KkWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06DDC4CEE3;
	Thu, 10 Jul 2025 05:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126204;
	bh=9/78KhLxRh/FOFo+IYsdpeilbbvfPG+E/03s01M8hZI=;
	h=Date:To:From:Subject:From;
	b=1wW1KkWi+9Yf1ANMG0bfiUY3qEfhVdVQK9RIGhkbNtAeO43pLEFwY9CzBZ4S2VEXs
	 TYfUnXztXbP8ZqGPedHgyaUvXbpK5Dd2EXCRVa6ZJNlCv3w7Fp70t6xrSiWlavXXxm
	 20QcMPvORwGHZJCOaagGypZ3hq0I70dMVXER2bd0=
Date: Wed, 09 Jul 2025 22:43:24 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,emueller@purestorage.com,csander@purestorage.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-unused-mmap-tracepoints.patch removed from -mm tree
Message-Id: <20250710054324.B06DDC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove unused mmap tracepoints
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-mmap-tracepoints.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Caleb Sander Mateos <csander@purestorage.com>
Subject: mm: remove unused mmap tracepoints
Date: Fri, 11 Apr 2025 10:17:45 -0600

The vma_mas_szero and vma_store tracepoints are unused since commit
fbcc3104b843 ("mmap: convert __vma_adjust() to use vma iterator").  Remove
them so they are no longer listed as available tracepoints.

Link: https://lkml.kernel.org/r/20250411161746.1043239-1-csander@purestorage.com
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reported-by: Eric Mueller <emueller@purestorage.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/mmap.h |   52 ----------------------------------
 1 file changed, 52 deletions(-)

--- a/include/trace/events/mmap.h~mm-remove-unused-mmap-tracepoints
+++ a/include/trace/events/mmap.h
@@ -43,58 +43,6 @@ TRACE_EVENT(vm_unmapped_area,
 		__entry->align_offset)
 );
 
-TRACE_EVENT(vma_mas_szero,
-	TP_PROTO(struct maple_tree *mt, unsigned long start,
-		 unsigned long end),
-
-	TP_ARGS(mt, start, end),
-
-	TP_STRUCT__entry(
-			__field(struct maple_tree *, mt)
-			__field(unsigned long, start)
-			__field(unsigned long, end)
-	),
-
-	TP_fast_assign(
-			__entry->mt		= mt;
-			__entry->start		= start;
-			__entry->end		= end;
-	),
-
-	TP_printk("mt_mod %p, (NULL), SNULL, %lu, %lu,",
-		  __entry->mt,
-		  (unsigned long) __entry->start,
-		  (unsigned long) __entry->end
-	)
-);
-
-TRACE_EVENT(vma_store,
-	TP_PROTO(struct maple_tree *mt, struct vm_area_struct *vma),
-
-	TP_ARGS(mt, vma),
-
-	TP_STRUCT__entry(
-			__field(struct maple_tree *, mt)
-			__field(struct vm_area_struct *, vma)
-			__field(unsigned long, vm_start)
-			__field(unsigned long, vm_end)
-	),
-
-	TP_fast_assign(
-			__entry->mt		= mt;
-			__entry->vma		= vma;
-			__entry->vm_start	= vma->vm_start;
-			__entry->vm_end		= vma->vm_end - 1;
-	),
-
-	TP_printk("mt_mod %p, (%p), STORE, %lu, %lu,",
-		  __entry->mt, __entry->vma,
-		  (unsigned long) __entry->vm_start,
-		  (unsigned long) __entry->vm_end
-	)
-);
-
-
 TRACE_EVENT(exit_mmap,
 	TP_PROTO(struct mm_struct *mm),
 
_

Patches currently in -mm which might be from csander@purestorage.com are


