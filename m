Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEBE4C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80CE2221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781047;
	bh=xzzxhU/8SiRsBrTPD9nwPf1PmQq1mdHEor5/lZyDKIs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=NEc+c95Qv2hNN846fG929nEGn45H1NTSo05bPCqKr8SKXB3PYEgonNVXySyONkOdq
	 66Wicna8matHb07i9+bOYVRWJrNSVsVE5/0hdrxWXazX8yuK64rSVz9fKsTLVUDsHJ
	 dTWmpoLW6siPsytfiURN2xu86vRO6fUjH1QiIlH8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgHGGR1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:17:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGR1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:17:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CFFC22C9F;
        Fri,  7 Aug 2020 06:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781046;
        bh=xzzxhU/8SiRsBrTPD9nwPf1PmQq1mdHEor5/lZyDKIs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mdSCBu1GrFNJGlkgjqRrkwUYsbUbI70jxufGxBdzhM5OCTQHrdHD1V0aNkPrqrLmV
         XCJml3xkGDstDFAX9Frg6ak1nWJB2tEToOGPTFh2tOdJvNBRxcCsBVotWalTwVi6ny
         Z2lIx2lRqfd6KD6YUcaTEcXaodTX+ZgFICbJXk+U=
Date:   Thu, 06 Aug 2020 23:17:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name,
        christian.brauner@ubuntu.com, gaurav1086@gmail.com, guro@fb.com,
        linux-mm@kvack.org, mkoutny@suse.com, mm-commits@vger.kernel.org,
        shuah@kernel.org, tj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 007/163]
 tools/testing/selftests/cgroup/cgroup_util.c: cg_read_strcmp: fix null
 pointer dereference
Message-ID: <20200807061725.WdE4MoFqu%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Gaurav Singh <gaurav1086@gmail.com>
Subject: tools/testing/selftests/cgroup/cgroup_util.c: cg_read_strcmp: fix null pointer dereference

Haven't reproduced this issue. This PR is does a minor code cleanup.

Link: http://lkml.kernel.org/r/20200726013808.22242-1-gaurav1086@gmail.com
Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Koutn <mkoutny@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/cgroup_util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/cgroup/cgroup_util.c~cg_read_strcmp-fix-null-pointer-dereference
+++ a/tools/testing/selftests/cgroup/cgroup_util.c
@@ -106,7 +106,7 @@ int cg_read_strcmp(const char *cgroup, c
 
 	/* Handle the case of comparing against empty string */
 	if (!expected)
-		size = 32;
+		return -1;
 	else
 		size = strlen(expected) + 1;
 
_
