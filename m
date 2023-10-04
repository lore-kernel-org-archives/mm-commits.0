Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE15E936E0
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244949AbjJDUYG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244664AbjJDUXR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A5EE8
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68564C433C8;
        Wed,  4 Oct 2023 20:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450992;
        bh=U5WKNV4hJD3CxAHKaBLn/J6SfAJcrrUqu+v8WNpXVlQ=;
        h=Date:To:From:Subject:From;
        b=r+AoFq3As2oTVRLTZa5f0zcL83RentYyvAGzxYCuLCsTEBdQ3+i8bbwkMiVeR2Qr5
         rUax5SZOMaB+nkL0yzy7DwV3YDwws2dHTbbXXJykUHUV/O+gnM3PEp8saG4YMHMSKe
         K9YfOjOHsAWJ9VJa/jFBk2FzLuHAuzqnyOOhq9YM=
Date:   Wed, 04 Oct 2023 13:23:11 -0700
To:     mm-commits@vger.kernel.org, zephray@outlook.com,
        thunder.leizhen@huawei.com, sunilvl@ventanamicro.com,
        robh@kernel.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
        jszhang@kernel.org, conor.dooley@microchip.com, bjorn@rivosinc.com,
        bhe@redhat.com, aou@eecs.berkeley.edu, alexghiti@rivosinc.com,
        ajones@ventanamicro.com, chenjiahao16@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] riscv-kdump-use-generic-interface-to-simplify-crashkernel-reservation-fix.patch removed from -mm tree
Message-Id: <20231004202312.68564C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: riscv: kdump: fix crashkernel reserving problem on RISC-V
has been removed from the -mm tree.  Its filename was
     riscv-kdump-use-generic-interface-to-simplify-crashkernel-reservation-fix.patch

This patch was dropped because it was folded into riscv-kdump-use-generic-interface-to-simplify-crashkernel-reservation.patch

------------------------------------------------------
From: Chen Jiahao <chenjiahao16@huawei.com>
Subject: riscv: kdump: fix crashkernel reserving problem on RISC-V
Date: Mon, 25 Sep 2023 10:43:33 +0800

When testing on risc-v QEMU environment with "crashkernel="
parameter enabled, a problem occurred with the following
message:

[    0.000000] crashkernel low memory reserved: 0xf8000000 - 0x100000000 (128 MB)
[    0.000000] crashkernel reserved: 0x0000000177e00000 - 0x0000000277e00000 (4096 MB)
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at kernel/resource.c:779 __insert_resource+0x8e/0xd0
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 6.6.0-rc2-next-20230920 #1
[    0.000000] Hardware name: riscv-virtio,qemu (DT)
[    0.000000] epc : __insert_resource+0x8e/0xd0
[    0.000000]  ra : insert_resource+0x28/0x4e
[    0.000000] epc : ffffffff80017344 ra : ffffffff8001742e sp : ffffffff81203db0
[    0.000000]  gp : ffffffff812ece98 tp : ffffffff8120dac0 t0 : ff600001f7ff2b00
[    0.000000]  t1 : 0000000000000000 t2 : 3428203030303030 s0 : ffffffff81203dc0
[    0.000000]  s1 : ffffffff81211e18 a0 : ffffffff81211e18 a1 : ffffffff81289380
[    0.000000]  a2 : 0000000277dfffff a3 : 0000000177e00000 a4 : 0000000177e00000
[    0.000000]  a5 : ffffffff81289380 a6 : 0000000277dfffff a7 : 0000000000000078
[    0.000000]  s2 : ffffffff81289380 s3 : ffffffff80a0bac8 s4 : ff600001f7ff2880
[    0.000000]  s5 : 0000000000000280 s6 : 8000000a00006800 s7 : 000000000000007f
[    0.000000]  s8 : 0000000080017038 s9 : 0000000080038ea0 s10: 0000000000000000
[    0.000000]  s11: 0000000000000000 t3 : ffffffff80a0bc00 t4 : ffffffff80a0bc00
[    0.000000]  t5 : ffffffff80a0bbd0 t6 : ffffffff80a0bc00
[    0.000000] status: 0000000200000100 badaddr: 0000000000000000 cause: 0000000000000003
[    0.000000] [<ffffffff80017344>] __insert_resource+0x8e/0xd0
[    0.000000] ---[ end trace 0000000000000000 ]---
[    0.000000] Failed to add a Crash kernel resource at 177e00000

The crashkernel memory has been allocated successfully, whereas
it failed to insert into iomem_resource. This is due to the
unique reserving logic in risc-v arch specific code, i.e.
crashk_res/crashk_low_res will be added into iomem_resource
later in init_resources(), which is not aligned with current
unified reserving logic in reserve_crashkernel_{generic,low}()
and therefore leads to the failure of crashkernel reservation.

Removing the arch specific code within #ifdef CONFIG_KEXEC_CORE
in init_resources() to fix above problem.

Link: https://lkml.kernel.org/r/20230925024333.730964-1-chenjiahao16@huawei.com
Fixes: 31549153088e ("riscv: kdump: use generic interface to simplify crashkernel reservation")
Signed-off-by: Chen Jiahao <chenjiahao16@huawei.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andrew Jones <ajones@ventanamicro.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Björn Töpel <bjorn@rivosinc.com>
Cc: Conor Dooley <conor.dooley@microchip.com>
Cc: Jisheng Zhang <jszhang@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Sunil V L <sunilvl@ventanamicro.com>
Cc: Wenting Zhang <zephray@outlook.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/kernel/setup.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/arch/riscv/kernel/setup.c~riscv-kdump-use-generic-interface-to-simplify-crashkernel-reservation-fix
+++ a/arch/riscv/kernel/setup.c
@@ -173,19 +173,6 @@ static void __init init_resources(void)
 	if (ret < 0)
 		goto error;
 
-#ifdef CONFIG_KEXEC_CORE
-	if (crashk_res.start != crashk_res.end) {
-		ret = add_resource(&iomem_resource, &crashk_res);
-		if (ret < 0)
-			goto error;
-	}
-	if (crashk_low_res.start != crashk_low_res.end) {
-		ret = add_resource(&iomem_resource, &crashk_low_res);
-		if (ret < 0)
-			goto error;
-	}
-#endif
-
 #ifdef CONFIG_CRASH_DUMP
 	if (elfcorehdr_size > 0) {
 		elfcorehdr_res.start = elfcorehdr_addr;
_

Patches currently in -mm which might be from chenjiahao16@huawei.com are

riscv-kdump-use-generic-interface-to-simplify-crashkernel-reservation.patch

