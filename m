Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E4A265621
	for <mm-commits@vger.kernel.org>; Tue, 24 Feb 2026 17:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771955253; cv=none; b=b5c2DSKxOQDtPizpzcBb25SIrzZPEyyF3By/Z2KasLhjO7nQVGuK81H06PUZYJYpognkVY6F/RToGTnuHkbbnN/4eY8yLkO1AUphAwWlEP/TALM0lbeKB3t6O3czV7oiW7cAd14/voO973pcMSUKd6wOpoyCs8S5K1KiwaiTIVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771955253; c=relaxed/simple;
	bh=UIuZVxPK9aFZrcXKIBeUE2UvVo54X57AmrkRrYdDIlM=;
	h=Date:To:From:Subject:Message-Id; b=HU3F7Kc57Kvq56HnCZFwUY+GYRNtqdgJO9ue0sM7bO5g4Zn6YHBIzBG/ej+2s7tWOVTDhsTTl0pMwyvE0nIccE9IJ++/KeSZSCJM1eqpToXW5MhtyUlps0jjH5T3CrghS2R3UYEUgW9FuTcZkvNwsEsr84nENMeaMxeSL4tieq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TMoxpG+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TMoxpG+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA905C116D0;
	Tue, 24 Feb 2026 17:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771955253;
	bh=UIuZVxPK9aFZrcXKIBeUE2UvVo54X57AmrkRrYdDIlM=;
	h=Date:To:From:Subject:From;
	b=TMoxpG+GkKWAgo8qKbzUdgg15HGfGnhom6jZae1Y89b5NZN9IeO6QuTyYDloSooE6
	 Ma+JP7t/kVziNyIwyTE2bG3hBv/pbxOpmD4RoGvApHxWdZiV1mIhMhRZEk3UWQf1oD
	 /duOQ1Ue/waz8GRG8ICQIlzg1a/7VxaJlm1K7UTM=
Date: Tue, 24 Feb 2026 09:47:32 -0800
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,pasha.tatashin@soleen.com,mjguzik@gmail.com,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kees@kernel.org,juri.lelli@redhat.com,dietmar.eggemann@arm.com,david@kernel.org,bsegall@google.com,ankur.a.arora@oracle.com,linusw@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-zero-vmap-stack-using-clear_pages-instead-of-memset.patch added to mm-nonmm-unstable branch
Message-Id: <20260224174732.DA905C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork: zero vmap stack using clear_pages() instead of memset()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fork-zero-vmap-stack-using-clear_pages-instead-of-memset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-zero-vmap-stack-using-clear_pages-instead-of-memset.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Linus Walleij <linusw@kernel.org>
Subject: fork: zero vmap stack using clear_pages() instead of memset()
Date: Tue, 24 Feb 2026 11:26:32 +0100

After the introduction of clear_pages() we exploit the fact that the
process vm_area is allocated in contiguous pages to just clear them all in
one swift operation.

Link: https://lkml.kernel.org/r/20260224-mm-fork-clear-pages-v1-1-184c65a72d49@kernel.org
Signed-off-by: Linus Walleij <linusw@kernel.org>
Suggested-by: Mateusz Guzik <mjguzik@gmail.com>
Link: https://lore.kernel.org/linux-mm/dpnwsp7dl4535rd7qmszanw6u5an2p74uxfex4dh53frpb7pu3@2bnjjavjrepe/
Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://lore.kernel.org/20240311164638.2015063-7-pasha.tatashin@soleen.com
Cc: Ankur Arora <ankur.a.arora@oracle.com>
Cc: Ben Segall <bsegall@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c~fork-zero-vmap-stack-using-clear_pages-instead-of-memset
+++ a/kernel/fork.c
@@ -350,7 +350,7 @@ static int alloc_thread_stack_node(struc
 		stack = kasan_reset_tag(vm_area->addr);
 
 		/* Clear stale pointers from reused stack. */
-		memset(stack, 0, THREAD_SIZE);
+		clear_pages(vm_area->addr, vm_area->nr_pages);
 
 		tsk->stack_vm_area = vm_area;
 		tsk->stack = stack;
_

Patches currently in -mm which might be from linusw@kernel.org are

fork-zero-vmap-stack-using-clear_pages-instead-of-memset.patch

