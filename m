Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5568C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 19:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbiBATyS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 14:54:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58526 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbiBATyR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 14:54:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DB5CB82F7D
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 19:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F7EC340EB;
        Tue,  1 Feb 2022 19:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643745255;
        bh=yGqVN5DnZw73WNrJJd1HUntIzWzC6MhASGtR172/ozQ=;
        h=Date:To:From:Subject:From;
        b=gZnrem1gFoFjulMUng4OjltLz5o7ZUNvksBoz1X+Y19kEWFRB9QKSPnLNF1JwX1BQ
         qMO+KfcmjLs/PRsLhaCic6E4BqCzmRq/Q5gONJu3QptcKi1QGBOt0AGPe4+kwNNdJt
         fvCUaUqyuPVOsJ2UpEkMOwk8+HIjP2YA4+4pEpV8=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 11:54:13 -0800
Date:   Tue, 01 Feb 2022 11:54:13 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, Felix.Kuehling@amd.com, apopple@nvidia.com,
        alex.sierra@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-update-test_hmm-script-to-support-sp-config.patch added to -mm tree
Message-Id: <20220201195413.C2F7EC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools: update test_hmm script to support SP config
has been added to the -mm tree.  Its filename is
     tools-update-test_hmm-script-to-support-sp-config.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-update-test_hmm-script-to-support-sp-config.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-update-test_hmm-script-to-support-sp-config.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Sierra <alex.sierra@amd.com>
Subject: tools: update test_hmm script to support SP config

Add two more parameters to set spm_addr_dev0 & spm_addr_dev1 addresses. 
These two parameters configure the start SP addresses for each device in
test_hmm driver.  Consequently, this configures zone device type as
coherent.

Link: https://lkml.kernel.org/r/20220201154901.7921-11-alex.sierra@amd.com
Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/test_hmm.sh |   24 ++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/vm/test_hmm.sh~tools-update-test_hmm-script-to-support-sp-config
+++ a/tools/testing/selftests/vm/test_hmm.sh
@@ -40,11 +40,26 @@ check_test_requirements()
 
 load_driver()
 {
-	modprobe $DRIVER > /dev/null 2>&1
+	if [ $# -eq 0 ]; then
+		modprobe $DRIVER > /dev/null 2>&1
+	else
+		if [ $# -eq 2 ]; then
+			modprobe $DRIVER spm_addr_dev0=$1 spm_addr_dev1=$2
+				> /dev/null 2>&1
+		else
+			echo "Missing module parameters. Make sure pass"\
+			"spm_addr_dev0 and spm_addr_dev1"
+			usage
+		fi
+	fi
 	if [ $? == 0 ]; then
 		major=$(awk "\$2==\"HMM_DMIRROR\" {print \$1}" /proc/devices)
 		mknod /dev/hmm_dmirror0 c $major 0
 		mknod /dev/hmm_dmirror1 c $major 1
+		if [ $# -eq 2 ]; then
+			mknod /dev/hmm_dmirror2 c $major 2
+			mknod /dev/hmm_dmirror3 c $major 3
+		fi
 	fi
 }
 
@@ -58,7 +73,7 @@ run_smoke()
 {
 	echo "Running smoke test. Note, this test provides basic coverage."
 
-	load_driver
+	load_driver $1 $2
 	$(dirname "${BASH_SOURCE[0]}")/hmm-tests
 	unload_driver
 }
@@ -75,6 +90,9 @@ usage()
 	echo "# Smoke testing"
 	echo "./${TEST_NAME}.sh smoke"
 	echo
+	echo "# Smoke testing with SPM enabled"
+	echo "./${TEST_NAME}.sh smoke <spm_addr_dev0> <spm_addr_dev1>"
+	echo
 	exit 0
 }
 
@@ -84,7 +102,7 @@ function run_test()
 		usage
 	else
 		if [ "$1" = "smoke" ]; then
-			run_smoke
+			run_smoke $2 $3
 		else
 			usage
 		fi
_

Patches currently in -mm which might be from alex.sierra@amd.com are

mm-add-zone-device-coherent-type-memory-support.patch
mm-add-device-coherent-vma-selection-for-memory-migration.patch
mm-gup-fail-get_user_pages-for-longterm-dev-coherent-type.patch
drm-amdkfd-add-spm-support-for-svm.patch
drm-amdkfd-coherent-type-as-sys-mem-on-migration-to-ram.patch
lib-test_hmm-add-ioctl-to-get-zone-device-type.patch
lib-test_hmm-add-module-param-for-zone-device-type.patch
lib-add-support-for-device-coherent-type-in-test_hmm.patch
tools-update-hmm-test-to-support-device-coherent-type.patch
tools-update-test_hmm-script-to-support-sp-config.patch

