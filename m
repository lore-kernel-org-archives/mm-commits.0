Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E76C8C54EAA
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 22:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbjAZWtH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 17:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbjAZWtE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 17:49:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2554CE7D
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 14:49:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB8FC6195E
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 22:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDCEC433D2;
        Thu, 26 Jan 2023 22:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674773343;
        bh=vpXxA88PH9py2WWEqBzKdQdoxUKj8a3YV+tXnjWs+kM=;
        h=Date:To:From:Subject:From;
        b=B/yfOyZa8jdKGDHB9HUFUvwsRb7/Vx4K4IL/gEMyFXBPF5NZdn+jmgMADyYn/ejJM
         Rz1s2WYuDI8Ea07hdJ56QUzgcUwTb5dfy57bC7KFPO+qF3+9shCk7KMBJd2RIF3Cbj
         zlvzH1CwqkgiajMK5xMiUfyDlWhZYgCo04huhoy0=
Date:   Thu, 26 Jan 2023 14:49:02 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, tony.luck@intel.com, tglx@linutronix.de,
        keescook@chromium.org, ira.weiny@intel.com, glider@google.com,
        dsterba@suse.com, deller@gmx.de, bigeasy@linutronix.de,
        bagasdotme@gmail.com, andreyknvl@gmail.com,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-highmem-align-down-to-page-the-address-for-kunmap_flush_on_unmap.patch removed from -mm tree
Message-Id: <20230126224903.0FDCEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/highmem: align-down to page the address for kunmap_flush_on_unmap()
has been removed from the -mm tree.  Its filename was
     mm-highmem-align-down-to-page-the-address-for-kunmap_flush_on_unmap.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: mm/highmem: align-down to page the address for kunmap_flush_on_unmap()
Date: Thu, 26 Jan 2023 15:33:46 +0100

If ARCH_HAS_FLUSH_ON_KUNMAP is defined (PA-RISC case), __kunmap_local()
calls kunmap_flush_on_unmap().  The latter currently flushes the wrong
address (as confirmed by Matthew Wilcox and Helge Deller).  Al Viro
proposed to call kunmap_flush_on_unmap() on an aligned-down to page
address in order to fix this issue.  Consensus has been reached on this
solution.

Therefore, if ARCH_HAS_FLUSH_ON_KUNMAP is defined, call
kunmap_flush_on_unmap() on an aligned-down to page address computed with
the PTR_ALIGN_DOWN() macro.

Link: https://lkml.kernel.org/r/20230126143346.12086-1-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Fixes: f3ba3c710ac5 ("mm/highmem: Provide kmap_local*")
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Helge Deller <deller@gmx.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: David Sterba <dsterba@suse.com>
Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem-internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/highmem-internal.h~mm-highmem-align-down-to-page-the-address-for-kunmap_flush_on_unmap
+++ a/include/linux/highmem-internal.h
@@ -200,7 +200,7 @@ static inline void *kmap_local_pfn(unsig
 static inline void __kunmap_local(const void *addr)
 {
 #ifdef ARCH_HAS_FLUSH_ON_KUNMAP
-	kunmap_flush_on_unmap(addr);
+	kunmap_flush_on_unmap(PTR_ALIGN_DOWN(addr, PAGE_SIZE));
 #endif
 }
 
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are

mm-highmem-add-notes-about-conversions-from-kmap_atomic.patch
mm-highmem-add-notes-about-conversions-from-kmap_atomic-v3.patch

