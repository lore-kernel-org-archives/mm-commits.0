Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A00C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 24 May 2022 18:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240464AbiEXSyA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 May 2022 14:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240460AbiEXSyA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 May 2022 14:54:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4635A17C
        for <mm-commits@vger.kernel.org>; Tue, 24 May 2022 11:53:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 327C9615A7
        for <mm-commits@vger.kernel.org>; Tue, 24 May 2022 18:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F95CC34100;
        Tue, 24 May 2022 18:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653418437;
        bh=o+Emwn8BKfYMhemd9fODgzplG/KAvsHSKf8R6SRHppg=;
        h=Date:To:From:Subject:From;
        b=oeQw8ZvHi0B6h74iSU3wQlZYcmr0GoUovbJUggcxQjprZFWWAeuc/TuhK4Sg8HUrl
         ymi7YmuY47uLuuA7bHNxdXDMKKvJeX+91chyGMbxqFmba1An1vpUbPTF/h4fqs5C+F
         r9WDvJ6P40x6ZM9i997pdn19WnXWH13PbYErCCg0=
Date:   Tue, 24 May 2022 11:53:56 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-muchun-as-co-maintainer-for-hugetlb.patch added to mm-unstable branch
Message-Id: <20220524185357.7F95CC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Muchun as co-maintainer for HugeTLB
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-muchun-as-co-maintainer-for-hugetlb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-muchun-as-co-maintainer-for-hugetlb.patch

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: MAINTAINERS: add Muchun as co-maintainer for HugeTLB
Date: Sat, 21 May 2022 15:41:03 +0800

I have been focusing on mm for the past two years.  e.g.  developing,
fixing bugs, reviewing related to HugeTLB system.  I would like to help
Mike and other people working on HugeTLB by reviewing their work.

When I first introduced the vmemmmap reduction, I forgot to update
MAINTAINERS file.  Let's update it as well.  And rename "HUGETLB
FILESYSTEM" to "HUGETLB SUBSYSTEM" since some files are not only related
to filesystem but also memory management (the name of FILESYSTEM cannot
cover this area).

Link: https://lkml.kernel.org/r/20220521074103.79468-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-add-muchun-as-co-maintainer-for-hugetlb
+++ a/MAINTAINERS
@@ -9020,16 +9020,20 @@ S:	Orphan
 F:	Documentation/networking/device_drivers/ethernet/huawei/hinic.rst
 F:	drivers/net/ethernet/huawei/hinic/
 
-HUGETLB FILESYSTEM
+HUGETLB SUBSYSTEM
 M:	Mike Kravetz <mike.kravetz@oracle.com>
+M:	Muchun Song <songmuchun@bytedance.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-mm-hugepages
 F:	Documentation/admin-guide/mm/hugetlbpage.rst
 F:	Documentation/vm/hugetlbfs_reserv.rst
+F:	Documentation/vm/vmemmap_dedup.rst
 F:	fs/hugetlbfs/
 F:	include/linux/hugetlb.h
 F:	mm/hugetlb.c
+F:	mm/hugetlb_vmemmap.c
+F:	mm/hugetlb_vmemmap.h
 
 HVA ST MEDIA DRIVER
 M:	Jean-Christophe Trotin <jean-christophe.trotin@foss.st.com>
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

maintainers-add-muchun-as-co-maintainer-for-hugetlb.patch

