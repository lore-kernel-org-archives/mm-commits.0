Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C9B7C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jan 2022 21:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244416AbiAJVhG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jan 2022 16:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244307AbiAJVhF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jan 2022 16:37:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51566C06173F
        for <mm-commits@vger.kernel.org>; Mon, 10 Jan 2022 13:37:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C979B8180A
        for <mm-commits@vger.kernel.org>; Mon, 10 Jan 2022 21:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0962C36AE3;
        Mon, 10 Jan 2022 21:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1641850622;
        bh=Tp+Th4lRJv6of6a8c8Ijj0EZyMR4EIZ1Ua4nKlWvACo=;
        h=Date:From:To:Subject:From;
        b=BQPyjYcNNI/kmAtKmTDn+UvgbUbvWOVkTRSB2O4DHqSQuz3pIY50LmQ/WJP3+rxlg
         7TBSFZiSe0bbwOz497tF4bLJ2HrVkbQabShmg97Kr6vybDHSD6WTrmoS4cMlEdTKhK
         Ni+4lPFcYZ0OH2816inSmp1oLbOrpY5CfmYJ4Gf8=
Date:   Mon, 10 Jan 2022 13:37:02 -0800
From:   akpm@linux-foundation.org
To:     jannh@google.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        rientjes@google.com
Subject:  + mm-oom-oom-sysrq-should-always-kill-a-process.patch
 added to -mm tree
Message-ID: <20220110213702.dzH_S646P%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: OOM sysrq should always kill a process
has been added to the -mm tree.  Its filename is
     mm-oom-oom-sysrq-should-always-kill-a-process.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-oom-oom-sysrq-should-always-kill-a-process.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-oom-sysrq-should-always-kill-a-process.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm, oom: OOM sysrq should always kill a process

The OOM kill sysrq (alt+sysrq+F) should allow the user to kill the process
with the highest OOM badness with a single execution.

However, at the moment, the OOM kill can bail out if an OOM notifier (e.g.
the i915 one) says that it reclaimed a tiny amount of memory from
somewhere.  That's probably not what the user wants, so skip the bailout
if the OOM was triggered via sysrq.

Link: https://lkml.kernel.org/r/20220106102605.635656-1-jannh@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/oom_kill.c~mm-oom-oom-sysrq-should-always-kill-a-process
+++ a/mm/oom_kill.c
@@ -1058,7 +1058,7 @@ bool out_of_memory(struct oom_control *o
 
 	if (!is_memcg_oom(oc)) {
 		blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
-		if (freed > 0)
+		if (freed > 0 && !is_sysrq_oom(oc))
 			/* Got some memory back in the last second. */
 			return true;
 	}
_

Patches currently in -mm which might be from jannh@google.com are

mm-oom-oom-sysrq-should-always-kill-a-process.patch

