Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BFDEC77B7F
	for <mm-commits@archiver.kernel.org>; Tue, 16 May 2023 21:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjEPVQV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 May 2023 17:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjEPVQR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2023 17:16:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F7961B7
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 14:16:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A18163F92
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 21:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB70C433D2;
        Tue, 16 May 2023 21:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684271775;
        bh=y17zLrdYMSwCs0MoaztlAsoDbvqnIP+iQ/IdeN+jmr8=;
        h=Date:To:From:Subject:From;
        b=2C25eDPKahrKw8KaiwXmOzIQyiHKKuUgAQrFwjxcBEDhINPSP5N4PoQSRU8TlpbQc
         9MFS/brO98OYYTnbc98YLpW5HR6MaTaW1XIh82AuT2wjBpZYx8F2yyjEK73Ku7kGOf
         qbeEk0WRt/S6evEEOq0OdA3QDVKPR6PVZzhxhMPg=
Date:   Tue, 16 May 2023 14:16:15 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, surenb@google.com,
        mhocko@suse.com, longman@redhat.com, glider@google.com,
        elver@google.com, edumazet@google.com, andreyknvl@gmail.com,
        osalvador@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmpage_owner-filter-out-stacks-by-a-threshold-counter.patch added to mm-unstable branch
Message-Id: <20230516211615.CFB70C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,page_owner: filter out stacks by a threshold counter
has been added to the -mm mm-unstable branch.  Its filename is
     mmpage_owner-filter-out-stacks-by-a-threshold-counter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmpage_owner-filter-out-stacks-by-a-threshold-counter.patch

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
Subject: mm,page_owner: filter out stacks by a threshold counter
Date: Tue, 16 May 2023 20:25:37 +0200

We want to be able to filter out the output on a threshold basis, in this
way we can get rid of a lot of noise and focus only on those stacks which
have an allegedly high counter.

We can control the threshold value by a new file called
'page_owner_threshold', which is 0 by default.

Link: https://lkml.kernel.org/r/20230516182537.3139-4-osalvador@suse.de
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

 lib/stackdepot.c |    5 ++++-
 mm/page_owner.c  |   21 +++++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

--- a/lib/stackdepot.c~mmpage_owner-filter-out-stacks-by-a-threshold-counter
+++ a/lib/stackdepot.c
@@ -488,6 +488,9 @@ static struct stack_record *stack_depot_
 }
 
 #ifdef CONFIG_PAGE_OWNER
+
+extern unsigned long page_owner_stack_threshold;
+
 void *stack_start(struct seq_file *m, loff_t *ppos)
 {
 	unsigned long *table = m->private;
@@ -543,7 +546,7 @@ int stack_print(struct seq_file *m, void
 
 	if (!stack->size || stack->size < 0 ||
 	    stack->size > PAGE_SIZE || stack->handle.valid != 1 ||
-	    refcount_read(&stack->count) < 1)
+	    refcount_read(&stack->count) < page_owner_stack_threshold)
 		return 0;
 
 	buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
--- a/mm/page_owner.c~mmpage_owner-filter-out-stacks-by-a-threshold-counter
+++ a/mm/page_owner.c
@@ -743,6 +743,23 @@ const struct file_operations page_owner_
 	.release        = seq_release,
 };
 
+unsigned long page_owner_stack_threshold;
+
+int page_owner_threshold_get(void *data, u64 *val)
+{
+	*val = page_owner_stack_threshold;
+	return 0;
+}
+
+int page_owner_threshold_set(void *data, u64 val)
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
 	if (!static_branch_unlikely(&page_owner_inited)) {
@@ -755,6 +772,10 @@ static int __init pageowner_init(void)
 
 	debugfs_create_file("page_owner_stacks", 0400, NULL, NULL,
 			     &page_owner_stack_operations);
+	debugfs_create_file("page_owner_threshold", 0600, NULL, NULL,
+			    &proc_page_owner_threshold);
+
+	page_owner_stack_threshold = 0;
 
 	return 0;
 }
_

Patches currently in -mm which might be from osalvador@suse.de are

lib-stackdepot-add-a-refcount-field-in-stack_record.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter.patch

