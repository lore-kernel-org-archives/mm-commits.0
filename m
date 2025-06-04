Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5188423A9B3
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 03:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749007387; cv=none; b=gGh45PWbKOW59GRwfeR+k+QIbFj1dg6FSn+WTEOtF2OAWqMRpMw1f4DpoRkjVWXVIlam/a6xKYkq31WU9OGADHkIAvupGL2fCAsM0P+0K2n98w3rqUv0LOBShG4GriEDCu1ekW/wWHnwy/FZKaOzImzBkPeeP77HRVeG55s70Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749007387; c=relaxed/simple;
	bh=3GTme77kvQEAuZXNlhs2eb/Ytz85MBVF46tsSVpW5GQ=;
	h=Date:To:From:Subject:Message-Id; b=DbQfBddu4FPSQkzIBklxubgmiRI0dlkUUSeIVpwGyvli5EvftFPZJU5F2xbh1kS3cdGkZtk3aZ5Af8roBwsH7ZPN9zxTcbopxGd6jYdOzlAJlKhDlKuoF+gsMuHRNuyf9XX7d66Z+507mdILopT+X5xalCll4oMKgcCVEufb9/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VzTlfwg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VzTlfwg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63EEC4CEF7;
	Wed,  4 Jun 2025 03:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749007386;
	bh=3GTme77kvQEAuZXNlhs2eb/Ytz85MBVF46tsSVpW5GQ=;
	h=Date:To:From:Subject:From;
	b=VzTlfwg5vWGuUstB+obmlX1/tyPsSeQs13axFXX7hMXDcUixOx1rkhsMGuZVVFGCz
	 PAGvmGd2PvxFYAX3MWHkgDjKDXi+D/r95kIamOdcJm7UFJRvlajlyBQodEEqkfaCzu
	 PumxYuLL1305Qdql5bzQ5rmXy60qd/QT24wlhYj0=
Date: Tue, 03 Jun 2025 20:23:06 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,emueller@purestorage.com,csander@purestorage.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unused-mmap-tracepoints.patch added to mm-new branch
Message-Id: <20250604032306.A63EEC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove unused mmap tracepoints
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-unused-mmap-tracepoints.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unused-mmap-tracepoints.patch

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

mm-remove-unused-mmap-tracepoints.patch

