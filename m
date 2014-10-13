From: akpm@linux-foundation.org
Subject: [merged]
 not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:18:28 -0700
Message-ID: <543c1774.8Ii8bYxR/+f8Gl8L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaJMSS2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:18:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, paul.gortmaker@windriver.com, qiuxishi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/kcore.c: don't add modules range to kcore if it's equal to vmcore range
has been removed from the -mm tree.  Its filename was
     not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: fs/proc/kcore.c: don't add modules range to kcore if it's equal to vmcore range

On some ARCHs modules range is eauql to vmalloc range. E.g on i686

	"#define MODULES_VADDR   VMALLOC_START"
	"#define MODULES_END     VMALLOC_END"

This will cause 2 duplicate program segments in /proc/kcore, and no flag
to indicate they are different.  This is confusing.  And usually people
who need check the elf header or read the content of kcore will check
memory ranges.  Two program segments which are the same are unnecessary.

So check if the modules range is equal to vmalloc range.  If so, just skip
adding the modules range.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/proc/kcore.c~not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range fs/proc/kcore.c
--- a/fs/proc/kcore.c~not-adding-modules-range-to-kcore-if-its-equal-to-vmcore-range
+++ a/fs/proc/kcore.c
@@ -610,8 +610,10 @@ static void __init proc_kcore_text_init(
 struct kcore_list kcore_modules;
 static void __init add_modules_range(void)
 {
-	kclist_add(&kcore_modules, (void *)MODULES_VADDR,
+	if (MODULES_VADDR != VMALLOC_START && MODULES_END != VMALLOC_END) {
+		kclist_add(&kcore_modules, (void *)MODULES_VADDR,
 			MODULES_END - MODULES_VADDR, KCORE_VMALLOC);
+	}
 }
 #else
 static void __init add_modules_range(void)
_

Patches currently in -mm which might be from bhe@redhat.com are

origin.patch
try-to-use-automatic-variable-in-kexec-purgatory-makefile.patch
take-the-segment-adding-out-of-locate_mem_hole-functions.patch
check-if-crashk_res_low-exists-when-exclude-it-from-crash-mem-ranges.patch
kexec-remove-the-unused-function-parameter.patch

