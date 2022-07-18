Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE1FCCA485
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbiGRAcj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbiGRAcg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:32:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E7613CFC
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4554360FA7
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3F1C341CD;
        Mon, 18 Jul 2022 00:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104352;
        bh=fZiDcOBM11DEbSyaakMxXGMrMGBbc0gwCwcYCC8Vwws=;
        h=Date:To:From:Subject:From;
        b=V1yjGFJHPWGZjQYlGkN/j5efdablsmpPKozqQtphNZVujkdj4x72zdXeASCMob+VQ
         nJGc3pDGl4W8wtwzRi7/y3x1sqiI3Y2uwRqFftZIAmnSj3fPEBJ7BAQthVH0XP9SPH
         Xw7QmVgx+/D9bdWQKjBS+FUnubXhtqCPLUuBNNyc=
Date:   Sun, 17 Jul 2022 17:32:32 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, vgoyal@redhat.com,
        swboyd@chromium.org, samitolvanen@google.com,
        ndesaulniers@google.com, keescook@chromium.org, jolsa@kernel.org,
        ebiederm@xmission.com, dyoung@redhat.com, cuibixuan@huawei.com,
        bhe@redhat.com, stephen.s.brennan@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] vmcoreinfo-include-kallsyms-symbols.patch removed from -mm tree
Message-Id: <20220718003232.9F3F1C341CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: vmcoreinfo: include kallsyms symbols
has been removed from the -mm tree.  Its filename was
     vmcoreinfo-include-kallsyms-symbols.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stephen Brennan <stephen.s.brennan@oracle.com>
Subject: vmcoreinfo: include kallsyms symbols
Date: Mon, 16 May 2022 17:05:08 -0700

The internal kallsyms tables contain information which could be quite
useful to a debugging tool in the absence of other debuginfo.  If kallsyms
is enabled, then a debugging tool could parse it and use it as a fallback
symbol table.  Combined with BTF data, live & post-mortem debuggers can
support basic operations without needing a large DWARF debuginfo file
available.  As many as five symbols are necessary to properly parse
kallsyms names and addresses.  Add these to the vmcoreinfo note.

CONFIG_KALLSYMS_ABSOLUTE_PERCPU does impact the computation of symbol
addresses.  However, a debugger can infer this configuration value by
comparing the address of _stext in the vmcoreinfo with the address
computed via kallsyms.  So there's no need to include information about
this config value in the vmcoreinfo note.

To verify that we're still well below the maximum of 4096 bytes, I created
a script[1] to compute a rough upper bound on the possible size of
vmcoreinfo.  On v5.18-rc7, the script reports 3106 bytes, and with this
patch, the maximum become 3370 bytes.

[1]: https://github.com/brenns10/kernel_stuff/blob/master/vmcoreinfosize/

Link: https://lkml.kernel.org/r/20220517000508.777145-3-stephen.s.brennan@oracle.com
Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Bixuan Cui <cuibixuan@huawei.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: David Vernet <void@manifault.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/kernel/crash_core.c~vmcoreinfo-include-kallsyms-symbols
+++ a/kernel/crash_core.c
@@ -15,6 +15,8 @@
 
 #include <crypto/sha1.h>
 
+#include "kallsyms_internal.h"
+
 /* vmcoreinfo stuff */
 unsigned char *vmcoreinfo_data;
 size_t vmcoreinfo_size;
@@ -480,6 +482,18 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_NUMBER(PAGE_OFFLINE_MAPCOUNT_VALUE);
 #endif
 
+#ifdef CONFIG_KALLSYMS
+	VMCOREINFO_SYMBOL(kallsyms_names);
+	VMCOREINFO_SYMBOL(kallsyms_token_table);
+	VMCOREINFO_SYMBOL(kallsyms_token_index);
+#ifdef CONFIG_KALLSYMS_BASE_RELATIVE
+	VMCOREINFO_SYMBOL(kallsyms_offsets);
+	VMCOREINFO_SYMBOL(kallsyms_relative_base);
+#else
+	VMCOREINFO_SYMBOL(kallsyms_addresses);
+#endif /* CONFIG_KALLSYMS_BASE_RELATIVE */
+#endif /* CONFIG_KALLSYMS */
+
 	arch_crash_save_vmcoreinfo();
 	update_vmcoreinfo_note();
 
_

Patches currently in -mm which might be from stephen.s.brennan@oracle.com are


