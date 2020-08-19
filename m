Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E39C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 01:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3DE92083B
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 01:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597801287;
	bh=Rn5r8KN8XNbuX/xF72Wt9Wu6HdAZjqmOJv1oViUs0GQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Skt4aIMOeTygjBg0sUbh99/z2u1RPFgF7fBkatoHTVnYh/U+ezllkYA8Sp2o5zBRQ
	 oKIiZ3OqQmM2lrnBVICiX9j3YLsBNPsVUKyFCDflF6KD1MKicY0ncnbhywR86IOp7t
	 Hi4DEpPH5xu/lDNmkjQjL7UbDFVSGaIBW5ijTXvA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgHSBl1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 21:41:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:48292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbgHSBlZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 21:41:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41859207BB;
        Wed, 19 Aug 2020 01:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597801281;
        bh=Rn5r8KN8XNbuX/xF72Wt9Wu6HdAZjqmOJv1oViUs0GQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=q6xggnPfQjdKpOo6NL+GyA8rxOc5Iz8NbtxvP8VxHESaw1k/5BY+SPRsFqrax8xTK
         g+n+q3RSaKWr6tGCL/s03qXqSoCg7aSskKSUSIyLIfxLZkruUnGuNrHFh4hfj65rEB
         60QZC+HG2ts2C+Z8vqe/0ZNh6306r0ItGlzx2s2A=
Date:   Tue, 18 Aug 2020 18:41:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     gscrivan@redhat.com, mm-commits@vger.kernel.org, tj@kernel.org,
        vulab@iscas.ac.cn
Subject:  + hugetlb_cgroup-convert-comma-to-semicolon.patch added
 to -mm tree
Message-ID: <20200819014120.2eSWpu2BA%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb_cgroup: convert comma to semicolon
has been added to the -mm tree.  Its filename is
     hugetlb_cgroup-convert-comma-to-semicolon.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb_cgroup-convert-comma-to-semicolon.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb_cgroup-convert-comma-to-semicolon.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xu Wang <vulab@iscas.ac.cn>
Subject: hugetlb_cgroup: convert comma to semicolon

Replace a comma between expression statements by a semicolon.

Link: http://lkml.kernel.org/r/20200818064333.21759-1-vulab@iscas.ac.cn
Fixes: faced7e0806cf4 ("mm: hugetlb controller for cgroups v2")
Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
Cc: Tejun Heo <tj@kernel.org>
Cc: Giuseppe Scrivano <gscrivan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-convert-comma-to-semicolon
+++ a/mm/hugetlb_cgroup.c
@@ -655,7 +655,7 @@ static void __init __hugetlb_cgroup_file
 	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.events", buf);
 	cft->private = MEMFILE_PRIVATE(idx, 0);
 	cft->seq_show = hugetlb_events_show;
-	cft->file_offset = offsetof(struct hugetlb_cgroup, events_file[idx]),
+	cft->file_offset = offsetof(struct hugetlb_cgroup, events_file[idx]);
 	cft->flags = CFTYPE_NOT_ON_ROOT;
 
 	/* Add the events.local file */
@@ -664,7 +664,7 @@ static void __init __hugetlb_cgroup_file
 	cft->private = MEMFILE_PRIVATE(idx, 0);
 	cft->seq_show = hugetlb_events_local_show;
 	cft->file_offset = offsetof(struct hugetlb_cgroup,
-				    events_local_file[idx]),
+				    events_local_file[idx]);
 	cft->flags = CFTYPE_NOT_ON_ROOT;
 
 	/* NULL terminate the last cft */
_

Patches currently in -mm which might be from vulab@iscas.ac.cn are

hugetlb_cgroup-convert-comma-to-semicolon.patch

