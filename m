Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF621C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4A5260F93
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhISXYS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Sep 2021 19:24:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhISXYS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 19 Sep 2021 19:24:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20C6A60F36;
        Sun, 19 Sep 2021 23:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632093772;
        bh=AIqFTSoDGa7lkJnW5znhaEKPBUrER/+yppYTxRee+pc=;
        h=Date:From:To:Subject:From;
        b=oxqjnqGYPYXowM0PF7Izos8lszAFaaK44GxMqulWhSSNcey6/OZZ67xihaNZy6Yzb
         8n5PETLH0T6JdNEYk00Q4NXFV3sWdNKqgk7slVxpu90fpJnNsbzwba5MtFXrqbNjKV
         OeW/tr8DmtAiS0U+cRaSXmx6K8DPgMWGnap/Stdc=
Date:   Sun, 19 Sep 2021 16:22:51 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sjpark@amazon.de
Subject:  + docs-vm-damon-remove-broken-reference.patch added to -mm
 tree
Message-ID: <20210919232251.Qn4XM%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs/vm/damon: remove broken reference
has been added to the -mm tree.  Its filename is
     docs-vm-damon-remove-broken-reference.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-vm-damon-remove-broken-reference.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-vm-damon-remove-broken-reference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sjpark@amazon.de>
Subject: docs/vm/damon: remove broken reference

Building DAMON documents warns for a reference to nonexisting doc, as
below:

    $ time make htmldocs
    [...]
    Documentation/vm/damon/index.rst:24: WARNING: toctree contains reference to nonexisting document 'vm/damon/plans'

This commit fixes the warning by removing the wrong reference.

Link: https://lkml.kernel.org/r/20210917123958.3819-4-sj@kernel.org
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/damon/index.rst |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/vm/damon/index.rst~docs-vm-damon-remove-broken-reference
+++ a/Documentation/vm/damon/index.rst
@@ -27,4 +27,3 @@ workloads and systems.
    faq
    design
    api
-   plans
_

Patches currently in -mm which might be from sjpark@amazon.de are

documentation-vm-move-user-guides-to-admin-guide-mm.patch
docs-vm-damon-remove-broken-reference.patch
include-linux-damonh-fix-kernel-doc-comments-for-damon_callback.patch

