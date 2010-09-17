From: akpm@linux-foundation.org
Subject: + include-linux-netlinkh-move-struct-net-declaration-inside-the-__kernel__-macro-guard.patch added to -mm tree
Date: Fri, 17 Sep 2010 12:47:07 -0700
Message-ID: <201009171947.o8HJl7k7006701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835Ab0IQTrO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Sep 2010 15:47:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aaw@google.com


The patch titled
     include/linux/netlink.h: move "struct net" declaration inside the __KERNEL__ macro guard
has been added to the -mm tree.  Its filename is
     include-linux-netlinkh-move-struct-net-declaration-inside-the-__kernel__-macro-guard.patch

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
Subject: include/linux/netlink.h: move "struct net" declaration inside the __KERNEL__ macro guard
From: Ollie Wild <aaw@google.com>

Reduce namespace pollution by moving the "struct net" declaration out of
the userspace-facing portion of linux/netlink.h.  It has no impact on the
kernel, and the declaration is not referenced anywhere outside the
__KERNEL__ macro guard.

This came up because we have several C++ applications which use "net" as a
namespace name.

Signed-off-by: Ollie Wild <aaw@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/netlink.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/netlink.h~include-linux-netlinkh-move-struct-net-declaration-inside-the-__kernel__-macro-guard include/linux/netlink.h
--- a/include/linux/netlink.h~include-linux-netlinkh-move-struct-net-declaration-inside-the-__kernel__-macro-guard
+++ a/include/linux/netlink.h
@@ -27,8 +27,6 @@
 
 #define MAX_LINKS 32		
 
-struct net;
