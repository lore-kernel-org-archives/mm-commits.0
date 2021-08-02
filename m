Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EAD7C4338F
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 21:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C65060F58
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 21:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbhHBVIS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Aug 2021 17:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231397AbhHBVIR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Aug 2021 17:08:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD92760F4B;
        Mon,  2 Aug 2021 21:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627938488;
        bh=uC4Ad2OHfydMg6sq8pDb3VsHS+STa9NgeCCIsvUQSEQ=;
        h=Date:From:To:Subject:From;
        b=syiXs3vpQacjWOcyzgLoobGTSvokXq5AzAEEK/tADrFStzlKE5UG8clKkfQ+Dux2o
         BtmZGB7++rcnjtIh2A4bZtPJcr5GJ1r3+9mKnAfAdE4hIthfoUCuCB+Z0Y0i+mjlK0
         ej0pBEQit6QR9wGMPAhprwWTHFzvuNGnXWqW0aTk=
Date:   Mon, 02 Aug 2021 14:08:07 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vjitta@codeaurora.org,
        rientjes@google.com, penberg@kernel.org, iamjoonsoo.kim@lge.com,
        cl@linux.com, vbabka@suse.cz
Subject:  [to-be-updated]
 mm-slub-fix-slub_debug-disabling-for-list-of-slabs.patch removed from -mm
 tree
Message-ID: <20210802210807.I5NKI%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slub: fix slub_debug disabling for list of slabs
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-slub_debug-disabling-for-list-of-slabs.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: slub: fix slub_debug disabling for list of slabs

Vijayanand Jitta reports:

  Consider the scenario where CONFIG_SLUB_DEBUG_ON is set and we would
  want to disable slub_debug for few slabs.  Using boot parameter with
  slub_debug=-,slab_name syntax doesn't work as expected i.e; only
  disabling debugging for the specified list of slabs.  Instead it
  disables debugging for all slabs, which is wrong.

This patch fixes it by delaying the moment when the global slub_debug
flags variable is updated.  In case a "slub_debug=-,slab_name" has been
passed, the global flags remain as initialized (depending on
CONFIG_SLUB_DEBUG_ON enabled or disabled) and are not simply reset to 0.

Link: https://lkml.kernel.org/r/8a3d992a-473a-467b-28a0-4ad2ff60ab82@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Vijayanand Jitta <vjitta@codeaurora.org>
Reviewed-by: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/slub.c~mm-slub-fix-slub_debug-disabling-for-list-of-slabs
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

