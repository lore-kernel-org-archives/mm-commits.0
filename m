Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6E3C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3997261426
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhEHWnZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:43:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229693AbhEHWnY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:43:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9295C6100C;
        Sat,  8 May 2021 22:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513742;
        bh=t2eaZlu1FtelaSqoiwH3tV/BxlQOeGkP2PoAq+OzAI8=;
        h=Date:From:To:Subject:From;
        b=P0SnIiiK126BbpdVKn8ecE4tOZHqCNDw0TkWi5A9DvhaPc4ciUhKOH9+w3b39SlFd
         T3SLSENuT9187fyNtDz/Vzei3/zY1gENcaKi3yTc9XezlX2taXYT2jzBu1tXRk7S3N
         Bsp+ekdAfmDJDgo6H9b81IRMbZ5Z4OPHlJHX9BJ4=
Date:   Sat, 08 May 2021 15:42:22 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@oracle.com, wangwensheng4@huawei.com
Subject:  [merged]
 mm-sparse-add-the-missing-sparse_buffer_fini-in-error-branch.patch removed
 from -mm tree
Message-ID: <20210508224222.Uvo0pCAcW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse: add the missing sparse_buffer_fini() in error branch
has been removed from the -mm tree.  Its filename was
     mm-sparse-add-the-missing-sparse_buffer_fini-in-error-branch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


