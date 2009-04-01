From: akpm@linux-foundation.org
Subject: + documentation-fix-unix_dgram_qlen-description.patch added to -mm tree
Date: Wed, 01 Apr 2009 14:30:48 -0700
Message-ID: <200904012130.n31LUmBv026018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754738AbZDAVcz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 17:32:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lixd@cn.fujitsu.com, davem@davemloft.net


The patch titled
     documentation: fix unix_dgram_qlen description
has been added to the -mm tree.  Its filename is
     documentation-fix-unix_dgram_qlen-description.patch

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

documentation-fix-unix_dgram_qlen-description.patch

