From: akpm@linux-foundation.org
Subject: [merged] nbd-update-documentation-and-link-to-mailinglist.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:17:05 -0800
Message-ID: <20130228201705.B35C231C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:60892 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3B1URG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:17:06 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so246738yhz.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:17:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w@uter.be, Paul.Clements@steeleye.com, pbonzini@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nbd: update documentation and link to mailinglist
has been removed from the -mm tree.  Its filename was
     nbd-update-documentation-and-link-to-mailinglist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wouter Verhelst <w@uter.be>
Subject: nbd: update documentation and link to mailinglist

Documentation/blockdev/nbd.txt contained some documentation which was
horribly outdated and probably still dates from the original patch that
added NBD support to the kernel.

This patch removes the useless and outdated bits.  The tools on nbd.sf.net
are fully documented in manpages, which is where documentation for the
non-kernel bits should live.

Additionally, add a reference to the MAINTAINERS file for the nbd-general
mailinglist that is used for discussion of the userland tools and the
kernel module already.

Signed-off-by: Wouter Verhelst <w@uter.be>
Cc: Paul Clements <Paul.Clements@steeleye.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/blockdev/nbd.txt |   38 +++----------------------------
 MAINTAINERS                    |    1 
 2 files changed, 5 insertions(+), 34 deletions(-)

diff -puN Documentation/blockdev/nbd.txt~nbd-update-documentation-and-link-to-mailinglist Documentation/blockdev/nbd.txt
--- a/Documentation/blockdev/nbd.txt~nbd-update-documentation-and-link-to-mailinglist
+++ a/Documentation/blockdev/nbd.txt
@@ -4,43 +4,13 @@
    can use a remote server as one of its block devices. So every time
    the client computer wants to read, e.g., /dev/nb0, it sends a
    request over TCP to the server, which will reply with the data read.
-   This can be used for stations with low disk space (or even diskless -
-   if you boot from floppy) to borrow disk space from another computer.
-   Unlike NFS, it is possible to put any filesystem on it, etc. It should
-   even be possible to use NBD as a root filesystem (I've never tried),
-   but it requires a user-level program to be in the initrd to start.
-   It also allows you to run block-device in user land (making server
-   and client physically the same computer, communicating using loopback).
-   
-   Current state: It currently works. Network block device is stable.
-   I originally thought that it was impossible to swap over TCP. It
-   turned out not to be true - swapping over TCP now works and seems
-   to be deadlock-free, but it requires heavy patches into Linux's
-   network layer.
-   
+   This can be used for stations with low disk space (or even diskless)
+   to borrow disk space from another computer.
+   Unlike NFS, it is possible to put any filesystem on it, etc.
+
    For more information, or to download the nbd-client and nbd-server
    tools, go to http://nbd.sf.net/.
 
-   Howto: To setup nbd, you can simply do the following:
-
-   First, serve a device or file from a remote server:
-
-   nbd-server <port-number> <device-or-file-to-serve-to-client>
-
-   e.g.,
-	root@server1 # nbd-server 1234 /dev/sdb1
-
-	(serves sdb1 partition on TCP port 1234)
-
-   Then, on the local (client) system:
-
-   nbd-client <server-name-or-IP> <server-port-number> /dev/nb[0-n]
-
-   e.g.,
-	root@client1 # nbd-client server1 1234 /dev/nb0
-
-	(creates the nb0 device on client1)
