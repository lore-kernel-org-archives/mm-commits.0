From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 3/5] ocfs2: fix build failure when TCP/IP is
 disabled
Date: Thu, 11 Jun 2020 17:34:51 -0700
Message-ID: <20200612003451.uX2bbelD9%akpm@linux-foundation.org>
References: <20200611173002.24352ae77ca6d6d7e65e4b2a@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbgFLAey (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Jun 2020 20:34:54 -0400
In-Reply-To: <20200611173002.24352ae77ca6d6d7e65e4b2a@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, gechangwei@live.cn, ghe@suse.com, hch@lst.de, jgg@mellanox.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com, sagi@grimberg.me, torvalds@linux-foundation.org, tseewald@gmail.com

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
