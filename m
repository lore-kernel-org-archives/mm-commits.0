Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20647C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2064206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195935;
	bh=ncpsCJ2hPBxYmQsr3dPoAkOMTa9hHDjTw2s9V+rXkCY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=CMhMGKfM73fjysbnRbLLusnHpV1d8aJSOfNLKFzjEUUqHAaMUNZySsZ8zlAzvt6Lb
	 KkxH0zeAQ8Q5JlWOEcaoPfPDghcWXXax78lBBuRNY5qtRLqkKCm6bym9wJ1N+G+FT1
	 7ZXwhOR3TkIPTIFwm81VJ7T3vGh/sf7v75lyGgJ0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgHLBcO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgHLBcO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:32:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33BC5207DA;
        Wed, 12 Aug 2020 01:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195933;
        bh=ncpsCJ2hPBxYmQsr3dPoAkOMTa9hHDjTw2s9V+rXkCY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xeNaXsNdr3QDcX+5zCewzFAdePDBYyVt4DsAO3t/MGqGyERzcANEiytWTUJuAB7/d
         5gLNCzgsBxYqjDHnEDiugKvHcqbIyeZTeWiKU/JDXvOQFtGKfhn47MbI0OXm2+m1im
         zzdKF5nJV53OR1ZthPvnQV2DI2U32hmrqIz03tK4=
Date:   Tue, 11 Aug 2020 18:32:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, daniel.m.jordan@oracle.com,
        dave.hansen@linux.intel.com, david@redhat.com, hpa@zytor.com,
        linux-mm@kvack.org, luto@kernel.org, mhocko@kernel.org,
        mingo@elte.hu, mm-commits@vger.kernel.org,
        pasha.tatashin@soleen.com, peterz@infradead.org,
        steven.sistare@oracle.com, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject:  [patch 037/165] x86/mm: use max memory block size on bare
 metal
Message-ID: <20200812013212.XG-D4Vf-8%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: x86/mm: use max memory block size on bare metal

Some of our servers spend significant time at kernel boot initializing
memory block sysfs directories and then creating symlinks between them and
the corresponding nodes.  The slowness happens because the machines get
stuck with the smallest supported memory block size on x86 (128M), which
results in 16,288 directories to cover the 2T of installed RAM.  The
search for each memory block is noticeable even with commit 4fb6eabf1037
("drivers/base/memory.c: cache memory blocks in xarray to accelerate
lookup").

Commit 078eb6aa50dc ("x86/mm/memory_hotplug: determine block size based on
the end of boot memory") chooses the block size based on alignment with
memory end.  That addresses hotplug failures in qemu guests, but for bare
metal systems whose memory end isn't aligned to even the smallest size, it
leaves them at 128M.

Make kernels that aren't running on a hypervisor use the largest supported
size (2G) to minimize overhead on big machines.  Kernel boot goes 7%
faster on the aforementioned servers, shaving off half a second.

[daniel.m.jordan@oracle.com: v3]
  Link: http://lkml.kernel.org/r/20200714205450.945834-1-daniel.m.jordan@oracle.com
Link: http://lkml.kernel.org/r/20200609225451.3542648-1-daniel.m.jordan@oracle.com
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/x86/mm/init_64.c~x86-mm-use-max-memory-block-size-on-bare-metal
+++ a/arch/x86/mm/init_64.c
@@ -1452,6 +1452,15 @@ static unsigned long probe_memory_block_
 		goto done;
 	}
 
+	/*
+	 * Use max block size to minimize overhead on bare metal, where
+	 * alignment for memory hotplug isn't a concern.
+	 */
+	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR)) {
+		bz = MAX_BLOCK_SIZE;
+		goto done;
+	}
+
 	/* Find the largest allowed block size that aligns to memory end */
 	for (bz = MAX_BLOCK_SIZE; bz > MIN_MEMORY_BLOCK_SIZE; bz >>= 1) {
 		if (IS_ALIGNED(boot_mem_end, bz))
_
