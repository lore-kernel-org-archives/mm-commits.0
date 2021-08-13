Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A56EC4320E
	for <mm-commits@archiver.kernel.org>; Fri, 13 Aug 2021 23:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB011610FC
	for <mm-commits@archiver.kernel.org>; Fri, 13 Aug 2021 23:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235794AbhHMXzC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Aug 2021 19:55:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235397AbhHMXzC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Aug 2021 19:55:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5D55610F7;
        Fri, 13 Aug 2021 23:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628898875;
        bh=fr14lSQkQ99+R/FsUh+9QNsz/PsbSgSiyqdCwuVq1ss=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=geC5F4h2f4+o5Zk8Eqm25dlNNXZXwUU7guN4hDuwjLqpvoxSGxN+nQHmp5fh+GS3t
         EVvJLUm7i3wQP9CJkMTPDMubgyzMaTiJrI/GkDyu5HQNFJ9mt7SJbfxvMd+wngyo+F
         jDb7JsxR6lLHB2lRKHOc8PsN3kbhE3OzjynZBSU4=
Date:   Fri, 13 Aug 2021 16:54:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        vinmenon@codeaurora.org, vjitta@codeaurora.org
Subject:  [patch 4/7] mm: slub: fix slub_debug disabling for list
 of slabs
Message-ID: <20210813235434.x-KKmCj59%akpm@linux-foundation.org>
In-Reply-To: <20210813165350.dc9afa56d27eadbd8ce629c0@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
