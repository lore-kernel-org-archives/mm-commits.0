Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA7826CE2B
	for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2025 22:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755125138; cv=none; b=cpcwc6xhqgS7iKGYDzGcKswfimpmiMc47ZkD8609X7mqOOK+LjXzp943Fkna/SjxCoph/0X76uCR1BvobhR+Lb1xPybeMctfXVL+gagN1aeDyljffPeeVBCp0raW0pYPjRlXTSpOWRJZcXy+ZYLHZKJdfYX95YxbOLPavQOAKA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755125138; c=relaxed/simple;
	bh=m2GL2WCLphmXDikeaqL1a/Qv9iw6/RTAw5aimYSZYbY=;
	h=Date:To:From:Subject:Message-Id; b=Q+gDuAaE0xpUYC+C9hUThaua+bFyF36eC/HcVEtxacLPrFnuqI1qnhD3ZwYNVXMUmmUMN9UUUGECoSI+BTvycY1ZumVZ0BLMwY89VYlRQImvVG7rcPcGjs8Vd/jo9m7Ljjro6bIKh/1cXHK1KEufKS6CgAF4e0WWWYeXsybsAzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nfjPGWuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nfjPGWuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7CF6C4CEEB;
	Wed, 13 Aug 2025 22:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755125138;
	bh=m2GL2WCLphmXDikeaqL1a/Qv9iw6/RTAw5aimYSZYbY=;
	h=Date:To:From:Subject:From;
	b=nfjPGWuheB9HKt+Zojt511/CgG/GhoK8EqvRLez5vx3H9KenxXswsOU8zh8tUcgOJ
	 Ep7xrdrzIRV/VuWI9jIzlQtEeCO6bK/6AqaEeMiQOKcILc+1Q4SQmV6iDv+95dT0wB
	 Ofd294f+cR8TESUjOY07YrgJR/0Z4tf6tyEEju0M=
Date: Wed, 13 Aug 2025 15:45:37 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,dev.jain@arm.com,liaoyuanhong@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-redundant-semicolons.patch added to mm-new branch
Message-Id: <20250813224537.E7CF6C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_maple_tree.c: remove redundant semicolons
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-remove-redundant-semicolons.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-redundant-semicolons.patch

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
From: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: lib/test_maple_tree.c: remove redundant semicolons
Date: Wed, 13 Aug 2025 17:45:43 +0800

Remove unnecessary semicolons.

Link: https://lkml.kernel.org/r/20250813094543.555906-1-liaoyuanhong@vivo.com
Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_maple_tree.c~maple_tree-remove-redundant-semicolons
+++ a/lib/test_maple_tree.c
@@ -3562,7 +3562,7 @@ static noinline void __init check_state_
 	MT_BUG_ON(mt, mas.last != 0x1500);
 	MT_BUG_ON(mt, !mas_is_active(&mas));
 
-	/* find: start ->active on value */;
+	/* find: start ->active on value */
 	mas_set(&mas, 1200);
 	entry = mas_find(&mas, ULONG_MAX);
 	MT_BUG_ON(mt, entry != ptr);
_

Patches currently in -mm which might be from liaoyuanhong@vivo.com are

maple_tree-remove-redundant-semicolons.patch
lib-digsig-remove-unnecessary-memset.patch

