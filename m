Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19EB9C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 21:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344167AbhKXVj1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 16:39:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229920AbhKXVj1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 16:39:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5E3A61038;
        Wed, 24 Nov 2021 21:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637789777;
        bh=2E2paRbyKtMcuJUkXDq42fsRV8xc4+m6U/5eIEcZhYw=;
        h=Date:From:To:Subject:From;
        b=RYA+uwHH1sXRImNeNZUDPEW2yEiNiriB9RBUDThVpCwLQea/G3dScIE4E+/X5Jk1K
         dJVavZVSzjOAYKGX5eFQn+z6+8eIuICSyLA5E537Sc7UFvMKb9LR1+kPQgAxCcWhFK
         JG1n3NyQLMi853vGGdlST8jsXotKrDPKbzsyro98=
Date:   Wed, 24 Nov 2021 13:36:16 -0800
From:   akpm@linux-foundation.org
To:     agruenba@redhat.com, catalin.marinas@arm.com, dsterba@suse.com,
        josef@toxicpanda.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk, will@kernel.org, willy@infradead.org
Subject:  +
 =?US-ASCII?Q?btrfs-avoid-live-lock-in-search=5Fioctl-on-hardware-with-s?=
 =?US-ASCII?Q?ub-page-faults.patch?= added to -mm tree
Message-ID: <20211124213616.9Ei57fBx5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: btrfs: avoid live-lock in search_ioctl() on hardware with sub-page faults
has been added to the -mm tree.  Its filename is
     btrfs-avoid-live-lock-in-search_ioctl-on-hardware-with-sub-page-faults.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/btrfs-avoid-live-lock-in-search_ioctl-on-hardware-with-sub-page-faults.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/btrfs-avoid-live-lock-in-search_ioctl-on-hardware-with-sub-page-faults.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: btrfs: avoid live-lock in search_ioctl() on hardware with sub-page faults

Commit a48b73eca4ce ("btrfs: fix potential deadlock in the search ioctl")
addressed a lockdep warning by pre-faulting the user pages and attempting
the copy_to_user_nofault() in an infinite loop.  On architectures like
arm64 with MTE, an access may fault within a page at a location different
from what fault_in_writeable() probed.  Since the sk_offset is rewound to
the previous struct btrfs_ioctl_search_header boundary, there is no
guaranteed forward progress and search_ioctl() may live-lock.

Use fault_in_exact_writeable() instead which probes the entire user
buffer for faults at sub-page granularity.

Link: https://lkml.kernel.org/r/20211124192024.2408218-4-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ioctl.c~btrfs-avoid-live-lock-in-search_ioctl-on-hardware-with-sub-page-faults
+++ a/fs/btrfs/ioctl.c
@@ -2223,7 +2223,8 @@ static noinline int search_ioctl(struct
 
 	while (1) {
 		ret = -EFAULT;
-		if (fault_in_writeable(ubuf + sk_offset, *buf_size - sk_offset))
+		if (fault_in_exact_writeable(ubuf + sk_offset,
+					     *buf_size - sk_offset))
 			break;
 
 		ret = btrfs_search_forward(root, &key, path, sk->min_transid);
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

mm-introduce-fault_in_exact_writeable-to-probe-for-sub-page-faults.patch
arm64-add-support-for-sub-page-faults-user-probing.patch
btrfs-avoid-live-lock-in-search_ioctl-on-hardware-with-sub-page-faults.patch

