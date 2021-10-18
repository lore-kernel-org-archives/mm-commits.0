Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32673C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 17:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BD5161077
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 17:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhJRRiS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Oct 2021 13:38:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232211AbhJRRiS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 Oct 2021 13:38:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98ECF6103D;
        Mon, 18 Oct 2021 17:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634578566;
        bh=IMJJ0nNMaVqGjT+GPnEn1N4fTk4beAxY3Ol6foVaE28=;
        h=Date:From:To:Subject:From;
        b=OMSW7R2zyKdF6eaN1ZeXQ/loTIqDSagNUDSeTDVIiyKFV9E24A/5hmwX1Rk7LewQX
         OFMjusQXnPxKZ7f9de7vNkgtz7Z6AQ9H0rukXplL8cOey/9E/YJl/z9LPLWZkNaiD5
         4YbXbH3CxGdtMf2r0tHcz1mGK/jtyE36/LL9/lN8=
Date:   Mon, 18 Oct 2021 10:36:06 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@kernel.org, sfr@canb.auug.org.au
Subject:  +
 memblock-use-memblock_free-for-freeing-virtual-pointers-fix.patch added to
 -mm tree
Message-ID: <20211018173606.KjReblVKN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fixup for "memblock: use memblock_free for freeing virtual pointers"
has been added to the -mm tree.  Its filename is
     memblock-use-memblock_free-for-freeing-virtual-pointers-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memblock-use-memblock_free-for-freeing-virtual-pointers-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memblock-use-memblock_free-for-freeing-virtual-pointers-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memblock-use-memblock_free-for-freeing-virtual-pointers-fix.patch
kernelh-drop-unneeded-linux-kernelh-inclusion-from-other-headers-fix.patch

