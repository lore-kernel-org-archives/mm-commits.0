Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92140C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D89061C6F
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhGFTKq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:10:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231792AbhGFTKq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:10:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B83661C70;
        Tue,  6 Jul 2021 19:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598487;
        bh=qReaXwPaBHmJAkLExzHes9BjXJIM1RjZzGJhGfK+w7g=;
        h=Date:From:To:Subject:From;
        b=WMGmUQJTO0XA5thWnGeHgwOnjPXPX2ijGf/2236K77NKeQbUel0CnuZUUkqNjk5as
         1rcpdvVDR2mv+M9dbK4W1NHdxDzc4Es1xEsWMRggkbqK1pIUS620E4cKvFNmxI52cp
         vzOAV2zbeUa4od2e9wNLjwGvYBsvymCcKH8d1gjg=
Date:   Tue, 06 Jul 2021 12:08:07 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, Felix.Kuehling@amd.com, j.neuschaefer@gmx.net,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        valentin.schneider@arm.com
Subject:  [merged]
 =?US-ASCII?Q?kthread-switch-to-new-kerneldoc-syntax-for-named-variable-?=
 =?US-ASCII?Q?macro-argument.patch?= removed from -mm tree
Message-ID: <20210706190807.ywrfRJA4T%akpm@linux-foundation.org>
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
has been removed from the -mm tree.  Its filename was
     kthread-switch-to-new-kerneldoc-syntax-for-named-variable-macro-argume=
nt.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

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


