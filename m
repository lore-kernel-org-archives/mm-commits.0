Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F6AC43217
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237988AbiKOWc2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238540AbiKOWcG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:32:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2207644
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8BCC61A4D
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E41C433D6;
        Tue, 15 Nov 2022 22:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551524;
        bh=YRdL0/9Jxh2slb6N/MYuFG9AYde06VtLKs/IEDvUZ2E=;
        h=Date:To:From:Subject:From;
        b=141zXQdjIjTJ9N5kphIiPa3jb65y+g+Ei8ZiGFwK/1tE10r+R+ulFbgdBQCzXR1kh
         Mi/ed8Vb7um6rs2EhKnN6+qYPKECMVnlyRrWCTABhIyYIF4vXBj8ClelcncxoMqzLq
         XzAprZd68eEMlbHijXmvqs7+TSlSY6Ja3dtLIB8w=
Date:   Tue, 15 Nov 2022 14:32:03 -0800
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        ye.xingchen@zte.com.cn, pmladek@suse.com, paulus@samba.org,
        mpe@ellerman.id.au, linux@armlinux.org.uk, lchen@ambarella.com,
        ebiederm@xmission.com, chenlifu@huawei.com, bhe@redhat.com,
        benh@kernel.crashing.org, niejianglei2021@163.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-vmcore-fix-potential-memory-leak-in-vmcore_init.patch removed from -mm tree
Message-Id: <20221115223204.48E41C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc/vmcore: fix potential memory leak in vmcore_init()
has been removed from the -mm tree.  Its filename was
     proc-vmcore-fix-potential-memory-leak-in-vmcore_init.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jianglei Nie <niejianglei2021@163.com>
Subject: proc/vmcore: fix potential memory leak in vmcore_init()
Date: Thu, 29 Sep 2022 12:29:33 +0800

Patch series "Some minor cleanup patches resent".

The first three patches trivial clean up patches.

And for the patch "kexec: replace crash_mem_range with range", I got a
ibm-p9wr ppc64le system to test, it works well.


This patch (of 4):

elfcorehdr_alloc() allocates a memory chunk for elfcorehdr_addr with
kzalloc().  If is_vmcore_usable() returns false, elfcorehdr_addr is a
predefined value.  If parse_crash_elf_headers() gets some error and
returns a negetive value, the elfcorehdr_addr should be released with
elfcorehdr_free().

Fix it by calling elfcorehdr_free() when parse_crash_elf_headers() fails.

Link: https://lkml.kernel.org/r/20220929042936.22012-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20220929042936.22012-2-bhe@redhat.com
Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chen Lifu <chenlifu@huawei.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Li Chen <lchen@ambarella.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: ye xingchen <ye.xingchen@zte.com.cn>
Cc: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/vmcore.c~proc-vmcore-fix-potential-memory-leak-in-vmcore_init
+++ a/fs/proc/vmcore.c
@@ -1567,6 +1567,7 @@ static int __init vmcore_init(void)
 		return rc;
 	rc = parse_crash_elf_headers();
 	if (rc) {
+		elfcorehdr_free(elfcorehdr_addr);
 		pr_warn("Kdump: vmcore not initialized\n");
 		return rc;
 	}
_

Patches currently in -mm which might be from niejianglei2021@163.com are


