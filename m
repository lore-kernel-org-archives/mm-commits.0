Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B1DFC32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiI0CxQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiI0CvO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:51:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496C8F9613
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1E21B81923
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75FE8C433D7;
        Tue, 27 Sep 2022 02:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246950;
        bh=bc4mFt93+aktgNrfjKi0KDsfs5tjl9UWTD5acsuFjhc=;
        h=Date:To:From:Subject:From;
        b=LE5SYIch5KI57pv2AdbvhGBqPNoczg5bpSmis/pkVNn24+bMj/4iKQ++V2XotBdzU
         SehGjiQzliKrN4291l5ApY7kIS7TUaut7RQNCphLvrUPi+agx90rBMkFu1a26iJ2RI
         f9JgnKfLcbq2tTuBfIo/sF4OBt0BJ5PKeD9N4RAs=
Date:   Mon, 26 Sep 2022 19:49:09 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-change-do_brk_munmap-to-use-do_mas_align_munmap.patch removed from -mm tree
Message-Id: <20220927024910.75FE8C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: change do_brk_munmap() to use do_mas_align_munmap()
has been removed from the -mm tree.  Its filename was
     mm-mmap-change-do_brk_munmap-to-use-do_mas_align_munmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mmap: change do_brk_munmap() to use do_mas_align_munmap()
Date: Tue, 6 Sep 2022 19:48:52 +0000

do_brk_munmap() has already aligned the address and has a maple tree state
to be used.  Use the new do_mas_align_munmap() to avoid unnecessary
alignment and error checks.

Link: https://lkml.kernel.org/r/20220906194824.2110408-30-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-change-do_brk_munmap-to-use-do_mas_align_munmap
+++ a/mm/mmap.c
@@ -3042,7 +3042,7 @@ static int do_brk_munmap(struct ma_state
 	int ret;
 
 	arch_unmap(mm, newbrk, oldbrk);
-	ret = do_mas_munmap(mas, mm, newbrk, oldbrk-newbrk, uf, true);
+	ret = do_mas_align_munmap(mas, vma, mm, newbrk, oldbrk, uf, true);
 	validate_mm_mt(mm);
 	return ret;
 }
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


