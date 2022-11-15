Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C60EC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbiKOW0L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbiKOW0K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:26:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2799A24F34
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:26:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D91CBB81B7B
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83531C433B5;
        Tue, 15 Nov 2022 22:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551166;
        bh=gl50wjMitP12Bvcr3XYpX/ZCURwMSo7ViSe2xjpiDhE=;
        h=Date:To:From:Subject:From;
        b=ijC7sN1tkfeXZ5weaahA589MqPdDCxn7i9kfIWBWpBo4LJqfvFj/O8yO3TU5lz/EH
         eH0l8HuzEGma1ob9V0gmdJTWnKtyH29n+VUJjL5WjVePdhjQZxBcUaJwTy5BWL85DA
         8rhFXD9469EBTwpfr04xYbR0C/lP9sU/sKkZGQB8=
Date:   Tue, 15 Nov 2022 14:26:06 -0800
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        rppt@kernel.org, paul.gortmaker@windriver.com,
        mail@christoph.anton.mitterer.name, kaleshsingh@google.com,
        ivan@cloudflare.com, hannes@cmpxchg.org, david@redhat.com,
        David.Laight@ACULAB.COM, corbet@lwn.net, adobriyan@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch removed from -mm tree
Message-Id: <20221115222606.83531C433B5@smtp.kernel.org>
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
mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd.patch

