Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46582C761A6
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjC1XW6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjC1XWE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:22:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD6A35B6
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CD55619AC
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94479C4339B;
        Tue, 28 Mar 2023 23:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045717;
        bh=qykK4WNfE+h/CuTv17qvo8AVXaAvwY9dMy8NM8dD3Jg=;
        h=Date:To:From:Subject:From;
        b=XbUUrwReRloHShxNrtTjBl1rCoMJmNTiDDuANJN93lZUb4v6m/JPcabcmyzkogCx5
         vovPfwDKxZ7Eoi36DMgzd0MPfP7BryW72l+ieWmRTypAfi3/zgFubZTYu1EXHvQF9G
         WHNVX7NgEw3em+4niChpZy9bvUG5IKW/kAMN6UH8=
Date:   Tue, 28 Mar 2023 16:21:57 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        dakr@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-export-symbol-mas_preallocate.patch removed from -mm tree
Message-Id: <20230328232157.94479C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: export symbol mas_preallocate()
has been removed from the -mm tree.  Its filename was
     maple_tree-export-symbol-mas_preallocate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Danilo Krummrich <dakr@redhat.com>
Subject: maple_tree: export symbol mas_preallocate()
Date: Thu, 2 Mar 2023 02:10:35 +0100

Fix missing EXPORT_SYMBOL_GPL() statement for mas_preallocate().

It isn't actually used by anything yet, but mas_preallocate() is part of
the maple tree's 'Advanced API'.  All other functions of this API are
exported already.

Link: https://lkml.kernel.org/r/20230302011035.4928-1-dakr@redhat.com
Signed-off-by: Danilo Krummrich <dakr@redhat.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/maple_tree.c~maple_tree-export-symbol-mas_preallocate
+++ a/lib/maple_tree.c
@@ -5825,6 +5825,7 @@ int mas_preallocate(struct ma_state *mas
 	mas_reset(mas);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(mas_preallocate);
 
 /*
  * mas_destroy() - destroy a maple state.
_

Patches currently in -mm which might be from dakr@redhat.com are


