Return-Path: <SRS0=L/bp=EB=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F539C4363A
	for <mm-commits@archiver.kernel.org>; Mon, 26 Oct 2020 19:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 317D221D41
	for <mm-commits@archiver.kernel.org>; Mon, 26 Oct 2020 19:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603740236;
	bh=6ikvQT9RLA+gYDeQLMq7pHkmA3TlDR+4i1xpnzxjP4Y=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=d0syjKPfsurdqVNv0u+fk3YvnTA65tRV+U+QEWnPNzvF1lLrBmHop3ljEWHJmW4qL
	 yyjqp5/vp8Ziv8Sr5W23i2kH5d/b/qKikcPkZvHjN0PbXKK99kn8rkjpkhNpJhFK7b
	 xMDYbQzMH+ifdAtqmKev1PQMUof2FtPZqmx3kfnU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1792986AbgJZTX4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Oct 2020 15:23:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1784580AbgJZTXz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 26 Oct 2020 15:23:55 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE59C20829;
        Mon, 26 Oct 2020 19:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603740235;
        bh=6ikvQT9RLA+gYDeQLMq7pHkmA3TlDR+4i1xpnzxjP4Y=;
        h=Date:From:To:Subject:From;
        b=BjcnEY1Xw5dRUxBLyZwrOvVU4k0ehy9nRaIfd5uXZXKSl/lJz+w8VLH6yEmin912i
         NFtTammQ5L49BNuUN+63sWDgvZMQcOg6a5IoRMqDFfU7EvfkaG/HmyLfrHfe+IvbyU
         hbH3EktH1xGiC0vIrQVO565H+Pc9c3cXaalAFIfA=
Date:   Mon, 26 Oct 2020 12:23:54 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mhocko@kernel.org, sh_def@163.com
Subject:  +
 mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs.patch added to -mm tree
Message-ID: <20201026192354.lJKUG%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill.c: fix the comment of is_dump_unreclaim_slabs()
has been added to the -mm tree.  Its filename is
     mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: mm/oom_kill.c: fix the comment of is_dump_unreclaim_slabs()

Fix the comment of is_dump_unreclaim_slabs().  It just checks whether
nr_unreclaimable slabs amount is greater than user memory.

Link: https://lkml.kernel.org/r/20200926041526.GA179745@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/oom_kill.c~mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs
+++ a/mm/oom_kill.c
@@ -170,9 +170,9 @@ static bool oom_unkillable_task(struct t
 	return false;
 }
 
-/*
- * Print out unreclaimble slabs info when unreclaimable slabs amount is greater
- * than all user memory (LRU pages)
+/**
+ * Check whether unreclaimable slabs amount is greater than
+ * all user memory(LRU pages).
  */
 static bool is_dump_unreclaim_slabs(void)
 {
_

Patches currently in -mm which might be from sh_def@163.com are

mmslab_common-use-list_for_each_entry-in-dump_unreclaimable_slab.patch
mm-hugetlbc-just-use-put_page_testzero-instead-of-page_count.patch
mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs.patch
acctc-use-elif-instead-of-end-and-elif.patch

