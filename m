Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA93C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F76560FEE
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhGFTQk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:16:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231800AbhGFTQk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:16:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8092F60FE3;
        Tue,  6 Jul 2021 19:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598840;
        bh=VNxYUol21lzUL2UEkm83PAtlem57744aQZI7uKzPqzg=;
        h=Date:From:To:Subject:From;
        b=Gj+9BcaHQ8YcJtrlLF3pw/LiV7K4LSS8kgB2YaET4F6mp4+0pV3iMY2eJLZWUqJwa
         BPNexJHBcLh9yY7+IwggnUTOZ1MHYXwZEC2WVOtefJn9RSWmswVoRY6+I5VDVyii52
         fIaAqYWQWbFQjN60181DESRy4FgEsVMzE20SAITQ=
Date:   Tue, 06 Jul 2021 12:14:00 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, js07.lee@samsung.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-report-which-part-of-mem-is-being-freed-on-initmem-case.patch removed
 from -mm tree
Message-ID: <20210706191400.2FPKemosI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: report which part of mem is being freed on initmem case
has been removed from the -mm tree.  Its filename was
     mm-report-which-part-of-mem-is-being-freed-on-initmem-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jungseung Lee <js07.lee@samsung.com>
Subject: mm: report which part of mem is being freed on initmem case

Add the details for figuring out which parts of the kernel image is being
freed on initmem case.

Before:
   Freeing unused kernel memory: 1024K

After:
   Freeing unused kernel image (initmem) memory: 1024K

Link: https://lkml.kernel.org/r/1622706274-4533-1-git-send-email-js07.lee@samsung.com
Signed-off-by: Jungseung Lee <js07.lee@samsung.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-report-which-part-of-mem-is-being-freed-on-initmem-case
+++ a/include/linux/mm.h
@@ -2416,7 +2416,7 @@ static inline unsigned long free_initmem
 	extern char __init_begin[], __init_end[];
 
 	return free_reserved_area(&__init_begin, &__init_end,
-				  poison, "unused kernel");
+				  poison, "unused kernel image (initmem)");
 }
 
 static inline unsigned long get_num_physpages(void)
_

Patches currently in -mm which might be from js07.lee@samsung.com are


