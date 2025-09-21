Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D6128DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489803; cv=none; b=lWuokcIp8vOOPFw2maEBDOAeLdLnJKQ/6B08jdBhXJ3j01KMez05xXCTUMBmgy6mbv2We5NiWQYSboO1T8Hitz7Jgagfz48QIPCmSgHZScmoLbovFMOIWX6AelGx2LeZKHJirD8yxpQ8BbTfVxvcxKlW6CBUHUGemNoJDmm8H6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489803; c=relaxed/simple;
	bh=gcRjg0ZgfekZLMOAHcz89oGFIVjuu1DcTxXyK53RBnY=;
	h=Date:To:From:Subject:Message-Id; b=V1oB8TnOwNDOjVOShIFUnoPwj2Xo0Rbd08H7zGyFfs1iSNwEOn5MPBdxcgHxe/en7S8j5twOFUq3mNDGfnTifN17o9t9juQBJjWUW3huV29dJ8/fqxw3X7zEoMq6NfDwr4wOjXmPKLhWLEwIxlS+Ufrvcgjvl2372s7azKrT2aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h+thArmO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h+thArmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698A4C4CEE7;
	Sun, 21 Sep 2025 21:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489801;
	bh=gcRjg0ZgfekZLMOAHcz89oGFIVjuu1DcTxXyK53RBnY=;
	h=Date:To:From:Subject:From;
	b=h+thArmOVM+5GLHUQ7xgJlAV0ySekqxKdZfWwNJI51a+Ae0PfouOzEsy/WgHO5yt9
	 NpVZt7Ov0AVb02GEL7E1nYcXRVNjQpYc79GzKhzoPX5FSa74aR4miHpTZYdIgr98tZ
	 k3HwluU7UYg/Za945z9NAuKoAke8Wuqb3J0L7+tU=
Date: Sun, 21 Sep 2025 14:23:20 -0700
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,linus.walleij@linaro.org,Liam.Howlett@oracle.com,kees@kernel.org,juri.lelli@redhat.com,dietmar.eggemann@arm.com,david@redhat.com,bsegall@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fork-check-charging-success-before-zeroing-stack.patch removed from -mm tree
Message-Id: <20250921212321.698A4C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fork: check charging success before zeroing stack
has been removed from the -mm tree.  Its filename was
     fork-check-charging-success-before-zeroing-stack.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: fork: check charging success before zeroing stack
Date: Fri, 29 Aug 2025 13:44:40 +0200

Patch series "mm: task_stack: Stack handling cleanups".

These are some small cleanups for the fork code that was split off from
Pasha:s dynamic stack patch series, they are generally nice on their own
so let's propose them for merging.


This patch (of 2):

No need to do zero cached stack if memcg charge fails, so move the
charging attempt before the memset operation.

Link: https://lkml.kernel.org/r/20250829-fork-cleanups-for-dynstack-v1-0-3bbaadce1f00@linaro.org
Link: https://lkml.kernel.org/r/20250829-fork-cleanups-for-dynstack-v1-1-3bbaadce1f00@linaro.org
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://lore.kernel.org/20240311164638.2015063-6-pasha.tatashin@soleen.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ben Segall <bsegall@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
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

 kernel/fork.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/fork.c~fork-check-charging-success-before-zeroing-stack
+++ a/kernel/fork.c
@@ -290,6 +290,11 @@ static int alloc_thread_stack_node(struc
 		if (!vm_area)
 			continue;
 
+		if (memcg_charge_kernel_stack(vm_area)) {
+			vfree(vm_area->addr);
+			return -ENOMEM;
+		}
+
 		/* Reset stack metadata. */
 		kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
 
@@ -298,11 +303,6 @@ static int alloc_thread_stack_node(struc
 		/* Clear stale pointers from reused stack. */
 		memset(stack, 0, THREAD_SIZE);
 
-		if (memcg_charge_kernel_stack(vm_area)) {
-			vfree(vm_area->addr);
-			return -ENOMEM;
-		}
-
 		tsk->stack_vm_area = vm_area;
 		tsk->stack = stack;
 		return 0;
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are


