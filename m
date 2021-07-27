Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E173EC4338F
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 21:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6CF560F90
	for <mm-commits@archiver.kernel.org>; Tue, 27 Jul 2021 21:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbhG0VUW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 27 Jul 2021 17:20:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232730AbhG0VUA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 27 Jul 2021 17:20:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E44A60BD3;
        Tue, 27 Jul 2021 21:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627420799;
        bh=EsAw1Kh2C8idQ8eN21aLImcb6xEPmX6jlgWdWwid3pA=;
        h=Date:From:To:Subject:From;
        b=owxTj12XASB+waClCHuyYzSoASNj4N59xWcOMVMtiqSev0Zvevyz732/+Upv/0FRa
         3Gi5hC63mmUwoUliAZNw5kLja1HfxwqPttETJjBsiQ/A18a3SCs3MAWoAW2nsonx0k
         MzS9byyQfM5It7/FqTZp4VJn4yV0lO/eqo1fPXJ4=
Date:   Tue, 27 Jul 2021 14:19:59 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rientjes@google.com,
        penberg@kernel.org, iamjoonsoo.kim@lge.com, cl@linux.com,
        vjitta@codeaurora.org
Subject:  [alternative-merged]
 mm-slub-fix-slub_debug-disablement-for-list-of-slabs.patch removed from -mm
 tree
Message-ID: <20210727211959.w3OJg%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slub: Fix slub_debug disablement for list of slabs
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-slub_debug-disablement-for-list-of-slabs.patch

This patch was dropped because an alternative patch was merged

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
@@ -1404,6 +1404,7 @@ static int __init setup_slub_debug(char
 	char *slab_list;
 	bool global_slub_debug_changed = false;
 	bool slab_list_specified = false;
+	bool slab_list_debug_disable = true;
 
 	slub_debug = DEBUG_DEFAULT_FLAGS;
 	if (*str++ != '=' || !*str)
@@ -1411,7 +1412,6 @@ static int __init setup_slub_debug(char
 		 * No options specified. Switch on full debugging.
 		 */
 		goto out;
-
 	saved_str = str;
 	while (str) {
 		str = parse_slub_debug_flags(str, &flags, &slab_list, true);
@@ -1420,6 +1420,8 @@ static int __init setup_slub_debug(char
 			slub_debug = flags;
 			global_slub_debug_changed = true;
 		} else {
+			if (flags || !IS_ENABLED(CONFIG_SLUB_DEBUG_ON))
+				slab_list_debug_disable = false;
 			slab_list_specified = true;
 		}
 	}
@@ -1431,7 +1433,7 @@ static int __init setup_slub_debug(char
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


