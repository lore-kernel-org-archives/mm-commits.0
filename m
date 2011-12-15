From: akpm@linux-foundation.org
Subject: + vmalloc-remove-static-declaration-of-va-from-__get_vm_area_node.patch added to -mm tree
Date: Thu, 15 Dec 2011 13:24:32 -0800
Message-ID: <20111215212432.A022910004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:52886 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab1LOVYd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2011 16:24:33 -0500
Received: by yenm5 with SMTP id m5so275013yen.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2011 13:24:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: consul.kautuk@gmail.com, rientjes@google.com


The patch titled
     Subject: mm/vmalloc.c: remove static declaration of va from __get_vm_area_node
has been added to the -mm tree.  Its filename is
     vmalloc-remove-static-declaration-of-va-from-__get_vm_area_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kautuk Consul <consul.kautuk@gmail.com>
Return-Path: <consul.kautuk@gmail.com>
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on z
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=7.0 tests=BAYES_00,FREEMAIL_FROM,
	T_DKIM_INVALID autolearn=ham version=3.3.1
Received: from localhost (localhost [127.0.0.1])
	by localhost.localdomain (8.14.3/8.14.3) with ESMTP id pB87m4Z2020153
	for <akpm@localhost>; Wed, 7 Dec 2011 23:48:04 -0800
X-Original-To: akpm@linux-foundation.org
Delivered-To: akpm@mail.linuxfoundation.org
Received: from mail.linuxfoundation.org [140.211.169.12]
	by localhost with IMAP (fetchmail-6.3.11)
	for <akpm@localhost> (single-drop); Wed, 07 Dec 2011 23:48:04 -0800 (PST)
Received: from smtp1.linuxfoundation.org (smtp1.linux-foundation.org [172.17.192.35])
	by mail.linuxfoundation.org (Postfix) with ESMTP id 6B87B50E
	for <akpm@linux-foundation.org>; Thu,  8 Dec 2011 07:44:40 +0000 (UTC)
X-Greylist: domain auto-whitelisted by SQLgrey-1.7.6
Received: from mail-iy0-f176.google.com (mail-iy0-f176.google.com [209.85.210.176])
	by smtp1.linuxfoundation.org (Postfix) with ESMTPS id 1A0D61FEB1
	for <akpm@linux-foundation.org>; Thu,  8 Dec 2011 07:45:21 +0000 (UTC)
Received: by iakk12 with SMTP id k12so2922405iak.35
        for <akpm@linux-foundation.org>; Wed, 07 Dec 2011 23:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=/wOBBJXjO/ozzVfRCIOgYDueNyy7272lh/2lnSbdbrk=;
        b=G1j5gf/hTwjw8AgLxCitKuId89coci8AktZ8XYZNIA4NBHuKO9VRlJKcGKQExn7L9s
         qbSATU4O1B91Im176mJdnTdJaX1VeLbgpAEAGxsyT6Dds0kvc6eQb/LltZ3dj/+CGADH
         oDpUMOTa4C05BkKrEuZOkUBZ2iqMVGQiRV9SE=
Received: by 10.42.161.132 with SMTP id t4mr2673330icx.16.1323330321401;
        Wed, 07 Dec 2011 23:45:21 -0800 (PST)
Received: from localhost.localdomain ([125.19.39.117])
        by mx.google.com with ESMTPS id wn1sm8967105igc.3.2011.12.07.23.45.17
        (version=TLSv1/SSLv3 cipher=OTHER);
        Wed, 07 Dec 2011 23:45:20 -0800 (PST)
To: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: vmalloc: Remove static declaration of va from __get_vm_area_node
Date: Thu,  8 Dec 2011 13:20:21 +0530
Message-Id: <1323330621-31254-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.6

Static storage is not required for the struct vmap_area in
__get_vm_area_node.

Removing "static" to store this variable on the stack instead.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 mm/vmalloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 3231bf3..173562c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1290,7 +1290,7 @@ static struct vm_struct *__get_vm_area_node(unsigned long size,
 		unsigned long align, unsigned long flags, unsigned long start,
 		unsigned long end, int node, gfp_t gfp_mask, void *caller)
 {
-	static struct vmap_area *va;
+	struct vmap_area *va;
 	struct vm_struct *area;
 
 	BUG_ON(in_interrupt());
-- 
1.7.6
Subject: Subject: mm/vmalloc.c: remove static declaration of va from __get_vm_area_node

Patches currently in -mm which might be from consul.kautuk@gmail.com are

linux-next.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
vmalloc-remove-static-declaration-of-va-from-__get_vm_area_node.patch

