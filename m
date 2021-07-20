Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E6DC07E95
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 21:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10CFA60FF2
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 21:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhGTVLl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jul 2021 17:11:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229820AbhGTVL0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Jul 2021 17:11:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1A8F6113A;
        Tue, 20 Jul 2021 21:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626817923;
        bh=aEFOTEYb/wg+ituKbN5ZstkelnCHv6fGQIZtCkJQR3c=;
        h=Date:From:To:Subject:From;
        b=wAUaZjeSCekTv0Xiq1kdBBVxVOZlVafI+y+MiHAXHnMEfHqThF0XCuysT19dVBpTC
         8438VWnWE/sQ8KkgYjsfWDkILYfurEBH5BonD8Ht43MlFiM/WnUFn3xyaSvDPuIPOI
         1qd5i+3BkA3IjN2hqrP8kKCL4sAaTIylAspm8oG8=
Date:   Tue, 20 Jul 2021 14:52:02 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ptikhomirov@virtuozzo.com,
        ktkhai@virtuozzo.com, keno@juliacomputing.com,
        ebiederm@xmission.com, avagin@gmail.com,
        alexander.mikhalitsyn@virtuozzo.com, 0x7f454c46@gmail.com,
        gorcunov@gmail.com
Subject:  + prctl-allow-to-setup-brk-for-et_dyn-executables.patch
 added to -mm tree
Message-ID: <20210720215202.J--HB%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: prctl: allow to setup brk for et_dyn executables
has been added to the -mm tree.  Its filename is
     prctl-allow-to-setup-brk-for-et_dyn-executables.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/prctl-allow-to-setup-brk-for-et_dyn-executables.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/prctl-allow-to-setup-brk-for-et_dyn-executables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: prctl: allow to setup brk for et_dyn executables

Keno Fischer reported that when a binray loaded via ld-linux-x the
prctl(PR_SET_MM_MAP) doesn't allow to setup brk value because it lays
before mm:end_data.

For example a test program shows

 | # ~/t
 |
 | start_code      401000
 | end_code        401a15
 | start_stack     7ffce4577dd0
 | start_data	   403e10
 | end_data        40408c
 | start_brk	   b5b000
 | sbrk(0)         b5b000

and when executed via ld-linux

 | # /lib64/ld-linux-x86-64.so.2 ~/t
 |
 | start_code      7fc25b0a4000
 | end_code        7fc25b0c4524
 | start_stack     7fffcc6b2400
 | start_data	   7fc25b0ce4c0
 | end_data        7fc25b0cff98
 | start_brk	   55555710c000
 | sbrk(0)         55555710c000

This of course prevent criu from restoring such programs.  Looking into
how kernel operates with brk/start_brk inside brk() syscall I don't see
any problem if we allow to setup brk/start_brk without checking for
end_data.  Even if someone pass some weird address here on a purpose then
the worst possible result will be an unexpected unmapping of existing vma
(own vma, since prctl works with the callers memory) but test for
RLIMIT_DATA is still valid and a user won't be able to gain more memory in
case of expanding VMAs via new values shipped with prctl call.

Link: https://lkml.kernel.org/r/20210121221207.GB2174@grain
Fixes: bbdc6076d2e5 ("binfmt_elf: move brk out of mmap when doing direct loader exec")
Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reported-by: Keno Fischer <keno@juliacomputing.com>
Acked-by: Andrey Vagin <avagin@gmail.com>
Tested-by: Andrey Vagin <avagin@gmail.com>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/kernel/sys.c~prctl-allow-to-setup-brk-for-et_dyn-executables
+++ a/kernel/sys.c
@@ -1960,13 +1960,6 @@ static int validate_prctl_map_addr(struc
 	error = -EINVAL;
 
 	/*
-	 * @brk should be after @end_data in traditional maps.
-	 */
-	if (prctl_map->start_brk <= prctl_map->end_data ||
-	    prctl_map->brk <= prctl_map->end_data)
-		goto out;
-
-	/*
 	 * Neither we should allow to override limits if they set.
 	 */
 	if (check_data_rlimit(rlimit(RLIMIT_DATA), prctl_map->brk,
_

Patches currently in -mm which might be from gorcunov@gmail.com are

prctl-allow-to-setup-brk-for-et_dyn-executables.patch

