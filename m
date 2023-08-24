Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D00E4C727A9
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236661AbjHXXW5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244126AbjHXXW0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:22:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7C510D
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:22:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C51F363A67
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293D3C433C7;
        Thu, 24 Aug 2023 23:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919342;
        bh=vOYgP4/Bu90zM6CdGgXjcY0OhiL8ZlWxLjDIqUIu/7E=;
        h=Date:To:From:Subject:From;
        b=lAiE4qKaouMzBhOwqS+mIM8Umw4zFuR8CAfcYP9YOztCvl+4V+dqPZqSJt8RYLEN1
         V409XgRPKcZVACixctZ0AldOZtlGk9KOZybh29UY75uLrLG9/7R4YEDT8gmF0M1oBq
         gUuWvHz7crfL5FWL4NwvyODvks/PGkV4QpLSZ5iQ=
Date:   Thu, 24 Aug 2023 16:22:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, mjguzik@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-shrink-struct-maple_tree-from-24-to-16-bytes-on-lp64.patch removed from -mm tree
Message-Id: <20230824232222.293D3C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: shrink struct maple_tree
has been removed from the -mm tree.  Its filename was
     maple_tree-shrink-struct-maple_tree-from-24-to-16-bytes-on-lp64.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mateusz Guzik <mjguzik@gmail.com>
Subject: maple_tree: shrink struct maple_tree
Date: Tue, 22 Aug 2023 00:51:45 +0200

Pack the members of struct maple_tree to avoid holes on 64-bit.  The size
shrinks from 24 to 16 bytes which will save eight bytes in every structure
which embeds it.

[willy@infradead.org: changelog alterations]
Link: https://lkml.kernel.org/r/20230821225145.2169848-1-mjguzik@gmail.com
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
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


