From: akpm@linux-foundation.org
Subject: [merged]
 kernel-smpc-on_each_cpu_cond-fix-warning-in-fallback-path.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:06:37 -0700
Message-ID: <53e3dc4d.tkltKsSN2gU/ZXyT%akpm__3774.82044646076$1407442020$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:44168 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbaHGUGi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:06:38 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so1177795pde.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:06:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, cl@gentwo.org, gilad@benyossef.com, htejun@gmail.com, iamjoonsoo.kim@lge.com, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/smp.c:on_each_cpu_cond(): fix warning in fallback path
has been removed from the -mm tree.  Its filename was
     kernel-smpc-on_each_cpu_cond-fix-warning-in-fallback-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: kernel/smp.c:on_each_cpu_cond(): fix warning in fallback path

The rarely-executed memry-allocation-failed callback path generates a
WARN_ON_ONCE() when smp_call_function_single() succeeds.  Presumably it's
supposed to warn on failures.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/smp.c~kernel-smpc-on_each_cpu_cond-fix-warning-in-fallback-path kernel/smp.c
--- a/kernel/smp.c~kernel-smpc-on_each_cpu_cond-fix-warning-in-fallback-path
+++ a/kernel/smp.c
@@ -670,7 +670,7 @@ void on_each_cpu_cond(bool (*cond_func)(
 			if (cond_func(cpu, info)) {
 				ret = smp_call_function_single(cpu, func,
 								info, wait);
-				WARN_ON_ONCE(!ret);
+				WARN_ON_ONCE(ret);
 			}
 		preempt_enable();
 	}
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

origin.patch
vmstat-on-demand-vmstat-workers-v8-fix-2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-cramfs-convert-printk-to-pr_foo.patch
fs-cramfs-use-pr_fmt.patch
fs-cramfs-code-clean-up.patch
fs-cramfs-inodec-use-linux-uaccessh.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

