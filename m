Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4C927C14E
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 17:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747849747; cv=none; b=G6nr9krOnNbTTF6LZ5CqF5BqenFInbgKFcl9k+8rWjA5QHBEJWZo8KUV6SdUQxARAVxgF6pB1hgqiMPb+/eHcV5BoL2+wYXxLszt0zFgIrlsRdaW791hMvw+wc141WczNwN8aRi2R335FU/aUo8Y6SVh92zLn2aw78Us2/ZTFZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747849747; c=relaxed/simple;
	bh=LEyn4vQBN9lp7E3+4ULLPTp7cOQixX46zuyL4sc6938=;
	h=Date:To:From:Subject:Message-Id; b=sY3/VFivpX5VrM5GZhuzCU1KEZvRnwdd34itxRUCu2rIJZwjG24F+QxeNIfMwK3/FsY4FKako3Pvp4Cv0umeOsdmfvZvdB6eTj/tj7Fjx6MOrJ3YalUHbvJHdN4X5NvatbZrQcYyJIq8zmYv5T0xjjK7lNP7INO7fVIUbLQ/zRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iXiyfyDO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iXiyfyDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1D2C4CEE4;
	Wed, 21 May 2025 17:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747849746;
	bh=LEyn4vQBN9lp7E3+4ULLPTp7cOQixX46zuyL4sc6938=;
	h=Date:To:From:Subject:From;
	b=iXiyfyDOqqKfk5TobPyxJZoORxkyN4QxQEDV9QsH3l7i4JOoBakMKo+6rIlGTUJ2L
	 L+neNtjUe2ESwyXKZkvPzcikb5Me6fZW9F95jEMy1q6a1ZrrI5RYHlJZj2AAphfL6z
	 KYh4iuLFWzDSO+/fI81tjKxv07BvfyhAltSFfoS4=
Date: Wed, 21 May 2025 10:49:06 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,linus.walleij@linaro.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fork-check-charging-success-before-zeroing-stack.patch removed from -mm tree
Message-Id: <20250521174906.9D1D2C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fork: check charging success before zeroing stack
has been removed from the -mm tree.  Its filename was
     fork-check-charging-success-before-zeroing-stack.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: fork: check charging success before zeroing stack
Date: Fri, 09 May 2025 08:29:28 +0200

No need to do zero cached stack if memcg charge fails, so move the
charging attempt before the memset operation.

[linus.walleij@linaro.org: rebased]
Link: https://lkml.kernel.org/r/20250509-fork-fixes-v3-3-e6c69dd356f2@linaro.org
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://lore.kernel.org/20240311164638.2015063-6-pasha.tatashin@soleen.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/fork.c~fork-check-charging-success-before-zeroing-stack
+++ a/kernel/fork.c
@@ -280,6 +280,11 @@ static int alloc_thread_stack_node(struc
 		if (!vm_area)
 			continue;
 
+		if (memcg_charge_kernel_stack(vm_area)) {
+			vfree(vm_area->addr);
+			return -ENOMEM;
+		}
+
 		/* Reset stack metadata. */
 		kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
 
@@ -288,11 +293,6 @@ static int alloc_thread_stack_node(struc
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


