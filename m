Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B9FC48BDF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 03:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB5EE611CA
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 03:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbhFODRX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Jun 2021 23:17:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhFODRX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Jun 2021 23:17:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C25B160698;
        Tue, 15 Jun 2021 03:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623726919;
        bh=MuuPeH7xEx4LHBRDHb8NO+jlyTQPJAqfaA2i6DBhlTw=;
        h=Date:From:To:Subject:From;
        b=Th+Cbu4LUPZG50BVb+8Oi3ln7zx4p2DWW0r3yVVd3cLEY6pcEGT6erf9a3a16pB4R
         YfChbe3YlPnbHDRiT4MlPAj8OMgoLNDWlnuUmGgkuV0EINGaCP9P4h2KoxjAecXuky
         /V2apLJeSm7L+CyVhc6iUzWBYD6CGtNBnmL9itmU=
Date:   Mon, 14 Jun 2021 20:15:18 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, gechangwei@live.cn, ghe@suse.com,
        jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org,
        piaojun@huawei.com
Subject:  +
 ocfs2-remove-redundant-initialization-of-variable-ret.patch added to -mm
 tree
Message-ID: <20210615031518.DnjoqXU17%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove redundant initialization of variable ret
has been added to the -mm tree.  Its filename is
     ocfs2-remove-redundant-initialization-of-variable-ret.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-redundant-initialization-of-variable-ret.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-redundant-initialization-of-variable-ret.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: ocfs2: remove redundant initialization of variable ret

The variable ret is being initialized with a value that is never read, the
assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Link: https://lkml.kernel.org/r/20210613135148.74658-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/nodemanager.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/cluster/nodemanager.c~ocfs2-remove-redundant-initialization-of-variable-ret
+++ a/fs/ocfs2/cluster/nodemanager.c
@@ -824,7 +824,7 @@ static void __exit exit_o2nm(void)
 
 static int __init init_o2nm(void)
 {
-	int ret = -1;
+	int ret;
 
 	o2hb_init();
 
_

Patches currently in -mm which might be from colin.king@canonical.com are

scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch
ocfs2-remove-redundant-assignment-to-pointer-queue.patch
ocfs2-remove-redundant-initialization-of-variable-ret.patch
lib-math-rational-add-kunit-test-cases-fix-2.patch

