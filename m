Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27EE0C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 01:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B9CA6137E
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 01:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhKPB3z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 20:29:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353307AbhKPB1v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 20:27:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A179A61104;
        Tue, 16 Nov 2021 01:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637025894;
        bh=H7igFod2D5qvm97iV2JijA9iprE0UNMvTi/nWx9PQGM=;
        h=Date:From:To:Subject:From;
        b=n68h/ue1/DVsF6pFxo7mthlcZq+CKOhli8A+UCmcjH6ZM4YWVpHFKFru5WweeX/ZB
         soDosmo6ty6sGhLyRrihng0gP9cHxPiwbH2Kj03o081vBoZAz+fJheGoONMNdInk+9
         xbbNuoXK+BhZ0ebuOVxxIYHcpVk/O1txEwcU6bQU=
Date:   Mon, 15 Nov 2021 17:24:54 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, ligang.bdlg@bytedance.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com
Subject:  + vmscan-make-drop_slab_node-static.patch added to -mm
 tree
Message-ID: <20211116012454.BjLS5-qTs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: make drop_slab_node static
has been added to the -mm tree.  Its filename is
     vmscan-make-drop_slab_node-static.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/vmscan-make-drop_slab_node-static.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/vmscan-make-drop_slab_node-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gang Li <ligang.bdlg@bytedance.com>
Subject: vmscan: make drop_slab_node static

drop_slab_node is only used in drop_slab.  So remove it's declaration from
header file and add keyword static for it's definition.

Link: https://lkml.kernel.org/r/20211111062445.5236-1-ligang.bdlg@bytedance.com
Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 mm/vmscan.c        |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/mm.h~vmscan-make-drop_slab_node-static
+++ a/include/linux/mm.h
@@ -3167,7 +3167,6 @@ int drop_caches_sysctl_handler(struct ct
 #endif
 
 void drop_slab(void);
-void drop_slab_node(int nid);
 
 #ifndef CONFIG_MMU
 #define randomize_va_space 0
--- a/mm/vmscan.c~vmscan-make-drop_slab_node-static
+++ a/mm/vmscan.c
@@ -951,7 +951,7 @@ out:
 	return freed;
 }
 
-void drop_slab_node(int nid)
+static void drop_slab_node(int nid)
 {
 	unsigned long freed;
 	int shift = 0;
_

Patches currently in -mm which might be from ligang.bdlg@bytedance.com are

vmscan-make-drop_slab_node-static.patch

