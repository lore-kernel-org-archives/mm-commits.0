Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E1F1C32EB;
	Thu, 17 Oct 2024 07:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150131; cv=none; b=nrss5QtXqmQnfKo6Hbp4ZIIqeNvkzyGFplt1Ejt0Rr2hh/iRdPeOy3MsgPySmyfvehPEF1Ay5ZuN6i1ACFVAgxESDAS9jBxAhzULRQTxP7GGHi86C6qLGBRtBBE0joURKW+lmYW6kRABZz9jKjiudlOvORtZ9Sd9aH+AdeeujQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150131; c=relaxed/simple;
	bh=cn4PPHh6EHyfE0NKYV98rWcBuGUfWadVcw1jdEUAf0w=;
	h=Date:To:From:Subject:Message-Id; b=K58Cm/vQBS1NqQPDCFk/396fpR4bz9aRPXR2n6BybgA0ESH/PEd31F5TyQtWvJ7XSSzhFLRkIs8gU7WiMtjHVvz68L6ElhkX3RzyPVmj3igscEOR/TZSZcCW0Eq7P7A6QMr1gRpS84xWVwpEoVTN1N7CucBMJ1eTBHV/nJC7u/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AVKY++n/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AVKY++n/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A7DC4CEC5;
	Thu, 17 Oct 2024 07:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150130;
	bh=cn4PPHh6EHyfE0NKYV98rWcBuGUfWadVcw1jdEUAf0w=;
	h=Date:To:From:Subject:From;
	b=AVKY++n/60Kv/QbaJzZfLOkr0kZLRmCu2HVeKuRdAIzGG58wn/+Jg5jGobAU+RZ9/
	 zaYpiF8Ni3Z7xTOlngQAL1KobxkUgb0x0YcZ/q52mLy/aLUua1X9R/hwWlwyiJd7Vn
	 bJiIqNPqo2I9hMG5PQiyJvNRdjL7j/gVug5o+OmQ=
Date: Thu, 17 Oct 2024 00:28:50 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rostedt@goodmis.org,gautammenghani201@gmail.com,yang@os.amperecomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-khugepaged-fix-the-arguments-order-in-khugepaged_collapse_file-trace-point.patch removed from -mm tree
Message-Id: <20241017072850.D5A7DC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: fix the arguments order in khugepaged_collapse_file trace point
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-the-arguments-order-in-khugepaged_collapse_file-trace-point.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Shi <yang@os.amperecomputing.com>
Subject: mm: khugepaged: fix the arguments order in khugepaged_collapse_file trace point
Date: Fri, 11 Oct 2024 18:17:02 -0700

The "addr" and "is_shmem" arguments have different order in TP_PROTO and
TP_ARGS.  This resulted in the incorrect trace result:

text-hugepage-644429 [276] 392092.878683: mm_khugepaged_collapse_file:
mm=0xffff20025d52c440, hpage_pfn=0x200678c00, index=512, addr=1, is_shmem=0,
filename=text-hugepage, nr=512, result=failed

The value of "addr" is wrong because it was treated as bool value, the
type of is_shmem.

Fix the order in TP_PROTO to keep "addr" is before "is_shmem" since the
original patch review suggested this order to achieve best packing.

And use "lx" for "addr" instead of "ld" in TP_printk because address is
typically shown in hex.

After the fix, the trace result looks correct:

text-hugepage-7291  [004]   128.627251: mm_khugepaged_collapse_file:
mm=0xffff0001328f9500, hpage_pfn=0x20016ea00, index=512, addr=0x400000,
is_shmem=0, filename=text-hugepage, nr=512, result=failed

Link: https://lkml.kernel.org/r/20241012011702.1084846-1-yang@os.amperecomputing.com
Fixes: 4c9473e87e75 ("mm/khugepaged: add tracepoint to collapse_file()")
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Cc: Gautam Menghani <gautammenghani201@gmail.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>    [6.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    4 ++--
 mm/khugepaged.c                    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-fix-the-arguments-order-in-khugepaged_collapse_file-trace-point
+++ a/include/trace/events/huge_memory.h
@@ -208,7 +208,7 @@ TRACE_EVENT(mm_khugepaged_scan_file,
 
 TRACE_EVENT(mm_khugepaged_collapse_file,
 	TP_PROTO(struct mm_struct *mm, struct folio *new_folio, pgoff_t index,
-			bool is_shmem, unsigned long addr, struct file *file,
+			unsigned long addr, bool is_shmem, struct file *file,
 			int nr, int result),
 	TP_ARGS(mm, new_folio, index, addr, is_shmem, file, nr, result),
 	TP_STRUCT__entry(
@@ -233,7 +233,7 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
 		__entry->result = result;
 	),
 
-	TP_printk("mm=%p, hpage_pfn=0x%lx, index=%ld, addr=%ld, is_shmem=%d, filename=%s, nr=%d, result=%s",
+	TP_printk("mm=%p, hpage_pfn=0x%lx, index=%ld, addr=%lx, is_shmem=%d, filename=%s, nr=%d, result=%s",
 		__entry->mm,
 		__entry->hpfn,
 		__entry->index,
--- a/mm/khugepaged.c~mm-khugepaged-fix-the-arguments-order-in-khugepaged_collapse_file-trace-point
+++ a/mm/khugepaged.c
@@ -2227,7 +2227,7 @@ rollback:
 	folio_put(new_folio);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	trace_mm_khugepaged_collapse_file(mm, new_folio, index, is_shmem, addr, file, HPAGE_PMD_NR, result);
+	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
 	return result;
 }
 
_

Patches currently in -mm which might be from yang@os.amperecomputing.com are


