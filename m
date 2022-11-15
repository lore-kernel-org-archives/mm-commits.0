Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CD84C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiKOWNW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiKOWNS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:13:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD95C3120B
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:13:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 528A9B81B88
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B1DC433D6;
        Tue, 15 Nov 2022 22:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668550394;
        bh=hK1YOtD98Zjk6CrZsOQCSLhtSs9ROOOJwOMa2AEoGsM=;
        h=Date:To:From:Subject:From;
        b=LHA84TzmLY3NXCug5nitw3TWdq/mr7UWQK59sZeDyyPmlYGPx2PFmjHqzrxmVvXgQ
         qnF6wqsYW0jThm8VV3HkoiIRFnVeVT4iWRF+4oJ+2OtKxsacQwvSFa2lLqOoOEf8e/
         TpHbF4t9bsYlsum87RxFRII6cOluYFg2mDWVw1AQ=
Date:   Tue, 15 Nov 2022 14:13:13 -0800
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        rppt@kernel.org, paul.gortmaker@windriver.com,
        mail@christoph.anton.mitterer.name, kaleshsingh@google.com,
        ivan@cloudflare.com, hannes@cmpxchg.org, david@redhat.com,
        David.Laight@ACULAB.COM, corbet@lwn.net, adobriyan@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch removed from -mm tree
Message-Id: <20221115221313.E4B1DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix
has been removed from the -mm tree.  Its filename was
     proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

This patch was dropped because it was folded into proc-report-open-files-as-size-in-stat-for-proc-pid-fd.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix
Date: Tue Oct 18 04:09:23 PM PDT 2022

include linux/bitmap.h for bitmap_weight()

Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/fd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/fd.c~proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix
+++ a/fs/proc/fd.c
@@ -7,6 +7,7 @@
 #include <linux/namei.h>
 #include <linux/pid.h>
 #include <linux/ptrace.h>
+#include <linux/bitmap.h>
 #include <linux/security.h>
 #include <linux/file.h>
 #include <linux/seq_file.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-fix.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd.patch

