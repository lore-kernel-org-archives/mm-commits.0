Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59175C4167D
	for <mm-commits@archiver.kernel.org>; Thu,  9 Nov 2023 22:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbjKIWkb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Nov 2023 17:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbjKIWkb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Nov 2023 17:40:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9094223
        for <mm-commits@vger.kernel.org>; Thu,  9 Nov 2023 14:40:29 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6A2C433C7;
        Thu,  9 Nov 2023 22:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699569628;
        bh=3ZvYYrQHYLXZG6ET+NInqDRAPuSiOoRJ+/41YMqLjnI=;
        h=Date:To:From:Subject:From;
        b=2JLc/IvIPXTGy3JuLpEdjQpeRJ2AaZtt57kJUef9lckalBaZT1yRlp1QWk1BCkE6a
         HjW9cNBImvc7kAMqPoQ/i3qUe264xZz5Qm6jaJQ9+TpfGGcmzr/VrsRHBB2JMPuAtk
         ExH4UMzT4CRz2LUkjaNGHflzYcUVez94KN5wnGKc=
Date:   Thu, 09 Nov 2023 14:40:28 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        djwong@kernel.org, agruenba@redhat.com, adilger.kernel@dilger.ca,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-folio_zero_tail-and-use-it-in-ext4-fix.patch added to mm-unstable branch
Message-Id: <20231109224028.9B6A2C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-folio_zero_tail-and-use-it-in-ext4-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-folio_zero_tail-and-use-it-in-ext4-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-folio_zero_tail-and-use-it-in-ext4-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-folio_zero_tail-and-use-it-in-ext4-fix
Date: Thu Nov  9 02:39:20 PM PST 2023

fix kerneldoc argument ordering

Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/highmem.h~mm-add-folio_zero_tail-and-use-it-in-ext4-fix
+++ a/include/linux/highmem.h
@@ -486,8 +486,8 @@ static inline void memcpy_to_folio(struc
 /**
  * folio_zero_tail - Zero the tail of a folio.
  * @folio: The folio to zero.
- * @kaddr: The address the folio is currently mapped to.
  * @offset: The byte offset in the folio to start zeroing at.
+ * @kaddr: The address the folio is currently mapped to.
  *
  * If you have already used kmap_local_folio() to map a folio, written
  * some data to it and now need to zero the end of the folio (and flush
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-for-negative-counter-nr_file_hugepages-fix.patch
mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-add-folio_zero_tail-and-use-it-in-ext4-fix.patch
kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix.patch

