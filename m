Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7735EE49AB
	for <mm-commits@archiver.kernel.org>; Tue, 22 Aug 2023 18:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjHVSo5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Aug 2023 14:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjHVSo5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Aug 2023 14:44:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E720FCD1
        for <mm-commits@vger.kernel.org>; Tue, 22 Aug 2023 11:44:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8517762B0C
        for <mm-commits@vger.kernel.org>; Tue, 22 Aug 2023 18:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B73C433C7;
        Tue, 22 Aug 2023 18:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692729894;
        bh=928xCH3Jr7LpJuGLjP63pUmsQhkNOwf4FRi1wMwM1+k=;
        h=Date:To:From:Subject:From;
        b=lW82mnyYI4omK9DMP/V4WiGU/b2TyHJqY4HHMkdJe9mcHFHlIdGNEXUmYK+/fRvJ0
         ec18LAiXuURyp6urW00KTtEq5rbCIAUTs/41BrLCP3e9pZ/7YES0jUs3udB8g7XDlL
         1CHRUuYbK+Ij+DQU99CODt6PwZl2hfeIiec/J3Q0=
Date:   Tue, 22 Aug 2023 11:44:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, mjguzik@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-shrink-struct-maple_tree-from-24-to-16-bytes-on-lp64.patch added to mm-unstable branch
Message-Id: <20230822184454.D1B73C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: shrink struct maple_tree from 24 to 16 bytes on LP64
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-shrink-struct-maple_tree-from-24-to-16-bytes-on-lp64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-shrink-struct-maple_tree-from-24-to-16-bytes-on-lp64.patch

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
From: Mateusz Guzik <mjguzik@gmail.com>
Subject: maple_tree: shrink struct maple_tree from 24 to 16 bytes on LP64
Date: Tue, 22 Aug 2023 00:51:45 +0200

by plugging a padding hole.

Link: https://lkml.kernel.org/r/20230821225145.2169848-1-mjguzik@gmail.com
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/maple_tree.h~maple_tree-shrink-struct-maple_tree-from-24-to-16-bytes-on-lp64
+++ a/include/linux/maple_tree.h
@@ -220,8 +220,8 @@ struct maple_tree {
 		spinlock_t	ma_lock;
 		lockdep_map_p	ma_external_lock;
 	};
-	void __rcu      *ma_root;
 	unsigned int	ma_flags;
+	void __rcu      *ma_root;
 };
 
 /**
_

Patches currently in -mm which might be from mjguzik@gmail.com are

maple_tree-shrink-struct-maple_tree-from-24-to-16-bytes-on-lp64.patch

