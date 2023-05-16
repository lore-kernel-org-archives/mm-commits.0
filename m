Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C193DC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 16 May 2023 21:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjEPVQU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 May 2023 17:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjEPVQP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2023 17:16:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3C7121
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 14:16:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 275ED63F8F
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 21:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8069CC433EF;
        Tue, 16 May 2023 21:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684271773;
        bh=3Ni/liYqYRAOirMpfuBageNS2hfpcsBDYDvgV1G8om4=;
        h=Date:To:From:Subject:From;
        b=hLG1XYAZFDS3kKiXjpwiQhF+/R6gKl2HMvgRu/DQjWm7hPeRiOBpbDJ8EMPCbf+o1
         Lc73rGBmOvnHPX/PGAXeTB8A4hhfhmo0gGPJIjcvBeTTUe1uYAEnvf2vkYcPmjZVKO
         dyDfyn5YXme1Tw563ijKia5/0biWgOs7zl//wuhM=
Date:   Tue, 16 May 2023 14:16:13 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, surenb@google.com,
        mhocko@suse.com, longman@redhat.com, glider@google.com,
        elver@google.com, edumazet@google.com, andreyknvl@gmail.com,
        osalvador@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte.patch added to mm-unstable branch
Message-Id: <20230516211613.8069CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_owner: add page_owner_stacks file to print out only stacks and their counte
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte.patch

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
Subject: mm, page_owner: add page_owner_stacks file to print out only stacks and their counte
Date: Tue, 16 May 2023 20:25:36 +0200

We might be only interested in knowing about stacks <-> count
relationship, so instead of having to fiddle with page_owner output and
screen through pfns, let us add a new file called 'page_owner_stacks' that
does just that.  By cating such file, we will get all the stacktraces
followed by its counter, so we can have a more global view.

Link: https://lkml.kernel.org/r/20230516182537.3139-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackdepot.h |    6 ++
 lib/stackdepot.c           |   72 +++++++++++++++++++++++++++++++++++
 mm/page_owner.c            |   27 +++++++++++++
 3 files changed, 105 insertions(+)

--- a/include/linux/stackdepot.h~mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte
+++ a/include/linux/stackdepot.h
@@ -112,6 +112,12 @@ void stack_depot_dec_count(depot_stack_h
 depot_stack_handle_t stack_depot_save(unsigned long *entries,
 				      unsigned int nr_entries, gfp_t gfp_flags);
 
+#ifdef CONFIG_PAGE_OWNER
+void *stack_start(struct seq_file *m, loff_t *ppos);
+void *stack_next(struct seq_file *m, void *v, loff_t *ppos);
+int stack_print(struct seq_file *m, void *v);
+#endif
+
 /**
  * stack_depot_fetch - Fetch a stack trace from stack depot
  *
--- a/lib/stackdepot.c~mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte
+++ a/lib/stackdepot.c
@@ -29,6 +29,7 @@
 #include <linux/types.h>
 #include <linux/memblock.h>
 #include <linux/kasan-enabled.h>
+#include <linux/seq_file.h>
 
 #define DEPOT_HANDLE_BITS (sizeof(depot_stack_handle_t) * 8)
 
@@ -486,6 +487,77 @@ static struct stack_record *stack_depot_
 	return stack;
 }
 
+#ifdef CONFIG_PAGE_OWNER
+void *stack_start(struct seq_file *m, loff_t *ppos)
+{
+	unsigned long *table = m->private;
+	struct stack_record **stacks, *stack;
+
+	/* First time */
+	if (*ppos == 0)
+		*table = 0;
+
+	if (*ppos == -1UL)
+		return NULL;
+
+	stacks = &stack_table[*table];
+	stack = (struct stack_record *)stacks;
+
+	return stack;
+}
+
+void *stack_next(struct seq_file *m, void *v, loff_t *ppos)
+{
+	unsigned long *table = m->private;
+	unsigned long nr_table = *table;
+	struct stack_record *next = NULL, *stack = v, **stacks;
+	unsigned long stack_table_entries = stack_hash_mask + 1;
+
+	if (!stack) {
+new_table:
+		/* New table */
+		nr_table++;
+		if (nr_table >= stack_table_entries)
+			goto out;
+		stacks = &stack_table[nr_table];
+		stack = (struct stack_record *)stacks;
+		next = stack;
+	} else {
+		next = stack->next;
+	}
+
+	if (!next)
+		goto new_table;
+
+out:
+	*table = nr_table;
+	*ppos = (nr_table >= stack_table_entries) ? -1UL : *ppos + 1;
+	return next;
+}
+
+int stack_print(struct seq_file *m, void *v)
+{
+	char *buf;
+	int ret = 0;
+	struct stack_record *stack = v;
+
+	if (!stack->size || stack->size < 0 ||
+	    stack->size > PAGE_SIZE || stack->handle.valid != 1 ||
+	    refcount_read(&stack->count) < 1)
+		return 0;
+
+	buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	ret += stack_trace_snprint(buf, PAGE_SIZE, stack->entries, stack->size, 0);
+	scnprintf(buf + ret, PAGE_SIZE - ret, "stack count: %d\n\n",
+		  refcount_read(&stack->count));
+	seq_printf(m, buf);
+	seq_puts(m, "\n\n");
+	kfree(buf);
+
+	return 0;
+}
+#endif
+
 unsigned int stack_depot_fetch(depot_stack_handle_t handle,
 			       unsigned long **entries)
 {
--- a/mm/page_owner.c~mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte
+++ a/mm/page_owner.c
@@ -719,6 +719,30 @@ static const struct file_operations proc
 	.llseek		= lseek_page_owner,
 };
 
+static void stack_stop(struct seq_file *m, void *v)
+{
+}
+
+static const struct seq_operations page_owner_stack_op = {
+	.start  = stack_start,
+	.next   = stack_next,
+	.stop   = stack_stop,
+	.show   = stack_print
+};
+
+static int page_owner_stack_open(struct inode *inode, struct file *file)
+{
+	return seq_open_private(file, &page_owner_stack_op,
+				sizeof(unsigned long));
+}
+
+const struct file_operations page_owner_stack_operations = {
+	.open           = page_owner_stack_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = seq_release,
+};
+
 static int __init pageowner_init(void)
 {
 	if (!static_branch_unlikely(&page_owner_inited)) {
@@ -729,6 +753,9 @@ static int __init pageowner_init(void)
 	debugfs_create_file("page_owner", 0400, NULL, NULL,
 			    &proc_page_owner_operations);
 
+	debugfs_create_file("page_owner_stacks", 0400, NULL, NULL,
+			     &page_owner_stack_operations);
+
 	return 0;
 }
 late_initcall(pageowner_init)
_

Patches currently in -mm which might be from osalvador@suse.de are

lib-stackdepot-add-a-refcount-field-in-stack_record.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter.patch

