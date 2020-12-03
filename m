Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A91C4361B
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 00:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71D1C22224
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 00:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729762AbgLDAAE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Dec 2020 19:00:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:52030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728240AbgLDAAD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Dec 2020 19:00:03 -0500
Date:   Thu, 03 Dec 2020 15:59:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607039957;
        bh=65iVujU5TWewewwBthYUrNfMlr2K3RerQVb/gD9rCj0=;
        h=From:To:Subject:From;
        b=QSB6Hn0duLyd8p1H1uLPXKBam0dDBFazNeo7+MGiArQ4oEl1l7M94sk4149ejjbru
         zl1PUCRrJ74THpmaBfG3Efzbuk1CPwpJFBuWYQuEgLA0MwLNbxdnQ8nFWj0C6NP6ny
         Dw63zok8BcaYlEXn88UkkcRGLsxoTigyKzfN6tn0=
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, corbet@lwn.net,
        dvyukov@google.com, elver@google.com, glider@google.com,
        jiangshanlai@gmail.com, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, tj@kernel.org,
        walter-zh.wu@mediatek.com
Subject:  + kasan-update-documentation-for-generic-kasan.patch
 added to -mm tree
Message-ID: <20201203235916.CsokYuYi_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: update documentation for generic kasan
has been added to the -mm tree.  Its filename is
     kasan-update-documentation-for-generic-kasan.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-update-documentation-for-generic-kasan.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-update-documentation-for-generic-kasan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: kasan: update documentation for generic kasan

Generic KASAN also supports to record the last two workqueue stacks and
print them in KASAN report.  So that need to update documentation.

Link: https://lkml.kernel.org/r/20201203023037.30792-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Suggested-by: Marco Elver <elver@google.com>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-update-documentation-for-generic-kasan
+++ a/Documentation/dev-tools/kasan.rst
@@ -190,8 +190,9 @@ function calls GCC directly inserts the
 This option significantly enlarges kernel but it gives x1.1-x2 performance
 boost over outline instrumented kernel.
 
-Generic KASAN prints up to 2 call_rcu() call stacks in reports, the last one
-and the second to last.
+Generic KASAN also reports the last 2 call stacks to creation of work that
+potentially has access to an object. Call stacks for the following are shown:
+call_rcu() and workqueue queuing.
 
 Software tag-based KASAN
 ~~~~~~~~~~~~~~~~~~~~~~~~
_

Patches currently in -mm which might be from walter-zh.wu@mediatek.com are

workqueue-kasan-record-workqueue-stack.patch
kasan-print-workqueue-stack.patch
lib-test_kasanc-add-workqueue-test-case.patch
kasan-update-documentation-for-generic-kasan.patch

