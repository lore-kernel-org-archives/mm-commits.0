Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF81C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D15E022CAF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781130;
	bh=MfO/fZsVOJp9DxsWMlg6hC+zRDpAKLgREa7mDK4tp+Q=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=LsnWiScRs6MmiXJjBpPv5Ib09gGAfJAUomG5V+boWh96Kv71lbywoC+JBdBONc8mQ
	 BYG/72/GoCIAv0prvnsYr/M1+T822fL/IplKzEvEOTx83mzdUaTVxQ60h29UeSVZFA
	 1PGck1Su9sRo2xWgxFZfqW0P5/I9CIoZ9xy0Dnro=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgHGGSu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGSu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:18:50 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1620922CB3;
        Fri,  7 Aug 2020 06:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781129;
        bh=MfO/fZsVOJp9DxsWMlg6hC+zRDpAKLgREa7mDK4tp+Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=csOCmnfY8MqClNgY5H17Q5Lzk/IQ6RD/ss+Jk369U4tzCGN7NYU3NmArV2+f2bGPD
         NJhwYsA8hHiwrDOBgfaR67LiDzYoIcDXMXG8naHzHzs0p8QRQcaPPjqLL7VcKWey0H
         uLVzS0J+S9nb9IRJ5TWwTkFoQkLJmVWTlfWuXnrQ=
Date:   Thu, 06 Aug 2020 23:18:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        iamjoonsoo.kim@lge.com, jannh@google.com, keescook@chromium.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        vjitta@codeaurora.org
Subject:  [patch 032/163] mm, slub: make reclaim_account attribute
 read-only
Message-ID: <20200807061848.vF8DVDKGT%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
