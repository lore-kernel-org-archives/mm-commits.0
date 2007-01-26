From: akpm@osdl.org
Subject: + typeof-__page_to_pfn-with-sparsemem=y.patch added to -mm tree
Date: Fri, 26 Jan 2007 12:35:09 -0800
Message-ID: <200701262035.l0QKZ9s3025813@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53820 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161234AbXAZUfN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 15:35:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     typeof __page_to_pfn with SPARSEMEM=y
has been added to the -mm tree.  Its filename is
     typeof-__page_to_pfn-with-sparsemem=y.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: typeof __page_to_pfn with SPARSEMEM=y
From: Randy Dunlap <randy.dunlap@oracle.com>

With CONFIG_SPARSEMEM=y:

mm/rmap.c:579: warning: format '%lx' expects type 'long unsigned int', but argument 2 has type 'int'

Make __page_to_pfn() return unsigned long.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-generic/memory_model.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/memory_model.h~typeof-__page_to_pfn-with-sparsemem=y include/asm-generic/memory_model.h
--- a/include/asm-generic/memory_model.h~typeof-__page_to_pfn-with-sparsemem=y
+++ a/include/asm-generic/memory_model.h
@@ -54,7 +54,7 @@
 #define __page_to_pfn(pg)					\
 ({	struct page *__pg = (pg);				\
 	int __sec = page_to_section(__pg);			\
-	__pg - __section_mem_map_addr(__nr_to_section(__sec));	\
+	(unsigned long)(__pg - __section_mem_map_addr(__nr_to_section(__sec)));	\
 })
 
 #define __pfn_to_page(pfn)				\
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

fix-various-kernel-doc-in-header-files.patch
git-alsa.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
dlm-gfs2-use-sysfs.patch
parisc-fix-module_param-iommu-permission.patch
git-scsi-misc.patch
math-emu-setcc-avoid-gcc-extension.patch
typeof-__page_to_pfn-with-sparsemem=y.patch
docbook-html-correction-of-recursive-a-tags-in-html-output.patch
kernel-doc-allow-a-little-whitespace.patch
sysrq-showblockedtasks-is-sysrq-w.patch
sysrq-alphabetize-command-keys-doc.patch
kernel-doc-allow-more-whitespace.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
docbook-add-edd-firmware-interfaces.patch
kernel-doc-fix-some-odd-spacing-issues.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
