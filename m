Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCE4C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 25 May 2022 17:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343557AbiEYRtY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 May 2022 13:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343516AbiEYRtJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2022 13:49:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13145AFAD2
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 10:49:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADB77B81E92
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 17:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4CCC385B8;
        Wed, 25 May 2022 17:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653500943;
        bh=bRQWj/4mHCPbp8kDDMIfrw6wpls1C06h92ViHSPxTog=;
        h=Date:To:From:Subject:From;
        b=asLJfo09JYK6/xm1cJQyX6V/s41edUWOJlVn8ixlJCGtL900RFnxydCqSy37cQiwq
         a1FlkIkA0h8IlVTotrFin8U0eZYVQ2dGWEr3PQwIiK1RLXFgN86ubdkDWPVqcC8sMm
         rW1eoVuXlgaMClDf5CaTCAxUNtKSGKrP4rsyIoWc=
Date:   Wed, 25 May 2022 10:49:02 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        patrick.wang.shcn@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-add-test_hmmsh-to-test_files.patch removed from -mm tree
Message-Id: <20220525174903.6B4CCC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: vm: add "test_hmm.sh" to TEST_FILES
has been removed from the -mm tree.  Its filename was
     selftests-vm-add-test_hmmsh-to-test_files.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Patrick Wang <patrick.wang.shcn@gmail.com>
Subject: selftests: vm: add "test_hmm.sh" to TEST_FILES
Date: Sat, 21 May 2022 16:38:24 +0800

The "test_hmm.sh" file used by run_vmtests.sh dose not be installed into
INSTALL_PATH.  Thus run_vmtests.sh can not call it in INSTALL_PATH:

  ---------------------------
  running ./test_hmm.sh smoke
  ---------------------------
  ./run_vmtests.sh: line 74: ./test_hmm.sh: No such file or directory
  [FAIL]
  -----------------------

Add "test_hmm.sh" to TEST_FILES so that it will be installed.

Link: https://lkml.kernel.org/r/20220521083825.319654-3-patrick.wang.shcn@gmail.com
Signed-off-by: Patrick Wang <patrick.wang.shcn@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/vm/Makefile~selftests-vm-add-test_hmmsh-to-test_files
+++ a/tools/testing/selftests/vm/Makefile
@@ -92,6 +92,7 @@ endif
 TEST_PROGS := run_vmtests.sh
 
 TEST_FILES := test_vmalloc.sh
+TEST_FILES += test_hmm.sh
 
 KSFT_KHDR_INSTALL := 1
 include ../lib.mk
_

Patches currently in -mm which might be from patrick.wang.shcn@gmail.com are


