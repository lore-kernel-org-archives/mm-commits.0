Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B99C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbiKOWcg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238581AbiKOWcL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:32:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0E5C19
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93EECB81B8B
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE0BC433C1;
        Tue, 15 Nov 2022 22:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551528;
        bh=kIv6HrPIedbj2VBzB1/czIEKMthmL2UGxydd5IUPPi8=;
        h=Date:To:From:Subject:From;
        b=luKM0CJhJgYMCWhBfj2CE/JwBPyJta/0GbubQxwF99p20bEAJ6bDM88xjgiUBvXE7
         QTWWGJs7HzZhut52d3axCAaXnx5WSEsB98l4/l8UNjr9BhNYh0AfxKoPwM+CRGgpzR
         EekMztpIQcSbB7jJdD4igyeaL9YGmyT4nfThCSTo=
Date:   Tue, 15 Nov 2022 14:32:07 -0800
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn,
        ye.xingchen@zte.com.cn, pmladek@suse.com, paulus@samba.org,
        niejianglei2021@163.com, mpe@ellerman.id.au, linux@armlinux.org.uk,
        lchen@ambarella.com, ebiederm@xmission.com, bhe@redhat.com,
        benh@kernel.crashing.org, chenlifu@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] arm-kexec-make-machine_crash_nonpanic_core-static.patch removed from -mm tree
Message-Id: <20221115223208.3BE0BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ARM: kexec: make machine_crash_nonpanic_core() static
has been removed from the -mm tree.  Its filename was
     arm-kexec-make-machine_crash_nonpanic_core-static.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chen Lifu <chenlifu@huawei.com>
Subject: ARM: kexec: make machine_crash_nonpanic_core() static
Date: Thu, 29 Sep 2022 12:29:36 +0800

This symbol is not used outside of the file, so mark it static.

Fixes the following warning:

arch/arm/kernel/machine_kexec.c:76:6: warning: symbol 'machine_crash_nonpanic_core' was not declared. Should it be static?

Link: https://lkml.kernel.org/r/20220929042936.22012-5-bhe@redhat.com
Signed-off-by: Chen Lifu <chenlifu@huawei.com>
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jianglei Nie <niejianglei2021@163.com>
Cc: Li Chen <lchen@ambarella.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: ye xingchen <ye.xingchen@zte.com.cn>
Cc: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/machine_kexec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/machine_kexec.c~arm-kexec-make-machine_crash_nonpanic_core-static
+++ a/arch/arm/kernel/machine_kexec.c
@@ -73,7 +73,7 @@ void machine_kexec_cleanup(struct kimage
 {
 }
 
-void machine_crash_nonpanic_core(void *unused)
+static void machine_crash_nonpanic_core(void *unused)
 {
 	struct pt_regs regs;
 
_

Patches currently in -mm which might be from chenlifu@huawei.com are


