Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA611C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A992E22227
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632915;
	bh=YnOFDoTMNsmdCt85t9gQmXht/nviOMk2ZqlVQsmQsLA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=N1G/T3p2lKZ3CanInvQ2acrYrdnnjZEjSMauBE2Gq5k8Rgxh+JluC/+8+/1lOwwXw
	 6ybWf9vq/NBKFWxqD5Vdpw7rJnE6VaSIIIQgFncPJanSYtggzWkdunf9p9GS0YrjTt
	 3cEC2kgbZBQDBiaagNiGoIOuGshNFh7dooujWNds=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbgJMXsf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:48:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727356AbgJMXsf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:48:35 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBAF122201;
        Tue, 13 Oct 2020 23:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632915;
        bh=YnOFDoTMNsmdCt85t9gQmXht/nviOMk2ZqlVQsmQsLA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nw3Wuv2bq9bbVd0l9zfcsNJQlp4xPAh7pQ6DhQ52XtXm+0K5wzj0dmkzkG5WQcxAu
         0+NDxL07uy2gNzikk1GIVibH7ndf4h6Hqnf5VeiOarA4S+PZd0wZ1VG5cf9Ol9ymgc
         5SA/D/f0/WrO4oWC8zbtBDEFvNvmCXG+gqJithSk=
Date:   Tue, 13 Oct 2020 16:48:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mateusznosek0@gmail.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org
Subject:  [patch 019/181] mm/slab.c: clean code by removing
 redundant if condition
Message-ID: <20201013234834.flfrT3wKb%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/slab.c: clean code by removing redundant if condition

The removed code was unnecessary and changed nothing in the flow, since in
case of returning NULL by 'kmem_cache_alloc_node' returning 'freelist'
from the function in question is the same as returning NULL.

Link: https://lkml.kernel.org/r/20200915230329.13002-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/slab.c~mm-slabc-clean-code-by-removing-redundant-if-condition
+++ a/mm/slab.c
@@ -2305,8 +2305,6 @@ static void *alloc_slabmgmt(struct kmem_
 		/* Slab management obj is off-slab. */
 		freelist = kmem_cache_alloc_node(cachep->freelist_cache,
 					      local_flags, nodeid);
-		if (!freelist)
-			return NULL;
 	} else {
 		/* We will use last bytes at the slab for freelist */
 		freelist = addr + (PAGE_SIZE << cachep->gfporder) -
_
