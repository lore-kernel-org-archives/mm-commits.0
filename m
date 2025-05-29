Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916364685
	for <mm-commits@vger.kernel.org>; Thu, 29 May 2025 19:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748546809; cv=none; b=HhV/8+6UsjuI6vkBYbZIl1J6Hd8qWxuUxSxMiWfaD7FH2SCByOPDK45tzriIgwr8uKyseOtIXZOONrKxBmxA2Gteflg0IkGh2Si7qL2XCFUHGa853NQx0bomV7cLJRc0nLmwtlo1WO+Z4IHn/0vPdAq59tPOlWJM1LEeKHIPejQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748546809; c=relaxed/simple;
	bh=j10wbo1JwlQBcjxt/LaOavb0p0dqBTAnt2O15ddEnAA=;
	h=Date:To:From:Subject:Message-Id; b=jc4UYgtMnn4tHBYruXwl2kaXGdExDCaRk/O9UF1JgTRX7zfWC7tes0HFBbNh6UINqL+AZC/zN9Y6PJoWiGZxascxiOI769vAbSQlzbi3YX3ywDz1NjR8Ap9JuXcujLZYcOAhxbPqUAFm3dFkGmRheMH9ajwGlF9M/OHjaTTdobE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H6za3EKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H6za3EKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D932FC4CEE7;
	Thu, 29 May 2025 19:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748546808;
	bh=j10wbo1JwlQBcjxt/LaOavb0p0dqBTAnt2O15ddEnAA=;
	h=Date:To:From:Subject:From;
	b=H6za3EKjVb/Sn6YOwcZGzGGVKjkgCcz/uUBCCCTqCYNToC7osBZkGKbU+IJ99SKMP
	 6LH+UHaU796sMMEZh3JAgo6EK4QXkK4wTi88ht+fslRzbDVA45nWTD6JBPI0+nbvTf
	 BLivUR9rhaOnCGC9D7lnWEwsrFtoAZ2nSq7Ux09A=
Date: Thu, 29 May 2025 12:26:48 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterz@infradead.org,oleg@redhat.com,mhiramat@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,pulehui@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-expose-abnormal-new_pte-during-move_ptes.patch added to mm-unstable branch
Message-Id: <20250529192648.D932FC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: expose abnormal new_pte during move_ptes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-expose-abnormal-new_pte-during-move_ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-expose-abnormal-new_pte-during-move_ptes.patch

This patch will later appear in the mm-unstable branch at
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
From: Pu Lehui <pulehui@huawei.com>
Subject: mm: expose abnormal new_pte during move_ptes
Date: Thu, 29 May 2025 15:56:48 +0000

When executing move_ptes, the new_pte must be NULL, otherwise it will be
overwritten by the old_pte, and cause the abnormal new_pte to be leaked. 
In order to make this problem to be more explicit, let's add WARN_ON_ONCE
when new_pte is not NULL.

Link: https://lkml.kernel.org/r/20250529155650.4017699-3-pulehui@huaweicloud.com
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/mremap.c~mm-expose-abnormal-new_pte-during-move_ptes
+++ a/mm/mremap.c
@@ -237,6 +237,8 @@ static int move_ptes(struct pagetable_mo
 
 	for (; old_addr < old_end; old_pte++, old_addr += PAGE_SIZE,
 				   new_pte++, new_addr += PAGE_SIZE) {
+		WARN_ON_ONCE(!pte_none(*new_pte));
+
 		if (pte_none(ptep_get(old_pte)))
 			continue;
 
_

Patches currently in -mm which might be from pulehui@huawei.com are

mm-fix-uprobe-pte-be-overwritten-when-expanding-vma.patch
mm-expose-abnormal-new_pte-during-move_ptes.patch
selftests-mm-extract-read_sysfs-and-write_sysfs-into-vm_util.patch
selftests-mm-add-test-about-uprobe-pte-be-orphan-during-vma-merge.patch

