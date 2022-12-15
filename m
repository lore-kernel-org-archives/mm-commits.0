Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B0CC3DA71
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 20:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiLOU1J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 15:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiLOU1E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 15:27:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48F2389F7
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 12:27:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 02064CE1D06
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 20:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134D0C433D2;
        Thu, 15 Dec 2022 20:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671136019;
        bh=KSA2MLdd3x383BY3sci3Q4j2LacImc70Oz2X0V1uOxY=;
        h=Date:To:From:Subject:From;
        b=sDBFzQ5hbtDoXJlx7JryiUR2pXdKfhb53XmikK86K84kYrdW8Uy1fsL+SFicOqVtp
         x2VKLJevst6nc+wTiOb68yHVsXKSSuqZT2zy39trQ345ujgDwtGU7vdqJGIEvmRghO
         Y5JYgHKkMBVk26cC1/DotW2xZ9MbnqlCHcb938jI=
Date:   Thu, 15 Dec 2022 12:26:58 -0800
To:     mm-commits@vger.kernel.org, zhaoyang.huang@unisoc.com,
        willy@infradead.org, vbabka@suse.cz, ke.wang@unisoc.com,
        huangzhaoyang@gmail.com, catalin.marinas@arm.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20221215202659.134D0C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-use-stack_depot-for-recording-kmemleaks-backtrace.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes
Date: Thu Oct 27 12:12:56 PM PDT 2022

WARNING: please, no spaces at the start of a line
#59: FILE: mm/kmemleak.c:362:
+       for (i = 0; i < nr_entries; i++) {$

WARNING: suspect code indent for conditional statements (7, 15)
#59: FILE: mm/kmemleak.c:362:
+       for (i = 0; i < nr_entries; i++) {
+               void *ptr = (void *)entries[i];

ERROR: code indent should use tabs where possible
#60: FILE: mm/kmemleak.c:363:
+               void *ptr = (void *)entries[i];$

WARNING: please, no spaces at the start of a line
#60: FILE: mm/kmemleak.c:363:
+               void *ptr = (void *)entries[i];$

ERROR: code indent should use tabs where possible
#61: FILE: mm/kmemleak.c:364:
+               warn_or_seq_printf(seq, "    [<%p>] %pS\n", ptr, ptr);$

WARNING: Missing a blank line after declarations
#61: FILE: mm/kmemleak.c:364:
+               void *ptr = (void *)entries[i];
+               warn_or_seq_printf(seq, "    [<%p>] %pS\n", ptr, ptr);

WARNING: please, no spaces at the start of a line
#61: FILE: mm/kmemleak.c:364:
+               warn_or_seq_printf(seq, "    [<%p>] %pS\n", ptr, ptr);$

WARNING: please, no spaces at the start of a line
#62: FILE: mm/kmemleak.c:365:
+       }$

ERROR: space required before the open parenthesis '('
#71: FILE: mm/kmemleak.c:384:
+	if(object->trace_handle)

total: 3 errors, 6 warnings, 107 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mm-use-stack_depot-for-recording-kmemleaks-backtrace.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: ke.wang <ke.wang@unisoc.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/kmemleak.c~mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes
+++ a/mm/kmemleak.c
@@ -359,10 +359,10 @@ static void print_unreferenced(struct se
 	hex_dump_object(seq, object);
 	warn_or_seq_printf(seq, "  backtrace:\n");
 
-       for (i = 0; i < nr_entries; i++) {
-               void *ptr = (void *)entries[i];
-               warn_or_seq_printf(seq, "    [<%p>] %pS\n", ptr, ptr);
-       }
+	for (i = 0; i < nr_entries; i++) {
+		void *ptr = (void *)entries[i];
+		warn_or_seq_printf(seq, "    [<%p>] %pS\n", ptr, ptr);
+	}
 }
 
 /*
@@ -381,7 +381,7 @@ static void dump_object_info(struct kmem
 	pr_notice("  flags = 0x%x\n", object->flags);
 	pr_notice("  checksum = %u\n", object->checksum);
 	pr_notice("  backtrace:\n");
-	if(object->trace_handle)
+	if (object->trace_handle)
 		stack_depot_print(object->trace_handle);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-use-stack_depot-for-recording-kmemleaks-backtrace.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-fix.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix.patch

