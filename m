Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F28B1C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 17:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D697520758
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 17:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597859232;
	bh=vmJFqssMATZ4kibX553ICm5gbXzR7/6xp0ZdOigiBq8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=OJf+TJVLlbOvnn1zw/lKVYFFguqmj/udjmGV9dUeJSF4qwh2PkjXxQFzjXXiH0VUe
	 KK6BvDWAqrNirAAnx/vxIokvXnQ8oAxWwhD541bNyeTm/Av2nGt+T/Yfb8EXllTrmu
	 WHmYaZlvWsC3HoGByBub57lWNkmHHKs3Kx/S48Ag=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgHSRrM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 13:47:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgHSRrM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 13:47:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0C922067C;
        Wed, 19 Aug 2020 17:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597859231;
        bh=vmJFqssMATZ4kibX553ICm5gbXzR7/6xp0ZdOigiBq8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sgyzamSbznV4I1zufTB/kYcf3x7axGpi46e9KJmVCWpiqP2/L9OG0sqreRwdWnhO1
         djAcrN5qa+sTK3ztPjIGSBlm8hFnAsvQW/biCZtbD/tNmFw7oJs9scXFhcDpa0U7jd
         HwbyAhUeBXHnTXVmbmGrOEYTHSbiOvjVGlUVHlRs=
Date:   Wed, 19 Aug 2020 10:47:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     corbet@lwn.net, dan.j.williams@intel.com, david@fromorbit.com,
        hch@infradead.org, jack@suse.cz, jgg@ziepe.ca, jglisse@redhat.com,
        jhubbard@nvidia.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, shuah@kernel.org,
        song.bao.hua@hisilicon.com, vbabka@suse.cz,
        viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  +
 mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm.patch
 added to -mm tree
Message-ID: <20200819174710.oWc_HkCpW%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: don't permit users to call get_user_pages with FOLL_L=
ONGTERM
has been added to the -mm tree.  Its filename is
     mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm.pat=
ch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-dont-permit-users-to-ca=
ll-get_user_pages-with-foll_longterm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-dont-permit-users-to-ca=
ll-get_user_pages-with-foll_longterm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: http://lkml.kernel.org/r/20200819110100.23504-1-song.bao.hua@hisilico=
n.com
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

--- a/mm/gup.c~mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_lo=
ngterm
+++ a/mm/gup.c
@@ -1789,6 +1789,25 @@ static long __get_user_pages_remote(stru
 				       gup_flags | FOLL_TOUCH | FOLL_REMOTE);
 }
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
 /**
  * get_user_pages_remote() - pin user pages in memory
  * @mm:		mm_struct of target mm
@@ -1854,11 +1873,7 @@ long get_user_pages_remote(struct mm_str
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
@@ -1904,11 +1919,7 @@ long get_user_pages(unsigned long start,
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
@@ -2810,11 +2821,7 @@ EXPORT_SYMBOL_GPL(get_user_pages_fast_on
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

mm-gup_benchmark-use-pin_user_pages-for-foll_longterm-flag.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm.patch

