Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A28F0C433EF
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jul 2022 02:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiGICe7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 22:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiGICe6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 22:34:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2506820F75
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 19:34:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B61536242A
        for <mm-commits@vger.kernel.org>; Sat,  9 Jul 2022 02:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFB0C341C0;
        Sat,  9 Jul 2022 02:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657334097;
        bh=0RJecmDhKkegFlOFRn+MwNcacWhCnl//JW7LL+TIxtM=;
        h=Date:To:From:Subject:From;
        b=Kg7t+Eat1bH4ntkLQvG8OrmrR5nNndviNuytaLPUEDlEyxxglRJXcQR83/q/yO/fi
         FY8fiFcFwDf0BjoYWeD64oXM1Z3HDisWp8Qb0qgSlV027TEZEmwcFsQDC0dmO5lkQ9
         DHO4/dt6TDtU6q+4w9xq29k8AUUVHzt/3bnj9N/g=
Date:   Fri, 08 Jul 2022 19:34:56 -0700
To:     mm-commits@vger.kernel.org, vgoyal@redhat.com, dyoung@redhat.com,
        bhe@redhat.com, niejianglei2021@163.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] proc-vmcore-fix-potential-memory-leak-in-vmcore_init.patch removed from -mm tree
Message-Id: <20220709023457.0CFB0C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc/vmcore: fix potential memory leak in vmcore_init()
has been removed from the -mm tree.  Its filename was
     proc-vmcore-fix-potential-memory-leak-in-vmcore_init.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jianglei Nie <niejianglei2021@163.com>
Subject: proc/vmcore: fix potential memory leak in vmcore_init()
Date: Mon, 4 Jul 2022 16:18:39 +0800

elfcorehdr_alloc() allocates a memory chunk for elfcorehdr_addr with
kzalloc().  If is_vmcore_usable() returns false, elfcorehdr_addr is a
predefined value.  If parse_crash_elf_headers() occurs some error and
returns a negative value, the elfcorehdr_addr should be released with
elfcorehdr_free().

We can fix by calling elfcorehdr_free() when parse_crash_elf_headers()
fails.

Link: https://lkml.kernel.org/r/20220704081839.2232996-1-niejianglei2021@163.com
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/proc/vmcore.c~proc-vmcore-fix-potential-memory-leak-in-vmcore_init
+++ a/fs/proc/vmcore.c
@@ -1568,7 +1568,7 @@ static int __init vmcore_init(void)
 	rc = parse_crash_elf_headers();
 	if (rc) {
 		pr_warn("Kdump: vmcore not initialized\n");
-		return rc;
+		goto fail;
 	}
 	elfcorehdr_free(elfcorehdr_addr);
 	elfcorehdr_addr = ELFCORE_ADDR_ERR;
@@ -1576,6 +1576,9 @@ static int __init vmcore_init(void)
 	proc_vmcore = proc_create("vmcore", S_IRUSR, NULL, &vmcore_proc_ops);
 	if (proc_vmcore)
 		proc_vmcore->size = vmcore_size;
+
+fail:
+	elfcorehdr_free(elfcorehdr_addr);
 	return 0;
 }
 fs_initcall(vmcore_init);
_

Patches currently in -mm which might be from niejianglei2021@163.com are


