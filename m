From: akpm@linux-foundation.org
Subject: + sysctl-fix-unused-function-warning.patch added to -mm
 tree
Date: Tue, 05 May 2020 11:47:16 -0700
Message-ID: <20200505184716.RpMye3dZV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727857AbgEESrR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 May 2020 14:47:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriin@fb.com, arnd@arndb.de, ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com, keescook@chromium.org, kpsingh@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, songliubraving@fb.com, yhs@fb.com, yzaikin@google.com


The patch titled
     Subject: kernel/sysctl.c: fix unused function warning
has been added to the -mm tree.  Its filename is
     sysctl-fix-unused-function-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysctl-fix-unused-function-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysctl-fix-unused-function-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kernel/sysctl.c: fix unused function warning

The newly added bpf_stats_handler() has the wrong #ifdef check around it,
leading to an unused-function warning when CONFIG_SYSCTL is disabled:

kernel/sysctl.c:205:12: error: unused function 'bpf_stats_handler' [-Werror,-Wunused-function]
static int bpf_stats_handler(struct ctl_table *table, int write,

Fix the check to match the reference.

Link: http://lkml.kernel.org/r/20200505140734.503701-1-arnd@arndb.de
Fixes: d46edd671a14 ("bpf: Sharing bpf runtime stats with BPF_ENABLE_STATS")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Song Liu <songliubraving@fb.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sysctl.c~sysctl-fix-unused-function-warning
+++ a/kernel/sysctl.c
@@ -201,7 +201,7 @@ static int max_extfrag_threshold = 1000;
 
 #endif /* CONFIG_SYSCTL */
 
-#ifdef CONFIG_BPF_SYSCALL
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_SYSCTL)
 static int bpf_stats_handler(struct ctl_table *table, int write,
 			     void __user *buffer, size_t *lenp,
 			     loff_t *ppos)
_

Patches currently in -mm which might be from arnd@arndb.de are

arm64-add-support-for-folded-p4d-page-tables-fix.patch
ubsan-fix-gcc-10-warnings.patch
initramfs-fix-another-section-mismatch.patch
sysctl-fix-unused-function-warning.patch
