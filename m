Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8BFC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 20:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239385AbiGHUQC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 16:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238996AbiGHUQB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 16:16:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C7624F18
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 13:16:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4DC4DCE2CCB
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 20:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C69C341C0;
        Fri,  8 Jul 2022 20:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657311356;
        bh=Od1u8pZ3p4uR+n0T0ScI5bwMYmnrQ8s33M2dPXQbfio=;
        h=Date:To:From:Subject:From;
        b=xDJe97Xm3sW6wCg2O4wbBTrbX+AZf+LvsFucb/wD0xsD6gqbWK8nCK9NkVhYyWXRs
         3CRBuWGMv7AS4MNx60kuhLePy8mlL5F8PBdi4cUiKvTf9Seba/qhal/yPcAY7MKEld
         NOZkNrDdS+jYKECj8XaqOHywwr2OBeNEtb3tDkj4=
Date:   Fri, 08 Jul 2022 13:15:55 -0700
To:     mm-commits@vger.kernel.org, vgoyal@redhat.com, dyoung@redhat.com,
        bhe@redhat.com, niejianglei2021@163.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-vmcore-fix-potential-memory-leak-in-vmcore_init.patch added to mm-nonmm-unstable branch
Message-Id: <20220708201556.86C69C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc/vmcore: fix potential memory leak in vmcore_init()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-vmcore-fix-potential-memory-leak-in-vmcore_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-vmcore-fix-potential-memory-leak-in-vmcore_init.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

proc-vmcore-fix-potential-memory-leak-in-vmcore_init.patch

