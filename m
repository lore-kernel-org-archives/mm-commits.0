Return-Path: <SRS0=qjDH=DG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B85C4727C
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 20:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 824CC20774
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 20:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601410882;
	bh=to3jWG/jQady0nSMrP2l5Rj/6Y83T7EEGJbAsgd4SUg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ub2UdVVE3uIOtBF9YRihmGeKCp4cef+ETZLbR//vxYqNV5aYl2LLXpf3aAQw4vltH
	 1i0nU894FeByP0TNP8sAtCROQtIy44MrwC0J5BBXZddJRc4YIlWNhjqaCk5grsaD/J
	 mA+Ok5vN3piYJWrcr4UFLNZFxVyRvGrEiKJZyIHg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbgI2UVW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Sep 2020 16:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgI2UVV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Sep 2020 16:21:21 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F39482076D;
        Tue, 29 Sep 2020 20:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601410881;
        bh=to3jWG/jQady0nSMrP2l5Rj/6Y83T7EEGJbAsgd4SUg=;
        h=Date:From:To:Subject:From;
        b=rqmkxxWe+L+TISn75bHyjeJGLsjakW8F868GiKl5/mDJXgF0NUjs67O5/SkVQPcVO
         nTWmwThhub/B0LIpSXKA9pSOzvBHfdluIGUTYdXYiuWv5NV5XVxrvSVhq71Ga2WioA
         GKwmNJBhpOPjj6IbxoxdrEQrcuZr1ni8CGF6Il/s=
Date:   Tue, 29 Sep 2020 13:21:20 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, dhowells@redhat.com,
        herbert@gondor.apana.org.au, longman@redhat.com,
        mm-commits@vger.kernel.org, tianjia.zhang@linux.alibaba.com
Subject:  + lib-mpi-fix-off-by-one-check-on-index-no.patch added to
 -mm tree
Message-ID: <20200929202120.tJcolvyab%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/mpi: fix off-by-one check on index "no"
has been added to the -mm tree.  Its filename is
     lib-mpi-fix-off-by-one-check-on-index-no.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-mpi-fix-off-by-one-check-on-index-no.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-mpi-fix-off-by-one-check-on-index-no.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-mpi-fix-off-by-one-check-on-index-no.patch

