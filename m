Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CEE22B5B6
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846643; cv=none; b=Lkn3muF38vYhGReHplwrzWlxgXRIbq6kbloFuLqp9vQEUNt3Jn5C40Jfak4Tmwz160+y8k7NQrxdpVxMVhS1syCFb6YIQDYdhs2fzvQMk2s+pjoj6iwQuw4yF3Tdp9ZLiiVuMhoZW1M7WDwwJKQ9ZhsPf7mL2y+2rpMBzR4D42Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846643; c=relaxed/simple;
	bh=mw2BhbdmbCer4zUT5QruybE1kcP6ceCCC+mBauBNfq8=;
	h=Date:To:From:Subject:Message-Id; b=d6YTr5Rk2a0KERQk2BLdnRQlRPOu7qKmdv8vQ8cNwQCa3GKkOimaBpSd/lm0eTGxHT9DE/OXdJBIS/sHyt8Vxe6DAzG5tna4uB7+yUBg67p6X9N8afu951FWCQR/nh1gNNx6gPQMRp/MO/Vx70qankjSLvPoccCacvfvF2VaFQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fItQLKrZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fItQLKrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730B1C4CEE4;
	Wed, 21 May 2025 16:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846643;
	bh=mw2BhbdmbCer4zUT5QruybE1kcP6ceCCC+mBauBNfq8=;
	h=Date:To:From:Subject:From;
	b=fItQLKrZCMTMsM2FKfLEneFZ7rrpTFhOiZZuPAG64qKIuqkKJ0YE0XAsQMYwilKwe
	 2QbJnLvrTCNSen6SWJvZcJxae0AqpLFLVgowLxSdApfrXnn2qQla95knZwc7/w3WT8
	 O1ReCrQ6GmLoNbm/TrTRYPTbIrTWe2mveeICMMM0=
Date: Wed, 21 May 2025 09:57:22 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,Liam.Howlett@oracle.com,kees@kernel.org,juri.lelli@redhat.com,dietmar.eggemann@arm.com,david@redhat.com,bsegall@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-kernel-forkc-to-relevant-sections.patch removed from -mm tree
Message-Id: <20250521165723.730B1C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add kernel/fork.c to relevant sections
has been removed from the -mm tree.  Its filename was
     maintainers-add-kernel-forkc-to-relevant-sections.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add kernel/fork.c to relevant sections
Date: Tue, 13 May 2025 15:57:06 +0100

Currently kernel/fork.c both contains absolutely key logic relating to a
number of kernel subsystems and also has absolutely no assignment in
MAINTAINERS.

Correct this by placing this file in relevant sections - mm core, exec and
the scheduler so people know who to contact when making changes here.

scripts/get_maintainers.pl can perfectly well handle a file being in
multiple sections, so this functions correctly.

Intent is that we keep putting changes to kernel/fork.c through Andrew's
tree.

Link: https://lkml.kernel.org/r/20250513145706.122101-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Kees Cook <kees@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Ben Segall <bsegall@google.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

--- a/MAINTAINERS~maintainers-add-kernel-forkc-to-relevant-sections
+++ a/MAINTAINERS
@@ -8840,6 +8840,7 @@ F:	include/linux/elf.h
 F:	include/uapi/linux/auxvec.h
 F:	include/uapi/linux/binfmts.h
 F:	include/uapi/linux/elf.h
+F:	kernel/fork.c
 F:	mm/vma_exec.c
 F:	tools/testing/selftests/exec/
 N:	asm/elf.h
@@ -15540,6 +15541,7 @@ F:	include/linux/mm.h
 F:	include/linux/mm_*.h
 F:	include/linux/mmdebug.h
 F:	include/linux/pagewalk.h
+F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
 F:	mm/init-mm.c
@@ -21770,6 +21772,7 @@ F:	include/linux/preempt.h
 F:	include/linux/sched.h
 F:	include/linux/wait.h
 F:	include/uapi/linux/sched.h
+F:	kernel/fork.c
 F:	kernel/sched/
 
 SCHEDULER - SCHED_EXT
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


