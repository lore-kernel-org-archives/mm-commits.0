Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD1DC61D97
	for <mm-commits@archiver.kernel.org>; Wed, 22 Nov 2023 22:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjKVWI1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Nov 2023 17:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbjKVWI1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Nov 2023 17:08:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015FD10C
        for <mm-commits@vger.kernel.org>; Wed, 22 Nov 2023 14:08:23 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94873C433C9;
        Wed, 22 Nov 2023 22:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700690903;
        bh=RMKGl240Sb2io8zbtrzkhJm62HBdeLzVy5mwy9+2ahk=;
        h=Date:To:From:Subject:From;
        b=bY5ZG0AwkSBhy8g9HrRPWPSdb9PJn14lRuLIeM+rx2HJMyNX9g4Ndo5vVrcvnyCkc
         aw5YMbwdkGuBvA5HnJx0T6jYgJVFambEKvBcnmtg6U8v0Kb6CwC5se+hlBKk1PzI2y
         pnRbmkkVnqQmtWkQVempcoDYH2/HwpPBx4OeYHHI=
Date:   Wed, 22 Nov 2023 14:08:22 -0800
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com, bhe@redhat.com,
        ubizjak@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-use-atomic_try_cmpxchg-in-crash_kexec.patch added to mm-nonmm-unstable branch
Message-Id: <20231122220823.94873C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: Use atomic_try_cmpxchg in crash_kexec
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-use-atomic_try_cmpxchg-in-crash_kexec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-use-atomic_try_cmpxchg-in-crash_kexec.patch

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
From: Uros Bizjak <ubizjak@gmail.com>
Subject: kexec: Use atomic_try_cmpxchg in crash_kexec
Date: Tue, 14 Nov 2023 17:12:01 +0100

Use atomic_try_cmpxchg instead of cmpxchg (*ptr, old, new) == old in
crash_kexec().  x86 CMPXCHG instruction returns success in ZF flag,
so this change saves a compare after cmpxchg.

No functional change intended.

Link: https://lkml.kernel.org/r/20231114161228.108516-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/kexec_core.c~kexec-use-atomic_try_cmpxchg-in-crash_kexec
+++ a/kernel/kexec_core.c
@@ -1063,9 +1063,10 @@ __bpf_kfunc void crash_kexec(struct pt_r
 	 * panic().  Otherwise parallel calls of panic() and crash_kexec()
 	 * may stop each other.  To exclude them, we use panic_cpu here too.
 	 */
+	old_cpu = PANIC_CPU_INVALID;
 	this_cpu = raw_smp_processor_id();
-	old_cpu = atomic_cmpxchg(&panic_cpu, PANIC_CPU_INVALID, this_cpu);
-	if (old_cpu == PANIC_CPU_INVALID) {
+
+	if (atomic_try_cmpxchg(&panic_cpu, &old_cpu, this_cpu)) {
 		/* This is the 1st CPU which comes here, so go ahead. */
 		__crash_kexec(regs);
 
_

Patches currently in -mm which might be from ubizjak@gmail.com are

kexec-use-atomic_try_cmpxchg-in-crash_kexec.patch

