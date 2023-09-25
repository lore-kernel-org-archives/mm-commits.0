Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37CECCE7A81
	for <mm-commits@archiver.kernel.org>; Mon, 25 Sep 2023 15:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbjIYPUK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Sep 2023 11:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbjIYPUK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2023 11:20:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F46E10C
        for <mm-commits@vger.kernel.org>; Mon, 25 Sep 2023 08:20:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A9FC433C8;
        Mon, 25 Sep 2023 15:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695655202;
        bh=A5UGgRPjDKNEPFhzqbEyaLb8qST2HxfHBDcFFubuDck=;
        h=Date:To:From:Subject:From;
        b=UGLEWCz8mUmG9KmKPUJZ5baRVGhxqJ32aKJynEcO5V7yU1ZLJAeNv7QXdXxa1nVcD
         qA99uFl5YuDqEl20qBr6L04cmhzsYCfJ+gPjrxCDdTH5rUcQ8PQh34aYhmsKxpZELl
         R4EJCNUF0sT+YIywlhidT1yDN+On3k0TCYw2WNF4=
Date:   Mon, 25 Sep 2023 08:20:01 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com,
        ndesaulniers@google.com, nathan@kernel.org, mark@fasheh.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        gustavoars@kernel.org, keescook@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-annotate-struct-ocfs2_replay_map-with-__counted_by.patch added to mm-nonmm-unstable branch
Message-Id: <20230925152002.09A9FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: annotate struct ocfs2_replay_map with __counted_by
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-annotate-struct-ocfs2_replay_map-with-__counted_by.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-annotate-struct-ocfs2_replay_map-with-__counted_by.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: ocfs2: annotate struct ocfs2_replay_map with __counted_by
Date: Fri, 22 Sep 2023 10:49:30 -0700

Prepare for the coming implementation by GCC and Clang of the __counted_by
attribute.  Flexible array members annotated with __counted_by can have
their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
(for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
functions).

As found with Coccinelle[1], add __counted_by for struct ocfs2_replay_map.

[1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci

Link: https://lkml.kernel.org/r/20230922174925.work.293-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/journal.c~ocfs2-annotate-struct-ocfs2_replay_map-with-__counted_by
+++ a/fs/ocfs2/journal.c
@@ -90,7 +90,7 @@ enum ocfs2_replay_state {
 struct ocfs2_replay_map {
 	unsigned int rm_slots;
 	enum ocfs2_replay_state rm_state;
-	unsigned char rm_replay_slots[];
+	unsigned char rm_replay_slots[] __counted_by(rm_slots);
 };
 
 static void ocfs2_replay_map_set_state(struct ocfs2_super *osb, int state)
_

Patches currently in -mm which might be from keescook@chromium.org are

mm-memcg-annotate-struct-mem_cgroup_threshold_ary-with-__counted_by.patch
ocfs2-annotate-struct-ocfs2_replay_map-with-__counted_by.patch

