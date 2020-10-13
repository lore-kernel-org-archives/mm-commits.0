Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B41C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42D292223F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633473;
	bh=XKjLzp7ntuEDEzK8gTjxcEFi7fAYfkslp5aKhjYErjI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Ak249ch3lNUK5CRneR6Cuyi6ptw9eUZVUn0/Qv11Y/e6iZCSUEJE94556D/lUSU6k
	 yPkekkRJDJxAgMhuYBEoQcqmkcI3sXxbasdZA8BbT3PnAhSa5PCraCe3qAB2fpIZWM
	 IbRdQveiUX1H+upx6KPt+oGpx2Jya7eVHio52OTA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389008AbgJMX5x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:57:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387851AbgJMX5w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:57:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44C2F221FC;
        Tue, 13 Oct 2020 23:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633471;
        bh=XKjLzp7ntuEDEzK8gTjxcEFi7fAYfkslp5aKhjYErjI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=c2mB9lvH+2gyxeAYZS1zUBVPGIlfbU40NUQZ0RBOkRbZ4PmEUeY+DCA6h1+qeVPB3
         ZX0R6/ft0mjH9zd/h8/dYx06nyu8EqrADc5VTK93uivS38UiuI2whkBDIE/WJxFFle
         RmOpTSW8dlOem3QhMvj22T1icW+t+GneWpKoOpVM=
Date:   Tue, 13 Oct 2020 16:57:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, benh@kernel.crashing.org,
        bhe@redhat.com, bp@alien8.de, catalin.marinas@arm.com,
        dave.hansen@linux.intel.com, dja@axtens.net,
        hbathini@linux.ibm.com, hch@lst.de, jcmvbkbc@gmail.com,
        Jonathan.Cameron@huawei.com, kernel@esmil.dk, linux-mm@kvack.org,
        linux@armlinux.org.uk, luto@kernel.org, m.szyprowski@samsung.com,
        miguel.ojeda.sandonis@gmail.com, mingo@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu,
        mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com,
        paulus@samba.org, peterz@infradead.org, rppt@linux.ibm.com,
        shorne@gmail.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, tsbogend@alpha.franken.de,
        will@kernel.org, ysato@users.sourceforge.jp
Subject:  [patch 169/181] memblock: make for_each_memblock_type()
 iterator private
Message-ID: <20201013235749.r7Zd7kpQK%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: memblock: make for_each_memblock_type() iterator private

for_each_memblock_type() is not used outside mm/memblock.c, move it there
from include/linux/memblock.h

Link: https://lkml.kernel.org/r/20200818151634.14343-9-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Emil Renner Berthing <kernel@esmil.dk>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    5 -----
 mm/memblock.c            |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/memblock.h~memblock-make-for_each_memblock_type-iterator-private
+++ a/include/linux/memblock.h
@@ -552,11 +552,6 @@ static inline unsigned long memblock_reg
 	     region < (memblock.memblock_type.regions + memblock.memblock_type.cnt);	\
 	     region++)
 
-#define for_each_memblock_type(i, memblock_type, rgn)			\
-	for (i = 0, rgn = &memblock_type->regions[0];			\
-	     i < memblock_type->cnt;					\
-	     i++, rgn = &memblock_type->regions[i])
-
 extern void *alloc_large_system_hash(const char *tablename,
 				     unsigned long bucketsize,
 				     unsigned long numentries,
--- a/mm/memblock.c~memblock-make-for_each_memblock_type-iterator-private
+++ a/mm/memblock.c
@@ -132,6 +132,11 @@ struct memblock_type physmem = {
 };
 #endif
 
+#define for_each_memblock_type(i, memblock_type, rgn)			\
+	for (i = 0, rgn = &memblock_type->regions[0];			\
+	     i < memblock_type->cnt;					\
+	     i++, rgn = &memblock_type->regions[i])
+
 int memblock_debug __initdata_memblock;
 static bool system_has_some_mirror __initdata_memblock = false;
 static int memblock_can_resize __initdata_memblock;
_
