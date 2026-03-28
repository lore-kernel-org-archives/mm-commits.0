Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C207337BB0
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671974; cv=none; b=hffHABGBki2AJFeJeLkOQibqIi2qe/CcdmtT5caxOg0VDkwQcNMOtpsp8qPt6LvurTmKKdJS711ecYIe94yWXVT4LfCHU/M7L1KYm7HvD26JOVWreQmMB1VEoDvjj+FE1K9PhPIbf35NYIgK8d0ejYmkq5SViB1qOZVpGyJn5B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671974; c=relaxed/simple;
	bh=GIsZxcpj7H/BYE9ipxJYD3RmFjIC/7Z0gkaCB6PtBzg=;
	h=Date:To:From:Subject:Message-Id; b=Vv9VM/cdt0FAKpgHYIVz5vrMHLHl47h7K1DGRFDW16DjL4oJdpBec19PLR1mCNThdwov0t/boR11aDucb1AEbWh1AahZizHYom8YHQQwmFXgb28H5k8VfjxdBKM3qmiNmt4bwlfwb6ru58wnbYaLNfsSAZuJQ2Wv2LGz+SWVuNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rgLowpUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rgLowpUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A88C4CEF7;
	Sat, 28 Mar 2026 04:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671974;
	bh=GIsZxcpj7H/BYE9ipxJYD3RmFjIC/7Z0gkaCB6PtBzg=;
	h=Date:To:From:Subject:From;
	b=rgLowpUHUJJX9E/FNFvqzA72gcU72fLW2UW2GQRWTpFc7t8kAGg8d+seyBWpQhUCQ
	 dXq6EtdR8wFg4VgX+/9aaz23V8G8WeByq5sNTBF2lLk7/Z/0NqbcIAEP9dRo+tLin2
	 IGXcERuZwQPTmYk+PTmscGEdXVhtGVTHrt0X2AnI=
Date: Fri, 27 Mar 2026 21:26:13 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,pasha.tatashin@soleen.com,mjguzik@gmail.com,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,ljs@kernel.org,liam.howlett@oracle.com,kees@kernel.org,juri.lelli@redhat.com,dietmar.eggemann@arm.com,david@kernel.org,bsegall@google.com,ankur.a.arora@oracle.com,linusw@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fork-zero-vmap-stack-using-clear_pages-instead-of-memset.patch removed from -mm tree
Message-Id: <20260328042614.03A88C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fork: zero vmap stack using clear_pages() instead of memset()
has been removed from the -mm tree.  Its filename was
     fork-zero-vmap-stack-using-clear_pages-instead-of-memset.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>
Cc: Ben Segall <bsegall@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
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
@@ -345,7 +345,7 @@ static int alloc_thread_stack_node(struc
 		stack = kasan_reset_tag(vm_area->addr);
 
 		/* Clear stale pointers from reused stack. */
-		memset(stack, 0, THREAD_SIZE);
+		clear_pages(vm_area->addr, vm_area->nr_pages);
 
 		tsk->stack_vm_area = vm_area;
 		tsk->stack = stack;
_

Patches currently in -mm which might be from linusw@kernel.org are


