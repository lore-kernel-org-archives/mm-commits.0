Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A80ECD484A
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 18:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbjIVSBB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Sep 2023 14:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233145AbjIVSA7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Sep 2023 14:00:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B89C1
        for <mm-commits@vger.kernel.org>; Fri, 22 Sep 2023 11:00:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D733C433C7;
        Fri, 22 Sep 2023 18:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695405652;
        bh=8R3TEAcY+/7dH/iZusLfbxyq9SSQq2Uk/0iyLHO+tks=;
        h=Date:To:From:Subject:From;
        b=yywIVS4HdPdKpl91mgiU3sKUETzZoH7t533kgmGQuFBxGTK3pBAi0AEcpiMX52dL5
         T7+9Bct1TjpmWnbu8TMo8+YguaIdhHEty5gVYg/3y6rmZB9hniwT7FQDZTcUdr35Ie
         GptWlUl0etDH63UwhKlXUjTrkbLR+LOVI73uqVjw=
Date:   Fri, 22 Sep 2023 11:00:51 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, keescook@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-annotate-struct-mem_cgroup_threshold_ary-with-__counted_by.patch added to mm-unstable branch
Message-Id: <20230922180052.8D733C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: annotate struct mem_cgroup_threshold_ary with __counted_by
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-annotate-struct-mem_cgroup_threshold_ary-with-__counted_by.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-annotate-struct-mem_cgroup_threshold_ary-with-__counted_by.patch

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
From: Kees Cook <keescook@chromium.org>
Subject: mm/memcg: annotate struct mem_cgroup_threshold_ary with __counted_by
Date: Fri, 22 Sep 2023 10:53:28 -0700

Prepare for the coming implementation by GCC and Clang of the __counted_by
attribute.  Flexible array members annotated with __counted_by can have
their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
(for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
functions).

As found with Coccinelle[1], add __counted_by for struct
mem_cgroup_threshold_ary.

[1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci

Link: https://lkml.kernel.org/r/20230922175327.work.985-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-memcg-annotate-struct-mem_cgroup_threshold_ary-with-__counted_by
+++ a/include/linux/memcontrol.h
@@ -143,7 +143,7 @@ struct mem_cgroup_threshold_ary {
 	/* Size of entries[] */
 	unsigned int size;
 	/* Array of thresholds */
-	struct mem_cgroup_threshold entries[];
+	struct mem_cgroup_threshold entries[] __counted_by(size);
 };
 
 struct mem_cgroup_thresholds {
_

Patches currently in -mm which might be from keescook@chromium.org are

mm-memcg-annotate-struct-mem_cgroup_threshold_ary-with-__counted_by.patch

