Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34608C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbiEJERD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236027AbiEJEQZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:16:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924CB15790B
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5D03B81AEF
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D1CC385C5;
        Tue, 10 May 2022 04:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155912;
        bh=ZpPOz3N1Al9tT1zeoPFTAeO08HaADnI95bHVYFZ7w5Q=;
        h=Date:To:From:Subject:From;
        b=yNP51VT7viRcjSyJbzA0AGU3Aq1LSTYhtqjCLYrC5FPu2RUIRUXBf6wrCJwB5ty+h
         pHAkCl6vKUGkjGTnCr49YRoIGmncA0/OGMcL0LoLSwoEkzcyhTVqDN8ZkYcEBsT66D
         daPCWttYcCKx7Ovn7I8oZLApaRnWgx3CJjQO7VAw=
Date:   Mon, 09 May 2022 21:11:51 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-clarify-protection_map-indices.patch removed from -mm tree
Message-Id: <20220510041152.89D1CC385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: clarify protection_map[] indices
has been removed from the -mm tree.  Its filename was
     mm-mmap-clarify-protection_map-indices.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/mmap: clarify protection_map[] indices

protection_map[] maps vm_flags access combinations into page protection
value as defined by the platform via __PXXX and __SXXX macros.  The array
indices in protection_map[], represents vm_flags access combinations but
it's not very intuitive to derive.  This makes it clear and explicit.

Link: https://lkml.kernel.org/r/20220404031840.588321-3-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-mmap-clarify-protection_map-indices
+++ a/mm/mmap.c
@@ -102,8 +102,22 @@ static void unmap_region(struct mm_struc
  *								x: (yes) yes
  */
 pgprot_t protection_map[16] __ro_after_init = {
-	__P000, __P001, __P010, __P011, __P100, __P101, __P110, __P111,
-	__S000, __S001, __S010, __S011, __S100, __S101, __S110, __S111
+	[VM_NONE]					= __P000,
+	[VM_READ]					= __P001,
+	[VM_WRITE]					= __P010,
+	[VM_WRITE | VM_READ]				= __P011,
+	[VM_EXEC]					= __P100,
+	[VM_EXEC | VM_READ]				= __P101,
+	[VM_EXEC | VM_WRITE]				= __P110,
+	[VM_EXEC | VM_WRITE | VM_READ]			= __P111,
+	[VM_SHARED]					= __S000,
+	[VM_SHARED | VM_READ]				= __S001,
+	[VM_SHARED | VM_WRITE]				= __S010,
+	[VM_SHARED | VM_WRITE | VM_READ]		= __S011,
+	[VM_SHARED | VM_EXEC]				= __S100,
+	[VM_SHARED | VM_EXEC | VM_READ]			= __S101,
+	[VM_SHARED | VM_EXEC | VM_WRITE]		= __S110,
+	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= __S111
 };
 
 #ifndef CONFIG_ARCH_HAS_FILTER_PGPROT
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


