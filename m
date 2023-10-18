Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 625A8CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbjJRVnu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbjJRVnu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:43:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4A8121
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:43:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AD8C433C7;
        Wed, 18 Oct 2023 21:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697665427;
        bh=oAkTxMKtAcxwWmBy+BBX1iIvF5X54aMpeFxYm/obxwc=;
        h=Date:To:From:Subject:From;
        b=Zky5SV1kEHk77aT++T1hV7ho5giVUx94PyUfA7ZLBihL+7mtPiYp61yepxvBi4ent
         FpjIkggv+8Uif8+dgHPJMECb/m/C4cE0OaOip+LgbjY9ZMHHkhYYrfJ1CeLNxjo71i
         gajnYqMeUh3pT7LDmzYcpGLZl8YKWwnoG9Oxnvog=
Date:   Wed, 18 Oct 2023 14:43:47 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com,
        ndesaulniers@google.com, nathan@kernel.org, mark@fasheh.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        gustavoars@kernel.org, keescook@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-annotate-struct-ocfs2_replay_map-with-__counted_by.patch removed from -mm tree
Message-Id: <20231018214347.B3AD8C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: annotate struct ocfs2_replay_map with __counted_by
has been removed from the -mm tree.  Its filename was
     ocfs2-annotate-struct-ocfs2_replay_map-with-__counted_by.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


