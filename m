Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70ECC34BA3C
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 02:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759977192; cv=none; b=mPQvHk2owN7qt6oIsQGgIpA17oTP0zHusOIfqmQiO0pMVbUSqpdUTTDWeI2mVJCSxyEqbiQfZ4K1LIirlXrFwo9CbKfyXhTh1G+UjM9eK3B36NjiOIPTwtgGJcCbzbN+hSxiLqRaBbCs+CyB8us73g9hHpJkG/Hh0NqCMRkZKsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759977192; c=relaxed/simple;
	bh=UoNlV/hbAahXmXmy8SBdJJhXqNY9J3oyQPjlxmJB9Es=;
	h=Date:To:From:Subject:Message-Id; b=QzC4puI/hJ1og5GjW9L4FwwlQBcnIHBtDeLT16GnlaV1m05uZNL8sLyF/z4xXgC/IQMpw4B9cRquaMVL/1mU18bGxwL76NEpWQ6PpAjkw8IXnhBBHkx5Vb52u3qZAMu3Wm2R6FiPwseHmUiKjCvQkUsZfzkAlSeTNsjsP4BNtzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CQbbmn2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CQbbmn2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D54C4CEE7;
	Thu,  9 Oct 2025 02:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759977189;
	bh=UoNlV/hbAahXmXmy8SBdJJhXqNY9J3oyQPjlxmJB9Es=;
	h=Date:To:From:Subject:From;
	b=CQbbmn2YxNdMsXCZdcpDGlnSav6JfGDZ7ErWFAwuwF8aYPM1j5ToBNxjms1S1R30R
	 XEmPA1W9hDLzX6h7QzhnUEc6w9fIFrm9vMVfaWnVFNoEwytti618D25MbZ0CcH+61Z
	 m3rZ1zHAXW2+Zp/xzpZsAGAHnKnFV6V3K43lBAMU=
Date: Wed, 08 Oct 2025 19:33:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,osalvador@suse.de,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,mfo@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-add-debugfs-file-show_handles.patch added to mm-new branch
Message-Id: <20251009023308.E7D54C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: add debugfs file 'show_handles'
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-add-debugfs-file-show_handles.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-add-debugfs-file-show_handles.patch

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
From: Mauricio Faria de Oliveira <mfo@igalia.com>
Subject: mm/page_owner: add debugfs file 'show_handles'
Date: Wed, 1 Oct 2025 14:56:09 -0300

Add the flag STACK_PRINT_FLAG_HANDLE to print a stack's handle number from
stackdepot, and add the file 'show_handles' to show just handles and their
number of pages.

This is similar to 'show_stacks', with handles instead of stack traces.

Link: https://lkml.kernel.org/r/20251001175611.575861-4-mfo@igalia.com
Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/page_owner.c~mm-page_owner-add-debugfs-file-show_handles
+++ a/mm/page_owner.c
@@ -47,6 +47,7 @@ static DEFINE_SPINLOCK(stack_list_lock);
 
 #define STACK_PRINT_FLAG_STACK		0x1
 #define STACK_PRINT_FLAG_PAGES		0x2
+#define STACK_PRINT_FLAG_HANDLE		0x4
 
 struct stack_print_ctx {
 	struct stack *stack;
@@ -921,6 +922,8 @@ static int stack_print(struct seq_file *
 		for (i = 0; i < nr_entries; i++)
 			seq_printf(m, " %pS\n", (void *)entries[i]);
 	}
+	if (ctx->flags & STACK_PRINT_FLAG_HANDLE)
+		seq_printf(m, "handle: %d\n", stack_record->handle.handle);
 	if (ctx->flags & STACK_PRINT_FLAG_PAGES)
 		seq_printf(m, "nr_base_pages: %d\n\n", nr_base_pages);
 
@@ -992,6 +995,10 @@ static int __init pageowner_init(void)
 			    (void *)(STACK_PRINT_FLAG_STACK |
 				     STACK_PRINT_FLAG_PAGES),
 			    &page_owner_stack_operations);
+	debugfs_create_file("show_handles", 0400, dir,
+			    (void *)(STACK_PRINT_FLAG_HANDLE |
+				     STACK_PRINT_FLAG_PAGES),
+			    &page_owner_stack_operations);
 	debugfs_create_file("count_threshold", 0600, dir, NULL,
 			    &proc_page_owner_threshold);
 
_

Patches currently in -mm which might be from mfo@igalia.com are

mm-page_owner-introduce-struct-stack_print_ctx.patch
mm-page_owner-add-struct-stack_print_ctxflags.patch
mm-page_owner-add-debugfs-file-show_handles.patch
mm-page_owner-add-debugfs-file-show_stacks_handles.patch
mm-page_owner-update-documentation-with-show_handles-and-show_stacks_handles.patch

