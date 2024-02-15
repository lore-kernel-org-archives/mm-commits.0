Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086BF13B289
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 23:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708040055; cv=none; b=tdiF6FWN1+bv0p1ERFQl23tknL7wrFFEmjbtdIXQuxsn0Q005zZFXSo4JN59FiXiiq/uNt/BtsUAdgPd1F5RrOZVxO14ulYzSADAlwh6F1y+RFX4kIDv/ZfvTp3njK8SF28FZNeElcopldvvj6T8nCcg7HTJL1eL/If9RlFdX/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708040055; c=relaxed/simple;
	bh=fjKmATCMM6vETqzQL0CUk+6Cm5Qc3HmbZZt80XvdOEE=;
	h=Date:To:From:Subject:Message-Id; b=ZBibiAuB8sVuJUZWKQAYzOD4R/I1G9ucgvL0Fxk9S72+Srd05SJIjUjxdgMxPhbyHXpZY8aT8cqG4AdWlH9wpCsEzACMtnHy/LzIMgM8JdXeb1UMP2NXT2i/mrG5uqqH8ntwqrJr/426vAakfLtlp1k3KB744WUjos0tlEM/yMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D6mTlpOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D6mTlpOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFABC433F1;
	Thu, 15 Feb 2024 23:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708040054;
	bh=fjKmATCMM6vETqzQL0CUk+6Cm5Qc3HmbZZt80XvdOEE=;
	h=Date:To:From:Subject:From;
	b=D6mTlpOyDCK5qff3zTfH5VGZ3+vTrDWgWHVF45imzNsNa7GL9btYwALsNb4/L6Oce
	 +lr98zddkxtCIa9ZCtC64nWosv7SKbd5RY40uuxzsbyd/AKHQ0zTQsJ0aLdZZYUeN8
	 qOgrw0HjqRc0qmvi0Hs6UP5zADUJceqw/gkcvBbE=
Date: Thu, 15 Feb 2024 15:34:14 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmpage_owner-filter-out-stacks-by-a-threshold.patch added to mm-unstable branch
Message-Id: <20240215233414.BBFABC433F1@smtp.kernel.org>
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
Date: Thu, 15 Feb 2024 22:59:06 +0100

We want to be able to filter out the stacks based on a threshold we can
can tune.  By writing to 'count_threshold' file, we can adjust the
threshold value.

Link: https://lkml.kernel.org/r/20240215215907.20121-7-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/mm/page_owner.c~mmpage_owner-filter-out-stacks-by-a-threshold
+++ a/mm/page_owner.c
@@ -846,6 +846,8 @@ static void *stack_next(struct seq_file
 	return stack;
 }
 
+static unsigned long page_owner_stack_threshold;
+
 static int stack_print(struct seq_file *m, void *v)
 {
 	int i, stack_count;
@@ -858,7 +860,8 @@ static int stack_print(struct seq_file *
 	entries = stack_record->entries;
 	stack_count = refcount_read(&stack_record->count) - 1;
 
-	if (!nr_entries || nr_entries < 0 || stack_count < 1)
+	if (!nr_entries || nr_entries < 0 || stack_count < 1 ||
+	    stack_count < page_owner_stack_threshold)
 		return 0;
 
 	for (i = 0; i < nr_entries; i++)
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

