Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29283C00140
	for <mm-commits@archiver.kernel.org>; Mon,  8 Aug 2022 22:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236115AbiHHWGg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Aug 2022 18:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236734AbiHHWGf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Aug 2022 18:06:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43820E0E4
        for <mm-commits@vger.kernel.org>; Mon,  8 Aug 2022 15:06:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02833B80EEB
        for <mm-commits@vger.kernel.org>; Mon,  8 Aug 2022 22:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93AA8C433D7;
        Mon,  8 Aug 2022 22:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659996391;
        bh=kLpNmJDWFq57EdvNpM2oprLJwwD7oILUpp1QGNKYyYA=;
        h=Date:To:From:Subject:From;
        b=x1TMiRKYYysMPUJesuapZd70/F/eoLnp+9+8t3DE7wXxTUnHO91joLFK3gM0ixRG0
         yxuZrbRDLmy2qCfCC5h5HE0zMPKfKq2vfvWTBoahvhp887j/nazDxk0qyWSAU6j9So
         dsrbSY1ZcHgxxgNoYOQiqbfYjVbbRUXuclCCM/D0=
Date:   Mon, 08 Aug 2022 15:06:30 -0700
To:     mm-commits@vger.kernel.org, vgoyal@redhat.com, dyoung@redhat.com,
        bhe@redhat.com, stephen.s.brennan@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmcoreinfo-add-kallsyms_num_syms-symbol.patch added to mm-hotfixes-unstable branch
Message-Id: <20220808220631.93AA8C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmcoreinfo: add kallsyms_num_syms symbol
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     vmcoreinfo-add-kallsyms_num_syms-symbol.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmcoreinfo-add-kallsyms_num_syms-symbol.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Stephen Brennan <stephen.s.brennan@oracle.com>
Subject: vmcoreinfo: add kallsyms_num_syms symbol
Date: Mon, 8 Aug 2022 13:54:10 -0700

The rest of the kallsyms symbols are useless without knowing the number of
symbols in the table.  In an earlier patch, I somehow dropped the
kallsyms_num_syms symbol, so add it back in.

Link: https://lkml.kernel.org/r/20220808205410.18590-1-stephen.s.brennan@oracle.com
Fixes: 5fd8fea935a1 ("vmcoreinfo: include kallsyms symbols")
Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/crash_core.c~vmcoreinfo-add-kallsyms_num_syms-symbol
+++ a/kernel/crash_core.c
@@ -494,6 +494,7 @@ static int __init crash_save_vmcoreinfo_
 
 #ifdef CONFIG_KALLSYMS
 	VMCOREINFO_SYMBOL(kallsyms_names);
+	VMCOREINFO_SYMBOL(kallsyms_num_syms);
 	VMCOREINFO_SYMBOL(kallsyms_token_table);
 	VMCOREINFO_SYMBOL(kallsyms_token_index);
 #ifdef CONFIG_KALLSYMS_BASE_RELATIVE
_

Patches currently in -mm which might be from stephen.s.brennan@oracle.com are

vmcoreinfo-add-kallsyms_num_syms-symbol.patch

