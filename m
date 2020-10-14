Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4066DC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E51E422253
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709169;
	bh=2HToNRDCryT48ts5tm1Odog2ctd0fuqTOyTSJhvOmY4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=FJCQLMgXDV/QUQ6wJclKnBQxkRc7dDoo1RVLslkWBTK5loyT9qkbtZ9wktkWFVZ2B
	 IhCbUFb7g1sEFilugYSLXTVZKOMo1gr8qiahkL6uL9HdWv7dXIaFhjHCvh3Fh7YYw0
	 Pj/84MKZ7eQy2/zMpZqvR6JhiKrmFIYBKNYQMj5Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389518AbgJNU72 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389499AbgJNU72 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:59:28 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 993FE2224D;
        Wed, 14 Oct 2020 20:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709167;
        bh=2HToNRDCryT48ts5tm1Odog2ctd0fuqTOyTSJhvOmY4=;
        h=Date:From:To:Subject:From;
        b=TT0cJi+hB9p/Fux+It4miTsagxH8JKHbsWSteEB1UDYtOzo7rAtFkS9aVE9+kH02A
         AV7e4+cAoRR1DhEXBfp27Mze81BLQJlA09YQKPSIB3QRq5QQ1Jsz1r+HKXvG+47gMH
         5U3y0D3qXdpJq1I9ucH0lqcIt0pOLpBESG+35iBI=
Date:   Wed, 14 Oct 2020 13:59:26 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dan.j.williams@intel.com, david@fromorbit.com,
        hch@infradead.org, ira.weiny@intel.com, jack@suse.cz, jgg@ziepe.ca,
        jglisse@redhat.com, jhubbard@nvidia.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naresh.kamboju@linaro.org, shuah@kernel.org,
        song.bao.hua@hisilicon.com, vbabka@suse.cz,
        viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  [merged]
 mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm.patch
 removed from -mm tree
Message-ID: <20201014205926.OSubC9hfj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: don't permit users to call get_user_pages with FOLL_L=
ONGTERM
has been removed from the -mm tree.  Its filename was
     mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm.pat=
ch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Barry Song <song.bao.hua@hisilicon.com>
Subject: mm/gup: don't permit users to call get_user_pages with FOLL_LONGTE=
RM

gup prohibits users from calling get_user_pages() with FOLL_PIN.  But it
allows users to call get_user_pages() with FOLL_LONGTERM only.  It seems
insensible.

Since FOLL_LONGTERM is a stricter case of FOLL_PIN, we should prohibit
users from calling get_user_pages() with FOLL_LONGTERM while not with
FOLL_PIN.

mm/gup_benchmark.c used to be the only user who did this improperly.
But it has been fixed by moving to use pin_user_pages().

[akpm@linux-foundation.org: fix CONFIG_MMU=3Dn build]
  Link: https://lkml.kernel.org/r/CA+G9fYuNS3k0DVT62twfV746pfNhCSrk5sVMcOcQ=
1PGGnEseyw@mail.gmail.com
Link: http://lkml.kernel.org/r/20200819110100.23504-1-song.bao.hua@hisilico=
n.com
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jan Kara <jack@suse.cz>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

--- a/mm/gup.c~mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_lo=
ngterm
+++ a/mm/gup.c
@@ -1747,6 +1747,25 @@ static __always_inline long __gup_longte
 }
 #endif /* CONFIG_FS_DAX || CONFIG_CMA */
=20
+static bool is_valid_gup_flags(unsigned int gup_flags)
+{
+	/*
+	 * FOLL_PIN must only be set internally by the pin_user_pages*() APIs,
+	 * never directly by the caller, so enforce that with an assertion:
+	 */
+	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
+		return false;
+	/*
+	 * FOLL_PIN is a prerequisite to FOLL_LONGTERM. Another way of saying
+	 * that is, FOLL_LONGTERM is a specific case, more restrictive case of
+	 * FOLL_PIN.
+	 */
+	if (WARN_ON_ONCE(gup_flags & FOLL_LONGTERM))
+		return false;
+
+	return true;
+}
+
 #ifdef CONFIG_MMU
 static long __get_user_pages_remote(struct mm_struct *mm,
 				    unsigned long start, unsigned long nr_pages,
@@ -1842,11 +1861,7 @@ long get_user_pages_remote(struct mm_str
 		unsigned int gup_flags, struct page **pages,
 		struct vm_area_struct **vmas, int *locked)
 {
-	/*
-	 * FOLL_PIN must only be set internally by the pin_user_pages*() APIs,
-	 * never directly by the caller, so enforce that with an assertion:
-	 */
-	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
+	if (!is_valid_gup_flags(gup_flags))
 		return -EINVAL;
=20
 	return __get_user_pages_remote(mm, start, nr_pages, gup_flags,
@@ -1892,11 +1907,7 @@ long get_user_pages(unsigned long start,
 		unsigned int gup_flags, struct page **pages,
 		struct vm_area_struct **vmas)
 {
-	/*
-	 * FOLL_PIN must only be set internally by the pin_user_pages*() APIs,
-	 * never directly by the caller, so enforce that with an assertion:
-	 */
-	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
+	if (!is_valid_gup_flags(gup_flags))
 		return -EINVAL;
=20
 	return __gup_longterm_locked(current->mm, start, nr_pages,
@@ -2786,11 +2797,7 @@ EXPORT_SYMBOL_GPL(get_user_pages_fast_on
 int get_user_pages_fast(unsigned long start, int nr_pages,
 			unsigned int gup_flags, struct page **pages)
 {
-	/*
-	 * FOLL_PIN must only be set internally by the pin_user_pages*() APIs,
-	 * never directly by the caller, so enforce that:
-	 */
-	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
+	if (!is_valid_gup_flags(gup_flags))
 		return -EINVAL;
=20
 	/*
_

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are


