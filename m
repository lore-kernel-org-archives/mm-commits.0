Return-Path: <SRS0=ocxe=C2=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5041AC43461
	for <mm-commits@archiver.kernel.org>; Thu, 17 Sep 2020 01:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B77720708
	for <mm-commits@archiver.kernel.org>; Thu, 17 Sep 2020 01:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600305933;
	bh=TWnsqK45yTGa9Vf3Y2Qa/fmyifQOi4wtijFnm9vGc6E=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=mCzaoK8PWjn5Y02TBl1NdymEl4GP3SpGx5tDoY7tMrEiyy16OdG4z1mUM+Bh2TwAc
	 ahvs95jyZqhhNACSLODtqLgs08UTH55+84QtOetB6IK+0R0njEGZ9bwvXMLqrHBn1f
	 01+sJwqHMdd4Ugt6eRhwQtOBdRafTH/u/PaQ56DM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgIQBZb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Sep 2020 21:25:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbgIQBZa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Sep 2020 21:25:30 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 21:25:30 EDT
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4652D20708;
        Thu, 17 Sep 2020 01:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600305550;
        bh=TWnsqK45yTGa9Vf3Y2Qa/fmyifQOi4wtijFnm9vGc6E=;
        h=Date:From:To:Subject:From;
        b=2vEv1PHSJdMND+untIu5uvcokJZJGLm8N44gB7h1+YGI3Hp51i1r9d+lDMqlbpqx0
         zxPNc3T+zYHlC7VV9N06sC8ndZ+Tbtoei51gu5k9IKEZfUyevXnxzPAfQ9wQZ43t49
         ac9l6p9JCuk2bu2xFHIK3PX2743Wwz0wMKUUgdSg=
Date:   Wed, 16 Sep 2020 18:19:09 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, cai@lca.pw, mhocko@kernel.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.com, osalvador@suse.de, tony.luck@intel.com
Subject:  + mmhwpoison-drop-unneeded-pcplist-draining-fix.patch
 added to -mm tree
Message-ID: <20200917011909.A91oftu12%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmhwpoison-drop-unneeded-pcplist-draining-fix
has been added to the -mm tree.  Its filename is
     mmhwpoison-drop-unneeded-pcplist-draining-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-drop-unneeded-pcplist-draining-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-drop-unneeded-pcplist-draining-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmhwpoison-drop-unneeded-pcplist-draining-fix

remove unused local `zone'

Cc: Michal Hocko <mhocko@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/madvise.c~mmhwpoison-drop-unneeded-pcplist-draining-fix
+++ a/mm/madvise.c
@@ -872,7 +872,6 @@ static long madvise_remove(struct vm_are
 static int madvise_inject_error(int behavior,
 		unsigned long start, unsigned long end)
 {
-	struct zone *zone;
 	unsigned long size;
 
 	if (!capable(CAP_SYS_ADMIN))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
device-dax-make-pgmap-optional-for-instance-creation-fix.patch
mm-memremap_pages-support-multiple-ranges-per-invocation-fix.patch
device-dax-make-align-a-per-device-property-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
mmhwpoison-drop-unneeded-pcplist-draining-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

