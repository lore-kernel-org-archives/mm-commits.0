Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51C94688
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739363; cv=none; b=dDsWZCBmsydqNCHSj3OuKISqo4wY32WSSvqPbe6hAt1oqRnAGi6+Mag84knrKQ2bzwF2mJ74aRSOde5imunE5i3fAsC76+fX5UJSSbgl0BQ1lGKrS8/zz+h8UiYe6v2ifzq91hobwSUv+btQH37NmK+YXubc58DMahbE+9welEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739363; c=relaxed/simple;
	bh=V79z6QWYZy8r4mKvujPmEnS97owcsCWLksYveDWah2M=;
	h=Date:To:From:Subject:Message-Id; b=u1r1LIEB1PM6IajdgnhRuvcxCCFRzl/c7FeYLP8Wl020OEJBdfHTCoq1+5qwH3JyMG6Y1cU9/QT5RKfi+ak3b+OGlf0eBQkwp1LTdpAxk0KoZtWd/IpjqsBoKUt0XJ3jyEeTWvWBh5m7FToR1Luz5HvJlTTWUKXLTFr/okznzS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H/c6RQRM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H/c6RQRM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9077DC433F1;
	Sat, 24 Feb 2024 01:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739363;
	bh=V79z6QWYZy8r4mKvujPmEnS97owcsCWLksYveDWah2M=;
	h=Date:To:From:Subject:From;
	b=H/c6RQRMgnYptPHoJAOtfr0sCHj7g5neu3FBZjePle+VkOQkmeq/qRH6SGl++HguS
	 QSSXium+0F9X+RyFwLQbKwqarKDKTJw/MQw9fOXM/kjukzpnNWWDVctjC5wAZKsv3T
	 Ltv9pU6UmzZQpcTH1GJzg7cwh9MBcdbntJ5odfmE=
Date: Fri, 23 Feb 2024 17:49:23 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmpage_owner-filter-out-stacks-by-a-threshold.patch removed from -mm tree
Message-Id: <20240224014923.9077DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,page_owner: filter out stacks by a threshold
has been removed from the -mm tree.  Its filename was
     mmpage_owner-filter-out-stacks-by-a-threshold.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
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


