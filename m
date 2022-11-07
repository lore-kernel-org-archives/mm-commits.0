Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA7A2C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  7 Nov 2022 00:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiKGAVU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Nov 2022 19:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiKGAVT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Nov 2022 19:21:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BFA639B
        for <mm-commits@vger.kernel.org>; Sun,  6 Nov 2022 16:21:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B68EE60DF0
        for <mm-commits@vger.kernel.org>; Mon,  7 Nov 2022 00:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1432EC433D7;
        Mon,  7 Nov 2022 00:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667780477;
        bh=OeZGvuLw9CbqaFu3B8GNv+anAukK+4xf4M4A67aFJnI=;
        h=Date:To:From:Subject:From;
        b=ncmDX1Ax5OE9jnRrTSFA4dcKMFC/28oqHqG8naWxcN0Dmovx24YhgyYX/480ySMDu
         WB1lA7vTiJ48HCThnPrlXaDk1Dcv/yaxWTKsvPUiCcz/WzFwd1bykuQdNiSF2tPIhR
         EnUQ7Sy3F/OWgN687I11806KpRNpC1cCEToobTCQ=
Date:   Sun, 06 Nov 2022 16:21:16 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com, tj@kernel.org,
        shuah@kernel.org, shakeelb@google.com, roman.gushchin@linux.dev,
        rientjes@google.com, lizefan.x@bytedance.com, hannes@cmpxchg.org,
        yuehaibing@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-fix-unsigned-comparison-with-less-than-zero.patch added to mm-nonmm-unstable branch
Message-Id: <20221107002117.1432EC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: cgroup: fix unsigned comparison with less than zero
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-cgroup-fix-unsigned-comparison-with-less-than-zero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-cgroup-fix-unsigned-comparison-with-less-than-zero.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: YueHaibing <yuehaibing@huawei.com>
Subject: selftests: cgroup: fix unsigned comparison with less than zero
Date: Sat, 5 Nov 2022 19:06:11 +0800

'size' is unsigned, it never less than zero.

Link: https://lkml.kernel.org/r/20221105110611.28920-1-yuehaibing@huawei.com
Fixes: 6c26df84e1f2 ("selftests: cgroup: return -errno from cg_read()/cg_write() on failure")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: zefan li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/cgroup_util.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/cgroup/cgroup_util.c~selftests-cgroup-fix-unsigned-comparison-with-less-than-zero
+++ a/tools/testing/selftests/cgroup/cgroup_util.c
@@ -555,6 +555,7 @@ int proc_mount_contains(const char *opti
 ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t size)
 {
 	char path[PATH_MAX];
+	ssize_t ret;
 
 	if (!pid)
 		snprintf(path, sizeof(path), "/proc/%s/%s",
@@ -562,8 +563,8 @@ ssize_t proc_read_text(int pid, bool thr
 	else
 		snprintf(path, sizeof(path), "/proc/%d/%s", pid, item);
 
-	size = read_text(path, buf, size);
-	return size < 0 ? -1 : size;
+	ret = read_text(path, buf, size);
+	return ret < 0 ? -1 : ret;
 }
 
 int proc_read_strstr(int pid, bool thread, const char *item, const char *needle)
_

Patches currently in -mm which might be from yuehaibing@huawei.com are

selftests-cgroup-fix-unsigned-comparison-with-less-than-zero.patch

