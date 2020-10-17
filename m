Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A88A9C433DF
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68AE1208B6
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602975875;
	bh=BqwsX+vgNzVlLTclAfnvx/tT28Jjn4dnu0c9zY4IsbA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=rYYJ6l73q4juVB0bJKRNIiCCFWcb4zoHxoGcpIlR3OlMEyrSYz2fYOP9VfGYk37Uo
	 06a9w6kV47hF/0HkATYVu/rEauANSbIr8VDlPoRcZkDlHRLS/5m0HMT/aKvXfNIw+Y
	 0nbOiiOMWd1gR2cRxhFap+69qmehOa6NuuwwfawA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439842AbgJQXEf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:04:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438235AbgJQXEe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:04:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE3E420878;
        Sat, 17 Oct 2020 23:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602975873;
        bh=BqwsX+vgNzVlLTclAfnvx/tT28Jjn4dnu0c9zY4IsbA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PM0tjagyZDlujXNPJXor73m+g5o6uVt5UDwWsHpIbYBOoc8nEL85ReCiGdCzUCaca
         A206PGZOyUnLxOeEnUmt8TICp84+/Bp7ssVX+rCTgYi9MpoJ34rno5+AKsuUr751Zh
         qEe+oZE+mQR7+4Wyfk+sPfPpRcCAohxwPxR3p/Rs=
Date:   Sat, 17 Oct 2020 16:04:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     hch@lst.de, minchan@kernel.org, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-madvise-introduce-process=5Fmadvise-syscall-an-external-?=
 =?US-ASCII?Q?memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix-fix.p?=
 =?US-ASCII?Q?atch?= removed from -mm tree
Message-ID: <20201017230432.yVPFgy0TD%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix up for "iov_iter: transparently handle compat iovecs in import_iovec"
has been removed from the -mm tree.  Its filename was
     mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix-fix.patch

This patch was dropped because it was folded into mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: fix up for "iov_iter: transparently handle compat iovecs in import_iovec"

Link: https://lkml.kernel.org/r/20200928212542.468e1fef@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/mm/madvise.c~mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix-fix
+++ a/mm/madvise.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/mman.h>
-#include <linux/compat.h>
 #include <linux/pagemap.h>
 #include <linux/syscalls.h>
 #include <linux/mempolicy.h>
@@ -1189,15 +1188,7 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 		goto out;
 	}
 
-#ifdef CONFIG_COMPAT
-	if (in_compat_syscall())
-		ret = compat_import_iovec(READ,
-				(struct compat_iovec __user *)vec, vlen,
-				ARRAY_SIZE(iovstack), &iov, &iter);
-	else
-#endif
-		ret = import_iovec(READ, vec, vlen, ARRAY_SIZE(iovstack),
-				&iov, &iter);
+	ret = import_iovec(READ, vec, vlen, ARRAY_SIZE(iovstack), &iov, &iter);
 	if (ret < 0)
 		goto out;
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch

