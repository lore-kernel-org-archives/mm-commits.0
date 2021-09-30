Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F903C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 20:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67E8361A54
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 20:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348028AbhI3Uga (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 16:36:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347824AbhI3Uga (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 16:36:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CFF561994;
        Thu, 30 Sep 2021 20:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633034087;
        bh=SjkNB4Z1KThQUsM4E9ksoo4YjfCq1z4x1sjOpb6hU3Y=;
        h=Date:From:To:Subject:From;
        b=O1LtVVQF2NCyjmJo/BB5zwTE2ARVT1Ot66WOeR5GTda5R3NJEf6SgplbugtvaoEqO
         bvh9Bz8zIfn1R/OGFFYre5dUgEOs7jd1mvISyMw+bhIV4kCq2zhZHgroB7yLb4E8oh
         feSplW345zKMo+vZEg/GQeL0gDoyM2TIXEUhnLCE=
Date:   Thu, 30 Sep 2021 13:34:46 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, rppt@kernel.org
Subject:  +
 =?US-ASCII?Q?memory-hotplugrst-fix-two-instances-of-movablecore-that-shou?=
 =?US-ASCII?Q?ld-be-movable=5Fnode.patch?= added to -mm tree
Message-ID: <20210930203446.4GMDlhAnh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug.rst: fix two instances of "movablecore" that should be "movable_node"
has been added to the -mm tree.  Its filename is
     memory-hotplugrst-fix-two-instances-of-movablecore-that-should-be-movable_node.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memory-hotplugrst-fix-two-instances-of-movablecore-that-should-be-movable_node.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memory-hotplugrst-fix-two-instances-of-movablecore-that-should-be-movable_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: memory-hotplug.rst: fix two instances of "movablecore" that should be "movable_node"

Pach series "memory-hotplug.rst: document the "auto-movable" online policy".

Now that the memory-hotplug.rst overhaul is upstream, proper documentation
for the "auto-movable" online policy, documenting all new toggles and
options.  Along, two fixes for the original overhaul.


This patch (of 3):

We really want to refer to the "movable_node" kernel command line
parameter here.

Link: https://lkml.kernel.org/r/20210930144117.23641-2-david@redhat.com
Fixes: ac3332c44767 ("memory-hotplug.rst: complete admin-guide overhaul")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
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

Patches currently in -mm which might be from david@redhat.com are

memory-hotplugrst-fix-two-instances-of-movablecore-that-should-be-movable_node.patch
memory-hotplugrst-fix-wrong-sys-module-memory_hotplug-parameters-path.patch
memory-hotplugrst-document-the-auto-movable-online-policy.patch
kernel-resource-clean-up-and-optimize-iomem_is_exclusive.patch
kernel-resource-disallow-access-to-exclusive-system-ram-regions.patch
virtio-mem-disallow-mapping-virtio-mem-memory-via-dev-mem.patch

