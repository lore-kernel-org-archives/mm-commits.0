Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E854DC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 18 Feb 2022 02:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbiBRCuI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Feb 2022 21:50:08 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbiBRCuI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Feb 2022 21:50:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FA11D307
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 18:49:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 125D0CE30B1
        for <mm-commits@vger.kernel.org>; Fri, 18 Feb 2022 02:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E64C340E8;
        Fri, 18 Feb 2022 02:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645152589;
        bh=nHw9ikYEwzgV4lsRQ3jCAGAbrua/GNOLRfz1o9Xx82U=;
        h=Date:To:From:Subject:From;
        b=HT3R4MNomfNGBrdDtDfQhqzfP6pW9K3NBLKyF8jGhcAGjMBPbvf1KuQXBRtOppM0s
         shhmCjPMYfVY/VJ4gz4Z0sTzH/Hwm5CM40/2ZN1rQKvR2mw6wBgmnsbRlRBeWtZVh7
         BF+rwt9BX8j1YWct/slT0HCaScpWwiElT3/0DK4w=
Date:   Thu, 17 Feb 2022 18:49:48 -0800
To:     mm-commits@vger.kernel.org, sujiaxun@uniontech.com,
        sfr@canb.auug.org.au, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-move-oom_kill-sysctls-to-their-own-file-fix.patch removed from -mm tree
Message-Id: <20220218024949.33E64C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix up for "mm: move oom_kill sysctls to their own file"
has been removed from the -mm tree.  Its filename was
     mm-move-oom_kill-sysctls-to-their-own-file-fix.patch

This patch was dropped because it was folded into mm-move-oom_kill-sysctls-to-their-own-file.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: fix up for "mm: move oom_kill sysctls to their own file"

Link: https://lkml.kernel.org/r/20220216193202.28838626@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: sujiaxun <sujiaxun@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/oom_kill.c~mm-move-oom_kill-sysctls-to-their-own-file-fix
+++ a/mm/oom_kill.c
@@ -80,7 +80,8 @@ static struct ctl_table vm_oom_kill_tabl
 		.maxlen		= sizeof(sysctl_oom_dump_tasks),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
-	}
+	},
+	{}
 };
 #endif
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

kasan-improve-vmalloc-tests-fix.patch
mm-move-oom_kill-sysctls-to-their-own-file.patch
mm-dont-include-linux-memremaph-in-linux-mmh-fix-2.patch

