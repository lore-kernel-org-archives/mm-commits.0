Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF35C07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3799613E8
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhGIVf4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:35:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhGIVfy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:35:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17DD8613D1;
        Fri,  9 Jul 2021 21:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866389;
        bh=XEJS0h19eMkAncGmc6CwkVY8CucOglmMGVvJdoywz6c=;
        h=Date:From:To:Subject:From;
        b=yAAkMbjQ1c+NXb/al1QQh1D6Us/TdfufzuduIkPdOQRwJDZ7Q85HnzxPsPS+lqkFW
         GkPamA3MdBbnVCvXmfxpQvdQJ5H+/PQ4Kv7vpMBYTKFSMf+63XxTp3Nb3//QO4guh7
         hGedztu+Q3Z8zQW4VdWuilT2DfPO+52ja5nGTq1g=
Date:   Fri, 09 Jul 2021 14:33:08 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, ast@kernel.org, bhe@redhat.com,
        bp@alien8.de, catalin.marinas@arm.com, dyoung@redhat.com,
        evgreen@chromium.org, hsinyi@chromium.org, jeyu@kernel.org,
        jolsa@kernel.org, khlebnikov@yandex-team.ru,
        linux@rasmusvillemoes.dk, mingo@redhat.com,
        mm-commits@vger.kernel.org, pmladek@suse.com, rostedt@goodmis.org,
        sashal@kernel.org, sergey.senozhatsky@gmail.com,
        swboyd@chromium.org, tglx@linutronix.de, vgoyal@redhat.com,
        will@kernel.org, willy@infradead.org
Subject:  [merged]
 buildid-only-consider-gnu-notes-for-build-id-parsing.patch removed from -mm
 tree
Message-ID: <20210709213308._qBeSLu1B%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buildid: only consider GNU notes for build ID parsing
has been removed from the -mm tree.  Its filename was
     buildid-only-consider-gnu-notes-for-build-id-parsing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Boyd <swboyd@chromium.org>
Subject: buildid: only consider GNU notes for build ID parsing

Patch series "Add build ID to stacktraces", v6.

This series adds the kernel's build ID[1] to the stacktrace header printed
in oops messages, warnings, etc.  and the build ID for any module that
appears in the stacktrace after the module name.  The goal is to make the
stacktrace more self-contained and descriptive by including the relevant
build IDs in the kernel logs when something goes wrong.  This can be used
by post processing tools like script/decode_stacktrace.sh and kernel
developers to easily locate the debug info associated with a kernel crash
and line up what line and file things started falling apart at.

To show how this can be used I've included a patch to decode_stacktrace.sh
that downloads the debuginfo from a debuginfod server.  This also includes
some patches to make the buildid.c file use more const arguments and
consolidate logic into buildid.c from kdump.  These are left to the end as
they were mostly cleanup patches.

Here's an example lkdtm stacktrace on arm64.

 WARNING: CPU: 4 PID: 3255 at drivers/misc/lkdtm/bugs.c:83 lkdtm_WARNING+0x28/0x30 [lkdtm]
 Modules linked in: lkdtm rfcomm algif_hash algif_skcipher af_alg xt_cgroup uinput xt_MASQUERADE
 CPU: 4 PID: 3255 Comm: bash Not tainted 5.11 #3 aa23f7a1231c229de205662d5a9e0d4c580f19a1
 Hardware name: Google Lazor (rev3+) with KB Backlight (DT)
 pstate: 00400009 (nzcv daif +PAN -UAO -TCO BTYPE=--)
 pc : lkdtm_WARNING+0x28/0x30 [lkdtm]
 lr : lkdtm_do_action+0x24/0x40 [lkdtm]
 sp : ffffffc0134fbca0
 x29: ffffffc0134fbca0 x28: ffffff92d53ba240
 x27: 0000000000000000 x26: 0000000000000000
 x25: 0000000000000000 x24: ffffffe3622352c0
 x23: 0000000000000020 x22: ffffffe362233366
 x21: ffffffe3622352e0 x20: ffffffc0134fbde0
 x19: 0000000000000008 x18: 0000000000000000
 x17: ffffff929b6536fc x16: 0000000000000000
 x15: 0000000000000000 x14: 0000000000000012
 x13: ffffffe380ed892c x12: ffffffe381d05068
 x11: 0000000000000000 x10: 0000000000000000
 x9 : 0000000000000001 x8 : ffffffe362237000
 x7 : aaaaaaaaaaaaaaaa x6 : 0000000000000000
 x5 : 0000000000000000 x4 : 0000000000000001
 x3 : 0000000000000008 x2 : ffffff93fef25a70
 x1 : ffffff93fef15788 x0 : ffffffe3622352e0
 Call trace:
  lkdtm_WARNING+0x28/0x30 [lkdtm ed5019fdf5e53be37cb1ba7899292d7e143b259e]
  direct_entry+0x16c/0x1b4 [lkdtm ed5019fdf5e53be37cb1ba7899292d7e143b259e]
  full_proxy_write+0x74/0xa4
  vfs_write+0xec/0x2e8
  ksys_write+0x84/0xf0
  __arm64_sys_write+0x24/0x30
  el0_svc_common+0xf4/0x1c0
  do_el0_svc_compat+0x28/0x3c
  el0_svc_compat+0x10/0x1c
  el0_sync_compat_handler+0xa8/0xcc
  el0_sync_compat+0x178/0x180
 ---[ end trace 3d95032303e59e68 ]---


This patch (of 13):

Some kernel elf files have various notes that also happen to have an elf
note type of '3', which matches NT_GNU_BUILD_ID but the note name isn't
"GNU".  For example, this note trips up the existing logic:

 Owner  Data size   Description
 Xen    0x00000008  Unknown note type: (0x00000003) description data: 00 00 00 ffffff80 ffffffff ffffffff ffffffff ffffffff

Let's make sure that it is a GNU note when parsing the build ID so that we
can use this function to parse a vmlinux's build ID too.

Link: https://lkml.kernel.org/r/20210511003845.2429846-1-swboyd@chromium.org
Link: https://lkml.kernel.org/r/20210511003845.2429846-2-swboyd@chromium.org
Fixes: bd7525dacd7e ("bpf: Move stack_map_get_build_id into lib")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reported-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Evan Green <evgreen@chromium.org>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/buildid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/buildid.c~buildid-only-consider-gnu-notes-for-build-id-parsing
+++ a/lib/buildid.c
@@ -31,6 +31,7 @@ static inline int parse_build_id(void *p
 
 		if (nhdr->n_type == BUILD_ID &&
 		    nhdr->n_namesz == sizeof("GNU") &&
+		    !strcmp((char *)(nhdr + 1), "GNU") &&
 		    nhdr->n_descsz > 0 &&
 		    nhdr->n_descsz <= BUILD_ID_SIZE_MAX) {
 			memcpy(build_id,
_

Patches currently in -mm which might be from swboyd@chromium.org are


