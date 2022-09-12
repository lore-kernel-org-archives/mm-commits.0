Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 718E1ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiILDdb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiILDb6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:31:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F1114D1F
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 842AD61178
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95E4C433D6;
        Mon, 12 Sep 2022 03:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953389;
        bh=8DKNCdrqxX3M4bLc+DTDREOg6lhqUMcjBh1WGSI0GgQ=;
        h=Date:To:From:Subject:From;
        b=DVuVjOAHCU6fqVgWBQEqUfStfB1t03YXQZzmoVhQE+kLXK6NeCJYG5uEu889l26Yk
         9ZQqd+R4vapxC5q0XDGM2i7l4otj5xVC4c0VGiv8me6gYtfc+phzSspGzujE7Co6B6
         AAwjacSWkuYkZHy4Vu2GALH5pXC3KsqJoO7SWFV0=
Date:   Sun, 11 Sep 2022 20:29:49 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        song.bao.hua@hisilicon.com, sjenning@redhat.com, ddstreet@ieee.org,
        dan.carpenter@oracle.com, bigeasy@linutronix.de, david@ixit.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-experimental-flag-for-zswap.patch removed from -mm tree
Message-Id: <20220912032949.D95E4C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove EXPERIMENTAL flag for zswap
has been removed from the -mm tree.  Its filename was
     mm-remove-experimental-flag-for-zswap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Heidelberg <david@ixit.cz>
Subject: mm: remove EXPERIMENTAL flag for zswap
Date: Tue, 23 Aug 2022 17:20:33 +0200

zswap has been with us since 2013, and it's widely used in many products.

Link: https://lkml.kernel.org/r/20220823152033.66682-1-david@ixit.cz
Signed-off-by: David Heidelberg <david@ixit.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/Kconfig~mm-remove-experimental-flag-for-zswap
+++ a/mm/Kconfig
@@ -23,7 +23,7 @@ menuconfig SWAP
 	  in your computer.  If unsure say Y.
 
 config ZSWAP
-	bool "Compressed cache for swap pages (EXPERIMENTAL)"
+	bool "Compressed cache for swap pages"
 	depends on SWAP
 	select FRONTSWAP
 	select CRYPTO
@@ -36,12 +36,6 @@ config ZSWAP
 	  in the case where decompressing from RAM is faster than swap device
 	  reads, can also improve workload performance.
 
-	  This is marked experimental because it is a new feature (as of
-	  v3.11) that interacts heavily with memory reclaim.  While these
-	  interactions don't cause any known issues on simple memory setups,
-	  they have not be fully explored on the large set of potential
-	  configurations and workloads that exist.
-
 config ZSWAP_DEFAULT_ON
 	bool "Enable the compressed cache for swap pages by default"
 	depends on ZSWAP
_

Patches currently in -mm which might be from david@ixit.cz are


