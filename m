Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C6AC46CA1
	for <mm-commits@archiver.kernel.org>; Mon, 18 Sep 2023 19:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjIRTi5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Sep 2023 15:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjIRTi4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Sep 2023 15:38:56 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394F3109
        for <mm-commits@vger.kernel.org>; Mon, 18 Sep 2023 12:38:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA200C433C9;
        Mon, 18 Sep 2023 19:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695065930;
        bh=AB4TlqVpfRSi6//cNfW3UVM6FNATAU3ofes3//hJNTo=;
        h=Date:To:From:Subject:From;
        b=hTkFPvKdgNWMjaNCxef+kTwe8GhfZyBCwLBUQ13GhAy4mPrpWOuLkClj7cSbrhibr
         +zBj1HDihlaU85FY7RafPMlxg/3rZzHNSnUGp04yPSIxuzgWzuHArEngfesAZbFr6Z
         Hvh4sskefekQIdopiN9snzEcmK97xgFDTjlhkYys=
Date:   Mon, 18 Sep 2023 12:38:50 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com, hughd@google.com,
        hannes@cmpxchg.org, david@redhat.com, shr@devkernel.io,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-document-pages_skipped-sysfs-knob.patch added to mm-unstable branch
Message-Id: <20230918193850.CA200C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm: document pages_skipped sysfs knob
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-document-pages_skipped-sysfs-knob.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-document-pages_skipped-sysfs-knob.patch

This patch will later appear in the mm-unstable branch at
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
From: Stefan Roesch <shr@devkernel.io>
Subject: mm/ksm: document pages_skipped sysfs knob
Date: Mon, 18 Sep 2023 11:58:16 -0700

This adds documentation for the new metric pages_skipped.

Link: https://lkml.kernel.org/r/20230918185816.1518366-5-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/ksm.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/admin-guide/mm/ksm.rst~mm-ksm-document-pages_skipped-sysfs-knob
+++ a/Documentation/admin-guide/mm/ksm.rst
@@ -178,6 +178,8 @@ pages_unshared
         how many pages unique but repeatedly checked for merging
 pages_volatile
         how many pages changing too fast to be placed in a tree
+pages_skipped
+        how many pages did the "smart" page scanning algorithm skip
 full_scans
         how many times all mergeable areas have been scanned
 stable_node_chains
_

Patches currently in -mm which might be from shr@devkernel.io are

mm-ksm-add-smart-page-scanning-mode.patch
mm-ksm-add-pages_skipped-metric.patch
mm-ksm-document-smart-scan-mode.patch
mm-ksm-document-pages_skipped-sysfs-knob.patch

