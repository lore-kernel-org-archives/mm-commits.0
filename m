Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FAFC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  7 Nov 2022 20:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbiKGUdt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Nov 2022 15:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbiKGUds (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2022 15:33:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E71F28E27
        for <mm-commits@vger.kernel.org>; Mon,  7 Nov 2022 12:33:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5346B81619
        for <mm-commits@vger.kernel.org>; Mon,  7 Nov 2022 20:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9072EC433C1;
        Mon,  7 Nov 2022 20:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667853223;
        bh=HoGEZARM5HjxLFgONvZxYj07l5H5vD2edS56fsXEkp4=;
        h=Date:To:From:Subject:From;
        b=c/nR+XGN5GjVfXJU7NZvMKRpJnS7E1jYp4HKjtpZzpFMZ1G13pyBILA1OzqXpDSAl
         xtiqXkLIzKzxq0Yk8Hp2/Jgtku1PIdKUT7DkaJKwAxqadBqqETy+09w4s0RyI5Apn6
         B6wpIbmpy6x2420VGa2+S+Pez04PDb81nWsA90AI=
Date:   Mon, 07 Nov 2022 12:33:42 -0800
To:     mm-commits@vger.kernel.org, corbet@lwn.net, bagasdotme@gmail.com,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-kmsan-fix-formatting-of-example-report.patch added to mm-hotfixes-unstable branch
Message-Id: <20221107203343.9072EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs: kmsan: fix formatting of "Example report"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     docs-kmsan-fix-formatting-of-example-report.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-kmsan-fix-formatting-of-example-report.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Alexander Potapenko <glider@google.com>
Subject: docs: kmsan: fix formatting of "Example report"
Date: Mon, 7 Nov 2022 15:22:55 +0100

Add a blank line to make the sentence before the list render as a separate
paragraph, not a definition.

Link: https://lkml.kernel.org/r/20221107142255.4038811-1-glider@google.com
Fixes: 93858ae70cf4 ("kmsan: add ReST documentation")
Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kmsan.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/dev-tools/kmsan.rst~docs-kmsan-fix-formatting-of-example-report
+++ a/Documentation/dev-tools/kmsan.rst
@@ -67,6 +67,7 @@ uninitialized in the local variable, as
 copied to another memory location before use.
 
 A use of uninitialized value ``v`` is reported by KMSAN in the following cases:
+
  - in a condition, e.g. ``if (v) { ... }``;
  - in an indexing or pointer dereferencing, e.g. ``array[v]`` or ``*v``;
  - when it is copied to userspace or hardware, e.g. ``copy_to_user(..., &v, ...)``;
_

Patches currently in -mm which might be from glider@google.com are

kmsan-core-kmsan_in_runtime-should-return-true-in-nmi-context.patch
x86-uaccess-instrument-copy_from_user_nmi.patch
kconfigdebug-ensure-early-check-for-kmsan-in-config_kmsan_warn.patch
kmsan-make-sure-preempt_rt-is-off.patch
x86-traps-avoid-kmsan-bugs-originating-from-handle_bug.patch
docs-kmsan-fix-formatting-of-example-report.patch

