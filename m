Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD3A280A4F
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 21:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744405374; cv=none; b=oEMrTSUPSFnF+j7jh1bIeu5GsveQC6uNDsppsnKB/nVnZD3iderFCJuxfYCeJt1dTdc4v7G6cJhdjjk8iABZuMxgDNHzipkh3ChJQT98qMGQPNudSb41aqNo3xyNdPVRoI62wiV7qKzLRFoAbGPpMBZfXQrlEfzNazrD9hJrxG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744405374; c=relaxed/simple;
	bh=xwEsmKFXfU2JJr3jXR3t40YHuDNaOWKzp508xFV9QSI=;
	h=Date:To:From:Subject:Message-Id; b=ECvMzQaX2/A68viQmKj+Z3IxqF9+IYvCI3Ob5v5A7tw/HQJMlxCjGeMtf+y3Q5zfBybjkL+u8Fod2/dtvlsfgVU/uAKCM7zd16eSjc5qcvv6Kna1ffA7h7zoxuHvWuX3+h5CZj6x+QrahQH9EXK0vqpQmBbKCA3EcFXoa09IWsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZCeMlfJS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZCeMlfJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1FBC4CEE5;
	Fri, 11 Apr 2025 21:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744405372;
	bh=xwEsmKFXfU2JJr3jXR3t40YHuDNaOWKzp508xFV9QSI=;
	h=Date:To:From:Subject:From;
	b=ZCeMlfJScz99zU2vo0gLfN4VsqBeFVDI12ouIgQnENUUoDuZUi2w3AXupzfl9J0oW
	 DtBYDfGCZCs33V86oPdGgqLob32R66aWTnJch+LH2bANv4WZRYzn7Lr1qW1zhlz2/K
	 RdzTlur6iTAPkyF+43CSyz1Kjewz0+hfepDQKHVo=
Date: Fri, 11 Apr 2025 14:02:51 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,rostedt@goodmis.org,lorenzo.stoakes@oracle.com,jannh@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-mmap-trace-events-to-memory-mapping.patch added to mm-hotfixes-unstable branch
Message-Id: <20250411210252.6F1FBC4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add mmap trace events to MEMORY MAPPING
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-mmap-trace-events-to-memory-mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-mmap-trace-events-to-memory-mapping.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: MAINTAINERS: add mmap trace events to MEMORY MAPPING
Date: Fri, 11 Apr 2025 13:33:28 -0400

MEMORY MAPPING does not list the mmap.h trace point file, but does list
the mmap.c file.  Couple the trace points with the users and authors of
the trace points for notifications of updates.

Link: https://lkml.kernel.org/r/20250411173328.8172-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-mmap-trace-events-to-memory-mapping
+++ a/MAINTAINERS
@@ -15558,6 +15558,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/trace/events/mmap.h
 F:	mm/mlock.c
 F:	mm/mmap.c
 F:	mm/mprotect.c
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maintainers-add-mmap-trace-events-to-memory-mapping.patch

