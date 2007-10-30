From: akpm@linux-foundation.org
Subject: + fix-drivers-net-wan-lmc-compilation.patch added to -mm tree
Date: Tue, 30 Oct 2007 16:07:27 -0700
Message-ID: <200710302307.l9UN7RKO032684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55635 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752534AbXJ3XHn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 19:07:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, davem@davemloft.net


The patch titled
     fix drivers/net/wan/lmc/ compilation
has been added to the -mm tree.  Its filename is
     fix-drivers-net-wan-lmc-compilation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix drivers/net/wan/lmc/ compilation
From: Adrian Bunk <bunk@kernel.org>

Documentation/SubmitChecklist, point 1:

/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/wan/lmc/lmc_main.c: In function `lmc_ioctl':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/wan/lmc/lmc_main.c:239: error: expected expression before `else'

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/lmc/lmc_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wan/lmc/lmc_main.c~fix-drivers-net-wan-lmc-compilation drivers/net/wan/lmc/lmc_main.c
--- a/drivers/net/wan/lmc/lmc_main.c~fix-drivers-net-wan-lmc-compilation
+++ a/drivers/net/wan/lmc/lmc_main.c
@@ -234,7 +234,7 @@ int lmc_ioctl (struct net_device *dev, s
         sc->lmc_xinfo.Magic1 = 0xDEADBEEF;
 
         if (copy_to_user(ifr->ifr_data, &sc->lmc_xinfo,
-					sizeof(struct lmc_xinfo))) {
+			 sizeof(struct lmc_xinfo)))
 		ret = -EFAULT;
 	else
 		ret = 0;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
fix-drivers-net-wan-lmc-compilation.patch
git-dvb.patch
git-hwmon.patch
git-ieee1394.patch
git-input.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-ocfs2.patch
git-sh64.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
kill-udffs_dateversion.patch
make-jbd-journalc__journal_abort_hard-static.patch
kernel-cgroupc-remove-dead-code.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
reiser4.patch
