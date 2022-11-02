Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB093C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  2 Nov 2022 20:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiKBUHA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Nov 2022 16:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiKBUGv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Nov 2022 16:06:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD9E107
        for <mm-commits@vger.kernel.org>; Wed,  2 Nov 2022 13:06:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E06461B94
        for <mm-commits@vger.kernel.org>; Wed,  2 Nov 2022 20:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E7DC433C1;
        Wed,  2 Nov 2022 20:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667419609;
        bh=eClqVJBT8htjaNTjZTNrvlDCcXJ0H1rhGeExcsaaAHI=;
        h=Date:To:From:Subject:From;
        b=W/TmUn2fShC63CDQFI28Ar6V41r8iNgt6A2klDCxCrQDnzqMqLnhmNoj3UM2oGYJa
         L0PXqY/tlUroXXlJy+zv+YoDnAjJ/Q+w8JlNXH+WCdrckW9UmPpRTufcK/ZWVGere9
         shJ2TpGByF4dS1Tdyv9p1UWV9wsO8IxLKLXYfbI4=
Date:   Wed, 02 Nov 2022 13:06:48 -0700
To:     mm-commits@vger.kernel.org, thomas.lendacky@amd.com,
        dan.j.williams@intel.com, pankaj.gupta@amd.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memremapc-map-fs_dax-device-memory-as-decrypted.patch added to mm-hotfixes-unstable branch
Message-Id: <20221102200649.03E7DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memremap.c: map FS_DAX device memory as decrypted
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memremapc-map-fs_dax-device-memory-as-decrypted.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memremapc-map-fs_dax-device-memory-as-decrypted.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Pankaj Gupta <pankaj.gupta@amd.com>
Subject: mm/memremap.c: map FS_DAX device memory as decrypted
Date: Wed, 2 Nov 2022 11:07:28 -0500

virtio_pmem use devm_memremap_pages() to map the device memory.  By
default this memory is mapped as encrypted with SEV.  Guest reboot changes
the current encryption key and guest no longer properly decrypts the FSDAX
device meta data.

Mark the corresponding device memory region for FSDAX devices (mapped with
memremap_pages) as decrypted to retain the persistent memory property.

Link: https://lkml.kernel.org/r/20221102160728.3184016-1-pankaj.gupta@amd.com
Fixes: b7b3c01b19159 ("mm/memremap_pages: support multiple ranges per invocation")
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memremap.c~mm-memremapc-map-fs_dax-device-memory-as-decrypted
+++ a/mm/memremap.c
@@ -335,6 +335,7 @@ void *memremap_pages(struct dev_pagemap
 			WARN(1, "File system DAX not supported\n");
 			return ERR_PTR(-EINVAL);
 		}
+		params.pgprot = pgprot_decrypted(params.pgprot);
 		break;
 	case MEMORY_DEVICE_GENERIC:
 		break;
_

Patches currently in -mm which might be from pankaj.gupta@amd.com are

mm-memremapc-map-fs_dax-device-memory-as-decrypted.patch

