Return-Path: <SRS0=1ZdY=CA=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38435C433DF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Aug 2020 17:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1813F207DA
	for <mm-commits@archiver.kernel.org>; Sat, 22 Aug 2020 17:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598117387;
	bh=t3ElTD3YwxghsH4rfxZ71gaAl3WOC7C6NdFd739WWSE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=oY5hdA8JgJjGzywEo0HhQk5cJ2sF9QhxSCEFJEqEtdkdC7FsuXTW+SLs00qQXsJ+l
	 1w5Cg4SzYw67rTHBD+r8lWfwLVegmNaQl2X6Ng6NTOuHIz6y5zK5xRNfNHi9vagO6S
	 h17E3I7TIYH/+zrcxXk9upspwAae4SXjPfLLDn14=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgHVR3q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Aug 2020 13:29:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727945AbgHVR3o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 Aug 2020 13:29:44 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77C0820724;
        Sat, 22 Aug 2020 17:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598117384;
        bh=t3ElTD3YwxghsH4rfxZ71gaAl3WOC7C6NdFd739WWSE=;
        h=Date:From:To:Subject:From;
        b=x334EAgdMJcBdCFhGUmxKy319lpHHXKz82jpAjT/Dw+VnXmPwT1qFAaX5286Ofv0A
         Y8tREj1BqiOcr1CJsQBa8W7e/8yn8eXrmiKjbvoFKa8G4W+7q5qKbr1pOTvOI75sEn
         CsyS5oUbYxIfkYzhEOy2Na9/t5Bv9+1p/ZVt6yLQ=
Date:   Sat, 22 Aug 2020 10:29:44 -0700
From:   akpm@linux-foundation.org
To:     gscrivan@redhat.com, mm-commits@vger.kernel.org, tj@kernel.org,
        vulab@iscas.ac.cn
Subject:  [merged] hugetlb_cgroup-convert-comma-to-semicolon.patch
 removed from -mm tree
Message-ID: <20200822172944.favwabTLp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb_cgroup: convert comma to semicolon
has been removed from the -mm tree.  Its filename was
     hugetlb_cgroup-convert-comma-to-semicolon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


