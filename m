Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3F633993
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 02:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759977193; cv=none; b=ienK4fFEiZm/7e0RNzxHPnuvhNqFXb66CcVJA6CuFO3XiE3Lz1IWQvM4BmmoE7dRraU7rBeUMEVluu2cdAZGGdhA++lvqCcKs+KWFexUSZiG1F5YzHuR2C0JIlI3vmzk/azb0M4FrBsN+95sYw5S2hytO9iILUg4/1xknTto5JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759977193; c=relaxed/simple;
	bh=YSeKut1TQDpXVPtxDA50FVffw/4htzBianAHzj/msMU=;
	h=Date:To:From:Subject:Message-Id; b=rCxbQoFGPA2Gz+7JRdG0bgwOpMySGtqRc1/UuXOGur+ao8BBr0I65QFM1Kn57ndNkZwizx4RTMxISgcOd6NtCxULlBETw3S2MuiilMVxLWvUb/E2RZCbweS4/uq9wcKbooLTlADyMQvrI3CbH7pijDjMxgoK1FvnZDklOdVLI8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e7PybNbD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e7PybNbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03523C4CEF5;
	Thu,  9 Oct 2025 02:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759977193;
	bh=YSeKut1TQDpXVPtxDA50FVffw/4htzBianAHzj/msMU=;
	h=Date:To:From:Subject:From;
	b=e7PybNbDwBN2eGP1uCBiO/Cyt1iYKhb1z5d3kNB2Wxw8gtLYH0S4LZz6iisKvxYJH
	 kbiA/KNvp30EUAMtU8BP9A+aoWzKY9pcYIRFffqu3n2lBdsNz/sXI3CVlxztTMc3A0
	 SQ/B7XwuuiKA6Y0pn1Y2qBWECG2ezR70TEt7+kHQ=
Date: Wed, 08 Oct 2025 19:33:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,osalvador@suse.de,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,mfo@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-add-debugfs-file-show_stacks_handles.patch added to mm-new branch
Message-Id: <20251009023313.03523C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: add debugfs file 'show_stacks_handles'
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-add-debugfs-file-show_stacks_handles.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-add-debugfs-file-show_stacks_handles.patch

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
Subject: mm/page_owner: add debugfs file 'show_stacks_handles'
Date: Wed, 1 Oct 2025 14:56:10 -0300

Add the file 'show_stacks_handles' to show just stack traces and their
handles, in order to resolve stack traces and handles (i.e., to identify
the stack traces for handles in previous reads from 'show_handles').

All stacks/handles must show up, regardless of their number of pages, that
might have become zero or no longer make 'count_threshold', but made it in
previous reads from 'show_handles' -- and need to be resolved later.

P.S.: now, print the extra newline independently of the number of pages.

Link: https://lkml.kernel.org/r/20251001175611.575861-5-mfo@igalia.com
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

 mm/page_owner.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-add-debugfs-file-show_stacks_handles
+++ a/mm/page_owner.c
@@ -913,7 +913,8 @@ static int stack_print(struct seq_file *
 
 	nr_base_pages = refcount_read(&stack_record->count) - 1;
 
-	if (nr_base_pages < 1 || nr_base_pages < page_owner_pages_threshold)
+	if (ctx->flags & STACK_PRINT_FLAG_PAGES &&
+	    (nr_base_pages < 1 || nr_base_pages < page_owner_pages_threshold))
 		return 0;
 
 	if (ctx->flags & STACK_PRINT_FLAG_STACK) {
@@ -925,7 +926,8 @@ static int stack_print(struct seq_file *
 	if (ctx->flags & STACK_PRINT_FLAG_HANDLE)
 		seq_printf(m, "handle: %d\n", stack_record->handle.handle);
 	if (ctx->flags & STACK_PRINT_FLAG_PAGES)
-		seq_printf(m, "nr_base_pages: %d\n\n", nr_base_pages);
+		seq_printf(m, "nr_base_pages: %d\n", nr_base_pages);
+	seq_putc(m, '\n');
 
 	return 0;
 }
@@ -999,6 +1001,10 @@ static int __init pageowner_init(void)
 			    (void *)(STACK_PRINT_FLAG_HANDLE |
 				     STACK_PRINT_FLAG_PAGES),
 			    &page_owner_stack_operations);
+	debugfs_create_file("show_stacks_handles", 0400, dir,
+			    (void *)(STACK_PRINT_FLAG_STACK |
+				     STACK_PRINT_FLAG_HANDLE),
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

