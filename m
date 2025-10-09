Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9163E19D8BC
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 02:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759977196; cv=none; b=uNMPRZaaYAXBCknmyTg0piSdo0cLouJYa7XXXB+70qrh1tr/kFs8PKPCwhizseEyPA8cO5KGHJ+CNn3e5OVMBr8oCwW11kXIIComw0TK/dgjsr+CdkvG0voNQnYpsEKcim2gcfc+noPd/QYyo0gXcg1n3qQIsDNw2HF8F3w7rNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759977196; c=relaxed/simple;
	bh=uqHZPRXJuujEbShnC6YXyEQnByHf7KcNOKMuwrMVmDQ=;
	h=Date:To:From:Subject:Message-Id; b=Bq0jNmNAcyO6AViNJbwSKfHLGafcYlAPB9SB23sZmw0WYjP8/sMvUjijtIrIMel8Rd8haSF+WJ0o4V3YZuHgKxMiKB24AHtc6uhb1MBOavhATpU6WVfoWEShD/ns6gkxGARjNhFzmvBx65JCFNhwbJ2Ue24CSGNQIgW+qp22kAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ijauehPg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ijauehPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B25CC4CEE7;
	Thu,  9 Oct 2025 02:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759977195;
	bh=uqHZPRXJuujEbShnC6YXyEQnByHf7KcNOKMuwrMVmDQ=;
	h=Date:To:From:Subject:From;
	b=ijauehPgWq/A/LcS/kr83nvxy2Vf5x6V+buAii3uCFqR8GKy2V//VDYnq1RncF/q4
	 KPyAAVijQaxMX+FtvWItpoU8mWa/LqnuDF9qaQBXZ62tg9Hq2iDOQja9Pj3gWgk83R
	 WW0cBcYhqivqLrt8ius/GTv2KkcdOX3PyRl/EWbc=
Date: Wed, 08 Oct 2025 19:33:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,osalvador@suse.de,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,mfo@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-update-documentation-with-show_handles-and-show_stacks_handles.patch added to mm-new branch
Message-Id: <20251009023315.0B25CC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: update Documentation with 'show_handles' and 'show_stacks_handles'
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-update-documentation-with-show_handles-and-show_stacks_handles.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-update-documentation-with-show_handles-and-show_stacks_handles.patch

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
Subject: mm/page_owner: update Documentation with 'show_handles' and 'show_stacks_handles'
Date: Wed, 1 Oct 2025 14:56:11 -0300

Describe and provide examples for 'show_handles' and 'show_stacks_handles'.

Link: https://lkml.kernel.org/r/20251001175611.575861-6-mfo@igalia.com
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

 Documentation/mm/page_owner.rst |   32 +++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

--- a/Documentation/mm/page_owner.rst~mm-page_owner-update-documentation-with-show_handles-and-show_stacks_handles
+++ a/Documentation/mm/page_owner.rst
@@ -27,7 +27,10 @@ enabled. Other usages are more than welc
 It can also be used to show all the stacks and their current number of
 allocated base pages, which gives us a quick overview of where the memory
 is going without the need to screen through all the pages and match the
-allocation and free operation.
+allocation and free operation. It's also possible to show only a numeric
+identifier of all the stacks (without stack traces) and their number of
+allocated base pages (faster to read and parse, eg, for monitoring) that
+can be matched with stacks later (show_handles and show_stacks_handles).
 
 page owner is disabled by default. So, if you'd like to use it, you need
 to add "page_owner=on" to your boot cmdline. If the kernel is built
@@ -116,6 +119,33 @@ Usage
 	nr_base_pages: 20824
 	...
 
+	cat /sys/kernel/debug/page_owner_stacks/show_handles > handles_7000.txt
+	cat handles_7000.txt
+	handle: 42
+	nr_base_pages: 20824
+	...
+
+	cat /sys/kernel/debug/page_owner_stacks/show_stacks_handles > stacks_handles.txt
+	cat stacks_handles.txt
+	 post_alloc_hook+0x177/0x1a0
+	 get_page_from_freelist+0xd01/0xd80
+	 __alloc_pages+0x39e/0x7e0
+	 alloc_pages_mpol+0x22e/0x490
+	 folio_alloc+0xd5/0x110
+	 filemap_alloc_folio+0x78/0x230
+	 page_cache_ra_order+0x287/0x6f0
+	 filemap_get_pages+0x517/0x1160
+	 filemap_read+0x304/0x9f0
+	 xfs_file_buffered_read+0xe6/0x1d0 [xfs]
+	 xfs_file_read_iter+0x1f0/0x380 [xfs]
+	 __kernel_read+0x3b9/0x730
+	 kernel_read_file+0x309/0x4d0
+	 __do_sys_finit_module+0x381/0x730
+	 do_syscall_64+0x8d/0x150
+	 entry_SYSCALL_64_after_hwframe+0x62/0x6a
+	handle: 42
+	...
+
 	cat /sys/kernel/debug/page_owner > page_owner_full.txt
 	./page_owner_sort page_owner_full.txt sorted_page_owner.txt
 
_

Patches currently in -mm which might be from mfo@igalia.com are

mm-page_owner-introduce-struct-stack_print_ctx.patch
mm-page_owner-add-struct-stack_print_ctxflags.patch
mm-page_owner-add-debugfs-file-show_handles.patch
mm-page_owner-add-debugfs-file-show_stacks_handles.patch
mm-page_owner-update-documentation-with-show_handles-and-show_stacks_handles.patch

