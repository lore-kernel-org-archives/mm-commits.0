From: akpm@linux-foundation.org
Subject: [alternative-merged]
 net-netfilter-ipset-ip_set_hash_netportnetc-fix-build-with-older-gccs.patch removed from -mm tree
Date: Wed, 06 Nov 2013 12:29:19 -0800
Message-ID: <527aa69f.LvWYW93unYbKkVoD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab3KFU3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Nov 2013 15:29:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa, kadlec@blackhole.kfki.hu, akpm@linux-foundation.org

Subject: [alternative-merged] net-netfilter-ipset-ip_set_hash_netportnetc-fix-build-with-older-gccs.patch removed from -mm tree
To: akpm@linux-foundation.org,kadlec@blackhole.kfki.hu,oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 06 Nov 2013 12:29:19 -0800


The patch titled
     Subject: net/netfilter/ipset/ip_set_hash_netportnet.c: fix build with older gccs
has been removed from the -mm tree.  Its filename was
     net-netfilter-ipset-ip_set_hash_netportnetc-fix-build-with-older-gccs.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: net/netfilter/ipset/ip_set_hash_netportnet.c: fix build with older gccs

net/netfilter/ipset/ip_set_hash_netportnet.c: In function 'hash_netportnet4_kadt':
net/netfilter/ipset/ip_set_hash_netportnet.c:151: error: unknown field 'cidr' specified in initializer
net/netfilter/ipset/ip_set_hash_netportnet.c:151: warning: missing braces around initializer
net/netfilter/ipset/ip_set_hash_netportnet.c:151: warning: (near initialization for 'e.<anonymous>')

etc

gcc-4.4.4 doesn't like that anonymous union initializer and I couldnt'
find a way of tricking it into doing the right thing, so open-code it.

Cc: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/ipset/ip_set_hash_netportnet.c |   28 +++++++++--------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff -puN net/netfilter/ipset/ip_set_hash_netportnet.c~net-netfilter-ipset-ip_set_hash_netportnetc-fix-build-with-older-gccs net/netfilter/ipset/ip_set_hash_netportnet.c
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c~net-netfilter-ipset-ip_set_hash_netportnetc-fix-build-with-older-gccs
+++ a/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -147,12 +147,12 @@ hash_netportnet4_kadt(struct ip_set *set
 {
 	const struct hash_netportnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_netportnet4_elem e = {
-		.cidr[0] = IP_SET_INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
-		.cidr[1] = IP_SET_INIT_CIDR(h->nets[0].cidr[1], HOST_MASK),
-	};
+	struct hash_netportnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
+	e.cidr[0] = IP_SET_INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
+	e.cidr[1] = IP_SET_INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
+
 	if (adt == IPSET_TEST)
 		e.ccmp = (HOST_MASK << (sizeof(e.cidr[0]) * 8)) | HOST_MASK;
 
@@ -174,8 +174,7 @@ hash_netportnet4_uadt(struct ip_set *set
 {
 	const struct hash_netportnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_netportnet4_elem e = { .cidr[0] = HOST_MASK,
-					   .cidr[1] = HOST_MASK };
+	struct hash_netportnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0, ip_last, p = 0, port, port_to;
 	u32 ip2_from = 0, ip2_to = 0, ip2_last, ip2;
@@ -183,6 +182,9 @@ hash_netportnet4_uadt(struct ip_set *set
 	u8 cidr, cidr2;
 	int ret;
 
+	e.cidr[0] = HOST_MASK;
+	e.cidr[1] = HOST_MASK;
+
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO) ||
@@ -419,12 +421,12 @@ hash_netportnet6_kadt(struct ip_set *set
 {
 	const struct hash_netportnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_netportnet6_elem e = {
-		.cidr[0] = IP_SET_INIT_CIDR(h->nets[0].cidr[0], HOST_MASK),
-		.cidr[1] = IP_SET_INIT_CIDR(h->nets[0].cidr[1], HOST_MASK),
-	};
+	struct hash_netportnet6_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
+	e.cidr[0] = IP_SET_INIT_CIDR(h->nets[0].cidr[0], HOST_MASK);
+	e.cidr[1] = IP_SET_INIT_CIDR(h->nets[0].cidr[1], HOST_MASK);
+
 	if (adt == IPSET_TEST)
 		e.ccmp = (HOST_MASK << (sizeof(u8) * 8)) | HOST_MASK;
 
@@ -446,13 +448,15 @@ hash_netportnet6_uadt(struct ip_set *set
 {
 	const struct hash_netportnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_netportnet6_elem e = { .cidr[0] = HOST_MASK,
-					   .cidr[1] = HOST_MASK };
+	struct hash_netportnet6_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 port, port_to;
 	bool with_ports = false;
 	int ret;
 
+	e.cidr[0] = HOST_MASK;
+	e.cidr[1] = HOST_MASK;
+
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
 		     !ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_PORT_TO) ||
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-factor-commit-limit-calculation-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch
fs-hfs-btreeh-remove-duplicate-defines-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
ipc-msg-fix-message-length-check-for-negative-values-fix.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

