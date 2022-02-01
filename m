Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29159C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 19:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiBATew (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 14:34:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42022 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiBATew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 14:34:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3420C61617
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 19:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63804C340EC;
        Tue,  1 Feb 2022 19:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643744091;
        bh=SYrTVBhR7xhSEV1kwAWJUGtNJ/YJ+xz0hhhjYaX/io8=;
        h=Date:To:From:Subject:From;
        b=V4iHbpFXlgD3TCA2Ct1AegHt8Fefujjl/w4zxE7/cwwQrhugqsDU0Kw+mmfH9IRrs
         DF4PR3mGmNJIdFGhRBVwph5KawzNYcylYIaQrAlL/JwGK3JITwkNTKdfDF6U0dAPqQ
         QgJeb2Kh77PdRz+hBRqaDw5by5lifGQmtlJY6mYg=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 11:34:49 -0800
Date:   Tue, 01 Feb 2022 11:34:49 -0800
To:     mm-commits@vger.kernel.org, mingo@kernel.org,
        kirill.shutemov@linux.intel.com, jforbes@redhat.com,
        aquini@redhat.com, longman@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch added to -mm tree
Message-Id: <20220201193450.63804C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparsemem: fix 'mem_section' will never be NULL gcc 12 warning
has been added to the -mm tree.  Its filename is
     mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/sparsemem: fix 'mem_section' will never be NULL gcc 12 warning

The gcc 12 compiler reports a warning on the following code:

    static inline struct mem_section *__nr_to_section(unsigned long nr)
    {
    #ifdef CONFIG_SPARSEMEM_EXTREME
        if (!mem_section)
                return NULL;
    #endif
       :

With CONFIG_SPARSEMEM_EXTREME on, the mem_section definition is

    extern struct mem_section **mem_section;

Obviously, mem_section cannot be NULL, but *mem_section can be if memory
hasn't been allocated for the dynamic mem_section[] array yet.  Fix this
warning by checking for "!*mem_section" instead.

Link: https://lkml.kernel.org/r/20220201192924.672675-1-longman@redhat.com
Fixes: 83e3c48729d9 ("mm/sparsemem: Allocate mem_section at runtime for CONFIG_SPARSEMEM_EXTREME=y")
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Justin Forbes <jforbes@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mmzone.h~mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning
+++ a/include/linux/mmzone.h
@@ -1390,7 +1390,7 @@ static inline unsigned long *section_to_
 static inline struct mem_section *__nr_to_section(unsigned long nr)
 {
 #ifdef CONFIG_SPARSEMEM_EXTREME
-	if (!mem_section)
+	if (!*mem_section)
 		return NULL;
 #endif
 	if (!mem_section[SECTION_NR_TO_ROOT(nr)])
_

Patches currently in -mm which might be from longman@redhat.com are

mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch
ipc-mqueue-use-get_tree_nodev-in-mqueue_get_tree.patch

