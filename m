From: akpm@linux-foundation.org
Subject: [folded-merged] hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:49:32 -0800
Message-ID: <20130228004932.CD6BB31C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:38105 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab3B1Ate (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:49:34 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so139667vea.0
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:49:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch

This patch was dropped because it was folded into hlist-drop-the-node-parameter-from-iterators.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix

drop bogus hunk from net/ipv6/raw.c

Cc: Sasha Levin <sasha.levin@oracle.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv6/raw.c |   18 ------------------
 1 file changed, 18 deletions(-)

diff -puN net/ipv6/raw.c~hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix net/ipv6/raw.c
--- a/net/ipv6/raw.c~hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix
+++ a/net/ipv6/raw.c
@@ -97,24 +97,6 @@ static struct sock *__raw_v6_lookup(stru
 			}
 			goto found;
 		}
-		sk_for_each_from (sk)
-			if (inet_sk(sk)->inet_num == num) {
-				struct ipv6_pinfo *np=inet6_sk(sk);
-				if (!net_eq(sock_net(sk), net))
-					continue;
-					if (!ipv6_addr_any(&np->daddr) && !ipv6_addr_equal(&np->daddr, rmt_addr))
-						continue;
-						if (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif)
-							continue;
-							if (!ipv6_addr_any(&np->rcv_saddr)) {
-								if (ipv6_addr_equal(&np->rcv_saddr, loc_addr))
-									goto found;
-									if (is_multicast && inet6_mc_check(sk, loc_addr, rmt_addr))
-										goto found;
-										continue;
-									}
-									goto found;
-								}
 	sk = NULL;
 found:
 	return sk;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
backlight-add-new-lp8788-backlight-driver.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
fs-proc-clean-up-printks.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
idr-remove-length-restriction-from-idr_layer-bitmap.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc.patch
hlist-drop-the-node-parameter-from-iterators.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch

