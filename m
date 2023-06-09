Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2AD3C7EE45
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbjFIXdN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbjFIXb7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C7C30F9
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6C0965CFE
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C14BC433EF;
        Fri,  9 Jun 2023 23:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353380;
        bh=50+ImKNfH00LT6CVKCAeT3uF/YN7ibz3D2xSblf5kdw=;
        h=Date:To:From:Subject:From;
        b=ht1Ohx4byKSF5KHUdGDGji7HqJr4aCL8sQwLPzVhtyqgscQP4Y96WX+SLtyl4ooIo
         slyZdXmpmhTJWv+1j3StI77rQrIeygAgeXimnKyfRsx5PfshtGSdyMr0ZxvivMZlAI
         Cmb8W6+vwsjCuuLmBAIERIdWAmkbITrqAhlaHjgE=
Date:   Fri, 09 Jun 2023 16:29:39 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-faq-remove-old-questions.patch removed from -mm tree
Message-Id: <20230609232940.3C14BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/mm/damon/faq: remove old questions
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-faq-remove-old-questions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/faq: remove old questions
Date: Thu, 25 May 2023 21:43:05 +0000

Patch series "Docs/mm/damon: Minor fixes and design doc update".

Some of the DAMON documents are outdated, or having minor typos or grammar
erros.  Especially, the design doc has not updated for DAMOS, which is an
important part of DAMON.  Fix the minor issues and update documents.


This patch (of 10):

The first two questions of DAMON faqs have raised when DAMON patches were
first submitted.  More than one year has passed since DAMON patches get
merged in the mainline, and that kind of questions are not asked nowadays.
Remove the questions.

Link: https://lkml.kernel.org/r/20230525214314.5204-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20230525214314.5204-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/faq.rst |   23 -----------------------
 1 file changed, 23 deletions(-)

--- a/Documentation/mm/damon/faq.rst~docs-mm-damon-faq-remove-old-questions
+++ a/Documentation/mm/damon/faq.rst
@@ -4,29 +4,6 @@
 Frequently Asked Questions
 ==========================
 
-Why a new subsystem, instead of extending perf or other user space tools?
-=========================================================================
-
-First, because it needs to be lightweight as much as possible so that it can be
-used online, any unnecessary overhead such as kernel - user space context
-switching cost should be avoided.  Second, DAMON aims to be used by other
-programs including the kernel.  Therefore, having a dependency on specific
-tools like perf is not desirable.  These are the two biggest reasons why DAMON
-is implemented in the kernel space.
-
-
-Can 'idle pages tracking' or 'perf mem' substitute DAMON?
-=========================================================
-
-Idle page tracking is a low level primitive for access check of the physical
-address space.  'perf mem' is similar, though it can use sampling to minimize
-the overhead.  On the other hand, DAMON is a higher-level framework for the
-monitoring of various address spaces.  It is focused on memory management
-optimization and provides sophisticated accuracy/overhead handling mechanisms.
-Therefore, 'idle pages tracking' and 'perf mem' could provide a subset of
-DAMON's output, but cannot substitute DAMON.
-
-
 Does DAMON support virtual memory only?
 =======================================
 
_

Patches currently in -mm which might be from sj@kernel.org are


