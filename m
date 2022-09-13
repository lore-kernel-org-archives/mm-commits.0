Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C808C54EE9
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 21:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiIMVlZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 17:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIMVlY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 17:41:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC1E6AA09
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 14:41:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 73359CE1349
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 21:41:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFB8C433C1;
        Tue, 13 Sep 2022 21:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663105279;
        bh=InIu9qTl7WSiEUb2Wss+/R8U2IlWTbjaPVBrXB8Q4AI=;
        h=Date:To:From:Subject:From;
        b=NT0ZzRq7AZNmxzCFRl9At86JtWUjlLVFXgtMzIMqVX/nE7ZkMnnPFUOOT77vXTLSL
         yPMgtWL2HCOdrTN1GT1Oep13qTPC4gr4Iw48V6qxu2EKeT6j+ujlzOW+hi2FFMsrRT
         5rmbQcUac8s/QlfD+8LWfuiVuxfEhhYErYXnk0jg=
Date:   Tue, 13 Sep 2022 14:41:18 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-add-thp-collapse-shmem-testing-fix.patch added to mm-unstable branch
Message-Id: <20220913214119.6CFB8C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: fix "add thp collapse file and tmpfs testing" for tmpfs
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-add-thp-collapse-shmem-testing-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-add-thp-collapse-shmem-testing-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: selftests/vm: fix "add thp collapse file and tmpfs testing" for tmpfs
Date: Tue, 13 Sep 2022 14:25:17 -0700

In write_settings() and save_settings() we properly only read/write
/sys/block/<device>/queue/read_ahead_kb if the test file is not backed by
tmpfs.  However, in get_finfo(), we unconditionally attempt to resolve the
major/minor device pair and search for device interface, which we fail to
do when the device is the null device (major 0), as is the case when
stat(2)'ing a tmpfs-backed file.

Only resolve path to queue/read_ahead_kb when dealing with non-tmpfs
files.

Link: https://lkml.kernel.org/r/20220913212517.3163701-1-zokeefe@google.com
Fixes: 64b9fb1fa904 ("selftests/vm: add thp collapse file and tmpfs testing")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/khugepaged.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/vm/khugepaged.c~selftests-vm-add-thp-collapse-shmem-testing-fix
+++ a/tools/testing/selftests/vm/khugepaged.c
@@ -453,6 +453,8 @@ static void get_finfo(const char *dir)
 		exit(EXIT_FAILURE);
 	}
 	finfo.type = fs.f_type == TMPFS_MAGIC ? VMA_SHMEM : VMA_FILE;
+	if (finfo.type == VMA_SHMEM)
+		return;
 
 	/* Find owning device's queue/read_ahead_kb control */
 	if (snprintf(path, sizeof(path), "/sys/dev/block/%d:%d/uevent",
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-shmem-add-flag-to-enforce-shmem-thp-in-hugepage_vma_check.patch
mm-khugepaged-attempt-to-map-file-shmem-backed-pte-mapped-thps-by-pmds.patch
mm-madvise-add-file-and-shmem-support-to-madv_collapse.patch
mm-khugepaged-add-tracepoint-to-hpage_collapse_scan_file.patch
selftests-vm-dedup-thp-helpers.patch
selftests-vm-modularize-thp-collapse-memory-operations.patch
selftests-vm-add-thp-collapse-file-and-tmpfs-testing.patch
selftests-vm-add-thp-collapse-shmem-testing.patch
selftests-vm-add-thp-collapse-shmem-testing-fix.patch
selftests-vm-add-file-shmem-madv_collapse-selftest-for-cleared-pmd.patch
selftests-vm-add-selftest-for-madv_collapse-of-uffd-minor-memory.patch

