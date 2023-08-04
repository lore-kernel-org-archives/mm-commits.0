Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F0C4C001DE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 20:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjHDUET (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 16:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjHDUEP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 16:04:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBE9E70;
        Fri,  4 Aug 2023 13:04:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8206620F9;
        Fri,  4 Aug 2023 20:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29895C433C8;
        Fri,  4 Aug 2023 20:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691179453;
        bh=/9pjbLqbxBCD2sXKJdTB/EpuTPSAcrQ16EFNdTqiHxk=;
        h=Date:To:From:Subject:From;
        b=NUDn1SEPtyippsR+VlC38Cx022oRtMTQ4+Gbsu+LNBUQ8TDmHJOA+JbTNAirwv6Bv
         yphacpfC7jlXsSmwg1GdIxuMaaa05+itXLOK9MLzfYj7hI/m889irUyGWiKZBW8Yc2
         yrdRoTQyBcRtbsSyX0pbEpq5Rhe9EQnDS8Equ9co=
Date:   Fri, 04 Aug 2023 13:04:12 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, koct9i@gmail.com, colin.i.king@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] radix-tree-test-suite-fix-incorrect-allocation-size-for-pthreads.patch removed from -mm tree
Message-Id: <20230804200413.29895C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: radix tree test suite: fix incorrect allocation size for pthreads
has been removed from the -mm tree.  Its filename was
     radix-tree-test-suite-fix-incorrect-allocation-size-for-pthreads.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: radix tree test suite: fix incorrect allocation size for pthreads
Date: Thu, 27 Jul 2023 17:09:30 +0100

Currently the pthread allocation for each array item is based on the size
of a pthread_t pointer and should be the size of the pthread_t structure,
so the allocation is under-allocating the correct size.  Fix this by using
the size of each element in the pthreads array.

Static analysis cppcheck reported:
tools/testing/radix-tree/regression1.c:180:2: warning: Size of pointer
'threads' used instead of size of its data. [pointerSize]

Link: https://lkml.kernel.org/r/20230727160930.632674-1-colin.i.king@gmail.com
Fixes: 1366c37ed84b ("radix tree test harness")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/regression1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/radix-tree/regression1.c~radix-tree-test-suite-fix-incorrect-allocation-size-for-pthreads
+++ a/tools/testing/radix-tree/regression1.c
@@ -177,7 +177,7 @@ void regression1_test(void)
 	nr_threads = 2;
 	pthread_barrier_init(&worker_barrier, NULL, nr_threads);
 
-	threads = malloc(nr_threads * sizeof(pthread_t *));
+	threads = malloc(nr_threads * sizeof(*threads));
 
 	for (i = 0; i < nr_threads; i++) {
 		arg = i;
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

fs-hfsplus-make-extend-error-rate-limited.patch

