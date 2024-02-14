Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F43134740
	for <mm-commits@vger.kernel.org>; Wed, 14 Feb 2024 18:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707935561; cv=none; b=d0VRZYvBxDXuQ1fxC7rcpKFkF3bK4KVzvU619DZkDLMHWWtjDFX1c1krFEQMB1uvceFa8ogMqqnNYTLipKzJVhlYfOk+RHDDG4MpEVRL3ToGlrEVNul+jKg2lzhl8Vu5klss4IKttR5DcVQVhfivi6G+iddvvl+yl1OKH3qp1kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707935561; c=relaxed/simple;
	bh=idBxVE0LK5EjLleT6ESH2tIJgqL5l8ESvseMEciUHjE=;
	h=Date:To:From:Subject:Message-Id; b=ufFvCekQSNSUNqmBrAObu9rntcltbcezB3AXCpFJ9VjH4krfseBUgUSVFwi0zygwf+7nHg+E/2L4iF04VFqeg5NIoUYp0uuggqnt681vueP0qcRgp0mnYYEZp113YVpFgRjnSmqM38Qww1s81CW1kFTB9oYn7/j2WrM4Ae4IsrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d6Qvatox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d6Qvatox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC80C433F1;
	Wed, 14 Feb 2024 18:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707935560;
	bh=idBxVE0LK5EjLleT6ESH2tIJgqL5l8ESvseMEciUHjE=;
	h=Date:To:From:Subject:From;
	b=d6QvatoxEJ7R27SobfUyaRs9oqDC+AKEgg/qpYMqjcotqTDhaOD0jX8K6HG9HeKmg
	 alaAG3ZIywXA9ksSum3bV66tih5JF9zyzj37wXctaKV7h5+7n5J5htnZ3c6lqCdWcd
	 Q6DwMqimikZee220N69CFtEAvdLLtTKCCbd2ZevE=
Date: Wed, 14 Feb 2024 10:32:40 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmpage_owner-filter-out-stacks-by-a-threshold.patch added to mm-unstable branch
Message-Id: <20240214183240.BEC80C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,page_owner: filter out stacks by a threshold
has been added to the -mm mm-unstable branch.  Its filename is
     mmpage_owner-filter-out-stacks-by-a-threshold.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmpage_owner-filter-out-stacks-by-a-threshold.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,page_owner: filter out stacks by a threshold
Date: Wed, 14 Feb 2024 18:01:56 +0100

We want to be able to filter out the stacks based on a threshold we can
can tune.  By writing to 'count_threshold' file, we can adjust the
threshold value.

Link: https://lkml.kernel.org/r/20240214170157.17530-7-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

--- a/mm/page_owner.c~mmpage_owner-filter-out-stacks-by-a-threshold
+++ a/mm/page_owner.c
@@ -846,9 +846,11 @@ static void *stack_next(struct seq_file
 	return stack;
 }
 
+static unsigned long page_owner_stack_threshold;
+
 static int stack_print(struct seq_file *m, void *v)
 {
-	int i;
+	int i, stack_count;
 	struct stack *stack = v;
 	unsigned long *entries;
 	unsigned long nr_entries;
@@ -856,14 +858,15 @@ static int stack_print(struct seq_file *
 
 	nr_entries = stack_record->size;
 	entries = stack_record->entries;
+	stack_count = refcount_read(&stack_record->count);
 
-	if (!nr_entries || nr_entries < 0 ||
-	    refcount_read(&stack_record->count) < 2)
+	if (!nr_entries || nr_entries < 0 || stack_count < 2 ||
+	    stack_count < page_owner_stack_threshold)
 		return 0;
 
 	for (i = 0; i < nr_entries; i++)
 		seq_printf(m, " %pS\n", (void *)entries[i]);
-	seq_printf(m, "stack_count: %d\n\n", refcount_read(&stack_record->count));
+	seq_printf(m, "stack_count: %d\n\n", stack_count);
 
 	return 0;
 }
@@ -891,6 +894,22 @@ static const struct file_operations page
 	.release	= seq_release,
 };
 
+static int page_owner_threshold_get(void *data, u64 *val)
+{
+	*val = READ_ONCE(page_owner_stack_threshold);
+	return 0;
+}
+
+static int page_owner_threshold_set(void *data, u64 val)
+{
+	WRITE_ONCE(page_owner_stack_threshold, val);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(proc_page_owner_threshold, &page_owner_threshold_get,
+			&page_owner_threshold_set, "%llu");
+
+
 static int __init pageowner_init(void)
 {
 	struct dentry *dir;
@@ -905,6 +924,8 @@ static int __init pageowner_init(void)
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir, NULL,
 			    &page_owner_stack_operations);
+	debugfs_create_file("count_threshold", 0600, dir, NULL,
+			    &proc_page_owner_threshold);
 
 	return 0;
 }
_

Patches currently in -mm which might be from osalvador@suse.de are

lib-stackdepot-fix-first-entry-having-a-0-handle.patch
lib-stackdepot-move-stack_record-struct-definition-into-the-header.patch
mmpage_owner-maintain-own-list-of-stack_records-structs.patch
mmpage_owner-implement-the-tracking-of-the-stacks-count.patch
mmpage_owner-display-all-stacks-and-their-count.patch
mmpage_owner-filter-out-stacks-by-a-threshold.patch
mmpage_owner-update-documentation-regarding-page_owner_stacks.patch

