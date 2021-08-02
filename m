Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E841EC4338F
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 21:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7C4A60F11
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 21:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhHBVFE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Aug 2021 17:05:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231194AbhHBVFC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Aug 2021 17:05:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F52A60F4B;
        Mon,  2 Aug 2021 21:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627938291;
        bh=5rJBbDaY2xcGK+oPyhT8sltHwkcb0U1BhJbuWnRk+ls=;
        h=Date:From:To:Subject:From;
        b=ORpAE05JS6Jc8usR9loqaxNL11+Z+8dXxbgVKg35OMBP9RUHiuCK7juGAoY2CqAV4
         XERab6A9/7O1ysnR2iAbU78qIRTfQbvqN+tOec+9QjBC1tORIYJvBt4y71jeIkWL2u
         ivZcF+TE6Mp2jPxkp1DxE0TRdostUEPeRwbI16A8=
Date:   Mon, 02 Aug 2021 14:04:51 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vjitta@codeaurora.org,
        vinmenon@codeaurora.org, rientjes@google.com, penberg@kernel.org,
        iamjoonsoo.kim@lge.com, cl@linux.com, vbabka@suse.cz
Subject:  +
 mm-slub-fix-slub_debug-disablement-for-list-of-slabs.patch added to -mm tree
Message-ID: <20210802210451.3TV5b%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slub: fix slub_debug disabling for list of slabs
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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: slub: fix slub_debug disabling for list of slabs

Vijayanand Jitta reports:

  Consider the scenario where CONFIG_SLUB_DEBUG_ON is set
  and we would want to disable slub_debug for few slabs.
  Using boot parameter with slub_debug=-,slab_name syntax
  doesn't work as expected i.e; only disabling debugging for
  the specified list of slabs. Instead it disables debugging
  for all slabs, which is wrong.

This patch fixes it by delaying the moment when the global slub_debug
flags variable is updated.  In case a "slub_debug=-,slab_name" has been
passed, the global flags remain as initialized (depending on
CONFIG_SLUB_DEBUG_ON enabled or disabled) and are not simply reset to 0.

Link: https://lkml.kernel.org/r/8a3d992a-473a-467b-28a0-4ad2ff60ab82@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Vijayanand Jitta <vjitta@codeaurora.org>
Reviewed-by: Vijayanand Jitta <vjitta@codeaurora.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/slub.c~mm-slub-fix-slub_debug-disablement-for-list-of-slabs
+++ a/mm/slub.c
@@ -1400,12 +1400,13 @@ check_slabs:
 static int __init setup_slub_debug(char *str)
 {
 	slab_flags_t flags;
+	slab_flags_t global_flags;
 	char *saved_str;
 	char *slab_list;
 	bool global_slub_debug_changed = false;
 	bool slab_list_specified = false;
 
-	slub_debug = DEBUG_DEFAULT_FLAGS;
+	global_flags = DEBUG_DEFAULT_FLAGS;
 	if (*str++ != '=' || !*str)
 		/*
 		 * No options specified. Switch on full debugging.
@@ -1417,7 +1418,7 @@ static int __init setup_slub_debug(char
 		str = parse_slub_debug_flags(str, &flags, &slab_list, true);
 
 		if (!slab_list) {
-			slub_debug = flags;
+			global_flags = flags;
 			global_slub_debug_changed = true;
 		} else {
 			slab_list_specified = true;
@@ -1426,16 +1427,18 @@ static int __init setup_slub_debug(char
 
 	/*
 	 * For backwards compatibility, a single list of flags with list of
-	 * slabs means debugging is only enabled for those slabs, so the global
-	 * slub_debug should be 0. We can extended that to multiple lists as
+	 * slabs means debugging is only changed for those slabs, so the global
+	 * slub_debug should be unchanged (0 or DEBUG_DEFAULT_FLAGS, depending
+	 * on CONFIG_SLUB_DEBUG_ON). We can extended that to multiple lists as
 	 * long as there is no option specifying flags without a slab list.
 	 */
 	if (slab_list_specified) {
 		if (!global_slub_debug_changed)
-			slub_debug = 0;
+			global_flags = slub_debug;
 		slub_debug_string = saved_str;
 	}
 out:
+	slub_debug = global_flags;
 	if (slub_debug != 0 || slub_debug_string)
 		static_branch_enable(&slub_debug_enabled);
 	else
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-fix-slub_debug-disablement-for-list-of-slabs.patch
mm-slub-fix-slub_debug-disabling-for-list-of-slabs.patch

