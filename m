Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3D54C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1669223D6
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbgLODGY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:06:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727231AbgLODGS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:06:18 -0500
Date:   Mon, 14 Dec 2020 19:05:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001532;
        bh=UHw1ngin03Ft0zGYyav14zYAFZFf/4etSOYRMeD4rw8=;
        h=From:To:Subject:In-Reply-To:From;
        b=mSkHTbBEMlgVHVYXxrZdIuOGcbCfYNzoSqTbOiioxpCvh+frA0/gP1+bGcE/wobwO
         dufDI3Hu73lN5wspGUR0AHKSSUdX3lardBcija0Zhd9oAiYhvSTNyQl78Bqc5hshN9
         WXQ0FYXgcAYTCm5skVeyagZs6DB8MK6QlMkUU9js=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com,
        shuah@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 040/200] selftests/vm: 2x speedup for
 run_vmtests.sh
Message-ID: <20201215030531.gikpraFhM%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: 2x speedup for run_vmtests.sh

Each invocation of userfaultfd for "anon" and "shmem" was taking about
6.5 sec to run, contributing to an overall run time of about 22 sec for
run_vmtests.sh.

Reduce the size and bounce input values to the userfaultfd invocation
within run_vmtests.sh, enough to get each invocation down to about 1.0
sec. This should still provide a reasonable smoke test, while staying
within a nominal time budget of around 1 second or so per test. And this
brings the overall running time of run_vmtests.sh down to 11 second.

Link: https://lkml.kernel.org/r/20201026064021.3545418-10-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/run_vmtests |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/vm/run_vmtests~selftests-vm-2x-speedup-for-run_vmtestssh
+++ a/tools/testing/selftests/vm/run_vmtests
@@ -160,7 +160,7 @@ fi
 echo "-------------------"
 echo "running userfaultfd"
 echo "-------------------"
-./userfaultfd anon 128 32
+./userfaultfd anon 20 16
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
 	exitcode=1
@@ -185,7 +185,7 @@ rm -f $mnt/ufd_test_file
 echo "-------------------------"
 echo "running userfaultfd_shmem"
 echo "-------------------------"
-./userfaultfd shmem 128 32
+./userfaultfd shmem 20 16
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
 	exitcode=1
_
