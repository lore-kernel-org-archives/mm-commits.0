From: akpm@linux-foundation.org
Subject: + console-limit-the-range-of-vgacon_soft_scrollback_size.patch added to -mm tree
Date: Mon, 04 Jan 2010 12:34:55 -0800
Message-ID: <201001042034.o04KYtq3016328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753417Ab0ADUfO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2010 15:35:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, buraphalinuxserver@gmail.com, davem@davemloft.net


The patch titled
     console: limit the range of VGACON_SOFT_SCROLLBACK_SIZE
has been added to the -mm tree.  Its filename is
     console-limit-the-range-of-vgacon_soft_scrollback_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
linux-next.patch
console-limit-the-range-of-vgacon_soft_scrollback_size.patch

