Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 758BAC07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DC7B61C9E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhGFTZr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:25:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229950AbhGFTZr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:25:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F90961CAB;
        Tue,  6 Jul 2021 19:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599387;
        bh=C3ZXsry8V1B/5o0Cwj4TrbWS8+/k6XXSNvWsXoSYkW4=;
        h=Date:From:To:Subject:From;
        b=cacT53/uptQ7EV6Ss+uf/NKvMQqBADQ9etVCp6szqcfEBQEnoebTA7yGNSfala6fe
         zKRQxASBUA+VgWqdxHU2Gb9o1LmxTjZ51uuKpWIJ1exGK8QjUauJzkEBnNvjxdamnI
         rvD921LWtqWOJ2OAcb9DwbSYmV7VeUn5jtcn9Ifo=
Date:   Tue, 06 Jul 2021 12:23:07 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, konishi.ryusuke@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 nilfs2-remove-redundant-continue-statement-in-a-while-loop.patch removed
 from -mm tree
Message-ID: <20210706192307.O3jCHhdoc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: remove redundant continue statement in a while-loop
has been removed from the -mm tree.  Its filename was
     nilfs2-remove-redundant-continue-statement-in-a-while-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: nilfs2: remove redundant continue statement in a while-loop

The continue statement at the end of the while-loop is redundant,
remove it.

Addresses-Coverity: ("Continue has no effect")
Link: https://lkml.kernel.org/r/20210621100519.10257-1-colin.king@canonical.com
Link: https://lkml.kernel.org/r/1624557664-17159-1-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/nilfs2/btree.c~nilfs2-remove-redundant-continue-statement-in-a-while-loop
+++ a/fs/nilfs2/btree.c
@@ -738,7 +738,6 @@ static int nilfs_btree_lookup_contig(con
 			if (ptr2 != ptr + cnt || ++cnt == maxblocks)
 				goto end;
 			index++;
-			continue;
 		}
 		if (level == maxlevel)
 			break;
_

Patches currently in -mm which might be from colin.king@canonical.com are


