From: akpm@linux-foundation.org
Subject: [patch 070/114] arm64: use set_memory.h header
Date: Mon, 08 May 2017 15:58:05 -0700
Message-ID: <20170508225805.pA879HBVN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47208 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751205AbdEHW6G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:58:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, catalin.marinas@arm.com, labbott@redhat.com, mark.rutland@arm.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Laura Abbott <labbott@redhat.com>
Subject: arm64: use set_memory.h header

The set_memory_* functions have moved to set_memory.h. Use that header
explicitly.

Link: http://lkml.kernel.org/r/1488920133-27229-4-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/pageattr.c      |    1 +
 arch/arm64/net/bpf_jit_comp.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/arm64/mm/pageattr.c~arm64-use-set_memoryh-header arch/arm64/mm/pageattr.c
--- a/arch/arm64/mm/pageattr.c~arm64-use-set_memoryh-header
+++ a/arch/arm64/mm/pageattr.c
@@ -17,6 +17,7 @@
 #include <linux/vmalloc.h>
 
 #include <asm/pgtable.h>
+#include <asm/set_memory.h>
 #include <asm/tlbflush.h>
 
 struct page_change_data {
diff -puN arch/arm64/net/bpf_jit_comp.c~arm64-use-set_memoryh-header arch/arm64/net/bpf_jit_comp.c
--- a/arch/arm64/net/bpf_jit_comp.c~arm64-use-set_memoryh-header
+++ a/arch/arm64/net/bpf_jit_comp.c
@@ -27,6 +27,7 @@
 #include <asm/byteorder.h>
 #include <asm/cacheflush.h>
 #include <asm/debug-monitors.h>
+#include <asm/set_memory.h>
 
 #include "bpf_jit.h"
 
_
