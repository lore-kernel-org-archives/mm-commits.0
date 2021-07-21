Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D7DC07E9B
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 01:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CD5860BD3
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jul 2021 01:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhGUApl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jul 2021 20:45:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229816AbhGUApj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Jul 2021 20:45:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FD2D60BD3;
        Wed, 21 Jul 2021 01:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626830775;
        bh=2yYu88zITuIqrnFXrYAp3786cEWMok6sLZAHIcGTZLE=;
        h=Date:From:To:Subject:From;
        b=TIGdwpoMeMctBUR7eS/TBX+CROY2wLS1eRx1AD5cr+Q/OIRLHnN2uOxhivMtQrGR0
         DtMSTIR7VLMG6TFnJFF0VumfbA4r3+UxJQcleg5aAcslZ8XYZzk6WCxHXAKwg1B98R
         aAkWYsiS/BVf5GMFQLjCj8uxU3YO86YWJHQnyllI=
Date:   Tue, 20 Jul 2021 18:26:15 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        xiyuyang19@fudan.edu.cn
Subject:  +
 =?US-ASCII?Q?mm-mempolicy-convert-from-atomic=5Ft-to-refcount=5Ft-on-me?=
 =?US-ASCII?Q?mpolicy-refcnt-fix.patch?= added to -mm tree
Message-ID: <20210721012615.-6KcsDH78%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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
 
@@ -2813,7 +2813,7 @@ void __init numa_policy_init(void)
 
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
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

