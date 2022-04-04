Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB347C3527D
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 21:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383085AbiDDVlW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380225AbiDDTRI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 15:17:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABE833E0A
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 12:15:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7341BB818F9
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 19:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9A8C2BBE4;
        Mon,  4 Apr 2022 19:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649099709;
        bh=LLcLStQnrdxfFpRitOlgZRakbbfizIwaRZkHpXFZwLQ=;
        h=Date:To:From:Subject:From;
        b=pqi0nvPWQezZjqXDBnsq6XMg4x24kkBfpRcK8obs6wQ2jdkHYfk59Syg1ocIukRjN
         DeZbZz/XTZn5B3dxZ83imY/74Trz+AkzDIhwAXX/WcD9K6Ll4ufAbiUmI5EHGGu60Q
         eoR9CJ8Pxvfgj+wPSBAojEOe5Md8Y+86jLKrKRwc=
Date:   Mon, 04 Apr 2022 12:15:08 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-clarify-protection_map-indices.patch added to -mm tree
Message-Id: <20220404191508.EF9A8C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: clarify protection_map[] indices
has been added to the -mm tree.  Its filename is
     mm-mmap-clarify-protection_map-indices.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-clarify-protection_map-indices.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-clarify-protection_map-indices.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-debug_vm_pgtable-drop-protection_map-usage.patch
mm-mmap-clarify-protection_map-indices.patch

