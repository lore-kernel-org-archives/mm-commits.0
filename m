Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1481FC4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6F952342C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgLPRLW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:11:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:60970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbgLPRLW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:11:22 -0500
Date:   Wed, 16 Dec 2020 09:10:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138641;
        bh=3q9u8MoJoyvXH5BCApxo/hSpu7y0OHtUnuxWcTPv/XI=;
        h=From:To:Subject:From;
        b=Djqd18DNmGEbo520hTUM6t1AiLfw/TryqnPaA9VENNbSxWBa+Y9uB9c7CsxcWWhWo
         BuqUJuWK46dEW9dWSi6AswV1W0yKCeGfXShq1wnrc8SgSzCjxG3np9F/pvnyAvGs2+
         5P+MgfRi0FL0hna0D/aLOoFcQU0aB0tN6416yN3c=
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, mm-commits@vger.kernel.org,
        oberpar@linux.ibm.com
Subject:  [merged] gcov-fix-kernel-doc-markup-issue.patch removed
 from -mm tree
Message-ID: <20201216171041.9jo5WjoSy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gcov: fix kernel-doc markup issue
has been removed from the -mm tree.  Its filename was
     gcov-fix-kernel-doc-markup-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: gcov: fix kernel-doc markup issue

Fix the following kernel-doc issue in gcov:
kernel/gcov/gcc_4_7.c:238: warning: Function parameter or member 'dst'
not described in 'gcov_info_add'
kernel/gcov/gcc_4_7.c:238: warning: Function parameter or member 'src'
not described in 'gcov_info_add'
kernel/gcov/gcc_4_7.c:238: warning: Excess function parameter 'dest'
description in 'gcov_info_add'
kernel/gcov/gcc_4_7.c:238: warning: Excess function parameter 'source'
description in 'gcov_info_add'

Link: https://lkml.kernel.org/r/1605252352-63983-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/gcc_4_7.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/gcov/gcc_4_7.c~gcov-fix-kernel-doc-markup-issue
+++ a/kernel/gcov/gcc_4_7.c
@@ -227,10 +227,10 @@ int gcov_info_is_compatible(struct gcov_
 
 /**
  * gcov_info_add - add up profiling data
- * @dest: profiling data set to which data is added
- * @source: profiling data set which is added
+ * @dst: profiling data set to which data is added
+ * @src: profiling data set which is added
  *
- * Adds profiling counts of @source to @dest.
+ * Adds profiling counts of @src to @dst.
  */
 void gcov_info_add(struct gcov_info *dst, struct gcov_info *src)
 {
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-vmscan-__isolate_lru_page_prepare-clean-up.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix.patch

