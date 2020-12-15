Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D63AC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF10B223E0
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgLODQF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:16:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:43082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728089AbgLODPM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:15:12 -0500
Date:   Mon, 14 Dec 2020 19:14:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608002066;
        bh=VDDsRcEPkHj+4tymAuu2Kw1c3vL5jbFuBmEb0CH4u4I=;
        h=From:To:Subject:In-Reply-To:From;
        b=cIz4X+PnD4HDOzic8+FGvsIJ3g0bRx30YqZKQecHLajE8mhoErOylgTETFpdvkxvh
         NmWTFJBSyfbftRzk2ZUgfpDnmhiEcjbf5BRPcyujvNqHMGiU9b9GNz1/Iyb/cLp+cO
         cjvJJUXWGT7gxE8oLw/1MtUWC9pio466XFiXfKv8=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.king@canonical.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 189/200] mm/process_vm_access: remove redundant
 initialization of iov_r
Message-ID: <20201215031425.Q3V0eXY6G%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
