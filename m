Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3704C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0F1D20838
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266093;
	bh=38pjSBSTzZtlbhg3hB+7bO8EHDUXwx5muJYl6fdEDjU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Oy09ferlv6lIKwdrwaWEAX1qHwqp7h8KwV6OVMTRL5lGw5+33J0cAb4A6sj+7SuN0
	 jA3jllKOkiiav/HNigSB0p37heGnYxdFmk4dX3GKBCOLrlG/Gvs2tRohK5kLRQXbKj
	 GJ4lfIY+0lOYuAFheM69c+KrKhN+VkYfz8wR4bS0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgHLVBd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:01:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbgHLVBc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:01:32 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98163207F7;
        Wed, 12 Aug 2020 21:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266091;
        bh=38pjSBSTzZtlbhg3hB+7bO8EHDUXwx5muJYl6fdEDjU=;
        h=Date:From:To:Subject:From;
        b=xCEqOnH4L2kg1/98kRLhZruz3P2sNSP+GLDHpW38oRMM1ke5H/dVo71UjC8aeBOcM
         fT/fzC6V03aSDWl+RoAV2umQwfutTrtZW40vkUYJmovUZMpXFTUrgRDIco+KlQuO42
         R07k28GqJF1PtnEIEaQJWLvLXd6DWN1X5Mu3ov4c=
Date:   Wed, 12 Aug 2020 14:01:31 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, mkoutny@suse.com, mm-commits@vger.kernel.org,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  [merged]
 proc-pid-smaps-consistent-whitespace-output-format.patch removed from -mm
 tree
Message-ID: <20200812210131.onaGTkJ26%akpm@linux-foundation.org>
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
     Subject: /proc/PID/smaps: consistent whitespace output format
has been removed from the -mm tree.  Its filename was
     proc-pid-smaps-consistent-whitespace-output-format.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Michal Koutn=C3=BD <mkoutny@suse.com>
Subject: /proc/PID/smaps: consistent whitespace output format

The keys in smaps output are padded to fixed width with spaces.  All
except for THPeligible that uses tabs (only since commit c06306696f83
("mm: thp: fix false negative of shmem vma's THP eligibility")).

Unify the output formatting to save time debugging some na=C3=AFve parsers.=
=20
(Part of the unification is also aligning FilePmdMapped with others.)

Link: http://lkml.kernel.org/r/20200728083207.17531-1-mkoutny@suse.com
Signed-off-by: Michal Koutn=C3=BD <mkoutny@suse.com>
Acked-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c~proc-pid-smaps-consistent-whitespace-output-format
+++ a/fs/proc/task_mmu.c
@@ -786,7 +786,7 @@ static void __show_smap(struct seq_file
 	SEQ_PUT_DEC(" kB\nLazyFree:       ", mss->lazyfree);
 	SEQ_PUT_DEC(" kB\nAnonHugePages:  ", mss->anonymous_thp);
 	SEQ_PUT_DEC(" kB\nShmemPmdMapped: ", mss->shmem_thp);
-	SEQ_PUT_DEC(" kB\nFilePmdMapped: ", mss->file_thp);
+	SEQ_PUT_DEC(" kB\nFilePmdMapped:  ", mss->file_thp);
 	SEQ_PUT_DEC(" kB\nShared_Hugetlb: ", mss->shared_hugetlb);
 	seq_put_decimal_ull_width(m, " kB\nPrivate_Hugetlb: ",
 				  mss->private_hugetlb >> 10, 7);
@@ -816,7 +816,7 @@ static int show_smap(struct seq_file *m,
=20
 	__show_smap(m, &mss, false);
=20
-	seq_printf(m, "THPeligible:		%d\n",
+	seq_printf(m, "THPeligible:    %d\n",
 		   transparent_hugepage_enabled(vma));
=20
 	if (arch_pkeys_enabled())
_

Patches currently in -mm which might be from mkoutny@suse.com are


