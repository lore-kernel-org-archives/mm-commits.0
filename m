Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 424A5C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 19 Dec 2022 20:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiLSUY0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Dec 2022 15:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiLSUYZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2022 15:24:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72B7FA
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2022 12:24:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A8386114D
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2022 20:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18C6C433D2;
        Mon, 19 Dec 2022 20:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671481462;
        bh=xU/Esl4n1NEPwkyq7Fq8pg7lAAW6sUj7rcaDqpfgXiI=;
        h=Date:To:From:Subject:From;
        b=J4G6D3yKSXwhtP76RrGNUHTHUi2+9qnqZ676apEqUcxl0aMfMQrq5+LIeITKSlaFa
         mr9RaepcPSFBdc+figISD424H5CCPv90vxfA4YwGSlPSdaKNSXktsIPoImtdlZbz3i
         Wn7AEejc0/g0v8jGAr64no9jjYC16kDmnEZd5wLI=
Date:   Mon, 19 Dec 2022 12:24:21 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-implement-scheme-filters-fix.patch added to mm-unstable branch
Message-Id: <20221219202422.B18C6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs-schemes: Fix leaking a filter for wrong cgroup path
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-implement-scheme-filters-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-implement-scheme-filters-fix.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: Fix leaking a filter for wrong cgroup path
Date: Mon, 19 Dec 2022 17:18:06 +0000

Commit f36f860207efa ("mm/damon/sysfs-schemes: implement scheme filters")
on mm-unstable introduced 'damon_syfs_set_scheme_filters()', which does
not free newly allocated filter when it fails setting memcg id for the
filter.  As a result, the memory for the filter leaks.  Fix it by freeing
the filter before returning the error.

Coverity CID: 1530032

Link: https://lkml.kernel.org/r/20221219171807.55708-2-sj@kernel.org
Fixes: f36f860207ef ("mm/damon/sysfs-schemes: implement scheme filters") on mm-unstable
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-scheme-filters-fix
+++ a/mm/damon/sysfs-schemes.c
@@ -1464,8 +1464,10 @@ static int damon_sysfs_set_scheme_filter
 			err = damon_sysfs_memcg_path_to_id(
 					sysfs_filter->memcg_path,
 					&filter->memcg_id);
-			if (err)
+			if (err) {
+				damos_destroy_filter(filter);
 				return err;
+			}
 		}
 		damos_add_filter(scheme, filter);
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-implement-damos-filter.patch
mm-damon-paddr-support-damos-filters.patch
mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation.patch
docs-admin-guide-damon-reclaim-document-skip_anon-parameter.patch
mm-damon-sysfs-schemes-implement-filters-directory.patch
mm-damon-sysfs-schemes-implement-filter-directory.patch
mm-damon-sysfs-schemes-connect-filter-directory-and-filters-directory.patch
mm-damon-sysfs-schemes-implement-scheme-filters.patch
mm-damon-sysfs-schemes-implement-scheme-filters-fix.patch
selftests-damon-sysfs-test-filters-directory.patch
docs-admin-guide-mm-damon-usage-document-damos-filters-of-sysfs.patch
docs-abi-damon-document-scheme-filters-files.patch

