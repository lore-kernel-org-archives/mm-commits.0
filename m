Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CF43672AE
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 22:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778626650; cv=none; b=SHehqo8St0PwYwJKk2tdXj4hxonHi/ijvhR4uMd7icM12NLhY6hn4txijkMqYvH7JIbBfEI4jTRlbe7TAH1NyyesbZbUmiXu2t6nvmEk1FXfJyBy2i+b+up3TTQR05fDIFGkwhVMBBRO6+FIcnBiEdLQ57Oo5bG1Uo4cMGBRyDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778626650; c=relaxed/simple;
	bh=lL1Aj80B45Avpw5fhTXJ7FSRh6+2uv0N7lIemLxQ+zY=;
	h=Date:To:From:Subject:Message-Id; b=atmopP0DtzPbm7v55XHXMD2BMjCEl7PD0180Fa+Z9eLrFlDweSWvvKqj4X3cAjEde143XYk0Y5WAJ2RYG7R3fmhuZUy7ElYBzKVxPLp/UICwkgY8jKbpuWz0Rmul43lfZIjdkZaxMx2QJ/x8yztJb0V4XL9vcFpEGrLLE0TnqJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fYlR/mwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fYlR/mwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC88CC2BCB0;
	Tue, 12 May 2026 22:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778626649;
	bh=lL1Aj80B45Avpw5fhTXJ7FSRh6+2uv0N7lIemLxQ+zY=;
	h=Date:To:From:Subject:From;
	b=fYlR/mwHxFUSD4bozoTSB8idg/9CWJ59Gsdb/v1+4FkNGSmZg9HnxJ6uNsNYxf9YB
	 5WkJ42lcHUCels84Jo95LRQZy50p0eI89OcFy5bJoGaoridwDosPfvnp3IAGcyK4IH
	 TJZHgx6ZYTtdvv8GyouD+du6qWCYAt04Iu0LZ5EE=
Date: Tue, 12 May 2026 15:57:29 -0700
To: mm-commits@vger.kernel.org,qiwu.chen@transsion.com,qiwuchen55@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-rework-lru_shrink-and-write_folio-tracepoints-fix.patch added to mm-new branch
Message-Id: <20260512225729.BC88CC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vmscan-rework-lru_shrink-and-write_folio-tracepoints-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-rework-lru_shrink-and-write_folio-tracepoints-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-rework-lru_shrink-and-write_folio-tracepoints-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: chenqiwu <qiwuchen55@gmail.com>
Subject: mm-vmscan-rework-lru_shrink-and-write_folio-tracepoints-fix
Date: Sun, 10 May 2026 08:36:34 +0800

build fix

Link: https://lore.kernel.org/20260510003634.GB5833@rlk
Signed-off-by: qiwu.chen <qiwu.chen@transsion.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/events/vmscan.h~mm-vmscan-rework-lru_shrink-and-write_folio-tracepoints-fix
+++ a/include/trace/events/vmscan.h
@@ -398,7 +398,7 @@ TRACE_EVENT(mm_vmscan_write_folio,
 	TP_ARGS(folio),
 
 	TP_STRUCT__entry(
-		__field(unsigned long, folio)
+		__field(struct folio *, folio)
 		__field(int, lru)
 	),
 
_

Patches currently in -mm which might be from qiwuchen55@gmail.com are

mm-vmscan-rework-lru_shrink-and-write_folio-tracepoints-fix.patch

