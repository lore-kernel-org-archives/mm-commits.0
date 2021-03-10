Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A355C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 10 Mar 2021 17:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA14664FC6
	for <mm-commits@archiver.kernel.org>; Wed, 10 Mar 2021 17:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhCJRGD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Mar 2021 12:06:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232970AbhCJRFr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Mar 2021 12:05:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40B1464FC3;
        Wed, 10 Mar 2021 17:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615395947;
        bh=Op5J/diw7ii/XvwOmFX8njwUsnYwc0tMHjsSnG41Og0=;
        h=Date:From:To:Subject:From;
        b=x0BqB7TZbmd/oYEoBBw3YjXIboAkv/DQ5fgCHNiu59WSIicUbRr7qIAkvjKLqacpN
         nSwq3pcQ7wl1MRAqmDPS7paiqnDh8essprZOIxuwx+0aNBTc4dMzlokBplH+D+RC1h
         X5Mh2x7YaL28YvoDDipgj67bQWif3xAyp+s4CXoQ=
Date:   Wed, 10 Mar 2021 09:05:46 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210310170546.Kwv4u4Ekk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/bpf.h |    4 ----
 net/ipv4/ip_vti.c        |    3 ---
 net/ipv6/ip6_vti.c       |    3 ---
 3 files changed, 10 deletions(-)

--- a/include/uapi/linux/bpf.h~linux-next-git-rejects
+++ a/include/uapi/linux/bpf.h
@@ -3850,11 +3850,7 @@ union bpf_attr {
  *
  * long bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)
  *	Description
-<<<<<<< HEAD
- *		Check ctx packet size against exceeding MTU of net device (based
-=======
  *		Check packet size against exceeding MTU of net device (based
->>>>>>> linux-next/akpm-base
  *		on *ifindex*).  This helper will likely be used in combination
  *		with helpers that adjust/change the packet size.
  *
--- a/net/ipv4/ip_vti.c~linux-next-git-rejects
+++ a/net/ipv4/ip_vti.c
@@ -238,11 +238,8 @@ static netdev_tx_t vti_xmit(struct sk_bu
 	if (skb->len > mtu) {
 		skb_dst_update_pmtu_no_confirm(skb, mtu);
 		if (skb->protocol == htons(ETH_P_IP)) {
-<<<<<<< HEAD
-=======
 			if (!(ip_hdr(skb)->frag_off & htons(IP_DF)))
 				goto xmit;
->>>>>>> linux-next/akpm-base
 			icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 				      htonl(mtu));
 		} else {
--- a/net/ipv6/ip6_vti.c~linux-next-git-rejects
+++ a/net/ipv6/ip6_vti.c
@@ -523,11 +523,8 @@ vti6_xmit(struct sk_buff *skb, struct ne
 
 			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 		} else {
-<<<<<<< HEAD
-=======
 			if (!(ip_hdr(skb)->frag_off & htons(IP_DF)))
 				goto xmit;
->>>>>>> linux-next/akpm-base
 			icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 				      htonl(mtu));
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

