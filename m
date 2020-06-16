From: akpm@linux-foundation.org
Subject: [merged]
 fix-build-failure-of-ocfs2-when-tcp-ip-is-disabled.patch removed from -mm
 tree
Date: Tue, 16 Jun 2020 10:28:23 -0700
Message-ID: <20200616172823.7l79D3pOV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730790AbgFPR2Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Jun 2020 13:28:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, gechangwei@live.cn, ghe@suse.com, hch@lst.de, jgg@mellanox.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com, sagi@grimberg.me, tseewald@gmail.com


The patch titled
     Subject: ocfs2: fix build failure when TCP/IP is disabled
has been removed from the -mm tree.  Its filename was
     fix-build-failure-of-ocfs2-when-tcp-ip-is-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tom Seewald <tseewald@gmail.com>
Subject: ocfs2: fix build failure when TCP/IP is disabled

After commit 12abc5ee7873 ("tcp: add tcp_sock_set_nodelay") and commit
c488aeadcbd0 ("tcp: add tcp_sock_set_user_timeout"), building the kernel
with OCFS2_FS=y but without INET=y causes it to fail with:

ld: fs/ocfs2/cluster/tcp.o: in function `o2net_accept_many':
tcp.c:(.text+0x21b1): undefined reference to `tcp_sock_set_nodelay'
ld: tcp.c:(.text+0x21c1): undefined reference to `tcp_sock_set_user_timeout
'
ld: fs/ocfs2/cluster/tcp.o: in function `o2net_start_connect':
tcp.c:(.text+0x2633): undefined reference to `tcp_sock_set_nodelay'
ld: tcp.c:(.text+0x2643): undefined reference to `tcp_sock_set_user_timeout
'

This is due to tcp_sock_set_nodelay() and tcp_sock_set_user_timeout()
being declared in linux/tcp.h and defined in net/ipv4/tcp.c, which depend
on TCP/IP being enabled.

To fix this, make OCFS2_FS depend on INET=y which already requires NET=y.

Link: http://lkml.kernel.org/r/20200606190827.23954-1-tseewald@gmail.com
12abc5ee7873 ("tcp: add tcp_sock_set_nodelay") and commit
Signed-off-by: Tom Seewald <tseewald@gmail.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/Kconfig~fix-build-failure-of-ocfs2-when-tcp-ip-is-disabled
+++ a/fs/ocfs2/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config OCFS2_FS
 	tristate "OCFS2 file system support"
-	depends on NET && SYSFS && CONFIGFS_FS
+	depends on INET && SYSFS && CONFIGFS_FS
 	select JBD2
 	select CRC32
 	select QUOTA
_

Patches currently in -mm which might be from tseewald@gmail.com are
