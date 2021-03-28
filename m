Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99EB2C433C1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 501CF61920
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhC1Tsi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbhC1TsA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 15:48:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF53B6193F;
        Sun, 28 Mar 2021 19:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616960880;
        bh=5lsJ3Bpy6Ro7D39MgkoTcqj0zEZWjOwuAYZhLgbXINY=;
        h=Date:From:To:Subject:From;
        b=Pvzs32nY5cQdJ9abot2iENeDE1OgjP1gzuvaPnt7VhoF9HZg35FNksVJzRjQat0S1
         /1afvVrGRxU2y3LijD+JX3GEEbFY6Ss8f1YKo8owrMlXhdkLAiRUAVbzlHpQa3Aqem
         fc2LTcnz8YBz+tFYyu73G89LROjqBi0OJotZd1CU=
Date:   Sun, 28 Mar 2021 12:47:59 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@oracle.com, wangwensheng4@huawei.com
Subject:  +
 mm-sparse-add-the-missing-sparse_buffer_fini-in-error-branch.patch added to
 -mm tree
Message-ID: <20210328194759.u3i1PYQf-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse: add the missing sparse_buffer_fini() in error branch
has been added to the -mm tree.  Its filename is
     mm-sparse-add-the-missing-sparse_buffer_fini-in-error-branch.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-sparse-add-the-missing-sparse_buffer_fini-in-error-branch.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-sparse-add-the-missing-sparse_buffer_fini-in-error-branch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Wensheng <wangwensheng4@huawei.com>
Subject: mm/sparse: add the missing sparse_buffer_fini() in error branch

sparse_buffer_init() and sparse_buffer_fini() should appear in pair, or a
WARN issue would be through the next time sparse_buffer_init() runs.

Add the missing sparse_buffer_fini() in error branch.

Link: https://lkml.kernel.org/r/20210325113155.118574-1-wangwensheng4@huawei.com
Fixes: 85c77f791390 ("mm/sparse: add new sparse_init_nid() and sparse_init()")
Signed-off-by: Wang Wensheng <wangwensheng4@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/sparse.c~mm-sparse-add-the-missing-sparse_buffer_fini-in-error-branch
+++ a/mm/sparse.c
@@ -547,6 +547,7 @@ static void __init sparse_init_nid(int n
 			pr_err("%s: node[%d] memory map backing failed. Some memory will not be available.",
 			       __func__, nid);
 			pnum_begin = pnum;
+			sparse_buffer_fini();
 			goto failed;
 		}
 		check_usemap_section_nr(nid, usage);
_

Patches currently in -mm which might be from wangwensheng4@huawei.com are

mm-sparse-add-the-missing-sparse_buffer_fini-in-error-branch.patch

