Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D704AC07E95
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 01:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B407661370
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 01:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237203AbhGNBMw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:12:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237199AbhGNBMw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Jul 2021 21:12:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9BC36128E;
        Wed, 14 Jul 2021 01:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626225000;
        bh=8F0k3z4xBvfqSFbgS4klviWxRxKvYhzWKJJnC1y4zCE=;
        h=Date:From:To:Subject:From;
        b=g9Km2Pyu+YlT/UOTQa+mS98WYo84U9CqxEskQfpw1DjZSbBZj/KVqEMDZ71eU4TxJ
         +pHa7zaQPtJL8o3h23uD4HifSh4GmjrjL7LmnPqK62CeTa0ZWZMBraTiBdsYvH5ikM
         1bJk4QohzgaRFi+cCz1aA4NsVmRKiejI8wBbEb3M=
Date:   Tue, 13 Jul 2021 18:10:00 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz,
        vjitta@codeaurora.org
Subject:  +
 mm-slub-fix-slub_debug-disablement-for-list-of-slabs.patch added to -mm
 tree
Message-ID: <20210714011000.lhtaX2B7f%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slub: Fix slub_debug disablement for list of slabs
has been added to the -mm tree.  Its filename is
     mm-slub-fix-slub_debug-disablement-for-list-of-slabs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-fix-slub_debug-disablement-for-list-of-slabs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-fix-slub_debug-disablement-for-list-of-slabs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vijayanand Jitta <vjitta@codeaurora.org>
Subject: mm: slub: Fix slub_debug disablement for list of slabs

Consider the scenario where CONFIG_SLUB_DEBUG_ON is set and we would want
to disable slub_debug for few slabs.  Using boot parameter with
slub_debug=-,slab_name syntax doesn't work as expected i.e; only disabling
debugging for the specified list of slabs, instead it disables debugging
for all slabs.  Fix this.

Link: https://lkml.kernel.org/r/1626176750-13099-1-git-send-email-vjitta@codeaurora.org
Signed-off-by: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/slub.c~mm-slub-fix-slub_debug-disablement-for-list-of-slabs
+++ a/mm/slub.c
@@ -1415,6 +1415,7 @@ static int __init setup_slub_debug(char
 	char *slab_list;
 	bool global_slub_debug_changed = false;
 	bool slab_list_specified = false;
+	bool slab_list_debug_disable = true;
 
 	slub_debug = DEBUG_DEFAULT_FLAGS;
 	if (*str++ != '=' || !*str)
@@ -1422,7 +1423,6 @@ static int __init setup_slub_debug(char
 		 * No options specified. Switch on full debugging.
 		 */
 		goto out;
-
 	saved_str = str;
 	while (str) {
 		str = parse_slub_debug_flags(str, &flags, &slab_list, true);
@@ -1431,6 +1431,8 @@ static int __init setup_slub_debug(char
 			slub_debug = flags;
 			global_slub_debug_changed = true;
 		} else {
+			if (flags || !IS_ENABLED(CONFIG_SLUB_DEBUG_ON))
+				slab_list_debug_disable = false;
 			slab_list_specified = true;
 		}
 	}
@@ -1442,7 +1444,7 @@ static int __init setup_slub_debug(char
 	 * long as there is no option specifying flags without a slab list.
 	 */
 	if (slab_list_specified) {
-		if (!global_slub_debug_changed)
+		if (!global_slub_debug_changed && !slab_list_debug_disable)
 			slub_debug = 0;
 		slub_debug_string = saved_str;
 	}
_

Patches currently in -mm which might be from vjitta@codeaurora.org are

mm-slub-fix-slub_debug-disablement-for-list-of-slabs.patch

