Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 094D4C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 22:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344811AbhLJWu1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 17:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344795AbhLJWuZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 17:50:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5772C0617A1
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 14:46:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97BCDB82A12
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 22:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB20C341C8;
        Fri, 10 Dec 2021 22:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639176407;
        bh=VLkLtXlpkYiZ81jh2+NSPYaD1/az52smLdLFAuiFZJc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qj1O84joWGN/dNKho65HWyaYtS0S1RVnmoxLNtGGvMkP35DsRTJKXMuF37SMrnAM5
         92784A23Vk1uwa8qtwvt41P3n8gl3kfm/q7Qozy7DspvnkfMs06LaZnEW/1Eu37sYL
         DZ4xfoMBBBz4FiO49Qo5PiUW5N7dOfdV94zNIy+s=
Date:   Fri, 10 Dec 2021 14:46:46 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, brendanhiggins@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, shuah@kernel.org,
        sj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 13/21] selftests/damon: skip test if DAMON is
 running
Message-ID: <20211210224646.fzWaFcACO%akpm@linux-foundation.org>
In-Reply-To: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: skip test if DAMON is running

Testing the DAMON debugfs files while DAMON is running makes no sense, as
any write to the debugfs files will fail.  This commit makes the test be
skipped in this case.

Link: https://lkml.kernel.org/r/20211201150440.1088-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/debugfs_attrs.sh |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/tools/testing/selftests/damon/debugfs_attrs.sh~selftests-damon-skip-test-if-damon-is-running
+++ a/tools/testing/selftests/damon/debugfs_attrs.sh
@@ -44,6 +44,15 @@ test_content() {
 
 source ./_chk_dependency.sh
 
+ksft_skip=4
+
+damon_onoff="$DBGFS/monitor_on"
+if [ $(cat "$damon_onoff") = "on" ]
+then
+	echo "monitoring is on"
+	exit $ksft_skip
+fi
+
 # Test attrs file
 # ===============
 
_
