Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AECFC3DA79
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 00:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiLPAjH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 19:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiLPAjF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 19:39:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0A74AF2C
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 16:39:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A52B5B81CD5
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 00:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6109DC433D2;
        Fri, 16 Dec 2022 00:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671151142;
        bh=wf7RMcfs8HX+0Z7Dp/WsMx250LYtkrlpbYPWPcT+eIw=;
        h=Date:To:From:Subject:From;
        b=OuhIjAxG2qrBtc/nkgC5/MKU9EeefxY9HAWIa7nd1QZRLs98jd3GSBfn1tpt1ah8D
         8wYiqstRcZJvo3P3F8s/T/F5dRQm4VKpze3czFAJTpH+ACKYB8k8IdKeDk8jXnuC+t
         jZF27MkjKS4+2OxYbT4JI++XiNSg90VTcvEe113k=
Date:   Thu, 15 Dec 2022 16:39:01 -0800
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-zram-zsmalloc-add-an-additional-co-maintainer.patch removed from -mm tree
Message-Id: <20221216003902.6109DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: zram: zsmalloc: Add an additional co-maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-zram-zsmalloc-add-an-additional-co-maintainer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: MAINTAINERS: zram: zsmalloc: Add an additional co-maintainer
Date: Tue, 13 Dec 2022 09:07:31 -0800

Move Sergey to co-maintainer for zram/zsmalloc since he has helped to
contribute/review those areas actively for eight years, which is quite
helpful.  Since Nitin has been inactive for several years, it's time to
move his name into CREDITS.

Link: https://lkml.kernel.org/r/20221213170731.796121-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    4 ++++
 MAINTAINERS |    6 ++----
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/CREDITS~maintainers-zram-zsmalloc-add-an-additional-co-maintainer
+++ a/CREDITS
@@ -1439,6 +1439,10 @@ N: Justin Guyett
 E: jguyett@andrew.cmu.edu
 D: via-rhine net driver hacking
 
+N: Nitin Gupta
+E: ngupta@vflare.org
+D: zsmalloc memory allocator and zram block device driver
+
 N: Danny ter Haar
 E: dth@cistron.nl
 D: /proc/cpuinfo, reboot on panic , kernel pre-patch tester ;)
--- a/MAINTAINERS~maintainers-zram-zsmalloc-add-an-additional-co-maintainer
+++ a/MAINTAINERS
@@ -23002,8 +23002,7 @@ F:	drivers/media/pci/zoran/
 
 ZRAM COMPRESSED RAM BLOCK DEVICE DRVIER
 M:	Minchan Kim <minchan@kernel.org>
-M:	Nitin Gupta <ngupta@vflare.org>
-R:	Sergey Senozhatsky <senozhatsky@chromium.org>
+M:	Sergey Senozhatsky <senozhatsky@chromium.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/admin-guide/blockdev/zram.rst
@@ -23016,8 +23015,7 @@ F:	drivers/tty/serial/zs.*
 
 ZSMALLOC COMPRESSED SLAB MEMORY ALLOCATOR
 M:	Minchan Kim <minchan@kernel.org>
-M:	Nitin Gupta <ngupta@vflare.org>
-R:	Sergey Senozhatsky <senozhatsky@chromium.org>
+M:	Sergey Senozhatsky <senozhatsky@chromium.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/mm/zsmalloc.rst
_

Patches currently in -mm which might be from minchan@kernel.org are


