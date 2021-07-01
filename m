Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB671C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF54B6105A
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbhGAB4F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238429AbhGAB4F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:56:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A4B66146D;
        Thu,  1 Jul 2021 01:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104415;
        bh=EpZ92Ktg0wuV7IHC93KuUtlQENqr3fTNHuENEJu4dIA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IGlh+Cbp0lIVr27Aqdqag3YqXI4cAxHKatvKUx5FuKy8YOJ/mveAM8G7QZkFmoMYj
         esVFqPJQARFGGQSnuvcKyfDFDB1CljOGawC/rx2PtEBY1doPZomjgPaxN93J+GgATq
         ShN+H8WJwgx6RA7n/7ouOIABBDhpNoUnaMrwm96E=
Date:   Wed, 30 Jun 2021 18:53:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, ddstreet@ieee.org,
        linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 120/192] mm/memory_hotplug: fix kerneldoc comment
 for __try_online_node
Message-ID: <20210701015335.Zrg-ltgp7%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/memory_hotplug: fix kerneldoc comment for __try_online_node

make W=1 generates the following warning for try_online_node

mm/memory_hotplug.c:1087: warning: expecting prototype for try_online_node(). Prototype was for __try_online_node() instead

Commit b9ff036082cd ("mm/memory_hotplug.c: make add_memory_resource use
__try_online_node") renamed the function but did not update the associated
kerneldoc.  The function is static and somewhat specialised in nature so
it's not clear it warrants being a kerneldoc by moving the comment to
try_online_node.  Hence, leave the comment of the internal helper in place
but leave it out of kerneldoc and correct the function name in the
comment.

Link: https://lkml.kernel.org/r/20210520084809.8576-8-mgorman@techsingularity.net
Fixes: Commit b9ff036082cd ("mm/memory_hotplug.c: make add_memory_resource use __try_online_node")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-kerneldoc-comment-for-__try_online_node
+++ a/mm/memory_hotplug.c
@@ -942,8 +942,8 @@ static void rollback_node_hotadd(int nid
 }
 
 
-/**
- * try_online_node - online a node if offlined
+/*
+ * __try_online_node - online a node if offlined
  * @nid: the node ID
  * @set_node_online: Whether we want to online the node
  * called by cpu_up() to online a node without onlined memory.
_
