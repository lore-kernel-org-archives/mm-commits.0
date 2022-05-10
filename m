Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B1D1C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbiEJEXW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236290AbiEJEWh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:22:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EE51BF19C
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C67DBB81AFE
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD8FC385C2;
        Tue, 10 May 2022 04:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156257;
        bh=gY3LtkA42L31lLM/8D2p7/TLyi2/BUIR92odFzq1R6k=;
        h=Date:To:From:Subject:From;
        b=1NprIu+wAFHcliaOPZ2rN/ZMDRqlBjyAaK+Dq+9qv/vuNoLqESZpPI5cqllnHlJel
         42z7Kj0pw9undI7sOYlyTD5SXzYJFLCBQ3jhfCiceu9tp6gn+n4mr4boQFkXFFS+V2
         xT27WXm4bt7NuY0ul276IdU2PuQ54cnJpJj85I8o=
Date:   Mon, 09 May 2022 21:17:36 -0700
To:     mm-commits@vger.kernel.org, mpe@ellerman.id.au, kuba@kernel.org,
        geert@linux-m68k.org, davem@davemloft.net, arnd@arndb.de,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] net-unexport-csum_and_copy_fromto_user.patch removed from -mm tree
Message-Id: <20220510041737.7CD8FC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: net: unexport csum_and_copy_{from,to}_user
has been removed from the -mm tree.  Its filename was
     net-unexport-csum_and_copy_fromto_user.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: net: unexport csum_and_copy_{from,to}_user

csum_and_copy_from_user and csum_and_copy_to_user are exported by a few
architectures, but not actually used in modular code.  Drop the exports.

Link: https://lkml.kernel.org/r/20220421070440.1282704-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/lib/csum_partial_copy.c   |    1 -
 arch/m68k/lib/checksum.c             |    2 --
 arch/powerpc/lib/checksum_wrappers.c |    2 --
 arch/x86/lib/csum-wrappers_64.c      |    2 --
 4 files changed, 7 deletions(-)

--- a/arch/alpha/lib/csum_partial_copy.c~net-unexport-csum_and_copy_fromto_user
+++ a/arch/alpha/lib/csum_partial_copy.c
@@ -353,7 +353,6 @@ csum_and_copy_from_user(const void __use
 		return 0;
 	return __csum_and_copy(src, dst, len);
 }
-EXPORT_SYMBOL(csum_and_copy_from_user);
 
 __wsum
 csum_partial_copy_nocheck(const void *src, void *dst, int len)
--- a/arch/m68k/lib/checksum.c~net-unexport-csum_and_copy_fromto_user
+++ a/arch/m68k/lib/checksum.c
@@ -265,8 +265,6 @@ csum_and_copy_from_user(const void __use
 	return sum;
 }
 
-EXPORT_SYMBOL(csum_and_copy_from_user);
-
 
 /*
  * copy from kernel space while checksumming, otherwise like csum_partial
--- a/arch/powerpc/lib/checksum_wrappers.c~net-unexport-csum_and_copy_fromto_user
+++ a/arch/powerpc/lib/checksum_wrappers.c
@@ -24,7 +24,6 @@ __wsum csum_and_copy_from_user(const voi
 	user_read_access_end();
 	return csum;
 }
-EXPORT_SYMBOL(csum_and_copy_from_user);
 
 __wsum csum_and_copy_to_user(const void *src, void __user *dst, int len)
 {
@@ -38,4 +37,3 @@ __wsum csum_and_copy_to_user(const void
 	user_write_access_end();
 	return csum;
 }
-EXPORT_SYMBOL(csum_and_copy_to_user);
--- a/arch/x86/lib/csum-wrappers_64.c~net-unexport-csum_and_copy_fromto_user
+++ a/arch/x86/lib/csum-wrappers_64.c
@@ -32,7 +32,6 @@ csum_and_copy_from_user(const void __use
 	user_access_end();
 	return sum;
 }
-EXPORT_SYMBOL(csum_and_copy_from_user);
 
 /**
  * csum_and_copy_to_user - Copy and checksum to user space.
@@ -57,7 +56,6 @@ csum_and_copy_to_user(const void *src, v
 	user_access_end();
 	return sum;
 }
-EXPORT_SYMBOL(csum_and_copy_to_user);
 
 /**
  * csum_partial_copy_nocheck - Copy and checksum.
_

Patches currently in -mm which might be from hch@lst.de are


