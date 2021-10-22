Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7622FC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 03:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5469E61A38
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 03:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbhJVDre (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Oct 2021 23:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232871AbhJVDre (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Oct 2021 23:47:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18E9961A0C;
        Fri, 22 Oct 2021 03:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634874317;
        bh=C6USjLNoOzAmqApAc3DzcNXpQ83U/Pn2DvViF+aUaY0=;
        h=Date:From:To:Subject:From;
        b=HjvH3V97cC5oWBzY+jBq85x+i+n+M0xLKrJ5TT+LmPYQpqc6lqoLbJi+CloBHq8Iv
         2SOL3D4RBlOHW+8f2a9XuSUD7AjxEmdcGJSjhZMwxDZ3z/YnsPRuCEc8MgS3XSBgCY
         HKWBcmewEnLdm5UCRxARgAqL2Pjb/qSVgrQBgBXY=
Date:   Thu, 21 Oct 2021 20:45:16 -0700
From:   akpm@linux-foundation.org
To:     baolin.wang@linux.alibaba.com, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  +
 hugetlb_cgroup-remove-unused-hugetlb_cgroup_from_counter-macro.patch added
 to -mm tree
Message-ID: <20211022034516.e0CCbaGTA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb_cgroup: remove unused hugetlb_cgroup_from_counter macro
has been added to the -mm tree.  Its filename is
     hugetlb_cgroup-remove-unused-hugetlb_cgroup_from_counter-macro.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb_cgroup-remove-unused-hugetlb_cgroup_from_counter-macro.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb_cgroup-remove-unused-hugetlb_cgroup_from_counter-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: hugetlb_cgroup: remove unused hugetlb_cgroup_from_counter macro

Patch series "Some cleanups and improvements for hugetlb".

This patchset does some cleanups and improvements for hugetlb and
hugetlb_cgroup.


This patch (of 4):

Since commit 726b7bbe ("hugetlb_cgroup: fix illegal access to memory"),
the hugetlb_cgroup_from_counter() macro is not used any more, remove it.

Link: https://lkml.kernel.org/r/cover.1634797639.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/f03b29b801fa9942466ab15334ec09988e124ae6.1634797639.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-remove-unused-hugetlb_cgroup_from_counter-macro
+++ a/mm/hugetlb_cgroup.c
@@ -27,9 +27,6 @@
 #define MEMFILE_IDX(val)	(((val) >> 16) & 0xffff)
 #define MEMFILE_ATTR(val)	((val) & 0xffff)
 
-#define hugetlb_cgroup_from_counter(counter, idx)                   \
-	container_of(counter, struct hugetlb_cgroup, hugepage[idx])
-
 static struct hugetlb_cgroup *root_h_cgroup __read_mostly;
 
 static inline struct page_counter *
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

hugetlb-support-node-specified-when-using-cma-for-gigantic-hugepages.patch
hugetlb_cgroup-remove-unused-hugetlb_cgroup_from_counter-macro.patch
hugetlb-replace-the-obsolete-hugetlb_instantiation_mutex-in-the-comments.patch
hugetlb-remove-redundant-validation-in-has_same_uncharge_info.patch
hugetlb-remove-redundant-vm_bug_on-in-add_reservation_in_range.patch
mm-migrate-simplify-the-file-backed-pages-validation-when-migrating-its-mapping.patch

