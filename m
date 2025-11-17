Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674521E1DE9
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343111; cv=none; b=lvHlbhgX28Bke84MB8Qi7ZtAJZNWi71ScrZJjcFVOm9sMg1PVgGnqE20/j6w6waUPQdcs3VcIPEGllIQ5WrWhplKDDkxvOqLRJfkG1oKF0XFjx7wrKWOh8o0L+FnOtIU8CAvJRUz8CIhwz7xs5Tlta0YHwpliOFIwIENwcz1Wag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343111; c=relaxed/simple;
	bh=MaOoUwaBAQOvGXYm32irKGkFHuNkZRoCASh+aDpvyLo=;
	h=Date:To:From:Subject:Message-Id; b=ao8DN+u5aXcpUAT9a4jH+6FIbXW24LsOfuyTsbW+yFhcv1VTpkm5eV4oIjKtn++VztB6o0AW3WIwE1Xv23mV/oKiJcUJt8aXBN+BmTSPskqU+zAVXsGhxZK5Etl+veFkwidlGSXXuQ0PMvARuek+I4OQkDRYWo10dP1Hf8K6wrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U/jpUODM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U/jpUODM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01B4C4CEF1;
	Mon, 17 Nov 2025 01:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343111;
	bh=MaOoUwaBAQOvGXYm32irKGkFHuNkZRoCASh+aDpvyLo=;
	h=Date:To:From:Subject:From;
	b=U/jpUODMnKu8VPRMNmJLKU3liDBf08RsEa5I8CsdPKg5CSBVa0gZw6N1xqhvZ9Fvw
	 IdaAU/DixPCD5X3XWcBE0i2OfhoM0V11931G2FV11ZQUUt4xIGM2ApTngymuPWme5D
	 3CpT/F4gAaAMrXA786sMx/kdnCiOWFaGrAK9TH20=
Date: Sun, 16 Nov 2025 17:31:50 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,osalvador@suse.de,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,mfo@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_owner-add-debugfs-file-show_stacks_handles.patch removed from -mm tree
Message-Id: <20251117013150.F01B4C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: add debugfs file 'show_stacks_handles'
has been removed from the -mm tree.  Its filename was
     mm-page_owner-add-debugfs-file-show_stacks_handles.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -916,7 +916,8 @@ static int stack_print(struct seq_file *
 
 	nr_base_pages = refcount_read(&stack_record->count) - 1;
 
-	if (nr_base_pages < 1 || nr_base_pages < page_owner_pages_threshold)
+	if (ctx->flags & STACK_PRINT_FLAG_PAGES &&
+	    (nr_base_pages < 1 || nr_base_pages < page_owner_pages_threshold))
 		return 0;
 
 	if (ctx->flags & STACK_PRINT_FLAG_STACK) {
@@ -928,7 +929,8 @@ static int stack_print(struct seq_file *
 	if (ctx->flags & STACK_PRINT_FLAG_HANDLE)
 		seq_printf(m, "handle: %d\n", stack_record->handle.handle);
 	if (ctx->flags & STACK_PRINT_FLAG_PAGES)
-		seq_printf(m, "nr_base_pages: %d\n\n", nr_base_pages);
+		seq_printf(m, "nr_base_pages: %d\n", nr_base_pages);
+	seq_putc(m, '\n');
 
 	return 0;
 }
@@ -1002,6 +1004,10 @@ static int __init pageowner_init(void)
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


