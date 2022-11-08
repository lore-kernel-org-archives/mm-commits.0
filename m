Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05ED6C43219
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 23:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiKHX6d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiKHX6R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 18:58:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB33E606A8;
        Tue,  8 Nov 2022 15:58:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 582BAB81CC7;
        Tue,  8 Nov 2022 23:58:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A84C433D6;
        Tue,  8 Nov 2022 23:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951894;
        bh=czQQlpEAmU1oJjo1aMzSyfYQLp3bApbAUQfIig7Nizg=;
        h=Date:To:From:Subject:From;
        b=AUiftZDUZmxCknDq+4kZKnf3Lj9jeVuXpB6wYVElOtmzzm1ZfjOQoapbPcCrTc2eU
         ApIYSR/+vuSu1f5yEv9+MmGQcQrZemHU3A4Ff1B5XRcKGCRKKtPTmkyK38Zd2m7Ifg
         5tpP0XHupioCBAJuQzpC2G9jZ3DFM/IBVCr5b8gU=
Date:   Tue, 08 Nov 2022 15:58:13 -0800
To:     mm-commits@vger.kernel.org, thomas.lendacky@amd.com,
        stable@vger.kernel.org, dan.j.williams@intel.com,
        pankaj.gupta@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memremapc-map-fs_dax-device-memory-as-decrypted.patch removed from -mm tree
Message-Id: <20221108235813.F2A84C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memremap.c: map FS_DAX device memory as decrypted
has been removed from the -mm tree.  Its filename was
     mm-memremapc-map-fs_dax-device-memory-as-decrypted.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: <stable@vger.kernel.org>
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


