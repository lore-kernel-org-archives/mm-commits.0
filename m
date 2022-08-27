Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A977ECAAD5
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 22:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbiH0WbJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Aug 2022 18:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiH0WbJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Aug 2022 18:31:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63DC49B59
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 15:31:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A223B80691
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 22:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4035C433D6;
        Sat, 27 Aug 2022 22:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661639465;
        bh=ZgW0fE5GtIE+/414ekyYffe1BnmxlwzLwCKLFNW82pQ=;
        h=Date:To:From:Subject:From;
        b=vGix4Euhn4AQlB7z2b3a1avCZ40HmtBJxOPdN+4t9ZmC+O+piC5khT7DXQdC8vtPL
         tMM1PmXSCzqpwrqdmwi8CBGn1t3ly+nJQL0hpEt3r99V2w0MvyoPjETLXbMLU9OTtN
         IXF0qU1+LNp/0bEFdl6SPEEZ2dinf7t8Fdl6GDok=
Date:   Sat, 27 Aug 2022 15:31:04 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, mwilck@suse.com, ddiss@suse.de,
        wuchi.zero@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + initramfs-mask-my_inptr-as-__initdata.patch added to mm-nonmm-unstable branch
Message-Id: <20220827223104.F4035C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: initramfs: mark my_inptr as __initdata
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     initramfs-mask-my_inptr-as-__initdata.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/initramfs-mask-my_inptr-as-__initdata.patch

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
From: wuchi <wuchi.zero@gmail.com>
Subject: initramfs: mark my_inptr as __initdata
Date: Sat, 27 Aug 2022 15:11:16 +0800

As my_inptr is only used in __init function unpack_to_rootfs(), mark it as
__initdata to allow it be freed after boot.

Link: https://lkml.kernel.org/r/20220827071116.83078-1-wuchi.zero@gmail.com
Signed-off-by: wuchi <wuchi.zero@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Disseldorp <ddiss@suse.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/initramfs.c~initramfs-mask-my_inptr-as-__initdata
+++ a/init/initramfs.c
@@ -482,7 +482,7 @@ static long __init flush_buffer(void *bu
 	return origLen;
 }
 
-static unsigned long my_inptr; /* index of next byte to be processed in inbuf */
+static unsigned long my_inptr __initdata; /* index of next byte to be processed in inbuf */
 
 #include <linux/decompress/generic.h>
 
_

Patches currently in -mm which might be from wuchi.zero@gmail.com are

lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch
initramfs-mask-my_inptr-as-__initdata.patch

