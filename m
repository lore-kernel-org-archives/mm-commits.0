Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07B726A1BE
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 23:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755646043; cv=none; b=O6i+wsyUNY7NwgZX2aPywojvTaogVnxZhPmeAY4sGA87QnhmP0gwukJbk7jU1dEdIHH54vByxFcHpcFU/TDm8zIPPF37Bg09/FCoj47ojWJiAzTwV5lbp9XsHq5d9lNYxgDBxowukJGzfh9y0EL6Ukze4JmcTwXakFb9uKG6FwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755646043; c=relaxed/simple;
	bh=Pc0EfPpQ3hNCYFD/9FreN3J/DOpkQLhBB7XsqBgxxjU=;
	h=Date:To:From:Subject:Message-Id; b=r0VcjY3gGTAnbJ2B8FWsvnlZB4XcVDphibW20pHuG9he6Ggu2ChfLmEVLlUHCa5LRmHlscq/s0HwV7isV8Pati9jdnEKnmj44xw2AteMhn/Xea4Nu7e8wHMOdKa0SDvbYGu7dMUW/1x7EuX0K1Lf8WLFjv2A5tuWkdM6rfKGKco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oiC1ADty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oiC1ADty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E7FC4CEF1;
	Tue, 19 Aug 2025 23:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755646042;
	bh=Pc0EfPpQ3hNCYFD/9FreN3J/DOpkQLhBB7XsqBgxxjU=;
	h=Date:To:From:Subject:From;
	b=oiC1ADtyHE8IJn0EBKJbtdtsFxjeHE283uGeejbTIO7iGIiE7rvN3P0dZkUn268Jx
	 9W3/NseuEFptQpmHDpH4bm2iHN+J46tL2dQPgemLR2GWqwYC+5J5Hs20kWE4oVnwmc
	 Tw/cFFi48yYst+UiCG7/rDgvfjmly8SLOb2+iHi8=
Date: Tue, 19 Aug 2025 16:27:21 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,luto@kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,bp@alien8.de,rostedt@goodmis.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-x86-mm-move-creating-the-tlb_flush-event-back-to-x86-code.patch added to mm-new branch
Message-Id: <20250819232722.67E7FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, x86/mm: move creating the tlb_flush event back to x86 code
has been added to the -mm mm-new branch.  Its filename is
     mm-x86-mm-move-creating-the-tlb_flush-event-back-to-x86-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-x86-mm-move-creating-the-tlb_flush-event-back-to-x86-code.patch

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
From: Steven Rostedt <rostedt@goodmis.org>
Subject: mm, x86/mm: move creating the tlb_flush event back to x86 code
Date: Thu, 12 Jun 2025 10:03:13 -0400

Commit e73ad5ff2f76 ("mm, x86/mm: Make the batched unmap TLB flush API
more generic") moved the trace_tlb_flush out of mm/rmap.c and back into
x86 specific architecture, but it kept the include to the events/tlb.h
file, even though it didn't use that event.

Then another commit came in and added more events to the mm/rmap.c file
and moved the #define CREATE_TRACE_POINTS define from the x86 specific
architecture to the generic mm/rmap.h file to create both the tlb_flush
tracepoint and the new tracepoints.

But since the tlb_flush tracepoint is only x86 specific, it now creates
that tracepoint for all other architectures and this wastes approximately
5K of text and meta data that will not be used.

Remove the events/tlb.h from mm/rmap.c and add the define
CREATE_TRACE_POINTS back in the x86 code.

Link: https://lkml.kernel.org/r/20250612100313.3b9a8b80@batman.local.home
Fixes: e73ad5ff2f76 ("mm, x86/mm: Make the batched unmap TLB flush API more generic")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init.c |    1 +
 mm/rmap.c          |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/init.c~mm-x86-mm-move-creating-the-tlb_flush-event-back-to-x86-code
+++ a/arch/x86/mm/init.c
@@ -34,6 +34,7 @@
  * We need to define the tracepoints somewhere, and tlb.c
  * is only compiled when SMP=y.
  */
+#define CREATE_TRACE_POINTS
 #include <trace/events/tlb.h>
 
 #include "mm_internal.h"
--- a/mm/rmap.c~mm-x86-mm-move-creating-the-tlb_flush-event-back-to-x86-code
+++ a/mm/rmap.c
@@ -79,7 +79,6 @@
 #include <asm/tlbflush.h>
 
 #define CREATE_TRACE_POINTS
-#include <trace/events/tlb.h>
 #include <trace/events/migrate.h>
 
 #include "internal.h"
_

Patches currently in -mm which might be from rostedt@goodmis.org are

mm-x86-mm-move-creating-the-tlb_flush-event-back-to-x86-code.patch

