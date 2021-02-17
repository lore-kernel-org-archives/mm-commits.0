Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3767C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 17 Feb 2021 19:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80F6264DF3
	for <mm-commits@archiver.kernel.org>; Wed, 17 Feb 2021 19:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhBQTKI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Feb 2021 14:10:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231653AbhBQTKI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Feb 2021 14:10:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CA3A64E15;
        Wed, 17 Feb 2021 19:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613588967;
        bh=o3/mMKuKtucwSnLneGf6pdTOOqjYmaFjNUnx459vc0U=;
        h=Date:From:To:Subject:From;
        b=JSm+5qCQtKHDK2bkKfIpkmQF/eHpg3Asj9bx+SsmQ+Z3uoznPf5PIvfYgqyE0Z7GE
         T12mIY4f6AjkkzdKe2vJIib5fmkrxCSiI8Tui2q3Kj7ejSxNmdXzGEnXiiABBodlVa
         9tjxIAgUezSXwtiZDo+700rjAEE9k2bYAJ6nzpHo=
Date:   Wed, 17 Feb 2021 11:09:27 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mtk.manpages@gmail.com,
        david@redhat.com, vbabka@suse.cz
Subject:  + maintainers-add-uapi-directories-to-api-abi-section.patch
 added to -mm tree
Message-ID: <20210217190927.PvKOv%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add uapi directories to API/ABI section
has been added to the -mm tree.  Its filename is
     maintainers-add-uapi-directories-to-api-abi-section.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-uapi-directories-to-api-abi-section.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-uapi-directories-to-api-abi-section.patch

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
Subject: MAINTAINERS: add uapi directories to API/ABI section

Let's add include/uapi/ and arch/*/include/uapi/ to API/ABI section, so
that for patches modifying them, get_maintainers.pl suggests CCing
linux-api@ so people don't forget.

Link: https://lkml.kernel.org/r/20210217174745.13591-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: David Hildenbrand <david@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-uapi-directories-to-api-abi-section
+++ a/MAINTAINERS
@@ -261,6 +261,8 @@ ABI/API
 L:	linux-api@vger.kernel.org
 F:	include/linux/syscalls.h
 F:	kernel/sys_ni.c
+F:	include/uapi/
+F:	arch/*/include/uapi/
 
 ABIT UGURU 1,2 HARDWARE MONITOR DRIVER
 M:	Hans de Goede <hdegoede@redhat.com>
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-stop-freeing-kmem_cache_node-structures-on-node-offline.patch
mm-slab-slub-stop-taking-memory-hotplug-lock.patch
mm-slab-slub-stop-taking-cpu-hotplug-lock.patch
mm-slub-splice-cpu-and-page-freelists-in-deactivate_slab.patch
mm-slub-remove-slub_memcg_sysfs-boot-param-and-config_slub_memcg_sysfs_on.patch
maintainers-add-uapi-directories-to-api-abi-section.patch

