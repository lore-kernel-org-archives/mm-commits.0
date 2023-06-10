Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB9FC7EE25
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbjFJA3i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjFJA3h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:29:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002A1BF
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:29:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89BE96485C
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB8EC433D2;
        Sat, 10 Jun 2023 00:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686356976;
        bh=wQxFoB0gpOU+DJG0kLzFmz7vjhMLnm7saD9Lib7JLuU=;
        h=Date:To:From:Subject:From;
        b=rAFI3lOshIPKdqm6TDQQAL9wCeKPcc+tXBOLIJtbiyTJ6/AEEFleEAJORH8NjXulv
         pl1ZdFTn/Ic9jV3VD6eqkfLSVdkGo9TtO/HhxMRIB3fTf98cX0X4bNCI7dMI2dN/BA
         EVNQRqZiL/GCJzvTOGBudbFPvDFuPoghWAQBBh1I=
Date:   Fri, 09 Jun 2023 17:29:35 -0700
To:     mm-commits@vger.kernel.org, arnd@arndb.de, sfr@canb.auug.org.au,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] init-consolidate-prototypes-in-linux-inith-fix.patch removed from -mm tree
Message-Id: <20230610002935.DFB8EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fix up for "init: consolidate prototypes in linux/init.h"
has been removed from the -mm tree.  Its filename was
     init-consolidate-prototypes-in-linux-inith-fix.patch

This patch was dropped because it was folded into init-consolidate-prototypes-in-linux-inith.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: fix up for "init: consolidate prototypes in linux/init.h"
Date: Fri, 19 May 2023 12:35:26 +1000

Link: https://lkml.kernel.org/r/20230519124311.5167221c@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/kernel.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/sparc/kernel/kernel.h~init-consolidate-prototypes-in-linux-inith-fix
+++ a/arch/sparc/kernel/kernel.h
@@ -62,6 +62,9 @@ asmlinkage void do_rt_sigreturn32(struct
 void do_signal32(struct pt_regs * regs);
 asmlinkage int do_sys32_sigstack(u32 u_ssptr, u32 u_ossptr, unsigned long sp);
 
+/* time_64.c */
+void __init time_init_early(void);
+
 /* compat_audit.c */
 extern unsigned int sparc32_dir_class[];
 extern unsigned int sparc32_chattr_class[];
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

init-consolidate-prototypes-in-linux-inith.patch

