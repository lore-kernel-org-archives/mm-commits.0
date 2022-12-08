Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17BC0C001B2
	for <mm-commits@archiver.kernel.org>; Thu,  8 Dec 2022 23:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiLHXBX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Dec 2022 18:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiLHXBW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Dec 2022 18:01:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D598F72E
        for <mm-commits@vger.kernel.org>; Thu,  8 Dec 2022 15:01:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BD6261CF8
        for <mm-commits@vger.kernel.org>; Thu,  8 Dec 2022 23:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31CAC433EF;
        Thu,  8 Dec 2022 23:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670540481;
        bh=JOQXAZFeKTLkwCvBP+Bl0aOu/DIkkU8UrLpcRYDUiKE=;
        h=Date:To:From:Subject:From;
        b=Z3vRQirVmIDGzL+fWFemfymiDVT0G0jF2UEgjIHUM+q4x+YaXOdmCSpapnyODXwOK
         Jlg394brOBWFNKiyO/U+ZIV4ETDV6YFFyJyV88QOrSIPS166aGyKLpNGzyu/1uL0ny
         nv0pXbeGv/umxZ9ZQmLmHdxiEILw1i+8l2fSgtXk=
Date:   Thu, 08 Dec 2022 15:01:20 -0800
To:     mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com,
        nadav.amit@gmail.com, ives@codesandbox.io, david@redhat.com,
        axelrasmussen@google.com, apopple@nvidia.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-migrate-fix-read-only-page-got-writable-when-recover-pte-fix.patch removed from -mm tree
Message-Id: <20221208230120.F31CAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-migrate-fix-read-only-page-got-writable-when-recover-pte-fix
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-read-only-page-got-writable-when-recover-pte-fix.patch

This patch was dropped because it was folded into mm-migrate-fix-read-only-page-got-writable-when-recover-pte.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm-migrate-fix-read-only-page-got-writable-when-recover-pte-fix
Date: Thu, 1 Dec 2022 10:19:22 -0500

enhance comment

Link: https://lkml.kernel.org/r/Y4jIHureiOd8XjDX@x1n
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Ives van Hoorne <ives@codesandbox.io>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-fix-read-only-page-got-writable-when-recover-pte-fix
+++ a/mm/migrate.c
@@ -214,7 +214,14 @@ static bool remove_migration_pte(struct
 		if (is_writable_migration_entry(entry))
 			pte = maybe_mkwrite(pte, vma);
 		else
-			/* NOTE: mk_pte can have write bit set */
+			/*
+			 * NOTE: mk_pte() can have write bit set per memory
+			 * type (e.g. shmem), or pte_mkdirty() per archs
+			 * (e.g., sparc64).  If this is a read migration
+			 * entry, we need to make sure when we recover the
+			 * pte from migration entry to present entry the
+			 * write bit is cleared.
+			 */
 			pte = pte_wrprotect(pte);
 
 		if (pte_swp_uffd_wp(*pvmw.pte)) {
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-migrate-fix-read-only-page-got-writable-when-recover-pte.patch

