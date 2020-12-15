Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D0E8C47434
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E76EB22D07
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgLPAAc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727599AbgLOX2M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:28:12 -0500
Date:   Tue, 15 Dec 2020 15:24:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074664;
        bh=+amoV93HXvjK0pGxxRPb657tquwqIIWIFG5xd1uV/kQ=;
        h=From:To:Subject:From;
        b=By7p/JCr+50V3kbmoCSZkeFYR38VPB7LjOEEIvBRt1Ph/Nc61q/LE+o+j+KzQSnIZ
         QJGxUccHRVKVVov9NM8oiCFt1WlyUEvLghHAqd9uGtCkVNfTBR2rG3Gt4+75oImtd+
         Plbx3mrzBhQmkRc2zvCWQXy2WV5n3Yi1zAm0yc6c=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, colin.king@canonical.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-process_vm_access-remove-redundant-initialization-of-iov_r.patch removed
 from -mm tree
Message-ID: <20201215232424.LwjCitkvC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/process_vm_access: remove redundant initialization of iov_r
has been removed from the -mm tree.  Its filename was
     mm-process_vm_access-remove-redundant-initialization-of-iov_r.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: mm/process_vm_access: remove redundant initialization of iov_r

The pointer iov_r is being initialized with a value that is never read and
it is being updated later with a new value.  The initialization is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Link: https://lkml.kernel.org/r/20201102120614.694917-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/process_vm_access.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/process_vm_access.c~mm-process_vm_access-remove-redundant-initialization-of-iov_r
+++ a/mm/process_vm_access.c
@@ -260,7 +260,7 @@ static ssize_t process_vm_rw(pid_t pid,
 	struct iovec iovstack_l[UIO_FASTIOV];
 	struct iovec iovstack_r[UIO_FASTIOV];
 	struct iovec *iov_l = iovstack_l;
-	struct iovec *iov_r = iovstack_r;
+	struct iovec *iov_r;
 	struct iov_iter iter;
 	ssize_t rc;
 	int dir = vm_write ? WRITE : READ;
_

Patches currently in -mm which might be from colin.king@canonical.com are


