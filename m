Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BFAC433B4
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 01:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2185D616E8
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 01:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhEKBgH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 21:36:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229628AbhEKBgG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 21:36:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EDB361629;
        Tue, 11 May 2021 01:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620696901;
        bh=2Tcw3Y0skEcKPylN1NnfWtpCo2zx5X1qc9kcB7tSOuI=;
        h=Date:From:To:Subject:From;
        b=qVytmBk2SomqLH8bIiRoJf0RAHnQP+4IEfrEWxyDx4oIq2Y2bHdK7XNOPg7NkJBX/
         ThiqB9MCEeViGrUu3uzKjIHKVvZPNNdTyV0T7MNvhjz2ijQqap7vl5tPM+BupucMhw
         T271kKVzCUCZuRAJ/F9zeQmrbHyqSGQS0Lt0VPrU=
Date:   Mon, 10 May 2021 18:35:00 -0700
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
Subject:  +
 buildid-only-consider-gnu-notes-for-build-id-parsing.patch added to -mm
 tree
Message-ID: <20210511013500.hgtb63Gkz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buildid: only consider GNU notes for build ID parsing
has been added to the -mm tree.  Its filename is
     buildid-only-consider-gnu-notes-for-build-id-parsing.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/buildid-only-consider-gnu-notes-for-build-id-parsing.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/buildid-only-consider-gnu-notes-for-build-id-parsing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

buildid-only-consider-gnu-notes-for-build-id-parsing.patch
buildid-add-api-to-parse-build-id-out-of-buffer.patch
buildid-stash-away-kernels-build-id-on-init.patch
dump_stack-add-vmlinux-build-id-to-stack-traces.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces.patch
arm64-stacktrace-use-%psb-for-backtrace-printing.patch
x86-dumpstack-use-%psb-%pbb-for-backtrace-printing.patch
scripts-decode_stacktracesh-support-debuginfod.patch
scripts-decode_stacktracesh-silence-stderr-messages-from-addr2line-nm.patch
scripts-decode_stacktracesh-indicate-auto-can-be-used-for-base-path.patch
buildid-mark-some-arguments-const.patch
buildid-fix-kernel-doc-notation.patch
kdump-use-vmlinux_build_id-to-simplify.patch

