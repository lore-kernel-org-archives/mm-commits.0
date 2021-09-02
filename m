Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 425C4C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31657610D2
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347579AbhIBV5T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347902AbhIBV5K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:57:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77E7E60E8B;
        Thu,  2 Sep 2021 21:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619771;
        bh=hYAiP/O9/6qUSohT4mqg6n/xoIPGlGghpTVZtAOl9YU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PBDgv7Xr79S3cRDtEZGe3fLAHmZb4Lccm95e9z8J+C1AENaxLppXmOgjUCZXkmOma
         PhPv7opeCT8vWqIsmiMQ6h1rWOFOvmcXvAXCa/ZsU5EyfwDNvziX4taRdP4IO9tUz7
         +SHLFTsWojJIEM0gRqTfi4MmeIf7ONll+usTsYrA=
Date:   Thu, 02 Sep 2021 14:56:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.king@canonical.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 116/212] selftests: Fix spelling mistake "cann't"
 -> "cannot"
Message-ID: <20210902215611.jgsDvlWvh%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>
Subject: selftests: Fix spelling mistake "cann't" -> "cannot"

There is a spelling mistake in an error message. Fix it.

Link: https://lkml.kernel.org/r/20210826121217.12885-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mlock-random-test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/mlock-random-test.c~selftests-fix-spelling-mistake-cannt-cannot
+++ a/tools/testing/selftests/vm/mlock-random-test.c
@@ -70,7 +70,7 @@ int get_proc_locked_vm_size(void)
 		}
 	}
 
-	perror("cann't parse VmLck in /proc/self/status\n");
+	perror("cannot parse VmLck in /proc/self/status\n");
 	fclose(f);
 	return -1;
 }
_
