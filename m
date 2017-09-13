From: akpm@linux-foundation.org
Subject: [patch 6/9] IB/mlx4: fix sprintf format warning
Date: Wed, 13 Sep 2017 16:28:26 -0700
Message-ID: <59b9bf1a.YmQcIKeZpgX0veiA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56544 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdIMX21 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2017 19:28:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de, leonro@mellanox.com

From: Arnd Bergmann <arnd@arndb.de>
Subject: IB/mlx4: fix sprintf format warning

gcc-7 points out that a negative port_num value would overflow
the string buffer:

drivers/infiniband/hw/mlx4/sysfs.c: In function 'mlx4_ib_device_register_sysfs':
drivers/infiniband/hw/mlx4/sysfs.c:251:16: error: 'sprintf' may write a terminating nul past the end of the destination [-Werror=format-overflow=]
drivers/infiniband/hw/mlx4/sysfs.c:251:2: note: 'sprintf' output between 2 and 11 bytes into a destination of size 10
drivers/infiniband/hw/mlx4/sysfs.c:303:17: error: 'sprintf' may write a terminating nul past the end of the destination [-Werror=format-overflow=]
drivers/infiniband/hw/mlx4/sysfs.c:303:3: note: 'sprintf' output between 2 and 11 bytes into a destination of size 10

While we should be able to assume that port_num is positive here,
making the buffer one byte longer has no downsides and avoids the
warning.

Fixes: c1e7e466120b ("IB/mlx4: Add iov directory in sysfs under the ib device")
Link: http://lkml.kernel.org/r/20170714120720.906842-23-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/mlx4/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/infiniband/hw/mlx4/sysfs.c~ib-mlx4-fix-sprintf-format-warning drivers/infiniband/hw/mlx4/sysfs.c
--- a/drivers/infiniband/hw/mlx4/sysfs.c~ib-mlx4-fix-sprintf-format-warning
+++ a/drivers/infiniband/hw/mlx4/sysfs.c
@@ -221,7 +221,7 @@ void del_sysfs_port_mcg_attr(struct mlx4
 static int add_port_entries(struct mlx4_ib_dev *device, int port_num)
 {
 	int i;
-	char buff[10];
+	char buff[11];
 	struct mlx4_ib_iov_port *port = NULL;
 	int ret = 0 ;
 	struct ib_port_attr attr;
_
