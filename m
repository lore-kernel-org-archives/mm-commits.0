From: akpm@linux-foundation.org
Subject: + net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
 added to -mm tree
Date: Wed, 17 Jun 2015 14:03:19 -0700
Message-ID: <5581e097.Q7QWbZ88YBK6t2od%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbbFQVDU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Jun 2015 17:03:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kadlec@blackhole.kfki.hu, oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa, mm-commits@vger.kernel.org


The patch titled
     Subject: net/netfilter/ipset: work around gcc-4.4.4 initializer bug
has been added to the -mm tree.  Its filename is
     net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch

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
Subject: net/netfilter/ipset: work around gcc-4.4.4 initializer bug

gcc-4.4.4 (at least) isn't able to handle the mixture on anonymous unions
and declaration-time intializers.  Work around this.

net/netfilter/ipset/ip_set_hash_netnet.c: In function 'hash_netnet4_uadt':
net/netfilter/ipset/ip_set_hash_netnet.c:163: error: unknown field 'cidr' specified in initializer
net/netfilter/ipset/ip_set_hash_netnet.c:163: warning: missing braces around initializer
net/netfilter/ipset/ip_set_hash_netnet.c:163: warning: (near initialization for 'e.<anonymous>.ip')
...

Fixes: ea53ac5b630e813ae ("netfilter: ipset: Add hash:net,net module to kernel.)
Cc: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/ipset/ip_set_hash_netnet.c     |   10 ++++++++--
 net/netfilter/ipset/ip_set_hash_netportnet.c |   10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff -puN net/netfilter/ipset/ip_set_hash_netnet.c~net-netfilter-ipset-work-around-gcc-444-initializer-bug net/netfilter/ipset/ip_set_hash_netnet.c
--- a/net/netfilter/ipset/ip_set_hash_netnet.c~net-netfilter-ipset-work-around-gcc-444-initializer-bug
+++ a/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -160,12 +160,15 @@ hash_netnet4_uadt(struct ip_set *set, st
 {
 	const struct hash_netnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_netnet4_elem e = { .cidr = { HOST_MASK, HOST_MASK, }, };
+	struct hash_netnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0, last;
 	u32 ip2 = 0, ip2_from = 0, ip2_to = 0, last2;
 	int ret;
 
+	e.cidr[0] = HOST_MASK;		/* gcc-4.4.4 has initializer issues */
+	e.cidr[1] = HOST_MASK;
+
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
@@ -385,10 +388,13 @@ hash_netnet6_uadt(struct ip_set *set, st
 		  enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_netnet6_elem e = { .cidr = { HOST_MASK, HOST_MASK, }, };
+	struct hash_netnet6_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	int ret;
 
+	e.cidr[0] = HOST_MASK;		/* gcc-4.4.4 has initializer issues */
+	e.cidr[1] = HOST_MASK;
+
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
diff -puN net/netfilter/ipset/ip_set_hash_netportnet.c~net-netfilter-ipset-work-around-gcc-444-initializer-bug net/netfilter/ipset/ip_set_hash_netportnet.c
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c~net-netfilter-ipset-work-around-gcc-444-initializer-bug
+++ a/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -175,13 +175,16 @@ hash_netportnet4_uadt(struct ip_set *set
 {
 	const struct hash_netportnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_netportnet4_elem e = { .cidr = { HOST_MASK, HOST_MASK, }, };
+	struct hash_netportnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0, ip_last, p = 0, port, port_to;
 	u32 ip2_from = 0, ip2_to = 0, ip2_last, ip2;
 	bool with_ports = false;
 	int ret;
 
+	e.cidr[0] = HOST_MASK;		/* gcc-4.4.4 has initializer issues */
+	e.cidr[1] = HOST_MASK;
+
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
@@ -445,12 +448,15 @@ hash_netportnet6_uadt(struct ip_set *set
 {
 	const struct hash_netportnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_netportnet6_elem e = { .cidr = { HOST_MASK, HOST_MASK, }, };
+	struct hash_netportnet6_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 port, port_to;
 	bool with_ports = false;
 	int ret;
 
+	e.cidr[0] = HOST_MASK;		/* gcc-4.4.4 has initializer issues */
+	e.cidr[1] = HOST_MASK;
+
 	if (tb[IPSET_ATTR_LINENO])
 		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
revert-cpumask-dont-perform-while-loop-in-cpumask_next_and.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
fs-userfaultfdc-work-around-i386-build-error.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zswap-runtime-enable-disable-fix.patch
prctl-more-prctlpr_set_mm_-checks-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog.patch
init-do_mounts-add-create_dev-failure-log-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
ipcshm-move-bug_on-check-into-shm_lock-fix.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
revert-x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
linux-next.patch
reapply-x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
linux-next-rejects.patch
drivers-block-nvme-corec-fix-build-with-gcc-444.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
mm-provide-new-get_vaddr_frames-helper-fix.patch
mm-move-get_vaddr_frames-behind-a-config-option.patch
mm-move-get_vaddr_frames-behind-a-config-option-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

