Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FD8C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 19:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiCYTZ5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 15:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiCYTZ4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 15:25:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37733E26B5
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 11:57:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 607EBB828F5
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 18:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD07C004DD;
        Fri, 25 Mar 2022 18:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648234667;
        bh=14imhToJWxZZL/jzdTqML/eEhYGCHeRP3bxl/7Wl4YY=;
        h=Date:To:From:Subject:From;
        b=0+ocqIARbX2dPEkm/M7UlsBfjU62WOUJF+yMfpz8C+sIfrzKl2mFwcX7ow0XEA+Me
         VqTn2CtX2JPgdQpfd4asXVYpNMgYgTSbhWZtMaCzvWkRwrEka+Gij3f9rl4jmwH2ZZ
         HsMNjlCt2OrFDSL8eIJoCBj7LF5bLIjHVBoqH/fA=
Date:   Fri, 25 Mar 2022 11:57:46 -0700
To:     mm-commits@vger.kernel.org, xiyuyang19@fudan.edu.cn,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch added to -mm tree
Message-Id: <20220325185747.0AD07C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix
has been added to the -mm tree.  Its filename is
     mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix

fix warnings

mm/mempolicy.c:125:42: warning: missing braces around initializer [-Wmissing-braces]
  125 | static struct mempolicy default_policy = {
      |                                          ^
mm/mempolicy.c:125:42: warning: missing braces around initializer [-Wmissing-braces]
mm/mempolicy.c: In function 'numa_policy_init':
mm/mempolicy.c:2815:32: warning: missing braces around initializer [-Wmissing-braces]
 2815 |   preferred_node_policy[nid] = (struct mempolicy) {
      |                                ^
mm/mempolicy.c:2815:32: warning: missing braces around initializer [-Wmissing-braces]

Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix
+++ a/mm/mempolicy.c
@@ -123,7 +123,7 @@ enum zone_type policy_zone = 0;
  * run-time system-wide default policy => local allocation
  */
 static struct mempolicy default_policy = {
-	.refcnt = ATOMIC_INIT(1), /* never free it */
+	.refcnt = { ATOMIC_INIT(1), }, /* never free it */
 	.mode = MPOL_LOCAL,
 };
 
@@ -2891,7 +2891,7 @@ void __init numa_policy_init(void)
 
 	for_each_node(nid) {
 		preferred_node_policy[nid] = (struct mempolicy) {
-			.refcnt = ATOMIC_INIT(1),
+			.refcnt = { ATOMIC_INIT(1), },
 			.mode = MPOL_PREFERRED,
 			.flags = MPOL_F_MOF | MPOL_F_MORON,
 			.nodes = nodemask_of_node(nid),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

