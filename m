From: akpm@linux-foundation.org
Subject: +
 net-netfilter-ipset-ip_set_hash_netnetc-fix-build-with-older-gcc.patch
 added to -mm tree
Date: Tue, 29 Oct 2013 15:40:23 -0700
Message-ID: <52703957.JfZeiBWomg8cpVk9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39584 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab3J2WkY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Oct 2013 18:40:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa, kadlec@blackhole.kfki.hu, akpm@linux-foundation.org

Subject: + net-netfilter-ipset-ip_set_hash_netnetc-fix-build-with-older-gcc.patch added to -mm tree
To: akpm@linux-foundation.org,kadlec@blackhole.kfki.hu,oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa
From: akpm@linux-foundation.org
Date: Tue, 29 Oct 2013 15:40:23 -0700


The patch titled
     Subject: net/netfilter/ipset/ip_set_hash_netnet.c: fix build with older gcc
has been added to the -mm tree.  Its filename is
     net-netfilter-ipset-ip_set_hash_netnetc-fix-build-with-older-gcc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-netfilter-ipset-ip_set_hash_netnetc-fix-build-with-older-gcc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-netfilter-ipset-ip_set_hash_netnetc-fix-build-with-older-gcc.patch

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
Subject: net/netfilter/ipset/ip_set_hash_netnet.c: fix build with older gcc

net/netfilter/ipset/ip_set_hash_netnet.c: In function 'hash_netnet4_kadt':
net/netfilter/ipset/ip_set_hash_netnet.c:141: error: unknown field 'cidr' specified in initializer
net/netfilter/ipset/ip_set_hash_netnet.c:141: warning: missing braces around initializer
net/netfilter/ipset/ip_set_hash_netnet.c:141: warning: (near initialization for 'e.<anonymous>')

etc.

gcc-4.4.4 doesn't like that anonymous union initializer and I couldnt'
find a way of tricking it into doing the right thing, so open-code it.

Cc: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/ipset/ip_set_hash_netnet.c |   28 ++++++++++++---------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff -puN net/netfilter/ipset/ip_set_hash_netnet.c~net-netfilter-ipset-ip_set_hash_netnetc-fix-build-with-older-gcc net/netfilter/ipset/ip_set_hash_netnet.c
--- a/net/netfilter/ipset/ip_set_hash_netnet.c~net-netfilter-ipset-ip_set_hash_netnetc-fix-build-with-older-gcc
+++ a/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -137,12 +137,12 @@ hash_netnet4_kadt(struct ip_set *set, co
 {
 	const struct hash_netnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_netnet4_elem e = {
-		.cidr[0] = h->nets[0].cidr[0] ? h->nets[0].cidr[0] : HOST_MASK,
-		.cidr[1] = h->nets[0].cidr[1] ? h->nets[0].cidr[1] : HOST_MASK,
-	};
+	struct hash_netnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
+	e.cidr[0] = h->nets[0].cidr[0] ? h->nets[0].cidr[0] : HOST_MASK;
+	e.cidr[1] = h->nets[0].cidr[1] ? h->nets[0].cidr[1] : HOST_MASK;
+
 	if (adt == IPSET_TEST)
 		e.ccmp = (HOST_MASK << (sizeof(e.cidr[0]) * 8)) | HOST_MASK;
 
@@ -160,13 +160,15 @@ hash_netnet4_uadt(struct ip_set *set, st
 {
 	const struct hash_netnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_netnet4_elem e = { .cidr[0] = HOST_MASK,
-				       .cidr[1] = HOST_MASK };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0, last;
 	u32 ip2 = 0, ip2_from = 0, ip2_to = 0, last2;
 	u8 cidr, cidr2;
 	int ret;
+	struct hash_netnet4_elem e = { };
+
+	e.cidr[0] = HOST_MASK;
+	e.cidr[1] = HOST_MASK;
 
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
@@ -364,12 +366,12 @@ hash_netnet6_kadt(struct ip_set *set, co
 {
 	const struct hash_netnet *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_netnet6_elem e = {
-		.cidr[0] = h->nets[0].cidr[0] ? h->nets[0].cidr[0] : HOST_MASK,
-		.cidr[1] = h->nets[0].cidr[1] ? h->nets[0].cidr[1] : HOST_MASK
-	};
+	struct hash_netnet6_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
+	e.cidr[0] = h->nets[0].cidr[0] ? h->nets[0].cidr[0] : HOST_MASK;
+	e.cidr[1] = h->nets[0].cidr[1] ? h->nets[0].cidr[1] : HOST_MASK;
+
 	if (adt == IPSET_TEST)
 		e.ccmp = (HOST_MASK << (sizeof(u8)*8)) | HOST_MASK;
 
@@ -386,11 +388,13 @@ hash_netnet6_uadt(struct ip_set *set, st
 	       enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
 	ipset_adtfn adtfn = set->variant->adt[adt];
-	struct hash_netnet6_elem e = { .cidr[0] = HOST_MASK,
-				       .cidr[1] = HOST_MASK };
+	struct hash_netnet6_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	int ret;
 
+	e.cidr[0] = HOST_MASK;
+	e.cidr[1] = HOST_MASK;
+
 	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS) ||
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-add-a-field-to-store-names-for-private-anonymous-memory-fix.patch
mm-add-a-field-to-store-names-for-private-anonymous-memory-fix-fix-2.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up-next-fix.patch
net-netfilter-ipset-ip_set_hash_netnetc-fix-build-with-older-gcc.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
seq_file-remove-%n-usage-from-seq_file-users-fix.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

