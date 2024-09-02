Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC59D79C0
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725246584; cv=none; b=DML8PJO08QeJzHQkOY8gLMStPvMC8gwsgwzNFTgDYo77KW++oRqn3mu37J4OP3x18puRZ7xO30f0vjU1Vhi0PFTCT6TH9KDJv12/pyh/cg8GEWFSSdS0M/CbZPW5KTuZYzYsUqvVk011jFp/Kd7SQa+0UR4xypzKK6Cci7wFMlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725246584; c=relaxed/simple;
	bh=Axf2esi+Vb+gn5YqmkpeTaPGuMcIIc0prLZhSvs6u6Q=;
	h=Date:To:From:Subject:Message-Id; b=QDwL9CcXju+rIMPUtNEXyY4wV8SuvN2fE1JBqvX8LhrpE7gcw+49gbKajsvJTn5oGmNTV3RP5x7G288gB5ExNxH6l/egIUeX6d5AAQ29Hwb3+2JeDJXdLwff34nyV/KFNxGDPJP1NaBDRbzUkuw9fgnS5xoiAR97nCoAApwLoBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FIHUnOEX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FIHUnOEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB40C4CEC3;
	Mon,  2 Sep 2024 03:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725246584;
	bh=Axf2esi+Vb+gn5YqmkpeTaPGuMcIIc0prLZhSvs6u6Q=;
	h=Date:To:From:Subject:From;
	b=FIHUnOEXOkMCpt0ZvqyBWDDNGt09XXjNOC5TJbCflMNtHEBlYbtD7LCuMqD+88KpV
	 3gkXiRlSj0UTYfl0hh6dmButEjgvgqPCButEQUaKbJIjLfrIo74yPkAX8BtWNL7KQH
	 bZfaX+1/5rrn6EatPLOl76aRQoCTZUxTZ8iJCUIQ=
Date: Sun, 01 Sep 2024 20:09:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shuah@kernel.org,rmoar@google.com,pengfei.xu@intel.com,Liam.Howlett@oracle.com,kees@kernel.org,jack@suse.cz,ebiederm@xmission.com,davidgow@google.com,brendanhiggins@google.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc-fix.patch removed from -mm tree
Message-Id: <20240902030944.6EB40C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: userfaultfd: fix user-after-free in userfaultfd_clear_vma()
has been removed from the -mm tree.  Its filename was
     userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc-fix.patch

This patch was dropped because it was folded into userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: userfaultfd: fix user-after-free in userfaultfd_clear_vma()
Date: Wed, 7 Aug 2024 12:44:27 +0100

After invoking vma_modify_flags_uffd() in userfaultfd_clear_vma(), we may
have merged the vma, and depending on the kind of merge, deleted the vma,
rendering the vma pointer invalid.

The code incorrectly referenced this now possibly invalid vma pointer when
invoking userfaultfd_reset_ctx().

If no merge is possible, vma_modify_flags_uffd() performs a split and
returns the original vma.  Therefore the correct approach is to simply
pass the ret pointer to userfaultfd_ret_ctx().

Link: https://lkml.kernel.org/r/3c947ddc-b804-49b7-8fe9-3ea3ca13def5@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Closes: https://lore.kernel.org/all/ZrLt9HIxV9QiZotn@xpf.sh.intel.com/
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Gow <davidgow@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rae Moar <rmoar@google.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/userfaultfd.c~userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc-fix
+++ a/mm/userfaultfd.c
@@ -1816,7 +1816,7 @@ struct vm_area_struct *userfaultfd_clear
 	 * the current one has not been updated yet.
 	 */
 	if (!IS_ERR(ret))
-		userfaultfd_reset_ctx(vma);
+		userfaultfd_reset_ctx(ret);
 
 	return ret;
 }
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc.patch
mm-move-vma_modify-and-helpers-to-internal-header.patch
mm-move-vma_shrink-vma_expand-to-internal-header.patch
mm-move-internal-core-vma-manipulation-functions-to-own-file.patch
maintainers-add-entry-for-new-vma-files.patch
tools-separate-out-shared-radix-tree-components.patch
tools-add-skeleton-code-for-userland-testing-of-vma-logic.patch
tools-improve-vma-test-makefile.patch
tools-add-vma-merge-tests.patch
mm-introduce-vma_merge_struct-and-abstract-vma_mergevma_modify.patch
mm-remove-duplicated-open-coded-vma-policy-check.patch
mm-abstract-vma_expand-to-use-vma_merge_struct.patch
mm-avoid-using-vma_merge-for-new-vmas.patch
mm-make-vma_prepare-and-friends-static-and-internal-to-vmac.patch
mm-introduce-commit_merge-abstracting-final-commit-of-merge.patch
mm-refactor-vma_merge-into-modify-only-vma_merge_existing_range.patch
mm-rework-vm_ops-close-handling-on-vma-merge.patch

