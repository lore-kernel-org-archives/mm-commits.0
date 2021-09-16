Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D59BC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 18:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B2B9611EE
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 18:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239203AbhIPSIC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Sep 2021 14:08:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346765AbhIPSFG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Sep 2021 14:05:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 913806113A;
        Thu, 16 Sep 2021 18:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631815425;
        bh=tfxQKDkG8VUeUMWgHxuBDyzWAj/R0j6IoEVWjnzS+Sg=;
        h=Date:From:To:Subject:From;
        b=2Erz9IOGWZ98Za90WRQ8h06ptJ+GwxrBj0GSz1satj844rUlxnXgHptA6KZ21ei9k
         2re8XRm+MohDSLJm3BedpQVF5/msNSdZ5CtRaSh8Lrps55USmTYGoYDFqsTrkvQD6y
         hsosdlaGSByBuliuBg+8wYhRFdC3tBmdmJDkJvic=
Date:   Thu, 16 Sep 2021 11:03:45 -0700
From:   akpm@linux-foundation.org
To:     imran.f.khan@oracle.com, mm-commits@vger.kernel.org
Subject:  +
 lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v3.patch added
 to -mm tree
Message-ID: <20210916180345.ASXyzshbz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v3
has been added to the -mm tree.  Its filename is
     lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Imran Khan <imran.f.khan@oracle.com>
Subject: lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v3

export stack_depot_snprint() to modules

Link: https://lkml.kernel.org/r/20210916133535.3592491-4-imran.f.khan@oracle.com
Signed-off-by: Imran Khan <imran.f.khan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/stackdepot.c~lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v3
+++ a/lib/stackdepot.c
@@ -237,6 +237,7 @@ int stack_depot_snprint(depot_stack_hand
 	return nr_entries ? stack_trace_snprint(buf, size, entries, nr_entries,
 						spaces) : 0;
 }
+EXPORT_SYMBOL_GPL(stack_depot_snprint);
 
 /**
  * stack_depot_print - print stack entries from a depot
_

Patches currently in -mm which might be from imran.f.khan@oracle.com are

lib-stackdepot-check-stackdepot-handle-before-accessing-slabs.patch
lib-stackdepot-add-helper-to-print-stack-entries.patch
lib-stackdepot-add-helper-to-print-stack-entries-into-buffer.patch
lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v2.patch
lib-stackdepot-add-helper-to-print-stack-entries-into-buffer-v3.patch

