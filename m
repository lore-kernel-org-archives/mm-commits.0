From: akpm@linux-foundation.org
Subject: +
 mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch added to -mm tree
Date: Wed, 10 May 2017 15:16:44 -0700
Message-ID: <5913914c.3aXpFk63VRLEJEDz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40606 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753001AbdEJWQp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 May 2017 18:16:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, richard.weiyang@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix
has been added to the -mm tree.  Its filename is
     mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix

avoid strange 80-col tricks

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/slub.c~mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix mm/slub.c
--- a/mm/slub.c~mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix
+++ a/mm/slub.c
@@ -4982,8 +4982,9 @@ static ssize_t slabs_cpu_partial_show(st
 	int len;
 
 	for_each_online_cpu(cpu) {
-		struct page *page =
-			slub_percpu_partial(per_cpu_ptr(s->cpu_slab, cpu));
+		struct page *page;
+
+		page = slub_percpu_partial(per_cpu_ptr(s->cpu_slab, cpu));
 
 		if (page) {
 			pages += page->pages;
@@ -4995,8 +4996,9 @@ static ssize_t slabs_cpu_partial_show(st
 
 #ifdef CONFIG_SMP
 	for_each_online_cpu(cpu) {
-		struct page *page =
-			slub_percpu_partial(per_cpu_ptr(s->cpu_slab, cpu));
+		struct page *page;
+
+		page = slub_percpu_partial(per_cpu_ptr(s->cpu_slab, cpu));
 
 		if (page && len < PAGE_SIZE - 20)
 			len += sprintf(buf + len, " C%d=%d(%d)", cpu,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
gcov-support-gcc-71-v2-checkpatch-fixes.patch
mm-vmalloc-fix-vmalloc-users-tracking-properly-checkpatch-fixes.patch
tigran-has-moved.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

