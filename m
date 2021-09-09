Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCB2C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9304611C5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348243AbhIIVG4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348628AbhIIVGf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:06:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B710D611C5;
        Thu,  9 Sep 2021 21:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221526;
        bh=PrXSVQ6GzXmjoXFAmaSrq4H6QSsM4rye+inSKP+vElY=;
        h=Date:From:To:Subject:From;
        b=pU8XD/9TIUpMjU1DpmaPxM8Qt0uOby4HZI0eY8jYda1LyTa7TQ1OqJfwBw/vvM6a4
         Xt35NzsLL61DxPjq6WmyC9owKW1KANbFFLAAEqolMUPn5Jx9heAzmMsVqEply0q1Pp
         ZA+90nchqcBoGHLv8Tsr4+lUcKWxtem2FSoR5wBg=
Date:   Thu, 09 Sep 2021 14:05:25 -0700
From:   akpm@linux-foundation.org
To:     0x7f454c46@gmail.com, alexander.mikhalitsyn@virtuozzo.com,
        avagin@gmail.com, ebiederm@xmission.com, gorcunov@gmail.com,
        keno@juliacomputing.com, ktkhai@virtuozzo.com,
        mm-commits@vger.kernel.org, ptikhomirov@virtuozzo.com
Subject:  [merged]
 prctl-allow-to-setup-brk-for-et_dyn-executables.patch removed from -mm tree
Message-ID: <20210909210525.T5I4ab84M%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: prctl: allow to setup brk for et_dyn executables
has been removed from the -mm tree.  Its filename was
     prctl-allow-to-setup-brk-for-et_dyn-executables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


