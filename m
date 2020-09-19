Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADB66C43464
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D6B3221EC
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600475052;
	bh=8Z69ePW7FLxAd0/2DXLmhVJCCLML4q5Ktfj3gvPK89Q=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=giWtg0wETj/3SXzbdepfoVCL0/szF2apqNaOnRijvrelOru3lHJqP+F22pqeJ71zk
	 xg+z/wFbIBOpFkejWmb4HiLqHVYaxHWz1zvoW+gd1pf7K/L/VbWXjDhM1D8Un9ZrAN
	 Z4Vt09f3uSAdEz2dJa+R35fpaYUW2FZRDDjfobWk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgISAYM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 20:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISAYM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 20:24:12 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17AF921D20;
        Sat, 19 Sep 2020 00:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600475051;
        bh=8Z69ePW7FLxAd0/2DXLmhVJCCLML4q5Ktfj3gvPK89Q=;
        h=Date:From:To:Subject:From;
        b=FkaQRFde4HPua5GVEvEappwRF+ueuUn/dP/Bh4kegJisJHN8mEIr/DwyvG6gDuBAR
         /lr8kLApne3dOZ6ZjG1W4qMWY+Qt+po2BmKuSPKdgW5grcLg+VVvJwyxl6uZ+m2vzr
         OOIsreFsmTYVzQ2nD85aVn4JXGGDAuUfW68HX54U=
Date:   Fri, 18 Sep 2020 17:24:10 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zeil@yandex-team.ru,
        tony.luck@intel.com, osalvador@suse.com, mike.kravetz@oracle.com,
        mhocko@kernel.org, david@redhat.com, dave.hansen@intel.com,
        cai@lca.pw, aneesh.kumar@linux.vnet.ibm.com,
        aneesh.kumar@linux.ibm.com, naoya.horiguchi@nec.com
Subject:  [to-be-updated]
 mm-hwpoison-remove-recalculating-hpage.patch removed from -mm tree
Message-ID: <20200919002410.VgEf9%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: remove recalculating hpage
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-remove-recalculating-hpage.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm, hwpoison: remove recalculating hpage

hpage is never used after try_to_split_thp_page() in memory_failure(), so
we don't have to update hpage.  So let's not recalculate/use hpage.

Link: http://lkml.kernel.org/r/20200806184923.7007-3-nao.horiguchi@gmail.com
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Oscar Salvador <osalvador@suse.com>
Suggested-by: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-remove-recalculating-hpage
+++ a/mm/memory-failure.c
@@ -1341,7 +1341,6 @@ int memory_failure(unsigned long pfn, in
 		}
 		unlock_page(p);
 		VM_BUG_ON_PAGE(!page_count(p), p);
-		hpage = compound_head(p);
 	}
 
 	/*
@@ -1413,11 +1412,8 @@ int memory_failure(unsigned long pfn, in
 	/*
 	 * Now take care of user space mappings.
 	 * Abort on fail: __delete_from_page_cache() assumes unmapped page.
-	 *
-	 * When the raw error page is thp tail page, hpage points to the raw
-	 * page after thp split.
 	 */
-	if (!hwpoison_user_mappings(p, pfn, flags, &hpage)) {
+	if (!hwpoison_user_mappings(p, pfn, flags, &p)) {
 		action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		res = -EBUSY;
 		goto out;
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mmhwpoison-inject-dont-pin-for-hwpoison_filter.patch
mmhwpoison-introduce-mf_msg_unsplit_thp.patch
mmhwpoison-double-check-page-count-in-__get_any_page.patch

