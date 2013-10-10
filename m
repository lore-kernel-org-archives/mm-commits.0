From: akpm@linux-foundation.org
Subject: +
 kernel-kexecc-use-vscnprintf-instead-of-vsnprintf-in-vmcoreinfo_append_str.patch added to -mm tree
Date: Thu, 10 Oct 2013 15:50:17 -0700
Message-ID: <52572f29.pnFEbSYQ5xV2YpFH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3JJWuS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Oct 2013 18:50:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gang.chen@asianux.com

Subject: + kernel-kexecc-use-vscnprintf-instead-of-vsnprintf-in-vmcoreinfo_append_str.patch added to -mm tree
To: gang.chen@asianux.com
From: akpm@linux-foundation.org
Date: Thu, 10 Oct 2013 15:50:17 -0700


The patch titled
     Subject: kernel/kexec.c: use vscnprintf() instead of vsnprintf() in vmcoreinfo_append_str()
has been added to the -mm tree.  Its filename is
     kernel-kexecc-use-vscnprintf-instead-of-vsnprintf-in-vmcoreinfo_append_str.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-kexecc-use-vscnprintf-instead-of-vsnprintf-in-vmcoreinfo_append_str.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-kexecc-use-vscnprintf-instead-of-vsnprintf-in-vmcoreinfo_append_str.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: kernel/kexec.c: use vscnprintf() instead of vsnprintf() in vmcoreinfo_append_str()

vsnprintf() may let 'r' larger than sizeof(buf), in this case, if 'r' is
also less than "vmcoreinfo_max_size - vmcoreinfo_size" (left size of
destination buffer), next memcpy() will read the unexpected addresses.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kexec.c~kernel-kexecc-use-vscnprintf-instead-of-vsnprintf-in-vmcoreinfo_append_str kernel/kexec.c
--- a/kernel/kexec.c~kernel-kexecc-use-vscnprintf-instead-of-vsnprintf-in-vmcoreinfo_append_str
+++ a/kernel/kexec.c
@@ -1533,7 +1533,7 @@ void vmcoreinfo_append_str(const char *f
 	size_t r;
 
 	va_start(args, fmt);
-	r = vsnprintf(buf, sizeof(buf), fmt, args);
+	r = vscnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 
 	r = min(r, vmcoreinfo_max_size - vmcoreinfo_size);
_

Patches currently in -mm which might be from gang.chen@asianux.com are

origin.patch
sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
mm-readaheadc-return-the-value-which-force_page_cache_readahead-returns.patch
mm-mempolicy-make-mpol_to_str-robust-and-always-succeed.patch
kernel-delayacctc-remove-redundant-checking-in-__delayacct_add_tsk.patch
kernel-kexecc-use-vscnprintf-instead-of-vsnprintf-in-vmcoreinfo_append_str.patch
kernel-sysctlc-check-return-value-after-call-proc_put_char-in-__do_proc_doulongvec_minmax.patch
kernel-taskstatsc-add-nla_nest_cancel-for-failure-processing-between-nla_nest_start-and-nla_nest_end.patch
kernel-taskstatsc-return-enomem-when-alloc-memory-fails-in-add_del_listener.patch
kernel-panicc-reduce-1-byte-usage-for-print-tainted-buffer.patch
linux-next.patch
kernel-sysctl_binaryc-use-scnprintf-instead-of-snprintf.patch

