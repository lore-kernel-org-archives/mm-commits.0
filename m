Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E13C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbiEJEPY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235968AbiEJEOu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357DA205E5
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:10:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D94ADB81AE7
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D5EC385C5;
        Tue, 10 May 2022 04:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155851;
        bh=EW1Jc32YtsxIj7lfRC7V6NJQnJugno7OF9JN4Ucuk2E=;
        h=Date:To:From:Subject:From;
        b=ZNrFzbDfcnsrr73K8PTgTStd4I2IFmlgtTMOYHrySQQXVrHXXa2PpmjwBwXvrzuuZ
         rbgiJgli5eO4PrA9qPpkMzYeCfKmDYy2hzbKSOcfkP8XNYdaBx6qpxsvnA4N6pAi+f
         ZrQ6HWCEGM05tZ3MuIGzPC1alqJqrFgeyW3abjwU=
Date:   Mon, 09 May 2022 21:10:50 -0700
To:     mm-commits@vger.kernel.org, yi.zhang@huawei.com, vbabka@suse.cz,
        torvalds@linux-foundation.org, surenb@google.com, rppt@kernel.org,
        mgorman@techsingularity.net, dave.hansen@linux.intel.com,
        corbet@lwn.net, charante@codeaurora.org, jsavitz@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-sysctl-document-page_lock_unfairness.patch removed from -mm tree
Message-Id: <20220510041051.86D5EC385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Documentation/sysctl: document page_lock_unfairness
has been removed from the -mm tree.  Its filename was
     documentation-sysctl-document-page_lock_unfairness.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Joel Savitz <jsavitz@redhat.com>
Subject: Documentation/sysctl: document page_lock_unfairness

commit 5ef64cc8987a ("mm: allow a controlled amount of unfairness in the
page lock") introduced a new systctl but no accompanying documentation.

Add a simple entry to the documentation.

Link: https://lkml.kernel.org/r/20220325164437.120246-1-jsavitz@redhat.com
Signed-off-by: Joel Savitz <jsavitz@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: Charan Teja Reddy <charante@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/Documentation/admin-guide/sysctl/vm.rst~documentation-sysctl-document-page_lock_unfairness
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -62,6 +62,7 @@ Currently, these files are in /proc/sys/
 - overcommit_memory
 - overcommit_ratio
 - page-cluster
+- page_lock_unfairness
 - panic_on_oom
 - percpu_pagelist_high_fraction
 - stat_interval
@@ -754,6 +755,14 @@ extra faults and I/O delays for followin
 that consecutive pages readahead would have brought in.
 
 
+page_lock_unfairness
+====================
+
+This value determines the number of times that the page lock can be
+stolen from under a waiter. After the lock is stolen the number of times
+specified in this file (default is 5), the "fair lock handoff" semantics
+will apply, and the waiter will only be awakened if the lock can be taken.
+
 panic_on_oom
 ============
 
_

Patches currently in -mm which might be from jsavitz@redhat.com are


