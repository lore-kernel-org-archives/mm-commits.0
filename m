Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7285C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 993BD6141E
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhEHWlC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhEHWlB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:41:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93AAD61402;
        Sat,  8 May 2021 22:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513598;
        bh=10s/CJ+JL8benTdEHcZi9tV54vliDWJ9sfpHNX54lk8=;
        h=Date:From:To:Subject:From;
        b=wCNXzPevKIGV+2/0YZnDk0ISyNdFG+Yb73uiqeUpzx3hfTkwBpkOCtI2kapit73Vo
         pRZLwleK4ePKjjHue8djTqciGGdpjhszD2WSsESTkui0V1V0+tP21pzkJALmqJeBvl
         jDnS4QIjFIYKzoBHic35EXr8nrGriY4YxIqFBYHc=
Date:   Sat, 08 May 2021 15:39:58 -0700
From:   akpm@linux-foundation.org
To:     aquini@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  [merged]
 =?US-ASCII?Q?mm-slab=5Fcommon-provide-slab=5Fmerge-option-for-is=5Fenabl?=
 =?US-ASCII?Q?edconfig=5Fslab=5Fmerge=5Fdefault-builds.patch?= removed from
 -mm tree
Message-ID: <20210508223958.V6GsFhCo_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common: provide "slab_merge" option for !IS_ENABLED(CONFIG_SLAB_MERGE_DEFAULT) builds
has been removed from the -mm tree.  Its filename was
     mm-slab_common-provide-slab_merge-option-for-is_enabledconfig_slab_merge_default-builds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: mm/slab_common: provide "slab_merge" option for !IS_ENABLED(CONFIG_SLAB_MERGE_DEFAULT) builds

This is a minor addition to the allocator setup options to provide a
simple way to on demand enable back cache merging for builds that by
default run with CONFIG_SLAB_MERGE_DEFAULT not set.

Link: https://lkml.kernel.org/r/20210319194506.200159-1-aquini@redhat.com
Signed-off-by: Rafael Aquini <aquini@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    7 +++++++
 mm/slab_common.c                                |    8 ++++++++
 2 files changed, 15 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-slab_common-provide-slab_merge-option-for-is_enabledconfig_slab_merge_default-builds
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -4996,6 +4996,10 @@
 
 	slram=		[HW,MTD]
 
+	slab_merge	[MM]
+			Enable merging of slabs with similar size when the
+			kernel is built without CONFIG_SLAB_MERGE_DEFAULT.
+
 	slab_nomerge	[MM]
 			Disable merging of slabs with similar size. May be
 			necessary if there is some reason to distinguish
@@ -5043,6 +5047,9 @@
 			lower than slub_max_order.
 			For more information see Documentation/vm/slub.rst.
 
+	slub_merge	[MM, SLUB]
+			Same with slab_merge.
+
 	slub_nomerge	[MM, SLUB]
 			Same with slab_nomerge. This is supported for legacy.
 			See slab_nomerge for more information.
--- a/mm/slab_common.c~mm-slab_common-provide-slab_merge-option-for-is_enabledconfig_slab_merge_default-builds
+++ a/mm/slab_common.c
@@ -71,11 +71,19 @@ static int __init setup_slab_nomerge(cha
 	return 1;
 }
 
+static int __init setup_slab_merge(char *str)
+{
+	slab_nomerge = false;
+	return 1;
+}
+
 #ifdef CONFIG_SLUB
 __setup_param("slub_nomerge", slub_nomerge, setup_slab_nomerge, 0);
+__setup_param("slub_merge", slub_merge, setup_slab_merge, 0);
 #endif
 
 __setup("slab_nomerge", setup_slab_nomerge);
+__setup("slab_merge", setup_slab_merge);
 
 /*
  * Determine the size of a slab object
_

Patches currently in -mm which might be from aquini@redhat.com are


