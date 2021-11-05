Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8111BC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64BB161357
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbhKEUqw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:46:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233708AbhKEUqw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:46:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB00861288;
        Fri,  5 Nov 2021 20:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145052;
        bh=Cg3gAnv0Nq31DQ40uPeNA/2Iv5l670RIiuarOxllnus=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=b4YYe7ySGVcnu928gyaOfgjSsoahgcClhpm8Z7A8ripx6tiKBcYpe5bRM0NycDzhN
         WiVw4zYPcu1wKvHWAkn1T4cmBB2Ykhx5MOF3mFoF+ABkgb/zIQlnsojeXBTU6hfGSx
         kMLZKeGiZUb6/hQDmEeXanksC9W46F+QPZkN7xzY=
Date:   Fri, 05 Nov 2021 13:44:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, david@redhat.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 183/262] memory-hotplug.rst: fix two instances of
 "movablecore" that should be "movable_node"
Message-ID: <20211105204411.-wGjo2Oc-%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: memory-hotplug.rst: fix two instances of "movablecore" that should be "movable_node"

Patch series "memory-hotplug.rst: document the "auto-movable" online policy".

Now that the memory-hotplug.rst overhaul is upstream, proper documentation
for the "auto-movable" online policy, documenting all new toggles and
options.  Along, two fixes for the original overhaul.


This patch (of 3):

We really want to refer to the "movable_node" kernel command line
parameter here.

Link: https://lkml.kernel.org/r/20210930144117.23641-2-david@redhat.com
Fixes: ac3332c44767 ("memory-hotplug.rst: complete admin-guide overhaul")
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/memory-hotplug.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/memory-hotplug.rst~memory-hotplugrst-fix-two-instances-of-movablecore-that-should-be-movable_node
+++ a/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -166,7 +166,7 @@ Or alternatively::
 	% echo 1 > /sys/devices/system/memory/memoryXXX/online
 
 The kernel will select the target zone automatically, usually defaulting to
-``ZONE_NORMAL`` unless ``movablecore=1`` has been specified on the kernel
+``ZONE_NORMAL`` unless ``movable_node`` has been specified on the kernel
 command line or if the memory block would intersect the ZONE_MOVABLE already.
 
 One can explicitly request to associate an offline memory block with
@@ -393,7 +393,7 @@ command line parameters are relevant:
 ======================== =======================================================
 ``memhp_default_state``	 configure auto-onlining by essentially setting
                          ``/sys/devices/system/memory/auto_online_blocks``.
-``movablecore``		 configure automatic zone selection of the kernel. When
+``movable_node``	 configure automatic zone selection in the kernel. When
 			 set, the kernel will default to ZONE_MOVABLE, unless
 			 other zones can be kept contiguous.
 ======================== =======================================================
_
