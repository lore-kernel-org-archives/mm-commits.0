Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C72C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4202B61108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbhKKCt6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:49:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234404AbhKKCt6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:49:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA18C60F26;
        Thu, 11 Nov 2021 02:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598829;
        bh=UtjHJ+hC4Koq4YNctVEGj/iFA2N3Ej1yABM4annQwxc=;
        h=Date:From:To:Subject:From;
        b=DBf9iTnrgw39Asslkub+8wxZpBVghr0JyAkiNcZREr9MCgtTfYSdZzfJKUjI9jcVB
         TQljtY9f7zA7/829NugurlzHCHlRjL5k35bGYKenx9Yy6RddQq5Bq4E6FnMeq8U0Li
         xuh+Qix5NaTvUekclSGj+IWGU3v/lyqnf9QdJ+Ls=
Date:   Wed, 10 Nov 2021 18:47:09 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, rppt@linux.ibm.com
Subject:  [merged]
 =?US-ASCII?Q?memory-hotplugrst-fix-two-instances-of-movablecore-that-shou?=
 =?US-ASCII?Q?ld-be-movable=5Fnode.patch?= removed from -mm tree
Message-ID: <20211111024709.9P9I9Kr6k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug.rst: fix two instances of "movablecore" that should be "movable_node"
has been removed from the -mm tree.  Its filename was
     memory-hotplugrst-fix-two-instances-of-movablecore-that-should-be-movable_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from david@redhat.com are


