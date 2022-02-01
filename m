Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE2AC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 19:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiBATgC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 14:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiBATgC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 14:36:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB26AC061714
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 11:36:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85D43B82F6F
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 19:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36EEC340EB;
        Tue,  1 Feb 2022 19:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643744159;
        bh=whKX+aKAYFAnF0ghDN2JC3TQwengsbHyxG9GxjWFZjE=;
        h=Date:To:From:Subject:From;
        b=LI3o+6ClpV8RaLslS/sfJtaeL+3qWpH4bRdiIXL/ACU3CRpCpyx3sqXCcM00ON9n3
         anZSMaiyY9FYw1bn9ecZXI+1kIrrKP3Far+1dx2LCLZw+GCaZwAEqFQEacJdIwWrkg
         lTEly2IX6jpbMjIo3tIeUTGUaNAX85tPk7gWfzfo=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 11:35:57 -0800
Date:   Tue, 01 Feb 2022 11:35:57 -0800
To:     mm-commits@vger.kernel.org, yangyingliang@huawei.com,
        willy@infradead.org, viro@zeniv.linux.org.uk, shuah@kernel.org,
        mtk.manpages@gmail.com, luto@kernel.org, ebiederm@xmission.com,
        dalias@libc.org, brauner@kernel.org, ariadne@dereferenced.org,
        keescook@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + exec-force-single-empty-string-when-argv-is-empty-fix.patch added to -mm tree
Message-Id: <20220201193557.C36EEC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: exec: Fix min/max typo in stack space calculation
has been added to the -mm tree.  Its filename is
     exec-force-single-empty-string-when-argv-is-empty-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/exec-force-single-empty-string-when-argv-is-empty-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/exec-force-single-empty-string-when-argv-is-empty-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: exec: Fix min/max typo in stack space calculation

When handling the argc == 0 case, the stack space calculation should be
using max() not min().

Link: https://lkml.kernel.org/r/20220201190700.3147041-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Ariadne Conill <ariadne@dereferenced.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/exec.c~exec-force-single-empty-string-when-argv-is-empty-fix
+++ a/fs/exec.c
@@ -502,7 +502,7 @@ static int bprm_stack_limits(struct linu
 	 * argc can never be 0, to keep them from walking envp by accident.
 	 * See do_execveat_common().
 	 */
-	ptr_size = (min(bprm->argc, 1) + bprm->envc) * sizeof(void *);
+	ptr_size = (max(bprm->argc, 1) + bprm->envc) * sizeof(void *);
 	if (limit <= ptr_size)
 		return -E2BIG;
 	limit -= ptr_size;
_

Patches currently in -mm which might be from keescook@chromium.org are

kconfigdebug-make-debug_info-selectable-from-a-choice.patch
kconfigdebug-make-debug_info-selectable-from-a-choice-fix.patch
exec-force-single-empty-string-when-argv-is-empty.patch
exec-force-single-empty-string-when-argv-is-empty-fix.patch
selftests-exec-test-for-empty-string-on-null-argv.patch
selftests-kselftest-framework-provide-finished-helper.patch

