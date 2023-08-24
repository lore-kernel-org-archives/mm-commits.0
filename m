Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F07C7EE2C
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 17:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjHXRaQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 13:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242863AbjHXR35 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 13:29:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA171BD3
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 10:29:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78DB06463F
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 17:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F6BC433C7;
        Thu, 24 Aug 2023 17:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692898191;
        bh=4FH2oY/Vsap4RMZB2Fljg0DiUP1UvHzoBbV0YkFWZAM=;
        h=Date:To:From:Subject:From;
        b=yB6mylAhrF5hMGO8eIEDcrJqqmEVYFxgbTJSBJ+YfhWDZakmcxpAgQDxrEc3DmQ0y
         yewesJcCy6tndU3fxhlAWTsrnnhXfDCY7lwc9yPhGFJibmeEY7mhLZxQkVkR3Hderr
         V1Gd+NAx+rotwSr64A43Pw7g6TntwTS9pidZmFMQ=
Date:   Thu, 24 Aug 2023 10:29:51 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, baruch@tkos.co.il,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + rmap-remove-anon_vma_link-nommu-stub.patch added to mm-unstable branch
Message-Id: <20230824172951.D0F6BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: rmap: remove anon_vma_link() nommu stub
has been added to the -mm mm-unstable branch.  Its filename is
     rmap-remove-anon_vma_link-nommu-stub.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rmap-remove-anon_vma_link-nommu-stub.patch

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
From: Baruch Siach <baruch@tkos.co.il>
Subject: rmap: remove anon_vma_link() nommu stub
Date: Thu, 24 Aug 2023 14:38:08 +0300

anon_vma_link() is unused since commit 5beb49305251 ("mm: change anon_vma
linking to fix multi-process server scalability issue").

Link: https://lkml.kernel.org/r/cdce9b00c9ab15f6d02eddf40dcad537d3e9676f.1692877089.git.baruch@tkos.co.il
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/rmap.h~rmap-remove-anon_vma_link-nommu-stub
+++ a/include/linux/rmap.h
@@ -479,7 +479,6 @@ struct anon_vma *folio_lock_anon_vma_rea
 
 #define anon_vma_init()		do {} while (0)
 #define anon_vma_prepare(vma)	(0)
-#define anon_vma_link(vma)	do {} while (0)
 
 static inline int folio_referenced(struct folio *folio, int is_locked,
 				  struct mem_cgroup *memcg,
_

Patches currently in -mm which might be from baruch@tkos.co.il are

rmap-remove-anon_vma_link-nommu-stub.patch
maintainers-add-rmaph-to-mm-entry.patch

