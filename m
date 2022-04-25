Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF51C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 20:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237389AbiDYUVm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 16:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239808AbiDYUVm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 16:21:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951F93134E
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 13:18:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30EB860F01
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 20:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84392C385A4;
        Mon, 25 Apr 2022 20:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650917916;
        bh=l7Jy3CB5aFORS3VXaJDWqafAVdvrywIWTNiHetb8Rl8=;
        h=Date:To:From:Subject:From;
        b=vf7NXw4SLniwVtv5WrxfLRluBPUyVlFNJOSQFOVms3NQcJfsuCP5HwinE+lVUaGl1
         1FQDO/rlgNtjdgft0ENxHwVnXhaxFACwtTBqng586msPcZo081UPu5u/zgZezDdLYk
         RkHm/WozsPY7UXv7dBklTeEwElup7lxrTvxREmG8=
Date:   Mon, 25 Apr 2022 13:18:35 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, weixugc@google.com,
        vaibhav@linux.ibm.com, tj@kernel.org, tim.c.chen@linux.intel.com,
        shuah@kernel.org, shakeelb@google.com, roman.gushchin@linux.dev,
        rientjes@google.com, mkoutny@suse.com, mhocko@suse.com,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, gthelen@google.com,
        dave.hansen@linux.intel.com, corbet@lwn.net, chenwandun@huawei.com,
        yosryahmed@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-cgroup-return-errno-from-cg_read-cg_write-on-failure.patch added to -mm tree
Message-Id: <20220425201836.84392C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: cgroup: return -errno from cg_read()/cg_write() on failure
has been added to the -mm tree.  Its filename is
     selftests-cgroup-return-errno-from-cg_read-cg_write-on-failure.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/selftests-cgroup-return-errno-from-cg_read-cg_write-on-failure.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/selftests-cgroup-return-errno-from-cg_read-cg_write-on-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: selftests: cgroup: return -errno from cg_read()/cg_write() on failure

Currently, cg_read()/cg_write() returns 0 on success and -1 on failure.
Modify them to return the -errno on failure.

Link: https://lkml.kernel.org/r/20220425190040.2475377-3-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Chen Wandun <chenwandun@huawei.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Michal Koutn" <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/cgroup/cgroup_util.c |   44 +++++++----------
 1 file changed, 19 insertions(+), 25 deletions(-)

--- a/tools/testing/selftests/cgroup/cgroup_util.c~selftests-cgroup-return-errno-from-cg_read-cg_write-on-failure
+++ a/tools/testing/selftests/cgroup/cgroup_util.c
@@ -19,6 +19,7 @@
 #include "cgroup_util.h"
 #include "../clone3/clone3_selftests.h"
 
+/* Returns read len on success, or -errno on failure. */
 static ssize_t read_text(const char *path, char *buf, size_t max_len)
 {
 	ssize_t len;
@@ -26,35 +27,29 @@ static ssize_t read_text(const char *pat
 
 	fd = open(path, O_RDONLY);
 	if (fd < 0)
-		return fd;
+		return -errno;
 
 	len = read(fd, buf, max_len - 1);
-	if (len < 0)
-		goto out;
 
-	buf[len] = 0;
-out:
+	if (len >= 0)
+		buf[len] = 0;
+
 	close(fd);
-	return len;
+	return len < 0 ? -errno : len;
 }
 
+/* Returns written len on success, or -errno on failure. */
 static ssize_t write_text(const char *path, char *buf, ssize_t len)
 {
 	int fd;
 
 	fd = open(path, O_WRONLY | O_APPEND);
 	if (fd < 0)
-		return fd;
+		return -errno;
 
 	len = write(fd, buf, len);
-	if (len < 0) {
-		close(fd);
-		return len;
-	}
-
 	close(fd);
-
-	return len;
+	return len < 0 ? -errno : len;
 }
 
 char *cg_name(const char *root, const char *name)
@@ -87,16 +82,16 @@ char *cg_control(const char *cgroup, con
 	return ret;
 }
 
+/* Returns 0 on success, or -errno on failure. */
 int cg_read(const char *cgroup, const char *control, char *buf, size_t len)
 {
 	char path[PATH_MAX];
+	ssize_t ret;
 
 	snprintf(path, sizeof(path), "%s/%s", cgroup, control);
 
-	if (read_text(path, buf, len) >= 0)
-		return 0;
-
-	return -1;
+	ret = read_text(path, buf, len);
+	return ret >= 0 ? 0 : ret;
 }
 
 int cg_read_strcmp(const char *cgroup, const char *control,
@@ -177,17 +172,15 @@ long cg_read_lc(const char *cgroup, cons
 	return cnt;
 }
 
+/* Returns 0 on success, or -errno on failure. */
 int cg_write(const char *cgroup, const char *control, char *buf)
 {
 	char path[PATH_MAX];
-	ssize_t len = strlen(buf);
+	ssize_t len = strlen(buf), ret;
 
 	snprintf(path, sizeof(path), "%s/%s", cgroup, control);
-
-	if (write_text(path, buf, len) == len)
-		return 0;
-
-	return -1;
+	ret = write_text(path, buf, len);
+	return ret == len ? 0 : ret;
 }
 
 int cg_find_unified_root(char *root, size_t len)
@@ -557,7 +550,8 @@ ssize_t proc_read_text(int pid, bool thr
 	else
 		snprintf(path, sizeof(path), "/proc/%d/%s", pid, item);
 
-	return read_text(path, buf, size);
+	size = read_text(path, buf, size);
+	return size < 0 ? -1 : size;
 }
 
 int proc_read_strstr(int pid, bool thread, const char *item, const char *needle)
_

Patches currently in -mm which might be from yosryahmed@google.com are

selftests-cgroup-return-errno-from-cg_read-cg_write-on-failure.patch
selftests-cgroup-fix-alloc_anon_noexit-instantly-freeing-memory.patch
selftests-cgroup-add-a-selftest-for-memoryreclaim.patch

