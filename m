Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BBE7C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:43:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 209AA60EB4
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:43:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhKESqJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:46:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231904AbhKESqI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:46:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E61496023D;
        Fri,  5 Nov 2021 18:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636137809;
        bh=4JimNJnAf4C4YSvOJmVu4ZJ+izw6MWVgx9poG9qEL1k=;
        h=Date:From:To:Subject:From;
        b=DXq1D4FU2DSkoimB2T8Lp7N93Wy2N1a7qRWdjc0qg+5nsLkwia13+ahpi5JvJsWnt
         NhQnXeUIaZkALQuWuMhQaOaMu6DUsqkpmMArnQ8xW1cGir8rNoZtLE/ksoIxSUpo3S
         I1YFiA/dQnXD9AKJp8TkQcJVWD4oMMPwvJ1IIqJs=
Date:   Fri, 05 Nov 2021 11:43:28 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@kernel.org, sfr@canb.auug.org.au
Subject:  [folded-merged]
 memblock-use-memblock_free-for-freeing-virtual-pointers-fix.patch removed
 from -mm tree
Message-ID: <20211105184328.YRnwmtZyX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fixup for "memblock: use memblock_free for freeing virtual pointers"
has been removed from the -mm tree.  Its filename was
     memblock-use-memblock_free-for-freeing-virtual-pointers-fix.patch

This patch was dropped because it was folded into memblock-use-memblock_free-for-freeing-virtual-pointers.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: fixup for "memblock: use memblock_free for freeing virtual pointers"

Link: https://lkml.kernel.org/r/20211018192940.3d1d532f@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/main.c~memblock-use-memblock_free-for-freeing-virtual-pointers-fix
+++ a/init/main.c
@@ -382,7 +382,7 @@ static char * __init xbc_make_cmdline(co
 	ret = xbc_snprint_cmdline(new_cmdline, len + 1, root);
 	if (ret < 0 || ret > len) {
 		pr_err("Failed to print extra kernel cmdline.\n");
-		memblock_free_ptr(new_cmdline, len + 1);
+		memblock_free(new_cmdline, len + 1);
 		return NULL;
 	}
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

memblock-use-memblock_free-for-freeing-virtual-pointers.patch
kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers-fix.patch
kernelh-split-out-instruction-pointer-accessors.patch

