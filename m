From: akpm@linux-foundation.org
Subject: +
 fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch added
 to -mm tree
Date: Mon, 23 May 2016 16:43:13 -0700
Message-ID: <57439591.7PkkPnBjix45Q8/F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42584 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbcEWXnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:43:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/nfs/nfs4state.c: work around gcc-4.4 anon union initialization bug
has been added to the -mm tree.  Its filename is
     fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch

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
Subject: fs/nfs/nfs4state.c: work around gcc-4.4 anon union initialization bug

fs/nfs/nfs4state.c:69: error: unknown field 'data' specified in initializer
fs/nfs/nfs4state.c:69: warning: missing braces around initializer
fs/nfs/nfs4state.c:69: warning: (near initialization for 'zero_stateid.<anonymous>.data')

Old gcc is stupid but the fix is easy enough.

Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/nfs4state.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/nfs/nfs4state.c~fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug fs/nfs/nfs4state.c
--- a/fs/nfs/nfs4state.c~fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug
+++ a/fs/nfs/nfs4state.c
@@ -66,7 +66,9 @@
 #define OPENOWNER_POOL_SIZE	8
 
 const nfs4_stateid zero_stateid = {
-	.data = { 0 },
+	{
+		.data = { 0 },
+	},
 	.type = NFS4_SPECIAL_STATEID_TYPE,
 };
 static DEFINE_MUTEX(nfs_clid_init_mutex);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-oom_reaper-do-not-mmput-synchronously-from-the-oom-reaper-context-fix-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

