Return-Path: <SRS0=lzHQ=BG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9CBC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 20:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FA0720792
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 20:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595882256;
	bh=p2SrElFD1YEyItEJ6DPz3jguIAEZL6b0nZWodWDybDY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=To/hp9J7FKKgt7G7B/q9He88a3l4sqTTi5YfzXdcMAmUGoSsi2z8UUyVxrZJFMn7l
	 ArJatQdcqDOV56Lpx776UmCD80vXlWM+5a5bv4XcuyVozRCgbNJta9OgGkfmGy5ZiT
	 NUjE2tuBGulPXxZK/275hlkhtCYWSYYWNFLSIv+8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgG0Uhf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jul 2020 16:37:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgG0Uhf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Jul 2020 16:37:35 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B15F32074F;
        Mon, 27 Jul 2020 20:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595882255;
        bh=p2SrElFD1YEyItEJ6DPz3jguIAEZL6b0nZWodWDybDY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oBOX3yflR9oX1MjgVzuhjS4nn78bCwYh5Z3iW9KJhfl6XT0ROMwZ88K+3IUoTnsUT
         wyhyfX2iQp298v2MebyMjUOfDHYQJcfHy/sLg/CXQR9YNQ6fNPDB6iyqzZTBzklIkG
         8ygsHZL8gTKQ1GYxd4n+ioBb0UM8HIainGL8IYBA=
Date:   Mon, 27 Jul 2020 13:37:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name,
        christian.brauner@ubuntu.com, gaurav1086@gmail.com, guro@fb.com,
        mkoutny@suse.com, mm-commits@vger.kernel.org, shuah@kernel.org,
        tj@kernel.org
Subject:  + cg_read_strcmp-fix-null-pointer-dereference.patch added
 to -mm tree
Message-ID: <20200727203734.reNl0RoVr%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/cgroup/cgroup_util.c: cg_read_strcmp: fix null pointer dereference
has been added to the -mm tree.  Its filename is
     cg_read_strcmp-fix-null-pointer-dereference.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cg_read_strcmp-fix-null-pointer-dereference.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cg_read_strcmp-fix-null-pointer-dereference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

cg_read_strcmp-fix-null-pointer-dereference.patch

