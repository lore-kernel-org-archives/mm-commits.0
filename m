From: akpm@linux-foundation.org
Subject: + kernel-sysctl_binaryc-use-scnprintf-instead-of-snprintf.patch
 added to -mm tree
Date: Thu, 10 Oct 2013 15:50:45 -0700
Message-ID: <52572f45.If6i/QziJFG/Wepo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab3JJWuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Oct 2013 18:50:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gang.chen@asianux.com

Subject: + kernel-sysctl_binaryc-use-scnprintf-instead-of-snprintf.patch added to -mm tree
To: gang.chen@asianux.com
From: akpm@linux-foundation.org
Date: Thu, 10 Oct 2013 15:50:45 -0700


The patch titled
     Subject: kernel/sysctl_binary.c: use scnprintf() instead of snprintf()
has been added to the -mm tree.  Its filename is
     kernel-sysctl_binaryc-use-scnprintf-instead-of-snprintf.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-sysctl_binaryc-use-scnprintf-instead-of-snprintf.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-sysctl_binaryc-use-scnprintf-instead-of-snprintf.patch

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
Subject: kernel/sysctl_binary.c: use scnprintf() instead of snprintf()

snprintf() will return the 'ideal' length which may be larger than real
buffer length, if we only want to use real length, need use scnprintf()
instead of.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_binary.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/sysctl_binary.c~kernel-sysctl_binaryc-use-scnprintf-instead-of-snprintf kernel/sysctl_binary.c
--- a/kernel/sysctl_binary.c~kernel-sysctl_binaryc-use-scnprintf-instead-of-snprintf
+++ a/kernel/sysctl_binary.c
@@ -1024,7 +1024,7 @@ static ssize_t bin_intvec(struct file *f
 			if (get_user(value, vec + i))
 				goto out_kfree;
 
-			str += snprintf(str, end - str, "%lu\t", value);
+			str += scnprintf(str, end - str, "%lu\t", value);
 		}
 
 		result = kernel_write(file, buffer, str - buffer, 0);
@@ -1095,7 +1095,7 @@ static ssize_t bin_ulongvec(struct file
 			if (get_user(value, vec + i))
 				goto out_kfree;
 
-			str += snprintf(str, end - str, "%lu\t", value);
+			str += scnprintf(str, end - str, "%lu\t", value);
 		}
 
 		result = kernel_write(file, buffer, str - buffer, 0);
@@ -1205,7 +1205,7 @@ static ssize_t bin_dn_node_address(struc
 		if (get_user(dnaddr, (__le16 __user *)newval))
 			goto out;
 
-		len = snprintf(buf, sizeof(buf), "%hu.%hu",
+		len = scnprintf(buf, sizeof(buf), "%hu.%hu",
 				le16_to_cpu(dnaddr) >> 10,
 				le16_to_cpu(dnaddr) & 0x3ff);
 
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
kernel-sysctl_binaryc-use-scnprintf-instead-of-snprintf.patch
kernel-taskstatsc-add-nla_nest_cancel-for-failure-processing-between-nla_nest_start-and-nla_nest_end.patch
kernel-taskstatsc-return-enomem-when-alloc-memory-fails-in-add_del_listener.patch
kernel-panicc-reduce-1-byte-usage-for-print-tainted-buffer.patch
linux-next.patch

