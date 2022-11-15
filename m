Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5842C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238095AbiKOWds (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238534AbiKOWdC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:33:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26D331215
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F4A861A66
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839F5C433C1;
        Tue, 15 Nov 2022 22:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551556;
        bh=TSZOwEYoCscrQOrB46jDIBHrQ2a3dou0VCUtXQ8igwo=;
        h=Date:To:From:Subject:From;
        b=JLi6rk18A+TpGkBOXQG/eF1hg/5WdvTT/iT+t4jvCoLbqOldzlwRTWf1NIiqjdDwp
         nBYX+h2VsXQzrtQJ+sxTaR3fxXnc/PgASkphfXEb96Xu1psQvAW5FCJ+IIz//vIsYU
         JXLNSNqNwBxKG+fqV6I4aU3YkhH3lBhK8MvuDFEQ=
Date:   Tue, 15 Nov 2022 14:32:36 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com, tj@kernel.org,
        shuah@kernel.org, shakeelb@google.com, roman.gushchin@linux.dev,
        rientjes@google.com, lizefan.x@bytedance.com,
        kamalesh.babulal@oracle.com, hannes@cmpxchg.org,
        yuehaibing@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-cgroup-fix-unsigned-comparison-with-less-than-zero.patch removed from -mm tree
Message-Id: <20221115223236.839F5C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: cgroup: fix unsigned comparison with less than zero
has been removed from the -mm tree.  Its filename was
     selftests-cgroup-fix-unsigned-comparison-with-less-than-zero.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: YueHaibing <yuehaibing@huawei.com>
Subject: selftests: cgroup: fix unsigned comparison with less than zero
Date: Sat, 5 Nov 2022 19:06:11 +0800

'size' is unsigned, it never less than zero.

Link: https://lkml.kernel.org/r/20221105110611.28920-1-yuehaibing@huawei.com
Fixes: 6c26df84e1f2 ("selftests: cgroup: return -errno from cg_read()/cg_write() on failure")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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


