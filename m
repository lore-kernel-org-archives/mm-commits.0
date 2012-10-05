From: akpm@linux-foundation.org
Subject: [merged] nbd-add-set-flags-ioctl.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:20:53 -0700
Message-ID: <20121005202054.1D21820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:55438 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUUz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:20:55 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so139102bkw.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:20:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.clements@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nbd: add set flags ioctl
has been removed from the -mm tree.  Its filename was
     nbd-add-set-flags-ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Paul Clements <paul.clements@steeleye.com>
Subject: nbd: add set flags ioctl

Add a set-flags ioctl, allowing various option flags to be set on an nbd
device.  This allows the nbd-client to set the device flags (to enable
read-only mode, or enable discard support, etc.).

Flags are typically specified by the nbd-server.  During the negotiation
phase of the nbd connection, the server sends its flags to the client. 
The client then uses NBD_SET_FLAGS to inform the kernel of the options.

Also included is a one-line fix to debug output for the set-timeout ioctl.

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    8 +++++++-
 include/linux/nbd.h |    9 +++++----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff -puN drivers/block/nbd.c~nbd-add-set-flags-ioctl drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-add-set-flags-ioctl
+++ a/drivers/block/nbd.c
@@ -78,6 +78,8 @@ static const char *ioctl_cmd_to_ascii(in
 	case NBD_SET_SOCK: return "set-sock";
 	case NBD_SET_BLKSIZE: return "set-blksize";
 	case NBD_SET_SIZE: return "set-size";
+	case NBD_SET_TIMEOUT: return "set-timeout";
+	case NBD_SET_FLAGS: return "set-flags";
 	case NBD_DO_IT: return "do-it";
 	case NBD_CLEAR_SOCK: return "clear-sock";
 	case NBD_CLEAR_QUE: return "clear-que";
@@ -468,7 +470,7 @@ static void nbd_handle_req(struct nbd_de
 	nbd_cmd(req) = NBD_CMD_READ;
 	if (rq_data_dir(req) == WRITE) {
 		nbd_cmd(req) = NBD_CMD_WRITE;
-		if (nbd->flags & NBD_READ_ONLY) {
+		if (nbd->flags & NBD_FLAG_READ_ONLY) {
 			dev_err(disk_to_dev(nbd->disk),
 				"Write on read-only\n");
 			goto error_out;
@@ -651,6 +653,10 @@ static int __nbd_ioctl(struct block_devi
 		nbd->xmit_timeout = arg * HZ;
 		return 0;
 
+	case NBD_SET_FLAGS:
+		nbd->flags = arg;
+		return 0;
+
 	case NBD_SET_SIZE_BLOCKS:
 		nbd->bytesize = ((u64) arg) * nbd->blksize;
 		bdev->bd_inode->i_size = nbd->bytesize;
diff -puN include/linux/nbd.h~nbd-add-set-flags-ioctl include/linux/nbd.h
--- a/include/linux/nbd.h~nbd-add-set-flags-ioctl
+++ a/include/linux/nbd.h
@@ -27,6 +27,7 @@
 #define NBD_SET_SIZE_BLOCKS	_IO( 0xab, 7 )
 #define NBD_DISCONNECT  _IO( 0xab, 8 )
 #define NBD_SET_TIMEOUT _IO( 0xab, 9 )
+#define NBD_SET_FLAGS   _IO( 0xab, 10)
 
 enum {
 	NBD_CMD_READ = 0,
@@ -34,6 +35,10 @@ enum {
 	NBD_CMD_DISC = 2
 };
 
+/* values for flags field */
+#define NBD_FLAG_HAS_FLAGS    (1 << 0) /* nbd-server supports flags */
+#define NBD_FLAG_READ_ONLY    (1 << 1) /* device is read-only */
+
 #define nbd_cmd(req) ((req)->cmd[0])
 
 /* userspace doesn't need the nbd_device structure */
@@ -42,10 +47,6 @@ enum {
 #include <linux/wait.h>
 #include <linux/mutex.h>
 
-/* values for flags field */
-#define NBD_READ_ONLY 0x0001
-#define NBD_WRITE_NOCHK 0x0002
