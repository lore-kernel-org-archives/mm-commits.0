From: akpm@linux-foundation.org
Subject: + kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
 added to -mm tree
Date: Wed, 11 Jun 2014 15:41:35 -0700
Message-ID: <5398db1f.SvPTeKJ8ulWMHqpE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbaFKWlg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 18:41:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, eparis@redhat.com, fabf@skynet.be

Subject: + kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch added to -mm tree
To: fabf@skynet.be,eparis@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 15:41:35 -0700


The patch titled
     Subject: kernel/auditfilter.c: replace count*size kmalloc by kcalloc
has been added to the -mm tree.  Its filename is
     kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: kernel/auditfilter.c: replace count*size kmalloc by kcalloc

kcalloc manages count*sizeof overflow.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditfilter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/auditfilter.c~kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc kernel/auditfilter.c
--- a/kernel/auditfilter.c~kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc
+++ a/kernel/auditfilter.c
@@ -106,7 +106,7 @@ static inline struct audit_entry *audit_
 	if (unlikely(!entry))
 		return NULL;
 
-	fields = kzalloc(sizeof(*fields) * field_count, GFP_KERNEL);
+	fields = kcalloc(field_count, sizeof(*fields), GFP_KERNEL);
 	if (unlikely(!fields)) {
 		kfree(entry);
 		return NULL;
@@ -160,7 +160,7 @@ static __u32 *classes[AUDIT_SYSCALL_CLAS
 
 int __init audit_register_class(int class, unsigned *list)
 {
-	__u32 *p = kzalloc(AUDIT_BITMASK_SIZE * sizeof(__u32), GFP_KERNEL);
+	__u32 *p = kcalloc(AUDIT_BITMASK_SIZE, sizeof(__u32), GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
 	while (*list != ~0U) {
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-slabc-add-__init-to-init_lock_keys.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
fs-isofs-logging-clean-up.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch

