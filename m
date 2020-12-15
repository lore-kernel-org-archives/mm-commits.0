Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB16C2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95B4022D07
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgLPAA1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730128AbgLOX1t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:27:49 -0500
Date:   Tue, 15 Dec 2020 15:24:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074646;
        bh=MW52Ypg5MuGxn+OS2vVNhEmsdWLP26d6tRPcoCbXx9c=;
        h=From:To:Subject:From;
        b=GRnzKyOd4oMVcdBEK/A1ysSDfo516fGpO30WrcyzhupuV+fuHvE/F1p7wV4PaL4PV
         dsL47w7BwRKm9jeh4W+1N/PE92IMCV5EQSaEzggJFBmNuosZOkDfBIXjv8BgLYOeko
         BQ9kEULCe3muEraO1tV9lpTcdyFV0DsY2R9vccWE=
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, mm-commits@vger.kernel.org, peterx@redhat.com,
        rppt@linux.vnet.ibm.com
Subject:  [merged]
 userfaultfd-selftests-always-dump-something-in-modes.patch removed from -mm
 tree
Message-ID: <20201215232406.9GzRYXz68%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/selftests: always dump something in modes
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftests-always-dump-something-in-modes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: userfaultfd/selftests: always dump something in modes

Patch series "userfaultfd: selftests: Small fixes".

Some very trivial fixes that I kept locally to userfaultfd selftest
program.  


This patch (of 3):

BOUNCE_POLL is a special bit that if cleared it means "READ" instead. 
Dump that too otherwise we'll see tests with empty modes.

Link: https://lkml.kernel.org/r/20201208024709.7701-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20201208024709.7701-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftests-always-dump-something-in-modes
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -1291,6 +1291,8 @@ static int userfaultfd_stress(void)
 			printf(" ver");
 		if (bounces & BOUNCE_POLL)
 			printf(" poll");
+		else
+			printf(" read");
 		printf(", ");
 		fflush(stdout);
 
_

Patches currently in -mm which might be from peterx@redhat.com are


