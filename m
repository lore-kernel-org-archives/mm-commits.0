Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7995DC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjDRXjX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbjDRXhg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:37:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDE5B463
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:36:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B01F160F32
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11349C433EF;
        Tue, 18 Apr 2023 23:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860961;
        bh=pRdLZS3PINWj9tHtjyQaCQEYbdjv5D5dsWt1oAOrjnM=;
        h=Date:To:From:Subject:From;
        b=gGlYtPa0NG+2F/6OUo3o4IpeaIBs8/v3mkSGLj2T7RYRp4l2iQcjfKDGuWWKdBf8a
         O3gSXbumXDQpki+nrpnVdxlQ8nKCtB8wpT5P29n3eNCgOJk13i/wD9hHDOnHwf6tx6
         MzAExREGaJc+m51ZfQnDN/iF4xv8DeRPreRaRTfY=
Date:   Tue, 18 Apr 2023 16:36:00 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, mark.rutland@arm.com,
        kirill.shutemov@linux.intel.com, aneesh.kumar@linux.ibm.com,
        chaitanyas.prakash@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-configure-nr_hugepages-for-arm64.patch removed from -mm tree
Message-Id: <20230418233601.11349C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: configure nr_hugepages for arm64
has been removed from the -mm tree.  Its filename was
     selftests-mm-configure-nr_hugepages-for-arm64.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Subject: selftests/mm: configure nr_hugepages for arm64
Date: Thu, 23 Mar 2023 16:22:42 +0530

Arm64 has a default hugepage size of 512MB when CONFIG_ARM64_64K_PAGES=y
is enabled.  While testing on arm64 platforms having up to 4PB of virtual
address space, a minimum of 6 hugepages were required for all test cases
to pass.  Support for this requirement has been added.

Link: https://lkml.kernel.org/r/20230323105243.2807166-5-chaitanyas.prakash@arm.com
Signed-off-by: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-configure-nr_hugepages-for-arm64
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -236,8 +236,16 @@ if [ $VADDR64 -ne 0 ]; then
 	CATEGORY="hugevm" run_test ./virtual_address_range
 	echo $prev_policy > /proc/sys/vm/overcommit_memory
 
-	# virtual address 128TB switch test
+	# va high address boundary switch test
+	ARCH_ARM64="arm64"
+	prev_nr_hugepages=$(cat /proc/sys/vm/nr_hugepages)
+	if [ "$ARCH" == "$ARCH_ARM64" ]; then
+		echo 6 > /proc/sys/vm/nr_hugepages
+	fi
 	CATEGORY="hugevm" run_test ./va_high_addr_switch.sh
+	if [ "$ARCH" == "$ARCH_ARM64" ]; then
+		echo $prev_nr_hugepages > /proc/sys/vm/nr_hugepages
+	fi
 fi # VADDR64
 
 # vmalloc stability smoke test
_

Patches currently in -mm which might be from chaitanyas.prakash@arm.com are

selftests-mm-run-hugetlb-testcases-of-va-switch.patch

