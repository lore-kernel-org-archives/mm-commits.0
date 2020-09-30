Return-Path: <SRS0=jIyd=DH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63240C4363D
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 21:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 147AE2076A
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 21:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601502043;
	bh=QsG6Mjw2lou/7K9meH588y0mk+9qCGakKPqxyg9yFls=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=dZKv1Ss9inN6OtEDsxQkC7r/h97ErM0SCWP7hsW1qYZUOP5w5GHF07w+g3kMkNdo0
	 qNBI5pZByG8wCZdnXlOwlBauR4ag9JHnzDxcO461JJRG8xEJRRRjafw/glHdbmECnb
	 ZyeSL2IcsABSKsiWPm2s+qf8Sr9DfTqNob8S+fzQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729912AbgI3Vkm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Sep 2020 17:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730633AbgI3Vkm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Sep 2020 17:40:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE2F220739;
        Wed, 30 Sep 2020 21:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601502040;
        bh=QsG6Mjw2lou/7K9meH588y0mk+9qCGakKPqxyg9yFls=;
        h=Date:From:To:Subject:From;
        b=QJfS9HkEObNHn4VI13Nz1VAhBgdG5si6yqTqe8kDmwQfV2caVBiu1pClFRC4I8Zge
         iJxue2HIxhXOoSq1lZh2f0eQ6Oa+0vibHJMQNUbSR7tU3uRwCXY8TZU99xzkZWEt76
         eYCloBX7DQTsFVIG77LImf8Fw7mhgtejGYe8Hc9E=
Date:   Wed, 30 Sep 2020 14:40:40 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, dhowells@redhat.com,
        herbert@gondor.apana.org.au, longman@redhat.com,
        mm-commits@vger.kernel.org, tianjia.zhang@linux.alibaba.com
Subject:  [to-be-updated]
 lib-mpi-fix-off-by-one-check-on-index-no.patch removed from -mm tree
Message-ID: <20200930214040.GgQLthv5k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/mpi: fix off-by-one check on index "no"
has been removed from the -mm tree.  Its filename was
     lib-mpi-fix-off-by-one-check-on-index-no.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: lib/mpi: fix off-by-one check on index "no"

There is an off-by-one range check on the upper limit of index "no".  Fix
this by changing the > comparison to >=.

Addresses-Coverity: ("Out-of-bounds read")
Link: https://lkml.kernel.org/r/20200929131828.155691-1-colin.king@canonical.com
Fixes: a8ea8bdd9df9 ("lib/mpi: Extend the MPI library")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/mpi/mpiutil.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/mpi/mpiutil.c~lib-mpi-fix-off-by-one-check-on-index-no
+++ a/lib/mpi/mpiutil.c
@@ -69,7 +69,7 @@ postcore_initcall(mpi_init);
  */
 MPI mpi_const(enum gcry_mpi_constants no)
 {
-	if ((int)no < 0 || no > MPI_NUMBER_OF_CONSTANTS)
+	if ((int)no < 0 || no >= MPI_NUMBER_OF_CONSTANTS)
 		pr_err("MPI: invalid mpi_const selector %d\n", no);
 	if (!constants[no])
 		pr_err("MPI: MPI subsystem not initialized\n");
_

Patches currently in -mm which might be from colin.king@canonical.com are


