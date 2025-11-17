Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D806521638D
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343109; cv=none; b=aVGLJRDdOn6qHPejZZJ9i/56GlUao3BbxtEinDjX06mnRZFQyjg26N12+hIULmH1+9GzG0GwwpQRMxZHfDttV+ZGawsDA7G27JCro6J1bekF73Kn6QLtGh15fto1Esg+poxk7bmvi+q29zidndk8PEW/MrmkRjvoAszbYxikIPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343109; c=relaxed/simple;
	bh=6QDP8Lr9ER6rd4QwdYiGqIsVc+3x8mtCAXpxmD67YjQ=;
	h=Date:To:From:Subject:Message-Id; b=rqvCrhVCQGDVkscMg++Oskx9vUfg080FuNm1QZ6xF7T3Di9N5gP/Iu1HnG5Ov+MKqI5o1NY5nmiNwd7wAeY+3KieMPTamyc9yjDBY+xTuQPcN+1Cl3q4S8CL4jtZLFeVRl2/wx5EHPE90lpRPO5guhAxie7fAYEPwsTvo/PrW9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RkbYDFeC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RkbYDFeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2FAC116D0;
	Mon, 17 Nov 2025 01:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343109;
	bh=6QDP8Lr9ER6rd4QwdYiGqIsVc+3x8mtCAXpxmD67YjQ=;
	h=Date:To:From:Subject:From;
	b=RkbYDFeCt16YbS9eTz2flAvc0tDp3U5RZxe3ii2pcU7vm2ATHJwtQ+VNUvhnGHJhr
	 Dq/WEcyX/B2es6b3cFtUQMOd+BMCLK8ujOczU+U/s9kHr5CCwhYufvH5vn8hYxPnaZ
	 yu0S8DbIc8ctEs8dOEtLWh5J5w6hyu+adODT1t/0=
Date: Sun, 16 Nov 2025 17:31:49 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,osalvador@suse.de,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,mfo@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_owner-add-debugfs-file-show_handles.patch removed from -mm tree
Message-Id: <20251117013149.AE2FAC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: add debugfs file 'show_handles'
has been removed from the -mm tree.  Its filename was
     mm-page_owner-add-debugfs-file-show_handles.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
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
@@ -924,6 +925,8 @@ static int stack_print(struct seq_file *
 		for (i = 0; i < nr_entries; i++)
 			seq_printf(m, " %pS\n", (void *)entries[i]);
 	}
+	if (ctx->flags & STACK_PRINT_FLAG_HANDLE)
+		seq_printf(m, "handle: %d\n", stack_record->handle.handle);
 	if (ctx->flags & STACK_PRINT_FLAG_PAGES)
 		seq_printf(m, "nr_base_pages: %d\n\n", nr_base_pages);
 
@@ -995,6 +998,10 @@ static int __init pageowner_init(void)
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


