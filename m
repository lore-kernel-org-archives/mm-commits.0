From: akpm@linux-foundation.org
Subject: [merged] console-limit-the-range-of-vgacon_soft_scrollback_size.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:10:08 -0800
Message-ID: <201003091910.o29JA8ko031573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756038Ab0CITW1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, buraphalinuxserver@gmail.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     console: limit the range of VGACON_SOFT_SCROLLBACK_SIZE
has been removed from the -mm tree.  Its filename was
     console-limit-the-range-of-vgacon_soft_scrollback_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: console: limit the range of VGACON_SOFT_SCROLLBACK_SIZE
From: Amerigo Wang <amwang@redhat.com>

BuraphaLinux reported that we will trigger a mm warning when we
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=65536, this is because mm cann't
allocate so many pages.  We should limit the range of
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE, don't give a user any chance to
trigger that.

Reported-by: BuraphaLinux Server <buraphalinuxserver@gmail.com>
Tested-by: BuraphaLinux Server <buraphalinuxserver@gmail.com>
Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/console/Kconfig~console-limit-the-range-of-vgacon_soft_scrollback_size drivers/video/console/Kconfig
--- a/drivers/video/console/Kconfig~console-limit-the-range-of-vgacon_soft_scrollback_size
+++ a/drivers/video/console/Kconfig
@@ -37,6 +37,7 @@ config VGACON_SOFT_SCROLLBACK
 config VGACON_SOFT_SCROLLBACK_SIZE
        int "Scrollback Buffer Size (in KB)"
        depends on VGACON_SOFT_SCROLLBACK
+       range 1 1024
        default "64"
        help
          Enter the amount of System RAM to allocate for the scrollback
_

Patches currently in -mm which might be from amwang@redhat.com are

linux-next.patch
cpufreq-unexport-unlock_policy_rwsem-functions.patch
cpufreq-fix-a-lockdep-warning.patch
markup_oops-fix-perlcritic-warnings.patch
headerdep-perlcritic-warning.patch

