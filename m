Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C8B9C761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234149AbjDFCy0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234555AbjDFCxb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:53:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58AA901C
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:53:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 465D764222
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954D3C433D2;
        Thu,  6 Apr 2023 02:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749592;
        bh=rVvhfNqZEnzP1AH7d6Hh/QiVL9Ju8hUzSrAD7GOpHEw=;
        h=Date:To:From:Subject:From;
        b=j/yiqcATA+ykkhVrLajk5/gNDg84oBa1x76dAn8IJtmdAk8Jgp9RdsJJi3fe958fQ
         NykA9XYLytPqBEmd2HyhROlsP8nnmkw6cdQm2czRgpdVg3Xdqek2gkN6QVUmOQVyM3
         XrXdCAHEbrQtGcXnQKqLVWdA0GaI5ezTRYwjGpO4=
Date:   Wed, 05 Apr 2023 19:53:12 -0700
To:     mm-commits@vger.kernel.org, kbingham@kernel.org,
        jan.kiszka@siemens.com, liupeng17@lenovo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-fix-lx-timerlist-for-struct-timequeue_head-change.patch removed from -mm tree
Message-Id: <20230406025312.954D3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb: fix lx-timerlist for struct timequeue_head change
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-lx-timerlist-for-struct-timequeue_head-change.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Liu <liupeng17@lenovo.com>
Subject: scripts/gdb: fix lx-timerlist for struct timequeue_head change
Date: Tue, 21 Mar 2023 14:18:43 +0800

commit 511885d7061e ("lib/timerqueue: Rely on rbtree semantics for next
timer") changed struct timerqueue_head, and so print_active_timers()
should be changed accordingly with its way to interpret the structure.

Link: https://lkml.kernel.org/r/Message-ID:
Signed-off-by: Peng Liu <liupeng17@lenovo.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/timerlist.py |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/scripts/gdb/linux/timerlist.py~scripts-gdb-fix-lx-timerlist-for-struct-timequeue_head-change
+++ a/scripts/gdb/linux/timerlist.py
@@ -43,8 +43,7 @@ def print_timer(rb_node, idx):
 
 
 def print_active_timers(base):
-    curr = base['active']['next']['node']
-    curr = curr.address.cast(rbtree.rb_node_type.get_type().pointer())
+    curr = base['active']['rb_root']['rb_leftmost']
     idx = 0
     while curr:
         yield print_timer(curr, idx)
_

Patches currently in -mm which might be from liupeng17@lenovo.com are


