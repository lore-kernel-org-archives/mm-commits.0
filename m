From: akpm@linux-foundation.org
Subject: + ib-mlx4-fix-sprintf-format-warning.patch added to -mm tree
Date: Wed, 19 Jul 2017 14:50:38 -0700
Message-ID: <596fd42e.RjUOWnQAhdGgw+ua%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34150 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755129AbdGSVuj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 17:50:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, leonro@mellanox.com, mm-commits@vger.kernel.org


The patch titled
     Subject: IB/mlx4: fix sprintf format warning
has been added to the -mm tree.  Its filename is
     ib-mlx4-fix-sprintf-format-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ib-mlx4-fix-sprintf-format-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ib-mlx4-fix-sprintf-format-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from arnd@arndb.de are

kbuild-disable-wformat-truncation-warnings-by-default.patch
scsi-megaraid-fix-format-overflow-warning.patch
scsi-mpt3sas-fix-format-overflow-warning.patch
scsi-fusion-fix-string-overflow-warning.patch
scsi-gdth-avoid-buffer-overflow-warning.patch
scsi-fnic-fix-format-string-overflow-warning.patch
scsi-gdth-increase-the-procfs-event-buffer-size.patch
usbvision-i2c-fix-format-overflow-warning.patch
hwmon-applesmc-fix-format-string-overflow.patch
x86-intel-mid-fix-a-format-string-overflow-warning.patch
platform-x86-alienware-wmi-fix-format-string-overflow-warning.patch
block-dac960-shut-up-format-overflow-warning.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch

