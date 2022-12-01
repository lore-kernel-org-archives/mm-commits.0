Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D256C47090
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiLAAR1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbiLAARB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:17:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FA899501
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:13:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2F9F61366
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E30C433C1;
        Thu,  1 Dec 2022 00:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669853634;
        bh=GGaeD4MH0pnjpxOArUObjGqtATVaXBCjw7bbFcJIodY=;
        h=Date:To:From:Subject:From;
        b=OheJw8eIgLeiim1j9UONmm3MbHglSAB+fNKUp+WDq8cOERtKh80Zk/HX4eibj2VrN
         i5KDITnyM9BvAPAtlCHcTbJrkYHxbFGwKlrOaTWqQuDtlOO1loYWM/SRIujFdD5a4c
         dFAISf3sFxoA/4q6EsapwFeGBLdQNxhlcboJ68uM=
Date:   Wed, 30 Nov 2022 16:13:53 -0800
To:     mm-commits@vger.kernel.org, vgoyal@redhat.com,
        keescook@chromium.org, dyoung@redhat.com, bhe@redhat.com,
        stephen.s.brennan@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] vmcoreinfo-warn-if-we-exceed-vmcoreinfo-data-size.patch removed from -mm tree
Message-Id: <20221201001353.E5E30C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: vmcoreinfo: warn if we exceed vmcoreinfo data size
has been removed from the -mm tree.  Its filename was
     vmcoreinfo-warn-if-we-exceed-vmcoreinfo-data-size.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stephen Brennan <stephen.s.brennan@oracle.com>
Subject: vmcoreinfo: warn if we exceed vmcoreinfo data size
Date: Thu, 27 Oct 2022 13:50:08 -0700

Though vmcoreinfo is intended to be small, at just one page, useful
information is still added to it, so we risk running out of space. 
Currently there is no runtime check to see whether the vmcoreinfo buffer
has been exhausted.  Add a warning for this case.

Currently, my static checking tool[1] indicates that a good upper bound
for vmcoreinfo size is currently 3415 bytes, but the best time to add
warnings is before the risk becomes too high.

[1] https://github.com/brenns10/kernel_stuff/blob/master/vmcoreinfosize/vmcoreinfosize.py

Link: https://lkml.kernel.org/r/20221027205008.312534-1-stephen.s.brennan@oracle.com
Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/crash_core.c~vmcoreinfo-warn-if-we-exceed-vmcoreinfo-data-size
+++ a/kernel/crash_core.c
@@ -383,6 +383,9 @@ void vmcoreinfo_append_str(const char *f
 	memcpy(&vmcoreinfo_data[vmcoreinfo_size], buf, r);
 
 	vmcoreinfo_size += r;
+
+	WARN_ONCE(vmcoreinfo_size == VMCOREINFO_BYTES,
+		  "vmcoreinfo data exceeds allocated size, truncating");
 }
 
 /*
_

Patches currently in -mm which might be from stephen.s.brennan@oracle.com are


