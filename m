Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EDA8C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 26 May 2022 21:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbiEZVD6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 May 2022 17:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240459AbiEZVDy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2022 17:03:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4AFCE733E
        for <mm-commits@vger.kernel.org>; Thu, 26 May 2022 14:03:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49F17B82217
        for <mm-commits@vger.kernel.org>; Thu, 26 May 2022 21:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09E2C385A9;
        Thu, 26 May 2022 21:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653599030;
        bh=ZCaYIzyzNQL1CR8awSX5jjmA6+wpN9y44hBFz6eQtts=;
        h=Date:To:From:Subject:From;
        b=lmvqPjNBbYH1OvDwbVD640TUXw6zAeIijcyYnZUmw5aUpqexvdlhw6iHxkN6QiNF+
         UbeL3TRyFAxjDt792Ope387hN+bj9GNhqa3M4bgz2P8DkRJTxDw7MveALth80UlBjB
         S4Myx4N+NZHjJdWuToObou7ZYoCHxL4oIRJDVvTI=
Date:   Thu, 26 May 2022 14:03:50 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-muchun-as-co-maintainer-for-hugetlb.patch removed from -mm tree
Message-Id: <20220526210350.D09E2C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: add Muchun as co-maintainer for HugeTLB
has been removed from the -mm tree.  Its filename was
     maintainers-add-muchun-as-co-maintainer-for-hugetlb.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -9019,16 +9019,20 @@ S:	Orphan
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


