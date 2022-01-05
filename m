Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F0DDC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  5 Jan 2022 23:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245297AbiAEXI4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Jan 2022 18:08:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60158 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245296AbiAEXIx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2022 18:08:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2F6FB81DCB
        for <mm-commits@vger.kernel.org>; Wed,  5 Jan 2022 23:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39821C36AEB;
        Wed,  5 Jan 2022 23:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1641424129;
        bh=mX1E+cAE4hHT1uemHadcnF0XAhRqpAK+L3GE2nZVVFI=;
        h=Date:From:To:Subject:From;
        b=Y4Lg8v6jEzqE91K5xbrqcpFS7noadBKg8oAfsKlgvshP6H8lGtL3bhxJJF/2/mE8K
         qMY8WgOI/u1iy9vn+n/+CSBvlmpJ9oorlJcya6jSAEBQHaPcf1srbPx9+zqV9L0QcE
         DJAeIG1obxAn1o1jbnYNGoc7gQjfFV5OSVBXp4Fs=
Date:   Wed, 05 Jan 2022 15:08:48 -0800
From:   akpm@linux-foundation.org
To:     jannh@google.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        schwidefsky@de.ibm.com
Subject:  + mm-oom-oom-sysrq-should-always-kill-a-process.patch
 added to -mm tree
Message-ID: <20220105230848.qucnz05JG%akpm@linux-foundation.org>
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
somewhere.  That's probably not what the user wants.

As documented in struct oom_control, order == -1 means the oom kill is
required by sysrq.  So check for that, and if it's true, don't bail out no
matter what the OOM notifiers say.

Link: https://lkml.kernel.org/r/20220105175115.605074-1-jannh@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/oom_kill.c~mm-oom-oom-sysrq-should-always-kill-a-process
+++ a/mm/oom_kill.c
@@ -1052,13 +1052,14 @@ EXPORT_SYMBOL_GPL(unregister_oom_notifie
 bool out_of_memory(struct oom_control *oc)
 {
 	unsigned long freed = 0;
+	bool sysrq_forced = oc->order == -1;
 
 	if (oom_killer_disabled)
 		return false;
 
 	if (!is_memcg_oom(oc)) {
 		blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
-		if (freed > 0)
+		if (freed > 0 && !sysrq_forced)
 			/* Got some memory back in the last second. */
 			return true;
 	}
_

Patches currently in -mm which might be from jannh@google.com are

mm-oom-oom-sysrq-should-always-kill-a-process.patch

