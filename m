Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D737EE49A4
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 19:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbjIJTeb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 15:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjIJTea (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 15:34:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC06103
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 12:34:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5EDC433C7;
        Sun, 10 Sep 2023 19:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694374466;
        bh=1PRQC+AMBZyyapQjzyG01AWMw8vScTIXN2aaofPeqv8=;
        h=Date:To:From:Subject:From;
        b=EkTD6RtYOqlcLxNnJKb0DZdx9ooHxWI2/tFxqElXwKdxXQM5ugftxc7IVZQ9jR7Bd
         0NuagcJRlOYJZSU11CgSIdKAhXHjvJ/cUhnthMGlo133R815ETlsGDsBixQAZOSzgx
         qhnmJMH0EU0977J1JO9BrNaAeoDTpsrT+6YVTq0I=
Date:   Sun, 10 Sep 2023 12:34:25 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, hannes@cmpxchg.org,
        ddstreet@ieee.org, cerasuolodomenico@gmail.com, nphamcs@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-change-zswaps-default-allocator-to-zsmalloc.patch added to mm-nonmm-unstable branch
Message-Id: <20230910193426.2E5EDC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: change zswap's default allocator to zsmalloc
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     zswap-change-zswaps-default-allocator-to-zsmalloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-change-zswaps-default-allocator-to-zsmalloc.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: zswap: change zswap's default allocator to zsmalloc
Date: Fri, 8 Sep 2023 16:51:15 -0700

Out of zswap's 3 allocators, zsmalloc is the clear superior in terms of
memory utilization, both in theory and as observed in practice, with its
high storage density and low internal fragmentation.  zsmalloc is also
more actively developed and maintained, since it is the allocator of
choice for zswap for many users, as well as the only allocator for zram.

A historical objection to the selection of zsmalloc as the default
allocator for zswap is its lack of writeback capability.  However, this
has changed, with the zsmalloc writeback patchset, and the subsequent
zswap LRU refactor.  With this, there is not a lot of good reasons to keep
zbud, an otherwise inferior allocator, as the default instead of zswap.

This patch changes the default allocator to zsmalloc.  The only exception
is on settings without MMU, in which case zbud will remain as the default.

Link: https://lkml.kernel.org/r/20230908235115.2943486-1-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/Kconfig~zswap-change-zswaps-default-allocator-to-zsmalloc
+++ a/mm/Kconfig
@@ -130,6 +130,7 @@ config ZSWAP_COMPRESSOR_DEFAULT
 choice
 	prompt "Default allocator"
 	depends on ZSWAP
+	default ZSWAP_ZPOOL_DEFAULT_ZSMALLOC if MMU
 	default ZSWAP_ZPOOL_DEFAULT_ZBUD
 	help
 	  Selects the default allocator for the compressed cache for
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zswap-change-zswaps-default-allocator-to-zsmalloc.patch

