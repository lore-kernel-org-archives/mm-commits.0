Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D641C4363D
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:00:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF3A623A74
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600794052;
	bh=fqxoNrJteQaCGPPZHxckWPkfSnQqhleCpY60Wmf0HQg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=sR05MgVysIzJWCv63SvjbNdVw8/pQZRMODIYoEVSX4RJE7KvVrQvQIYE1Hep0D44v
	 VYLfuJIXejELFcQyPfT//oA+aJdr7qGS0YPKmdkjlfA1ZiaAUdVJ0G/3fLLKPBzNiG
	 6CFLkSIJOtMq5KUI4olIroYbEwh9ftDOQ5WCnJsU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgIVRAw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 13:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbgIVRAv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 13:00:51 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1E1423A61;
        Tue, 22 Sep 2020 17:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600794050;
        bh=fqxoNrJteQaCGPPZHxckWPkfSnQqhleCpY60Wmf0HQg=;
        h=Date:From:To:Subject:From;
        b=pR11/uN8vWNi9/82hpgEef3m1Jw3oV54V+hZzOLqvRJZirzz9OLEt8GbBEVCyvb/b
         rnPeNMi5yYQLPkzH74L5raJ2bWWbA5UVzqOr1EzZUVo23irAjVP1YvIDwbqoiECDZR
         sfAgw0XDj8f02ZMHStS6xlotsB/w5mSka34u7q7k=
Date:   Tue, 22 Sep 2020 10:00:49 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zeil@yandex-team.ru,
        tony.luck@intel.com, osalvador@suse.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, mhocko@kernel.org, david@redhat.com,
        dave.hansen@intel.com, cai@lca.pw, aris@ruivo.org,
        aneesh.kumar@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com,
        osalvador@suse.de
Subject:  + mmhwpoison-try-to-narrow-window-race-for-free-pages.patch
 added to -mm tree
Message-ID: <20200922170049.oAZIm%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: try to narrow window race for free pages
has been added to the -mm tree.  Its filename is
     mmhwpoison-try-to-narrow-window-race-for-free-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-try-to-narrow-window-race-for-free-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-try-to-narrow-window-race-for-free-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: try to narrow window race for free pages

Aristeu Rozanski reported that a customer test case started to report
-EBUSY after the hwpoison rework patchset.

There is a race window between spotting a free page and taking it off its
buddy freelist, so it might be that by the time we try to take it off, the
page has been already allocated.

This patch tries to handle such race window by trying to handle the new
type of page again if the page was allocated under us.

Link: https://lkml.kernel.org/r/20200922135650.1634-15-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reported-by: Aristeu Rozanski <aris@ruivo.org>
Tested-by: Aristeu Rozanski <aris@ruivo.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/memory-failure.c~mmhwpoison-try-to-narrow-window-race-for-free-pages
+++ a/mm/memory-failure.c
@@ -1903,6 +1903,7 @@ int soft_offline_page(unsigned long pfn,
 {
 	int ret;
 	struct page *page;
+	bool try_again = true;
 
 	if (!pfn_valid(pfn))
 		return -ENXIO;
@@ -1918,6 +1919,7 @@ int soft_offline_page(unsigned long pfn,
 		return 0;
 	}
 
+retry:
 	get_online_mems();
 	ret = get_any_page(page, pfn, flags);
 	put_online_mems();
@@ -1925,7 +1927,10 @@ int soft_offline_page(unsigned long pfn,
 	if (ret > 0)
 		ret = soft_offline_in_use_page(page);
 	else if (ret == 0)
-		ret = soft_offline_free_page(page);
+		if (soft_offline_free_page(page) && try_again) {
+			try_again = false;
+			goto retry;
+		}
 
 	return ret;
 }
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-unexport-get_hwpoison_page-and-make-it-static.patch
mmhwpoison-refactor-madvise_inject_error.patch
mmhwpoison-kill-put_hwpoison_page.patch
mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
mmhwpoison-rework-soft-offline-for-free-pages.patch
mmhwpoison-rework-soft-offline-for-in-use-pages.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
mmhwpoison-try-to-narrow-window-race-for-free-pages.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch
mmhwpoison-remove-stale-code.patch

