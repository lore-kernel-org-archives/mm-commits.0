Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED1AC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3EE8206E9
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026840;
	bh=K3U3BI632jGS2PkapqDKBXrU0eCtcI9bTcLum9JY2k4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=dIrky+i9dwgK+SSuNPtYd8yKyKYvlTuFEtnlbn1W9FbBv1G4JkrYk2vgmZhXDeYSG
	 ilxVrew/t8Gun5/N55BV7byUvO7dl9HX3Zqkms1LegQrSC9wgpnoR5WLnibdjj/CgF
	 uCToRARfQJp3J7w27Kcw+ciztCo0Ai2kQ9gEnF8s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgHJCeA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:34:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCeA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:00 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A46F206C3;
        Mon, 10 Aug 2020 02:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026839;
        bh=K3U3BI632jGS2PkapqDKBXrU0eCtcI9bTcLum9JY2k4=;
        h=Date:From:To:Subject:From;
        b=a33fNSFdTIoNPPGETl6eHtgkEh41m7U3vLShL1D4MWmlD6UaOlmNAhEFXC3uLzpuv
         usqki4lPFp89dfAJ6eP4nDpg4EMQ5PeuUvUH4B1v71M8O3bNQ0K1ClogRO+HB1t1aZ
         Uj7UcUQnDcUAUUtJKOB6oPfPDbShw6I/AWl7jydA=
Date:   Sun, 09 Aug 2020 19:33:59 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, chris@chrisdown.name,
        christian.brauner@ubuntu.com, gaurav1086@gmail.com, guro@fb.com,
        mkoutny@suse.com, mm-commits@vger.kernel.org, shuah@kernel.org,
        tj@kernel.org
Subject:  [merged]
 cg_read_strcmp-fix-null-pointer-dereference.patch removed from -mm tree
Message-ID: <20200810023359.lTerF2Oef%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/cgroup/cgroup_util.c: cg_read_strcmp: fix null pointer dereference
has been removed from the -mm tree.  Its filename was
     cg_read_strcmp-fix-null-pointer-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from gaurav1086@gmail.com are


