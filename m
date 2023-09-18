Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A38CD13D2
	for <mm-commits@archiver.kernel.org>; Mon, 18 Sep 2023 19:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjIRTiz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Sep 2023 15:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjIRTiy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Sep 2023 15:38:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928DF10A
        for <mm-commits@vger.kernel.org>; Mon, 18 Sep 2023 12:38:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1F1C433CA;
        Mon, 18 Sep 2023 19:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695065929;
        bh=mYNDs8B43LPEqO4dHDvf0TlKvPG7O26Tpz3knZQJTq4=;
        h=Date:To:From:Subject:From;
        b=SulttOfhbyp77Ostsz2neUknEc0tNFGQWgrf5rpN0xKAbHtni17tOEoO6+JXVdQ9w
         hV7RIgiLKpz+pAD9wXrhNtaByGGUseYDJ57DnRN6JX0Io/8amX8AuocbosqzK7bvfd
         UpQ/i/2WSaVfwHdcw1QYjY/sP4lLor1C5Szepe0E=
Date:   Mon, 18 Sep 2023 12:38:48 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com, hughd@google.com,
        hannes@cmpxchg.org, david@redhat.com, shr@devkernel.io,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-document-smart-scan-mode.patch added to mm-unstable branch
Message-Id: <20230918193849.1D1F1C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm: document smart scan mode
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-document-smart-scan-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-document-smart-scan-mode.patch

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
Subject: mm/ksm: document smart scan mode
Date: Mon, 18 Sep 2023 11:58:15 -0700

This adds documentation for the smart scan mode of KSM.

Link: https://lkml.kernel.org/r/20230918185816.1518366-4-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/ksm.rst |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/Documentation/admin-guide/mm/ksm.rst~mm-ksm-document-smart-scan-mode
+++ a/Documentation/admin-guide/mm/ksm.rst
@@ -155,6 +155,15 @@ stable_node_chains_prune_millisecs
         scan. It's a noop if not a single KSM page hit the
         ``max_page_sharing`` yet.
 
+smart_scan
+        By default KSM checks every candidate page for each scan. It does
+        not take into account historic information. When smart scan is
+        enabled, pages that have previously not been de-duplicated get
+        skipped. How often these pages are skipped depends on how often
+        de-duplication has already been tried and failed. By default this
+        optimization is disabled. The ``pages_skipped`` metric shows how
+        effetive the setting is.
+
 The effectiveness of KSM and MADV_MERGEABLE is shown in ``/sys/kernel/mm/ksm/``:
 
 general_profit
_

Patches currently in -mm which might be from shr@devkernel.io are

mm-ksm-add-smart-page-scanning-mode.patch
mm-ksm-add-pages_skipped-metric.patch
mm-ksm-document-smart-scan-mode.patch
mm-ksm-document-pages_skipped-sysfs-knob.patch

