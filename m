Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A359C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbjDRXOx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbjDRXOx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:14:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A9E8A55
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:14:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4AF8601C3
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25129C433EF;
        Tue, 18 Apr 2023 23:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681859691;
        bh=u3nWlGnMwDuwHp3f4CVTTbsj4LESVNTFHdJf+90KjKw=;
        h=Date:To:From:Subject:From;
        b=Qv9HVR2ksh6Qk13s89yx8iON5nx5SGekEszLHz2vs57fz37T5oJQ0qMUs3aiQrOp/
         unKyZZgSy5tC359Ku8oCz67u3X+FB4PzK91A/ZIJDy2n1lBruraEoJ1hVypol1aiTt
         ZuwHq3P12TJhu6VM+pYP2hbs5VBwFKxT2E1/V+2I=
Date:   Tue, 18 Apr 2023 16:14:50 -0700
To:     mm-commits@vger.kernel.org, songliubraving@fb.com,
        skhan@linuxfoundation.org, riel@surriel.com,
        kirill.shutemov@linux.intel.com, ivan.orlov0322@gmail.com,
        himadrispandya@gmail.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix.patch removed from -mm tree
Message-Id: <20230418231451.25129C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix.patch

This patch was dropped because it was folded into mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix
Date: Wed Mar 29 02:50:56 PM PDT 2023

update include/trace/events/huge_memory.h's SCAN_STATUS

Cc: Himadri Pandya <himadrispandya@gmail.com>
Cc: Ivan Orlov <ivan.orlov0322@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix
+++ a/include/trace/events/huge_memory.h
@@ -36,7 +36,8 @@
 	EM( SCAN_ALLOC_HUGE_PAGE_FAIL,	"alloc_huge_page_failed")	\
 	EM( SCAN_CGROUP_CHARGE_FAIL,	"ccgroup_charge_failed")	\
 	EM( SCAN_TRUNCATED,		"truncated")			\
-	EMe(SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
+	EM( SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
+	EMe(SCAN_STORE_FAILED,		"store_failed")
 
 #undef EM
 #undef EMe
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix.patch
scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers-fix.patch

