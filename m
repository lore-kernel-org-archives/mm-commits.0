From: akpm@linux-foundation.org
Subject: + sections-fix-section-conflicts-in-net.patch added to -mm tree
Date: Thu, 13 Sep 2012 16:37:54 -0700
Message-ID: <20120913233755.B23B15C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:60098 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759068Ab2IMXh5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 19:37:57 -0400
Received: by wgbdt11 with SMTP id dt11so220139wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 16:37:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, davem@davemloft.net


The patch titled
     Subject: sections: fix section conflicts in net
has been added to the -mm tree.  Its filename is
     sections-fix-section-conflicts-in-net.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in net

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/net_namespace.h |    2 ++
 net/decnet/dn_rules.c       |    2 +-
 net/ipv4/fib_rules.c        |    2 +-
 net/ipv4/ipmr.c             |    2 +-
 net/ipv6/addrlabel.c        |    2 +-
 net/ipv6/fib6_rules.c       |    2 +-
 net/ipv6/ip6mr.c            |    2 +-
 7 files changed, 8 insertions(+), 6 deletions(-)

diff -puN include/net/net_namespace.h~sections-fix-section-conflicts-in-net include/net/net_namespace.h
--- a/include/net/net_namespace.h~sections-fix-section-conflicts-in-net
+++ a/include/net/net_namespace.h
@@ -253,10 +253,12 @@ static inline struct net *read_pnet(stru
 #define __net_init
 #define __net_exit
 #define __net_initdata
+#define __net_initconst
 #else
 #define __net_init	__init
 #define __net_exit	__exit_refok
 #define __net_initdata	__initdata
+#define __net_initconst	__initconst
 #endif
 
 struct pernet_operations {
diff -puN net/decnet/dn_rules.c~sections-fix-section-conflicts-in-net net/decnet/dn_rules.c
--- a/net/decnet/dn_rules.c~sections-fix-section-conflicts-in-net
+++ a/net/decnet/dn_rules.c
@@ -220,7 +220,7 @@ static void dn_fib_rule_flush_cache(stru
 	dn_rt_cache_flush(-1);
 }
 
-static const struct fib_rules_ops __net_initdata dn_fib_rules_ops_template = {
+static const struct fib_rules_ops __net_initconst dn_fib_rules_ops_template = {
 	.family		= AF_DECnet,
 	.rule_size	= sizeof(struct dn_fib_rule),
 	.addr_size	= sizeof(u16),
diff -puN net/ipv4/fib_rules.c~sections-fix-section-conflicts-in-net net/ipv4/fib_rules.c
--- a/net/ipv4/fib_rules.c~sections-fix-section-conflicts-in-net
+++ a/net/ipv4/fib_rules.c
@@ -262,7 +262,7 @@ static void fib4_rule_flush_cache(struct
 	rt_cache_flush(ops->fro_net);
 }
 
-static const struct fib_rules_ops __net_initdata fib4_rules_ops_template = {
+static const struct fib_rules_ops __net_initconst fib4_rules_ops_template = {
 	.family		= AF_INET,
 	.rule_size	= sizeof(struct fib4_rule),
 	.addr_size	= sizeof(u32),
diff -puN net/ipv4/ipmr.c~sections-fix-section-conflicts-in-net net/ipv4/ipmr.c
--- a/net/ipv4/ipmr.c~sections-fix-section-conflicts-in-net
+++ a/net/ipv4/ipmr.c
@@ -221,7 +221,7 @@ static int ipmr_rule_fill(struct fib_rul
 	return 0;
 }
 
-static const struct fib_rules_ops __net_initdata ipmr_rules_ops_template = {
+static const struct fib_rules_ops __net_initconst ipmr_rules_ops_template = {
 	.family		= RTNL_FAMILY_IPMR,
 	.rule_size	= sizeof(struct ipmr_rule),
 	.addr_size	= sizeof(u32),
diff -puN net/ipv6/addrlabel.c~sections-fix-section-conflicts-in-net net/ipv6/addrlabel.c
--- a/net/ipv6/addrlabel.c~sections-fix-section-conflicts-in-net
+++ a/net/ipv6/addrlabel.c
@@ -75,7 +75,7 @@ struct net *ip6addrlbl_net(const struct 
 
 #define IPV6_ADDR_LABEL_DEFAULT	0xffffffffUL
 
-static const __net_initdata struct ip6addrlbl_init_table
+static const __net_initconst struct ip6addrlbl_init_table
 {
 	const struct in6_addr *prefix;
 	int prefixlen;
diff -puN net/ipv6/fib6_rules.c~sections-fix-section-conflicts-in-net net/ipv6/fib6_rules.c
--- a/net/ipv6/fib6_rules.c~sections-fix-section-conflicts-in-net
+++ a/net/ipv6/fib6_rules.c
@@ -238,7 +238,7 @@ static size_t fib6_rule_nlmsg_payload(st
 	       + nla_total_size(16); /* src */
 }
 
-static const struct fib_rules_ops __net_initdata fib6_rules_ops_template = {
+static const struct fib_rules_ops __net_initconst fib6_rules_ops_template = {
 	.family			= AF_INET6,
 	.rule_size		= sizeof(struct fib6_rule),
 	.addr_size		= sizeof(struct in6_addr),
diff -puN net/ipv6/ip6mr.c~sections-fix-section-conflicts-in-net net/ipv6/ip6mr.c
--- a/net/ipv6/ip6mr.c~sections-fix-section-conflicts-in-net
+++ a/net/ipv6/ip6mr.c
@@ -205,7 +205,7 @@ static int ip6mr_rule_fill(struct fib_ru
 	return 0;
 }
 
-static const struct fib_rules_ops __net_initdata ip6mr_rules_ops_template = {
+static const struct fib_rules_ops __net_initconst ip6mr_rules_ops_template = {
 	.family		= RTNL_FAMILY_IP6MR,
 	.rule_size	= sizeof(struct ip6mr_rule),
 	.addr_size	= sizeof(struct in6_addr),
_

Patches currently in -mm which might be from ak@linux.intel.com are

compilerh-add-__visible.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
sections-disable-const-sections-for-pa-risc-v2.patch
sections-fix-section-conflicts-in-arch-arm.patch
sections-fix-section-conflicts-in-arch-frv.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-arch-ia64.patch
sections-fix-section-conflicts-in-arch-mips.patch
sections-fix-section-conflicts-in-arch-powerpc.patch
sections-fix-section-conflicts-in-arch-score.patch
sections-fix-section-conflicts-in-arch-sh.patch
sections-fix-section-conflicts-in-arch-x86.patch
sections-fix-section-conflicts-in-drivers-atm.patch
sections-fix-section-conflicts-in-drivers-char.patch
sections-fix-section-conflicts-in-drivers-cpufreq.patch
sections-fix-section-conflicts-in-drivers-ide.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sections-fix-section-conflicts-in-drivers-mfd.patch
sections-fix-section-conflicts-in-drivers-mmc.patch
sections-fix-section-conflicts-in-drivers-net.patch
sections-fix-section-conflicts-in-drivers-net-hamradio.patch
sections-fix-section-conflicts-in-drivers-net-wan.patch
sections-fix-section-conflicts-in-drivers-platform-x86.patch
sections-fix-section-conflicts-in-drivers-scsi.patch
sections-fix-section-conflicts-in-drivers-video.patch
sections-fix-section-conflicts-in-mm-percpuc.patch
sections-fix-section-conflicts-in-net-can.patch
sections-fix-section-conflicts-in-net.patch
sections-fix-section-conflicts-in-sound.patch
sectons-fix-const-sections-for-crc32-table.patch
compat_ioctl-remove-unused-local-typedef.patch

