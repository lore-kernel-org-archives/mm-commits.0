Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9532BC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D93F2076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195859;
	bh=IIsvzlL6Rz5YlfR8i1Oshk46tk5uNokNDDjidG9fTDQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=t61DH7Tmnswz2CGn8egHSUev3+CqM9BW5LKdxFl7KF/s6xZNKgwoD/HqCM1nPbuAz
	 ZUXnFKYaPq+w0mGQLCri0m5KdCdbMJ4rIPcLHJTnDfZN07UixbIszOIJKwY7SmfE6Z
	 OMSWe9wC4zD119ZWMbp7YSOQaroPlyH2Q/f/NoQY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgHLBa7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBa6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:30:58 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D012C206B2;
        Wed, 12 Aug 2020 01:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195858;
        bh=IIsvzlL6Rz5YlfR8i1Oshk46tk5uNokNDDjidG9fTDQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OiRbUHX1d4a4bHnmTH1uYCvKPMoFP5Vdbtp8ZtsnwuEEbH3SJy5E3Vqcxk1XLL0bQ
         n47iaAfoLKGIRXSjXn7Jz8h5BA6n6Mg3B3vn1tGtx3XHOCfpraUbRiysbR7TTX+V9n
         T7/M86/Gg6KvSIRHJh0aKl8rgMVYTeFiJRuQrfAI=
Date:   Tue, 11 Aug 2020 18:30:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mkoutny@suse.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org,
        yang.shi@linux.alibaba.com
Subject:  [patch 013/165] /proc/PID/smaps: consistent whitespace
 output format
Message-ID: <20200812013057.Q0tDuMw08%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
