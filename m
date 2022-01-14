Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 531E2C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiANWF2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiANWF2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:05:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67CCC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:05:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DB4262003
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAFDC36AE5;
        Fri, 14 Jan 2022 22:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197926;
        bh=A6orIj7zEKCwqVSN/lU708h9PEkKG+pv4FQp8bVap30=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AZ5qYlpTZijVLdEZWCzhit5/fGinmeBPhnN4dBLAwG3jvetQYB/4j/3pysm0u3cUv
         5cueOj4F88qZseM580hGBsObrDAXncZmpmsZ1S/dsPle+Hw9MoQwO+RBmFCrWbX6nw
         zf58UrTar/O6zwgeLV1PvJaQFY0LlhkSXTAS59KU=
Date:   Fri, 14 Jan 2022 14:05:26 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, christophe.jaillet@wanadoo.fr,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 047/146] mm/frontswap.c: use non-atomic
 '__set_bit()' when possible
Message-ID: <20220114220526.Av3FTFVPw%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
