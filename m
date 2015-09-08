From: akpm@linux-foundation.org
Subject: [obsolete]
 net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch removed from
 -mm tree
Date: Tue, 08 Sep 2015 11:00:58 -0700
Message-ID: <55ef225a.6vFksAA5TBGp1xtv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbbIHSA7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:00:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kadlec@blackhole.kfki.hu, oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa, mm-commits@vger.kernel.org


The patch titled
     Subject: net/netfilter/ipset: work around gcc-4.4.4 initializer bug
has been removed from the -mm tree.  Its filename was
     net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: net/netfilter/ipset: work around gcc-4.4.4 initializer bug

gcc-4.4.4 (at least) isn't able to handle the mixture of anonymous unions
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
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages-fix.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
pagemap-update-documentation-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
mm-srcu-ify-shrinkers-fix-fix.patch
x86-use-generic-early-mem-copy-fix.patch
mm-mmap-simplify-the-failure-return-working-flow-fix.patch
zswap-dynamic-pool-creation-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
proc-add-kpageidle-file-fix-6-fix.patch
proc-add-kpageidle-file-fix-6-fix-2-fix.patch
proc-export-idle-flag-via-kpageflags-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix-fix.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix.patch
linux-next-rejects.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

