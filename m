Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 586D6ECAAD6
	for <mm-commits@archiver.kernel.org>; Fri, 26 Aug 2022 17:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344951AbiHZRQC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 13:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344911AbiHZRP6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 13:15:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122DF80F4E
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 10:15:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D284B8320B
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 17:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C01BC43148;
        Fri, 26 Aug 2022 17:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661534145;
        bh=CqiN9jMgvAbw/4CWfo9xrvEfgljXMRr6rh5tH0vmwBY=;
        h=Date:To:From:Subject:From;
        b=ZCoHH+raQkvd8bFIM9hMTvPom3XA24FE5f40vta8OzFZbBwW/6M8O9vPrRozeoekn
         GVrozzTGhE65DPw/n/ZuPG0fnc5fBG+jA8ESQh737yGP7NahjnN+1QwnIkRMGh9Hha
         ON5QdEi7bs/doXDeg6pBOHvTfvClJFNpwQ/TmNoM=
Date:   Fri, 26 Aug 2022 10:15:44 -0700
To:     mm-commits@vger.kernel.org, mhocko@suse.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix.patch added to mm-unstable branch
Message-Id: <20220826171545.1C01BC43148@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Michal Hocko <mhocko@suse.com>
Subject: mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix
Date: Fri, 26 Aug 2022 09:32:27 +0200

fix arch/powerpc/xmon/xmon.c

Link: https://lkml.kernel.org/r/Ywh3C4dKB9B93jIy@dhcp22.suse.cz

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/xmon/xmon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/xmon/xmon.c~mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix
+++ a/arch/powerpc/xmon/xmon.c
@@ -1086,7 +1086,7 @@ cmds(struct pt_regs *excp)
 				memzcan();
 				break;
 			case 'i':
-				show_mem(0, NULL);
+				show_mem(0, NULL, GFP_HIGHUSER_MOVABLE);
 				break;
 			default:
 				termch = cmd;
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-reduce-noise-in-show_mem-for-lowmem-allocations.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-fix.patch

