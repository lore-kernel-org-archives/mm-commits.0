Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF14C04A95
	for <mm-commits@archiver.kernel.org>; Sat, 22 Oct 2022 23:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiJVXeH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Oct 2022 19:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiJVXeE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Oct 2022 19:34:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1809E748C7
        for <mm-commits@vger.kernel.org>; Sat, 22 Oct 2022 16:34:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99E1060B52
        for <mm-commits@vger.kernel.org>; Sat, 22 Oct 2022 23:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5F4C433D7;
        Sat, 22 Oct 2022 23:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666481643;
        bh=YPTKWy6UzhkH5M3N3ySRDnTivqM1WAbBbi3UxjOZ/H8=;
        h=Date:To:From:Subject:From;
        b=jjlmyPU2rwNrxOjgzWSDROWUOSAui8rv4/mUfhYJXX4Ur+L6WWIKhwCkkZVWohCi4
         EPs04rSl2gJshtSu8g8g09YoGvziZP6lJZmgAyUWCLKOYcN+ifgRUWLEtT+Psf71ca
         zSI3Bpy9c1DCu5kuMM/4kMyO25MqIdAAtfydu22c=
Date:   Sat, 22 Oct 2022 16:34:02 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com,
        dan.j.williams@intel.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch added to mm-unstable branch
Message-Id: <20221022233402.ED5F4C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix
Date: Sat Oct 22 04:31:31 PM PDT 2022

fix pgmap_request_folio() stub return type

Reported-by: kernel test robot <lkp@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memremap.h~mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix
+++ a/include/linux/memremap.h
@@ -255,7 +255,7 @@ static inline struct dev_pagemap *get_de
 static inline struct folio *pgmap_request_folio(struct dev_pagemap *pgmap,
 						pgoff_t pgmap_offset, int order)
 {
-	return false;
+	return NULL;
 }
 
 static inline bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ipc-msgc-fix-percpu_counter-use-after-free.patch
fs-ext4-superc-remove-unused-deprecated_msg.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-hugetlb-convert-free_huge_page-to-folios-fix.patch
vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-gup-remove-foll_migration-fix.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

