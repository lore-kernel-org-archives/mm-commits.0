From: akpm@linux-foundation.org
Subject: + mm-introduce-helper-function-set_max_mapnr.patch added to -mm
 tree
Date: Fri, 31 May 2013 14:03:39 -0700
Message-ID: <51a9102b.xtUWt2GNaViqSucv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab3EaVDk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 17:03:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mchehab@redhat.com, jiang.liu@huawei.com, gregkh@linuxfoundation.org, davem@davemloft.net, broonie@opensource.wolfsonmicro.com, liuj97@gmail.com

Subject: + mm-introduce-helper-function-set_max_mapnr.patch added to -mm tree
To: liuj97@gmail.com,broonie@opensource.wolfsonmicro.com,davem@davemloft.net,gregkh@linuxfoundation.org,jiang.liu@huawei.com,mchehab@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 14:03:39 -0700


The patch titled
     Subject: mm: introduce helper function set_max_mapnr()
has been added to the -mm tree.  Its filename is
     mm-introduce-helper-function-set_max_mapnr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm: introduce helper function set_max_mapnr()

Introduce a helper function set_max_mapnr() to set global variable
max_mapnr.

Also unify condition compilation for max_mapnr with
CONFIG_NEED_MULTIPLE_NODES instead of CONFIG_DISCONTIGMEM.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN include/linux/mm.h~mm-introduce-helper-function-set_max_mapnr include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-helper-function-set_max_mapnr
+++ a/include/linux/mm.h
@@ -25,8 +25,15 @@ struct file_ra_state;
 struct user_struct;
 struct writeback_control;
 
-#ifndef CONFIG_DISCONTIGMEM          /* Don't use mapnrs, do it properly */
+#ifndef CONFIG_NEED_MULTIPLE_NODES	/* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;
+
+static inline void set_max_mapnr(unsigned long limit)
+{
+	max_mapnr = limit;
+}
+#else
+static inline void set_max_mapnr(unsigned long limit) { }
 #endif
 
 extern unsigned long totalram_pages;
_

Patches currently in -mm which might be from liuj97@gmail.com are

linux-next.patch
mm-change-signature-of-free_reserved_area-to-fix-building-warnings.patch
mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero.patch
mm-arm64-kill-poison_init_mem.patch
mm-x86-use-free_reserved_area-to-simplify-code.patch
mm-tile-use-common-help-functions-to-free-reserved-pages.patch
mm-fix-some-trivial-typos-in-comments.patch
mm-use-managed_pages-to-calculate-default-zonelist-order.patch
mm-accurately-calculate-zone-managed_pages-for-highmem-zones.patch
mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages.patch
mm-make-__free_pages_bootmem-only-available-at-boot-time.patch
mm-correctly-update-zone-managed_pages.patch
mm-correctly-update-zone-managed_pages-fix.patch
mm-concentrate-modification-of-totalram_pages-into-the-mm-core.patch
mm-report-available-pages-as-memtotal-for-each-numa-node.patch
vmlinuxlds-add-comments-for-global-variables-and-clean-up-useless-declarations.patch
avr32-normalize-global-variables-exported-by-vmlinuxlds.patch
c6x-normalize-global-variables-exported-by-vmlinuxlds.patch
h8300-normalize-global-variables-exported-by-vmlinuxlds.patch
score-normalize-global-variables-exported-by-vmlinuxlds.patch
tile-normalize-global-variables-exported-by-vmlinuxlds.patch
uml-normalize-global-variables-exported-by-vmlinuxlds.patch
mm-introduce-helper-function-mem_init_print_info-to-simplify-mem_init.patch
mm-use-totalram_pages-instead-of-num_physpages-at-runtime.patch
mm-hotplug-prepare-for-removing-num_physpages.patch
mm-alpha-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-arc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-arm-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-arm64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-avr32-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-blackfin-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-c6x-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-cris-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-frv-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-h8300-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-hexagon-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-ia64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-m32r-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-m68k-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-metag-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-microblaze-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-mips-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-mn10300-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-openrisc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-parisc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-ppc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-s390-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-score-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-sh-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-sparc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-tile-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-um-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-unicore32-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-x86-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-xtensa-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-kill-global-variable-num_physpages.patch
mm-introduce-helper-function-set_max_mapnr.patch
mm-avr32-prepare-for-killing-free_all_bootmem_node.patch
mm-ia64-prepare-for-killing-free_all_bootmem_node.patch
mm-m32r-prepare-for-killing-free_all_bootmem_node.patch
mm-m68k-prepare-for-killing-free_all_bootmem_node.patch
mm-metag-prepare-for-killing-free_all_bootmem_node.patch
mm-mips-prepare-for-killing-free_all_bootmem_node.patch
mm-parisc-prepare-for-killing-free_all_bootmem_node.patch
mm-ppc-prepare-for-killing-free_all_bootmem_node.patch
mm-sh-prepare-for-killing-free_all_bootmem_node.patch
mm-kill-free_all_bootmem_node.patch
mm-alpha-unify-mem_init-for-both-uma-and-numa-architectures.patch
mm-m68k-fix-build-warning-of-unused-variable.patch

