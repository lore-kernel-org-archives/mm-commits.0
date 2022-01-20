Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EDC8C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237502AbiATV1V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377873AbiATV1T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:27:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBB0C06173F
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:27:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FF6060A6C
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86733C340E0;
        Thu, 20 Jan 2022 21:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714038;
        bh=Z7gFLnGGbEZJnW8Dfp0XQS+9p9i6Ynq8gP+Bpqq6LPs=;
        h=Date:From:To:Subject:From;
        b=tURyHFxPKsjZhGsoyqpUxN7EZpsaJ7gDALmuf+1iU5pWCtaMlLMVoLFyC50a2xxbs
         I39EusKLX4yVi5I2mSEogyk+ImkE8oPlzRNoeRypunmxwoHYnoVh4zYFtDy5pwT7tf
         5QQlbK9WfVc93mtXiM2jbu40kbTKpaproye1FyNs=
Date:   Thu, 20 Jan 2022 13:27:18 -0800
From:   akpm@linux-foundation.org
To:     jannh@google.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        rientjes@google.com
Subject:  [merged]
 mm-oom-oom-sysrq-should-always-kill-a-process.patch removed from -mm tree
Message-ID: <20220120212718.zWY6Dq7QG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: OOM sysrq should always kill a process
has been removed from the -mm tree.  Its filename was
     mm-oom-oom-sysrq-should-always-kill-a-process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


