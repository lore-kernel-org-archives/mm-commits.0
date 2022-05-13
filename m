Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B064C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383722AbiEMTWa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383793AbiEMTWT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962F23630E
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57D0FB83159
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09703C34100;
        Fri, 13 May 2022 19:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469700;
        bh=ZuiqHvlF0RfvJeJiPo6r5NOunyQ0hGvLyWSq7J4flOc=;
        h=Date:To:From:Subject:From;
        b=dZotA0s8iedftF6Y5Gf1RcrSMJxNBaTFF1j4EZtQYSH3B6hApHU4QeLz+atjBXHJA
         3mcT5Jwa9iV9daNsWRDeXA+vM6X9ieYPmQHPHROKUQSwO4BaHlCmVxseHiKGxf6i4J
         zKXKvtzE26FV6vAD88FHbr1feprxG9WuVJVm5J/w=
Date:   Fri, 13 May 2022 12:21:39 -0700
To:     mm-commits@vger.kernel.org, wanjiabing@vivo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-remove-duplicate-include-in-memoryc.patch removed from -mm tree
Message-Id: <20220513192140.09703C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: remove duplicate include in memory.c
has been removed from the -mm tree.  Its filename was
     mm-shmem-remove-duplicate-include-in-memoryc.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wan Jiabing <wanjiabing@vivo.com>
Subject: mm/shmem: remove duplicate include in memory.c

Fix following checkincludes.pl warning:
mm/memory.c: linux/mm_inline.h is included more than once.

The include is in line 44. Remove the duplicated here.

Link: https://lkml.kernel.org/r/20220427064717.803019-1-wanjiabing@vivo.com
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memory.c~mm-shmem-remove-duplicate-include-in-memoryc
+++ a/mm/memory.c
@@ -74,7 +74,6 @@
 #include <linux/perf_event.h>
 #include <linux/ptrace.h>
 #include <linux/vmalloc.h>
-#include <linux/mm_inline.h>
 
 #include <trace/events/kmem.h>
 
_

Patches currently in -mm which might be from wanjiabing@vivo.com are


