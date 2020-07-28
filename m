Return-Path: <SRS0=nZXm=BH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7641FC433E0
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 22:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5167C20672
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 22:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595974564;
	bh=MsP3pcTdfj0d2u2x6eTPRFsODWlLR9bGBg7EyiekOhA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=VkaCBX3FM5UH67FIrj1sk5f5tWZvwfiAZRqH8EFeYerUA8fsbH/HQOPmvO+yCTTdf
	 eX4F17Xe3BcqjnWhe3a68zgebCkGtVDi+6RatODLpeaOrCAfhtdWaVixKLLgnexS1+
	 +zS7DBzOY7iFbDjqc3obCamabXdq+xShmL3elAxk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729647AbgG1WQE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jul 2020 18:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729639AbgG1WQD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Jul 2020 18:16:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA65320663;
        Tue, 28 Jul 2020 22:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595974563;
        bh=MsP3pcTdfj0d2u2x6eTPRFsODWlLR9bGBg7EyiekOhA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gHM4qethKC6eNLOAsWU7mrDqAzsz6p/x720TvFeE3QIBLgwEeOvR/U2gUPC4CAs3v
         iMyNBppozQfV7ISRWqP7qEhx8VLUVTfxyS1UiWOfTNCyJ8Q1E2JAaEg5ov/BNe1vde
         CUnKqkIFJTH9Kro6TnBabFpZqZRDNkCNOIvGaX8o=
Date:   Tue, 28 Jul 2020 15:16:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, mkoutny@suse.com, mm-commits@vger.kernel.org,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  +
 proc-pid-smaps-consistent-whitespace-output-format.patch added to -mm tree
Message-ID: <20200728221602.0FkRGlXk7%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
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
has been added to the -mm tree.  Its filename is
     proc-pid-smaps-consistent-whitespace-output-format.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-pid-smaps-consistent-whit=
espace-output-format.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-pid-smaps-consistent-whit=
espace-output-format.patch

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

proc-pid-smaps-consistent-whitespace-output-format.patch

