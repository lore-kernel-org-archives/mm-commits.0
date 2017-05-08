From: akpm@linux-foundation.org
Subject: [patch 071/114] s390: use set_memory.h header
Date: Mon, 08 May 2017 15:58:08 -0700
Message-ID: <20170508225808.qflhJruO3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47218 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbdEHW6J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:58:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, heiko.carstens@de.ibm.com, labbott@redhat.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Laura Abbott <labbott@redhat.com>
Subject: s390: use set_memory.h header

set_memory_* functions have moved to set_memory.h. Switch to this
explicitly

Link: http://lkml.kernel.org/r/1488920133-27229-5-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/ftrace.c        |    1 +
 arch/s390/kernel/kprobes.c       |    2 +-
 arch/s390/kernel/machine_kexec.c |    1 +
 arch/s390/mm/init.c              |    1 +
 arch/s390/mm/pageattr.c          |    1 +
 arch/s390/mm/vmem.c              |    1 +
 arch/s390/net/bpf_jit_comp.c     |    1 +
 7 files changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/s390/kernel/ftrace.c~s390-use-set_memoryh-header arch/s390/kernel/ftrace.c
--- a/arch/s390/kernel/ftrace.c~s390-use-set_memoryh-header
+++ a/arch/s390/kernel/ftrace.c
@@ -17,6 +17,7 @@
 #include <trace/syscall.h>
 #include <asm/asm-offsets.h>
 #include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 #include "entry.h"
 
 /*
diff -puN arch/s390/kernel/kprobes.c~s390-use-set_memoryh-header arch/s390/kernel/kprobes.c
--- a/arch/s390/kernel/kprobes.c~s390-use-set_memoryh-header
+++ a/arch/s390/kernel/kprobes.c
@@ -31,7 +31,7 @@
 #include <linux/slab.h>
 #include <linux/hardirq.h>
 #include <linux/ftrace.h>
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 #include <asm/sections.h>
 #include <linux/uaccess.h>
 #include <asm/dis.h>
diff -puN arch/s390/kernel/machine_kexec.c~s390-use-set_memoryh-header arch/s390/kernel/machine_kexec.c
--- a/arch/s390/kernel/machine_kexec.c~s390-use-set_memoryh-header
+++ a/arch/s390/kernel/machine_kexec.c
@@ -26,6 +26,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/cacheflush.h>
 #include <asm/os_info.h>
+#include <asm/set_memory.h>
 #include <asm/switch_to.h>
 #include <asm/nmi.h>
 
diff -puN arch/s390/mm/init.c~s390-use-set_memoryh-header arch/s390/mm/init.c
--- a/arch/s390/mm/init.c~s390-use-set_memoryh-header
+++ a/arch/s390/mm/init.c
@@ -39,6 +39,7 @@
 #include <asm/sections.h>
 #include <asm/ctl_reg.h>
 #include <asm/sclp.h>
+#include <asm/set_memory.h>
 
 pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
 
diff -puN arch/s390/mm/pageattr.c~s390-use-set_memoryh-header arch/s390/mm/pageattr.c
--- a/arch/s390/mm/pageattr.c~s390-use-set_memoryh-header
+++ a/arch/s390/mm/pageattr.c
@@ -8,6 +8,7 @@
 #include <asm/facility.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
+#include <asm/set_memory.h>
 
 static inline unsigned long sske_frame(unsigned long addr, unsigned char skey)
 {
diff -puN arch/s390/mm/vmem.c~s390-use-set_memoryh-header arch/s390/mm/vmem.c
--- a/arch/s390/mm/vmem.c~s390-use-set_memoryh-header
+++ a/arch/s390/mm/vmem.c
@@ -17,6 +17,7 @@
 #include <asm/setup.h>
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
+#include <asm/set_memory.h>
 
 static DEFINE_MUTEX(vmem_mutex);
 
diff -puN arch/s390/net/bpf_jit_comp.c~s390-use-set_memoryh-header arch/s390/net/bpf_jit_comp.c
--- a/arch/s390/net/bpf_jit_comp.c~s390-use-set_memoryh-header
+++ a/arch/s390/net/bpf_jit_comp.c
@@ -24,6 +24,7 @@
 #include <linux/bpf.h>
 #include <asm/cacheflush.h>
 #include <asm/dis.h>
+#include <asm/set_memory.h>
 #include "bpf_jit.h"
 
 int bpf_jit_enable __read_mostly;
_
