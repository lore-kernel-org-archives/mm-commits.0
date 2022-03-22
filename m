Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C29C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236334AbiCVVrX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236435AbiCVVrH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:47:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F695F8E1
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:45:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60777B81DAD
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA3DC340EC;
        Tue, 22 Mar 2022 21:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985536;
        bh=koN+O93h9DoI06AbB3NNqvHiV3pa1CEpORDqQtz7MlY=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=mmRClisvqLONimhzS6Jl8prC2DOaOWqTd/7U/ZY1/iHvTSRhouVWoEcnHUduH7GRO
         Mtrgyql6QXsB+uZAy/i2zRR+w8Lyn8Za5EXd5roaBrzLzlY+bwxbAfylVCRhAj8XAv
         c4q3/A98BRJW2feZMgcuBeYRETxNJCXKdENTNwjM=
Date:   Tue, 22 Mar 2022 14:45:35 -0700
To:     shuah@kernel.org, guozhengkui@vivo.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 139/227] userfaultfd/selftests: fix uninitialized_var.cocci warning
Message-Id: <20220322214535.EFA3DC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Guo Zhengkui <guozhengkui@vivo.com>
Subject: userfaultfd/selftests: fix uninitialized_var.cocci warning

Fix following coccicheck warning:
tools/testing/selftests/vm/userfaultfd.c:556:23-24:
WARNING this kind of initialization is deprecated

`unsigned long page_nr = *(&page_nr)` has the same form of
uninitialized_var() macro. I remove the redundant assignement. It has
been tested with gcc (Debian 8.3.0-6) 8.3.0.

The patch which removed uninitialized_var() is:
https://lore.kernel.org/all/20121028102007.GA7547@gmail.com/ And there is
very few "/* GCC */" comments in the Linux kernel code now.

Link: https://lkml.kernel.org/r/20220304082333.9252-1-guozhengkui@vivo.com
Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-fix-uninitialized_varcocci-warning
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -540,7 +540,7 @@ static void continue_range(int ufd, __u6
 static void *locking_thread(void *arg)
 {
 	unsigned long cpu = (unsigned long) arg;
-	unsigned long page_nr = *(&(page_nr)); /* uninitialized warning */
+	unsigned long page_nr;
 	unsigned long long count;
 
 	if (!(bounces & BOUNCE_RANDOM)) {
_
