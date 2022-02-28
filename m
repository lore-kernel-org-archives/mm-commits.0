Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F9DC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 02:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbiB1C6k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Feb 2022 21:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbiB1C6j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 27 Feb 2022 21:58:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E292DAA3
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 18:58:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A56A960EBE
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 02:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C104C340E9;
        Mon, 28 Feb 2022 02:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646017081;
        bh=wsATtkZ9+6Tw1j7uSo0MHG5xk7bH45Pol7pOK1fvEiI=;
        h=Date:To:From:Subject:From;
        b=AUrSjAuUSKWqTuEFRiu/ItoHJdUpfEzv8y9/rWZbyDufQytcVtnH4e+oJB2FnKvET
         7rjcrvRK2OPHeujb4NQZXZX17d9YGqSzAzJ8WI9K/WJK8AT/O1DOHklEnjxa12kWVs
         rAaSCuy3XnrCKX+kzwHDAbl9DcLqftz6thCuss1M=
Date:   Sun, 27 Feb 2022 18:58:00 -0800
To:     mm-commits@vger.kernel.org, yangyingliang@huawei.com,
        willy@infradead.org, viro@zeniv.linux.org.uk, shuah@kernel.org,
        mtk.manpages@gmail.com, luto@kernel.org, ebiederm@xmission.com,
        dalias@libc.org, brauner@kernel.org, ariadne@dereferenced.org,
        keescook@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] exec-force-single-empty-string-when-argv-is-empty-fix.patch removed from -mm tree
Message-Id: <20220228025801.0C104C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: exec: Fix min/max typo in stack space calculation
has been removed from the -mm tree.  Its filename was
     exec-force-single-empty-string-when-argv-is-empty-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
selftests-kselftest-framework-provide-finished-helper.patch

