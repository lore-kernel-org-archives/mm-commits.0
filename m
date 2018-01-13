From: akpm@linux-foundation.org
Subject: +
 net-ipv6-routec-work-around-gcc-444-anon-union-initializer-issue.patch
 added to -mm tree
Date: Fri, 12 Jan 2018 16:18:03 -0800
Message-ID: <5a59503b.7ea+hCJMAycpgrrm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38678 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965312AbeAMASE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 Jan 2018 19:18:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, dsahern@gmail.com, idosch@mellanox.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net/ipv6/route.c: work around gcc-4.4.4 anon union initializer issue
has been added to the -mm tree.  Its filename is
     net-ipv6-routec-work-around-gcc-444-anon-union-initializer-issue.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-ipv6-routec-work-around-gcc-444-anon-union-initializer-issue.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-ipv6-routec-work-around-gcc-444-anon-union-initializer-issue.patch

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
Subject: net/ipv6/route.c: work around gcc-4.4.4 anon union initializer issue

gcc-4.4.4 has problems with initializers of anonymous union fields.

net/ipv6/route.c: In function 'rt6_sync_up':
net/ipv6/route.c:3586: error: unknown field 'nh_flags' specified in initializer
net/ipv6/route.c:3586: warning: missing braces around initializer
net/ipv6/route.c:3586: warning: (near initialization for 'arg.<anonymous>')
net/ipv6/route.c: In function 'rt6_sync_down_dev':
net/ipv6/route.c:3695: error: unknown field 'event' specified in initializer
net/ipv6/route.c:3695: warning: missing braces around initializer
net/ipv6/route.c:3695: warning: (near initialization for 'arg.<anonymous>')

Fixes: 2127d95aef6c ("ipv6: Clear nexthop flags upon netdev up")
Cc: Ido Schimmel <idosch@mellanox.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv6/route.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN net/ipv6/route.c~net-ipv6-routec-work-around-gcc-444-anon-union-initializer-issue net/ipv6/route.c
--- a/net/ipv6/route.c~net-ipv6-routec-work-around-gcc-444-anon-union-initializer-issue
+++ a/net/ipv6/route.c
@@ -3583,7 +3583,7 @@ void rt6_sync_up(struct net_device *dev,
 {
 	struct arg_netdev_event arg = {
 		.dev = dev,
-		.nh_flags = nh_flags,
+		{ .nh_flags = nh_flags, },
 	};
 
 	if (nh_flags & RTNH_F_DEAD && netif_carrier_ok(dev))
@@ -3692,7 +3692,7 @@ void rt6_sync_down_dev(struct net_device
 {
 	struct arg_netdev_event arg = {
 		.dev = dev,
-		.event = event,
+		{ .event = event, },
 	};
 
 	fib6_clean_all(dev_net(dev), fib6_ifdown, &arg);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
mm-fadvise-discard-partial-page-if-endbyte-is-also-eof-fix.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
net-ipv6-routec-work-around-gcc-444-anon-union-initializer-issue.patch

