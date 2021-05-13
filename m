Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C6CC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 20:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE5D160E0B
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 20:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbhEMUxf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 16:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231159AbhEMUxd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 16:53:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFD1B61370;
        Thu, 13 May 2021 20:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620939142;
        bh=v1ctAvgaqBIb7gac1Uno9NvKI11DL0xjr87wuGEH+a0=;
        h=Date:From:To:Subject:From;
        b=kntrQP3NgwX3+E03O1T4TVOc6sVZ+CHTkOPE9ShTCksmhYGnNzPWQ1eEl50YJZLKw
         +j+za71RkOnGbUs/VnA7fJDIOSqr5bVWsLehMn9pkVotsbj30ColI4w4H85cWhkzgE
         nrkGVYWvRuhi1uwtpxCsaXzusyKQX+zAS9vdMVQc=
Date:   Thu, 13 May 2021 13:52:21 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, Felix.Kuehling@amd.com, j.neuschaefer@gmx.net,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        valentin.schneider@arm.com
Subject:  +
 =?US-ASCII?Q?kthread-switch-to-new-kerneldoc-syntax-for-named-variable-?=
 =?US-ASCII?Q?macro-argument.patch?= added to -mm tree
Message-ID: <20210513205221.LAbSEgSjq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: switch to new kerneldoc syntax for named variable ma=
cro argument
has been added to the -mm tree.  Its filename is
     kthread-switch-to-new-kerneldoc-syntax-for-named-variable-macro-argume=
nt.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kthread-switch-to-new-kerneld=
oc-syntax-for-named-variable-macro-argument.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kthread-switch-to-new-kerneld=
oc-syntax-for-named-variable-macro-argument.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
Subject: kthread: switch to new kerneldoc syntax for named variable macro a=
rgument

The syntax without dots is available since commit 43756e347f21
("scripts/kernel-doc: Add support for named variable macro arguments").

The same HTML output is produced with and without this patch.

Link: https://lkml.kernel.org/r/20210513161702.1721039-1-j.neuschaefer@gmx.=
net
Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kthread.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/kthread.h~kthread-switch-to-new-kerneldoc-syntax-for-na=
med-variable-macro-argument
+++ a/include/linux/kthread.h
@@ -18,7 +18,7 @@ struct task_struct *kthread_create_on_no
  * @threadfn: the function to run in the thread
  * @data: data pointer for @threadfn()
  * @namefmt: printf-style format string for the thread name
- * @arg...: arguments for @namefmt.
+ * @arg: arguments for @namefmt.
  *
  * This macro will create a kthread on the current node, leaving it in
  * the stopped state.  This is just a helper for kthread_create_on_node();
_

Patches currently in -mm which might be from j.neuschaefer@gmx.net are

kthread-switch-to-new-kerneldoc-syntax-for-named-variable-macro-argument.pa=
tch

