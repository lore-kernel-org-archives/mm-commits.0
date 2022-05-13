Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3964C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 02:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358819AbiEMC5m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 22:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235873AbiEMC5l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 22:57:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A5C5C67A
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 19:57:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F8B662119
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 02:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B7CC34114;
        Fri, 13 May 2022 02:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652410659;
        bh=AxAwh/MEAjvnCMbBPZHV9g6r2IfJxV4XUUQTYHxOALY=;
        h=Date:To:From:Subject:From;
        b=KKlbpTloszBNJZjHoE0wDguPJM10ms7PUtZFfTZG7amyZ39/jYmccKhjqlSzDLkbT
         nXQ5io0dWc3K+oXE+BCfbrQquNpvxxtIzxDGPQXmsMBdNu2TQnArZCTTbpjFTWmhAS
         PSO8UmqHTAHbsMXqYogoxYibL/JsYe8J7CRuraPg=
Date:   Thu, 12 May 2022 19:57:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        jvgediya@linux.ibm.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch removed from -mm tree
Message-Id: <20220513025739.65B7CC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix
has been removed from the -mm tree.  Its filename was
     lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch

This patch was dropped because it was folded into lib-kstrtoxc-add-false-true-support-to-kstrtobool.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix

undo s/iff/if/, per Matthew

Cc: Jagdish Gediya <jvgediya@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/kstrtox.c~lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix
+++ a/lib/kstrtox.c
@@ -340,7 +340,7 @@ EXPORT_SYMBOL(kstrtos8);
  * @s: input string
  * @res: result
  *
- * This routine returns 0 if the first character is one of 'YyTt1NnFf0', or
+ * This routine returns 0 iff the first character is one of 'YyTt1NnFf0', or
  * [oO][NnFf] for "on" and "off". Otherwise it will return -EINVAL.  Value
  * pointed to by res is updated upon finding a match.
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

assoc_array-fix-bug_on-during-garbage-collect-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool.patch
mm-convert-sysfs-input-to-bool-using-kstrtobool-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

