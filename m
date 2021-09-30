Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5512DC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 20:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F1B161A55
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 20:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348050AbhI3Ugf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 16:36:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347824AbhI3Ugd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 16:36:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D531A61A54;
        Thu, 30 Sep 2021 20:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633034090;
        bh=WvSEXqsNviI/CNr0W234P/EuIwRSV4cXGLtd091/adU=;
        h=Date:From:To:Subject:From;
        b=i3/6Rb2Wa+zFT4I+hPmMBedNdRNn7f6LZxdhJkoNtIXAXPfcxAU2wmlb3nIS1LxUq
         trLLBbBUdwdVx7lThjnSp4nLQsUMIHmLcZL6blkxoePLfXZd13ga6ThvVOqW3Xvqnr
         KBPcfzQmTr4+633qp0WP9WidTGV1mVxNl/ntJKhQ=
Date:   Thu, 30 Sep 2021 13:34:49 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, rppt@kernel.org
Subject:  +
 memory-hotplugrst-fix-wrong-sys-module-memory_hotplug-parameters-path.patch
 added to -mm tree
Message-ID: <20210930203449.5Ezvd8X17%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug.rst: fix wrong /sys/module/memory_hotplug/parameters/ path
has been added to the -mm tree.  Its filename is
     memory-hotplugrst-fix-wrong-sys-module-memory_hotplug-parameters-path.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memory-hotplugrst-fix-wrong-sys-module-memory_hotplug-parameters-path.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memory-hotplugrst-fix-wrong-sys-module-memory_hotplug-parameters-path.patch

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
Subject: memory-hotplug.rst: fix wrong /sys/module/memory_hotplug/parameters/ path

We accidentially added a superfluous "s".

Link: https://lkml.kernel.org/r/20210930144117.23641-3-david@redhat.com
Fixes: ac3332c44767 ("memory-hotplug.rst: complete admin-guide overhaul")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/memory-hotplug.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/memory-hotplug.rst~memory-hotplugrst-fix-wrong-sys-module-memory_hotplug-parameters-path
+++ a/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -410,7 +410,7 @@ them with ``memory_hotplug.`` such as::
 
 and they can be observed (and some even modified at runtime) via::
 
-	/sys/modules/memory_hotplug/parameters/
+	/sys/module/memory_hotplug/parameters/
 
 The following module parameters are currently defined:
 
_

Patches currently in -mm which might be from david@redhat.com are

memory-hotplugrst-fix-two-instances-of-movablecore-that-should-be-movable_node.patch
memory-hotplugrst-fix-wrong-sys-module-memory_hotplug-parameters-path.patch
memory-hotplugrst-document-the-auto-movable-online-policy.patch
kernel-resource-clean-up-and-optimize-iomem_is_exclusive.patch
kernel-resource-disallow-access-to-exclusive-system-ram-regions.patch
virtio-mem-disallow-mapping-virtio-mem-memory-via-dev-mem.patch

