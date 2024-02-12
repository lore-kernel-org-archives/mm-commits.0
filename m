Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27ECD4F898
	for <mm-commits@vger.kernel.org>; Mon, 12 Feb 2024 23:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707780524; cv=none; b=ruyTDGFgdy9QjXm/40aD8V9NvW15QGFwOxmUTNo2CD90C240Mdcq4LJExSzH8XGoYy3FUBA++2q/KWKV/bHA9lshOA0PaVcBmxA7E6s7HqwIgXjAcz+XkIhpONNZaKTU86CXMJsX+YCWdaCI75g3bopR8T/lapfhs00Z/YuuSGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707780524; c=relaxed/simple;
	bh=jJP27Dsrp8ljQqvh4saDtKe78d59cM3rdlbiO1jBjSM=;
	h=Date:To:From:Subject:Message-Id; b=htW6R9AD8xnyF/0GhSs6baSep7WTQXGwLKlL8lXEDkmDT6JrGjeRgG9556fmLao+qEUuadLVLs+FKm8JZkW8vEe/cov8M/v/FNLTrtkfmru81oidariI8jVPmAweW4ojNFs1HDpzy48qwC70w6XCvzmvsRIUGqrTWerLKhBf9/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0N0CqAs3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0N0CqAs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97062C433C7;
	Mon, 12 Feb 2024 23:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707780523;
	bh=jJP27Dsrp8ljQqvh4saDtKe78d59cM3rdlbiO1jBjSM=;
	h=Date:To:From:Subject:From;
	b=0N0CqAs3uVWh5aUYFAo9FAuOg3oqLIaK/Pfsdb3W2yjlyOtLYww2hL/LK5Z1Zyzt0
	 JLVSlQYJnemwqYIKuZ+XycMGAYkg6Sv/5UKoDomBJTaPHWnKab1qzcSts7JZGn2sZg
	 qKmQiZTAqORFxKO1rM1Jo65zXHEHQpapUv8q/kvg=
Date: Mon, 12 Feb 2024 15:28:43 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmpage_owner-filter-out-stacks-by-a-threshold.patch added to mm-unstable branch
Message-Id: <20240212232843.97062C433C7@smtp.kernel.org>
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
Date: Mon, 12 Feb 2024 23:30:28 +0100

We want to be able to filter out the stacks based on a threshold we can
can tune.  By writing to 'set_threshold' file, we can adjust the threshold
value.

Link: https://lkml.kernel.org/r/20240212223029.30769-5-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/mm/page_owner.c~mmpage_owner-filter-out-stacks-by-a-threshold
+++ a/mm/page_owner.c
@@ -832,15 +832,18 @@ static void *stack_next(struct seq_file
 	return stack;
 }
 
+static unsigned long page_owner_stack_threshold;
+
 static int stack_print(struct seq_file *m, void *v)
 {
 	char *buf;
 	int ret = 0;
 	struct stack *stack = v;
 	struct stack_record *stack_record = stack->stack_record;
+	int stack_count = refcount_read(&stack_record->count);
 
 	if (!stack_record->size || stack_record->size < 0 ||
-	    refcount_read(&stack_record->count) < 2)
+	    stack_count < 2 || stack_count < page_owner_stack_threshold)
 		return 0;
 
 	buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
@@ -851,7 +854,7 @@ static int stack_print(struct seq_file *
 		goto out;
 
 	scnprintf(buf + ret, PAGE_SIZE - ret, "stack_count: %d\n\n",
-		  refcount_read(&stack_record->count));
+		  stack_count);
 
 	seq_printf(m, buf);
 	seq_puts(m, "\n\n");
@@ -884,6 +887,21 @@ static const struct file_operations page
 	.release	= seq_release,
 };
 
+static int page_owner_threshold_get(void *data, u64 *val)
+{
+	*val = page_owner_stack_threshold;
+	return 0;
+}
+
+static int page_owner_threshold_set(void *data, u64 val)
+{
+	page_owner_stack_threshold = val;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(proc_page_owner_threshold, &page_owner_threshold_get,
+			&page_owner_threshold_set, "%llu");
+
 static int __init pageowner_init(void)
 {
 	struct dentry *dir;
@@ -898,6 +916,8 @@ static int __init pageowner_init(void)
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir, NULL,
 			    &page_owner_stack_operations);
+	debugfs_create_file("set_threshold", 0600, dir, NULL,
+			    &proc_page_owner_threshold);
 
 	return 0;
 }
_

Patches currently in -mm which might be from osalvador@suse.de are

lib-stackdepot-move-stack_record-struct-definition-into-the-header.patch
mmpage_owner-implement-the-tracking-of-the-stacks-count.patch
mmpage_owner-display-all-stacks-and-their-count.patch
mmpage_owner-filter-out-stacks-by-a-threshold.patch
mmpage_owner-update-documentation-regarding-page_owner_stacks.patch

