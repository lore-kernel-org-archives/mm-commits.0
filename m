Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 614F1C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31BE32076C
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026904;
	bh=T5klIuR6+ZFkOuGIGYlfrXCymW9zRrKc+O452kFmVtk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=jjeRA7v0rxY20KSEwDDNR4ZjP0k9bJLL3z7Gil1z1+3wtpxFct/A+domHWPfV30Sp
	 gIF+CgfNgcZk6DoybVib9z8qg0kd1jcsl0n4Ti+dkwE/1anp0NWgGmO0eloQ9b7Bkz
	 /SQG9JmCA4iS3XsycU4Du47OtrbyH52fdEDrguoE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgHJCfD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:35:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCfD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:35:03 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98C8E206C3;
        Mon, 10 Aug 2020 02:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026903;
        bh=T5klIuR6+ZFkOuGIGYlfrXCymW9zRrKc+O452kFmVtk=;
        h=Date:From:To:Subject:From;
        b=pkaApr7UlcM4JQVX9gk5Vg03YeE04mtLjFLriD3j4gI8CP0E1jjmlcPdlakrHMjXM
         szJ2lJkogma1nBvWLr+sDE21bmbvTK9hDwujbgQ28BzQPDX79o/XBt7aZQ+KNRqa9c
         bofkcz6I7ex4lApI1zqlA6kJwFqGdCoyaX9GBbEU=
Date:   Sun, 09 Aug 2020 19:35:02 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, iamjoonsoo.kim@lge.com,
        jannh@google.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, vjitta@codeaurora.org
Subject:  [merged]
 mm-slub-make-reclaim_account-attribute-read-only.patch removed from -mm
 tree
Message-ID: <20200810023502.qN-cMWQAg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: make reclaim_account attribute read-only
has been removed from the -mm tree.  Its filename was
     mm-slub-make-reclaim_account-attribute-read-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: make reclaim_account attribute read-only

The attribute reflects the SLAB_RECLAIM_ACCOUNT cache flag.  It's not
clear why this attribute was writable in the first place, as it's tied to
how the cache is used by its creator, it's not a user tunable. 
Furthermore:

- it affects slab merging, but that's not being checked while toggled
- if affects whether __GFP_RECLAIMABLE flag is used to allocate page, but
  the runtime toggle doesn't update allocflags
- it affects cache_vmstat_idx() so runtime toggling might lead to incosistency
  of NR_SLAB_RECLAIMABLE and NR_SLAB_UNRECLAIMABLE

Thus make it read-only.

Link: http://lkml.kernel.org/r/20200610163135.17364-6-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/mm/slub.c~mm-slub-make-reclaim_account-attribute-read-only
+++ a/mm/slub.c
@@ -5207,16 +5207,7 @@ static ssize_t reclaim_account_show(stru
 {
 	return sprintf(buf, "%d\n", !!(s->flags & SLAB_RECLAIM_ACCOUNT));
 }
-
-static ssize_t reclaim_account_store(struct kmem_cache *s,
-				const char *buf, size_t length)
-{
-	s->flags &= ~SLAB_RECLAIM_ACCOUNT;
-	if (buf[0] == '1')
-		s->flags |= SLAB_RECLAIM_ACCOUNT;
-	return length;
-}
-SLAB_ATTR(reclaim_account);
+SLAB_ATTR_RO(reclaim_account);
 
 static ssize_t hwcache_align_show(struct kmem_cache *s, char *buf)
 {
_

Patches currently in -mm which might be from vbabka@suse.cz are


