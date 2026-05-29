Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50696370AEC
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027674; cv=none; b=TB2hKko1IJhSqaz5wFOTw8SEvYOwvfJmy1sS1XgW/etgXAH5tn6EpiDQ0srTsbDvY86HZmMteEMtFIIVGcFY2P3ZhjYzcGyIbUmv31wYOUXNAlSK/jhyfoYtm/bcUdTcE8wswmDmp4RCmBkY+Cn8yeR963t/uvuZKzvsQ5jS9gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027674; c=relaxed/simple;
	bh=ZgvIXvBz0oSMvwMcCngkZt/gkN5gzc7BhNlLVXywB/U=;
	h=Date:To:From:Subject:Message-Id; b=SEFglshWum5EDl0i2phSKE1aYne77/bB4o2g8jhVpDXv7NUcyFA6uZcYLOY5eSix9a9kE+TVtwutAimRXS0OLVvF4OLZZ1YDtKf7sFkrWXhfPGr1oPTLHSfiBm4m8+I5GcHqsFbyUgQnOPmtFPo7ktcwkhugYAf4dARNEh6+BEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=131IBIYe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="131IBIYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB781F00893;
	Fri, 29 May 2026 04:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027673;
	bh=AtmLF3e65ZuFAM0gXzzdkVeUyuHOqHcAtpfnsQIzTZk=;
	h=Date:To:From:Subject;
	b=131IBIYeySZjd5n6jHMdAmOkTzQbdWeKuBpGIyng5IGaRqmAhXZVh6aeFNkwBNeXq
	 nybC8FBoh82ZHMtBW8XKzisp73yKanNxdtKEcXCY3MBVxdP9y72VPnScCLAQQYID/S
	 1CRjCde7S6tw8vCXItyZ7jLTZdbQ5LSQ7Dv4y+Ds=
Date: Thu, 28 May 2026 21:07:52 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@kernel.org,urezki@gmail.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,kprateek.nayak@amd.com,kees@kernel.org,juri.lelli@redhat.com,dietmar.eggemann@arm.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,bsegall@google.com,arnd@arndb.de,usama.anjum@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-skip-kasan-tagging-for-page-allocated-page-tables.patch removed from -mm tree
Message-Id: <20260529040753.1FB781F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: skip KASAN tagging for page-allocated page tables
has been removed from the -mm tree.  Its filename was
     mm-skip-kasan-tagging-for-page-allocated-page-tables.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: mm: skip KASAN tagging for page-allocated page tables
Date: Wed, 29 Apr 2026 15:57:04 +0530

Page tables are always accessed via the linear mapping with a match-all
tag, so HW-tag KASAN never checks them.  For page-allocated tables (PTEs
and PGDs etc), avoid the tag setup and poisoning overhead by using
__GFP_SKIP_KASAN.  SLUB-backed page tables are unchanged for now.  (They
aren't widely used and require more SLUB related skip logic.  Leave it
later.)

Link: https://lore.kernel.org/20260429102704.680174-4-dev.jain@arm.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Segall <bsegall@google.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgalloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/pgalloc.h~mm-skip-kasan-tagging-for-page-allocated-page-tables
+++ a/include/asm-generic/pgalloc.h
@@ -4,7 +4,7 @@
 
 #ifdef CONFIG_MMU
 
-#define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
+#define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO | __GFP_SKIP_KASAN)
 #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
 
 /**
_

Patches currently in -mm which might be from usama.anjum@arm.com are


