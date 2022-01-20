Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC61C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244034AbiATVYy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377821AbiATVYx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:24:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF06AC061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:24:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B0B960018
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E416C340E0;
        Thu, 20 Jan 2022 21:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713892;
        bh=05+GQhCed6OfqCj+QbG5EQQGOMDnhXLDovizuif/Czo=;
        h=Date:From:To:Subject:From;
        b=ewv45i3vJJlL2Jm1vXVmHKQr206x/DC45z3wgjJ99ny/P+ERttquyOUuCPQ+FZmCT
         ++0onYixX9xi/X4t4+i3Tsupqx7VhwGGI5Fsez4+jhMiZ6U/fF3yPw7tiEO56kLMcR
         cBL37H3K0mlN0+cJz8cRUku7AzdEY9XdU1aq5GWk=
Date:   Thu, 20 Jan 2022 13:24:52 -0800
From:   akpm@linux-foundation.org
To:     christophe.jaillet@wanadoo.fr, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-mempool-use-non-atomic-__set_bit-when-possible.patch removed from -mm
 tree
Message-ID: <20220120212452.ltFfm9EtT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/frontswap.c: use non-atomic '__set_bit()' when possible
has been removed from the -mm tree.  Its filename was
     mm-mempool-use-non-atomic-__set_bit-when-possible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: mm/frontswap.c: use non-atomic '__set_bit()' when possible

the 'a' and 'b' bitmaps are local to this function, so no concurrent
access can occur.  So the non-atomic '__set_bit()' can be used to save a
few cycles.

Link: https://lkml.kernel.org/r/e52476da5cee57151745c5c3c934a69798dc6fa4.1638132190.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frontswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/frontswap.c~mm-mempool-use-non-atomic-__set_bit-when-possible
+++ a/mm/frontswap.c
@@ -127,7 +127,7 @@ void frontswap_register_ops(struct front
 	spin_lock(&swap_lock);
 	plist_for_each_entry(si, &swap_active_head, list) {
 		if (!WARN_ON(!si->frontswap_map))
-			set_bit(si->type, a);
+			__set_bit(si->type, a);
 	}
 	spin_unlock(&swap_lock);
 
@@ -149,7 +149,7 @@ void frontswap_register_ops(struct front
 	spin_lock(&swap_lock);
 	plist_for_each_entry(si, &swap_active_head, list) {
 		if (si->frontswap_map)
-			set_bit(si->type, b);
+			__set_bit(si->type, b);
 	}
 	spin_unlock(&swap_lock);
 
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are


