Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92350C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 25 May 2022 17:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343540AbiEYRtW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 May 2022 13:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343504AbiEYRtE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2022 13:49:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F9D55225
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 10:49:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0681761811
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 17:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B48EC385B8;
        Wed, 25 May 2022 17:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653500942;
        bh=GUOVmzkE09zPvh+sl1yyhtQjqAxQ5FytOzHgEusCUDA=;
        h=Date:To:From:Subject:From;
        b=ahVdjmfMB7pBUq9XWRxtenlbT3RgCYOlIBotH6pMhL/4BPAASY64pJvBnDpFkWxdo
         rP7ZJsfYQdMm1Wczl/hZhYIXWoJkYYP1ZwMxMtZW/XhWvOrFh07bvyJhbjIuSssBmh
         oTJp8n/q5uJ268e9dVO5RKB2/EmJcL2qtiry95X0=
Date:   Wed, 25 May 2022 10:49:01 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        patrick.wang.shcn@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-check-numa_available-before-operating-merge_across_nodes-in-ksm_tests.patch removed from -mm tree
Message-Id: <20220525174902.5B48EC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: vm: check numa_available() before operating "merge_across_nodes" in ksm_tests
has been removed from the -mm tree.  Its filename was
     selftests-vm-check-numa_available-before-operating-merge_across_nodes-in-ksm_tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Patrick Wang <patrick.wang.shcn@gmail.com>
Subject: selftests: vm: check numa_available() before operating "merge_across_nodes" in ksm_tests
Date: Sat, 21 May 2022 16:38:23 +0800

Patch series "selftests: vm: a few fixup patches".

This series contains three fixup patches for vm selftests.  They are
independent.  Please see the patches.


This patch (of 3):

Currently, ksm_tests operates "merge_across_nodes" with NUMA either
enabled or disabled.  In a system with NUMA disabled, these operations
will fail and output a misleading report given "merge_across_nodes" does
not exist in sysfs:

  ----------------------------
  running ./ksm_tests -M -p 10
  ----------------------------
  f /sys/kernel/mm/ksm/merge_across_nodes
  fopen: No such file or directory
  Cannot save default tunables
  [FAIL]
  ----------------------

So check numa_available() before those operations to skip them if NUMA is
disabled.

Link: https://lkml.kernel.org/r/20220521083825.319654-1-patrick.wang.shcn@gmail.com
Link: https://lkml.kernel.org/r/20220521083825.319654-2-patrick.wang.shcn@gmail.com
Signed-off-by: Patrick Wang <patrick.wang.shcn@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/ksm_tests.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/vm/ksm_tests.c~selftests-vm-check-numa_available-before-operating-merge_across_nodes-in-ksm_tests
+++ a/tools/testing/selftests/vm/ksm_tests.c
@@ -221,7 +221,8 @@ static bool assert_ksm_pages_count(long
 static int ksm_save_def(struct ksm_sysfs *ksm_sysfs)
 {
 	if (ksm_read_sysfs(KSM_FP("max_page_sharing"), &ksm_sysfs->max_page_sharing) ||
-	    ksm_read_sysfs(KSM_FP("merge_across_nodes"), &ksm_sysfs->merge_across_nodes) ||
+	    numa_available() ? 0 :
+		ksm_read_sysfs(KSM_FP("merge_across_nodes"), &ksm_sysfs->merge_across_nodes) ||
 	    ksm_read_sysfs(KSM_FP("sleep_millisecs"), &ksm_sysfs->sleep_millisecs) ||
 	    ksm_read_sysfs(KSM_FP("pages_to_scan"), &ksm_sysfs->pages_to_scan) ||
 	    ksm_read_sysfs(KSM_FP("run"), &ksm_sysfs->run) ||
@@ -236,7 +237,8 @@ static int ksm_save_def(struct ksm_sysfs
 static int ksm_restore(struct ksm_sysfs *ksm_sysfs)
 {
 	if (ksm_write_sysfs(KSM_FP("max_page_sharing"), ksm_sysfs->max_page_sharing) ||
-	    ksm_write_sysfs(KSM_FP("merge_across_nodes"), ksm_sysfs->merge_across_nodes) ||
+	    numa_available() ? 0 :
+		ksm_write_sysfs(KSM_FP("merge_across_nodes"), ksm_sysfs->merge_across_nodes) ||
 	    ksm_write_sysfs(KSM_FP("pages_to_scan"), ksm_sysfs->pages_to_scan) ||
 	    ksm_write_sysfs(KSM_FP("run"), ksm_sysfs->run) ||
 	    ksm_write_sysfs(KSM_FP("sleep_millisecs"), ksm_sysfs->sleep_millisecs) ||
@@ -720,7 +722,8 @@ int main(int argc, char *argv[])
 
 	if (ksm_write_sysfs(KSM_FP("run"), 2) ||
 	    ksm_write_sysfs(KSM_FP("sleep_millisecs"), 0) ||
-	    ksm_write_sysfs(KSM_FP("merge_across_nodes"), 1) ||
+	    numa_available() ? 0 :
+		ksm_write_sysfs(KSM_FP("merge_across_nodes"), 1) ||
 	    ksm_write_sysfs(KSM_FP("pages_to_scan"), page_count))
 		return KSFT_FAIL;
 
_

Patches currently in -mm which might be from patrick.wang.shcn@gmail.com are


