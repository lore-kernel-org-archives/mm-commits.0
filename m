Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D2E2ECAAA2
	for <mm-commits@archiver.kernel.org>; Sun, 28 Aug 2022 21:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiH1VD2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Aug 2022 17:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiH1VD0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 28 Aug 2022 17:03:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E493120A
        for <mm-commits@vger.kernel.org>; Sun, 28 Aug 2022 14:03:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A37660E17
        for <mm-commits@vger.kernel.org>; Sun, 28 Aug 2022 21:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF25C433C1;
        Sun, 28 Aug 2022 21:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661720604;
        bh=iUro94OKM24PMm/QxuPfatac6sTqGoScXbkgoe84dmA=;
        h=Date:To:From:Subject:From;
        b=hnMDBbCDFOznDYrpycOCwjMTQuiYnnsBA/3BbP4nxdK5GefxzhqOSx0osbm1QwBYO
         Td2SCX1owMAD6KEkM7wYMq1gkGy16DkwekrgdXz97QCaK4h8BMPWaOVLZm+cys+Ppy
         9A7bKQD79lXEMoQ5VDgm2ApGhPdq43W8taJRlci4=
Date:   Sun, 28 Aug 2022 14:03:24 -0700
To:     mm-commits@vger.kernel.org, vgoyal@redhat.com, dyoung@redhat.com,
        bhe@redhat.com, stephen.s.brennan@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmcoreinfo-add-kallsyms_num_syms-symbol.patch removed from -mm tree
Message-Id: <20220828210324.AFF25C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: vmcoreinfo: add kallsyms_num_syms symbol
has been removed from the -mm tree.  Its filename was
     vmcoreinfo-add-kallsyms_num_syms-symbol.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


