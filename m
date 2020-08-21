Return-Path: <SRS0=KdEm=B7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D09DDC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 00:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A21BD207BB
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 00:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597970520;
	bh=PhgVNKj2nh1/nEjYcIbmagUGcE0qaexEX02i78hau4E=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=igx85P2WAUg6XAZ9cdmuouPN3cKjkjrz0uDlFRtVaU8YnCv+IJcpkKiixJAwQTjQk
	 Tf0w48stJJ/yg8rgljn8MMIugv5y+wO/6bav/TJmq/O7c9pBwPuFXC4fUlM7hULF91
	 IVLz3lJl0+lRcWzfe5Y3ZmanEmXw6+iq7IXyz6nk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgHUAmA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Aug 2020 20:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbgHUAmA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Aug 2020 20:42:00 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8264620738;
        Fri, 21 Aug 2020 00:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597970519;
        bh=PhgVNKj2nh1/nEjYcIbmagUGcE0qaexEX02i78hau4E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CDF4eqKQusXYwMMzK1T6Q97XbFx4XPf3L5uYv+XB5HMPkasgnROUcHqsKsl977CpS
         YRHzuTYSCG9z/jq+yGjEzq+qGYCNhRbWSqbJd7F6/7xsFnY7waTZwMDCOLOBu+gIN6
         QATOoxjBUh/a8Glx+OVSVwmR2eXqXc77hkZ/Ql48=
Date:   Thu, 20 Aug 2020 17:41:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gscrivan@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org, vulab@iscas.ac.cn
Subject:  [patch 02/11] hugetlb_cgroup: convert comma to semicolon
Message-ID: <20200821004159.94PY6CGXn%akpm@linux-foundation.org>
In-Reply-To: <20200820174132.67fd4a7a9359048f807a533b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
