Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53274C54EAA
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 20:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbjAZUkj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 15:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbjAZUki (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 15:40:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4496C7AB0
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 12:40:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D40E460B55
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 20:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBC1C433EF;
        Thu, 26 Jan 2023 20:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674765636;
        bh=XeZXqqN4qgXchvoQFD47gm1pSv8Vj4tB5k7cklZVGtw=;
        h=Date:To:From:Subject:From;
        b=LmVsa4jJvJ3Uu5WCxtsiXPdA4AvpZyO5eFKSHsTib0zIYNjSbsI5hgNr8pUMPqf3I
         or+3efaoD7GSzQiAKIAKQREWEKt0yQTWDgY957+JIyR6kLIsdmwaumXuExjaFVr59/
         xDmIEhljs4LwaZ1AOBYVuGGCVoeR4HwsAC9a4kQU=
Date:   Thu, 26 Jan 2023 12:40:35 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, tony.luck@intel.com, tglx@linutronix.de,
        keescook@chromium.org, ira.weiny@intel.com, glider@google.com,
        dsterba@suse.com, deller@gmx.de, bigeasy@linutronix.de,
        bagasdotme@gmail.com, andreyknvl@gmail.com,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-highmem-align-down-to-page-the-address-for-kunmap_flush_on_unmap.patch added to mm-unstable branch
Message-Id: <20230126204036.2DBC1C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem: align-down to page the address for kunmap_flush_on_unmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-highmem-align-down-to-page-the-address-for-kunmap_flush_on_unmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-highmem-align-down-to-page-the-address-for-kunmap_flush_on_unmap.patch

This patch will later appear in the mm-unstable branch at
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
mm-highmem-align-down-to-page-the-address-for-kunmap_flush_on_unmap.patch

