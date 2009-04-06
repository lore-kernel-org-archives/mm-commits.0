From: akpm@linux-foundation.org
Subject: [merged] documentation-fix-unix_dgram_qlen-description.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:34:00 -0700
Message-ID: <200904061934.n36JY0B8011352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757352AbZDFTgG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:36:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lixd@cn.fujitsu.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     documentation: fix unix_dgram_qlen description
has been removed from the -mm tree.  Its filename was
     documentation-fix-unix_dgram_qlen-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: documentation: fix unix_dgram_qlen description
From: Li Xiaodong <lixd@cn.fujitsu.com>

Previous description about system parameter in /proc/sys/net/unix/ is
wrong (or missed).  Simply add a new description about unix_dgram_qlen
according to latest kernel.

Signed-off-by: Li Xiaodong <lixd@cn.fujitsu.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/net.txt |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN Documentation/sysctl/net.txt~documentation-fix-unix_dgram_qlen-description Documentation/sysctl/net.txt
--- a/Documentation/sysctl/net.txt~documentation-fix-unix_dgram_qlen-description
+++ a/Documentation/sysctl/net.txt
@@ -93,8 +93,9 @@ of struct cmsghdr structures with append
 2. /proc/sys/net/unix - Parameters for Unix domain sockets
 -------------------------------------------------------
 
-There are  only  two  files  in this subdirectory. They control the delays for
-deleting and destroying socket descriptors.
+There is only one file in this directory.
+unix_dgram_qlen limits the max number of datagrams queued in Unix domain
+socket's buffer. It will not take effect unless PF_UNIX flag is spicified.
 
 
 3. /proc/sys/net/ipv4 - IPV4 settings
_

Patches currently in -mm which might be from lixd@cn.fujitsu.com are

origin.patch

