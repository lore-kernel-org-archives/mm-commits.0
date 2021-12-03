Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5AA6C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Dec 2021 20:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240227AbhLCUpp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Dec 2021 15:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239909AbhLCUpp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Dec 2021 15:45:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD151C061751
        for <mm-commits@vger.kernel.org>; Fri,  3 Dec 2021 12:42:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7967F62CC1
        for <mm-commits@vger.kernel.org>; Fri,  3 Dec 2021 20:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9F3C53FAD;
        Fri,  3 Dec 2021 20:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638564139;
        bh=YWPdYHE5ZXxsxNqrPR7oQyP1LUHs1lUOgBkYjycmt/g=;
        h=Date:From:To:Subject:From;
        b=HE+NlqQrCY2Thu/dpF4hs3OAwNSWEAldsiHNAMiYRj1WTFJdxn3k2iUW3RsaxIhUq
         MQ1teNAUPclEqxZ/A1dUdqUdFxYF+RInKJBNZwt4Un8oMSD29h/Un1+EwITl8zfZD+
         4WL3tNHqZ4+8zYxglbX7ewoILJQIY0o0t+Ku8mg0=
Date:   Fri, 03 Dec 2021 12:42:19 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, keescook@chromium.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au, songmuchun@bytedance.com
Subject:  + hugetlb-add-hugetlbnuma_stat-file-fix-2.patch added to
 -mm tree
Message-ID: <20211203204219.RoCYi90-H%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb/cgroup: fix copy/paste array assignment
has been added to the -mm tree.  Its filename is
     hugetlb-add-hugetlbnuma_stat-file-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-add-hugetlbnuma_stat-file-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-add-hugetlbnuma_stat-file-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: hugetlb/cgroup: fix copy/paste array assignment

Fix mismatched array assignment, reported by an -Warray-bounds build:

mm/hugetlb_cgroup.c: In function '__hugetlb_cgroup_file_legacy_init':
mm/hugetlb_cgroup.c:850:35: error: array subscript 8 is above array bounds of 'struct cftype[8]' [-Werror=array-bounds ]
  850 |         cft = &h->cgroup_files_dfl[8];
      |                ~~~~~~~~~~~~~~~~~~~^~~
In file included from mm/hugetlb_cgroup.c:23:
./include/linux/hugetlb.h:625:23: note: while referencing 'cgroup_files_dfl'
  625 |         struct cftype cgroup_files_dfl[8];
      |                       ^~~~~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/20211203065647.2819707-1-keescook@chromium.org
Fixes: e45f4726bcad ("hugetlb: add hugetlb.*.numa_stat file")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb_cgroup.c~hugetlb-add-hugetlbnuma_stat-file-fix-2
+++ a/mm/hugetlb_cgroup.c
@@ -847,7 +847,7 @@ static void __init __hugetlb_cgroup_file
 	cft->read_u64 = hugetlb_cgroup_read_u64;
 
 	/* Add the numa stat file */
-	cft = &h->cgroup_files_dfl[8];
+	cft = &h->cgroup_files_legacy[8];
 	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.numa_stat", buf);
 	cft->private = MEMFILE_PRIVATE(idx, 1);
 	cft->seq_show = hugetlb_cgroup_read_numa_stat;
_

Patches currently in -mm which might be from keescook@chromium.org are

hugetlb-add-hugetlbnuma_stat-file-fix-2.patch
hfsplus-use-struct_group_attr-for-memcpy-region.patch

