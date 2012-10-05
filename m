From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-net.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:13:34 -0700
Message-ID: <20121005201335.0C6635C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:40398 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932799Ab2JEUNg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:13:36 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so57806wib.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:13:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in net
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-net.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -257,10 +257,12 @@ static inline struct net *read_pnet(stru
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
@@ -79,7 +79,7 @@ struct net *ip6addrlbl_net(const struct 
 
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

origin.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

