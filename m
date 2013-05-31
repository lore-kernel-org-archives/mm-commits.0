From: akpm@linux-foundation.org
Subject: + mm-use-totalram_pages-instead-of-num_physpages-at-runtime.patch added to -mm tree
Date: Fri, 31 May 2013 13:32:33 -0700
Message-ID: <51a908e1.0vDf+oELXL2bm5og%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab3EaUce (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 16:32:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yoshfuji@linux-ipv6.org, miklos@szeredi.hu, kuznet@ms2.inr.ac.ru, kaber@trash.net, jmorris@namei.org, jiang.liu@huawei.com, davem@davemloft.net, liuj97@gmail.com

Subject: + mm-use-totalram_pages-instead-of-num_physpages-at-runtime.patch added to -mm tree
To: liuj97@gmail.com,davem@davemloft.net,jiang.liu@huawei.com,jmorris@namei.org,kaber@trash.net,kuznet@ms2.inr.ac.ru,miklos@szeredi.hu,yoshfuji@linux-ipv6.org
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 13:32:33 -0700


The patch titled
     Subject: mm: use totalram_pages instead of num_physpages at runtime
has been added to the -mm tree.  Its filename is
     mm-use-totalram_pages-instead-of-num_physpages-at-runtime.patch

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
Subject: mm: use totalram_pages instead of num_physpages at runtime

The global variable num_physpages is scheduled to be removed, so use
totalram_pages instead of num_physpages at runtime.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/inode.c          |    2 +-
 kernel/power/snapshot.c  |    4 ++--
 net/ipv4/inet_fragment.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/fuse/inode.c~mm-use-totalram_pages-instead-of-num_physpages-at-runtime fs/fuse/inode.c
--- a/fs/fuse/inode.c~mm-use-totalram_pages-instead-of-num_physpages-at-runtime
+++ a/fs/fuse/inode.c
@@ -785,7 +785,7 @@ static const struct super_operations fus
 static void sanitize_global_limit(unsigned *limit)
 {
 	if (*limit == 0)
-		*limit = ((num_physpages << PAGE_SHIFT) >> 13) /
+		*limit = ((totalram_pages << PAGE_SHIFT) >> 13) /
 			 sizeof(struct fuse_req);
 
 	if (*limit >= 1 << 16)
diff -puN kernel/power/snapshot.c~mm-use-totalram_pages-instead-of-num_physpages-at-runtime kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~mm-use-totalram_pages-instead-of-num_physpages-at-runtime
+++ a/kernel/power/snapshot.c
@@ -1651,7 +1651,7 @@ unsigned long snapshot_get_image_size(vo
 static int init_header(struct swsusp_info *info)
 {
 	memset(info, 0, sizeof(struct swsusp_info));
-	info->num_physpages = num_physpages;
+	info->num_physpages = get_num_physpages();
 	info->image_pages = nr_copy_pages;
 	info->pages = snapshot_get_image_size();
 	info->size = info->pages;
@@ -1795,7 +1795,7 @@ static int check_header(struct swsusp_in
 	char *reason;
 
 	reason = check_image_kernel(info);
-	if (!reason && info->num_physpages != num_physpages)
+	if (!reason && info->num_physpages != get_num_physpages())
 		reason = "memory size";
 	if (reason) {
 		printk(KERN_ERR "PM: Image mismatch: %s\n", reason);
diff -puN net/ipv4/inet_fragment.c~mm-use-totalram_pages-instead-of-num_physpages-at-runtime net/ipv4/inet_fragment.c
--- a/net/ipv4/inet_fragment.c~mm-use-totalram_pages-instead-of-num_physpages-at-runtime
+++ a/net/ipv4/inet_fragment.c
@@ -93,7 +93,7 @@ void inet_frags_init(struct inet_frags *
 	}
 	rwlock_init(&f->lock);
 
-	f->rnd = (u32) ((num_physpages ^ (num_physpages>>7)) ^
+	f->rnd = (u32) ((totalram_pages ^ (totalram_pages >> 7)) ^
 				   (jiffies ^ (jiffies >> 6)));
 
 	setup_timer(&f->secret_timer, inet_frag_secret_rebuild,
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

