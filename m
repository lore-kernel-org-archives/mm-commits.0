From: akpm@linux-foundation.org
Subject: [to-be-updated] fs-squashfs-xz_wrapperc-dont-use-uninitialized-variable-in-squashfs_xz_uncompress.patch removed from -mm tree
Date: Tue, 25 Jan 2011 12:58:13 -0800
Message-ID: <201101252058.p0PKwEjX007572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753534Ab1AYU7H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Jan 2011 15:59:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jj@chaosbits.net, phillip@lougher.demon.co.uk, mm-commits@vger.kernel.org


The patch titled
     fs/squashfs/xz_wrapper.c: don't use uninitialized variable in squashfs_xz_uncompress()
has been removed from the -mm tree.  Its filename was
     fs-squashfs-xz_wrapperc-dont-use-uninitialized-variable-in-squashfs_xz_uncompress.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/squashfs/xz_wrapper.c: don't use uninitialized variable in squashfs_xz_uncompress()
From: Jesper Juhl <jj@chaosbits.net>

In fs/squashfs/xz_wrapper.c::squashfs_xz_uncompress() we have this code:

	enum xz_ret xz_err;
	...
	do {
		if (stream->buf.in_pos == stream->buf.in_size && k < b) {
		... [nothing that assigns to 'xz_err'] ...
			if (avail == 0) {
				offset = 0;
				put_bh(bh[k++]);
				continue;
			}
		...
	} while (xz_err == XZ_OK);

If we hit that 'continue' statement the first time through, then the
'while' condition will be testing an uninitialized 'xz_err' - not what we
want.

This patch should take care of the problem by making sure that 'xz_err' is
initialized to 'XZ_OK' at the start of the function.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/xz_wrapper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/squashfs/xz_wrapper.c~fs-squashfs-xz_wrapperc-dont-use-uninitialized-variable-in-squashfs_xz_uncompress fs/squashfs/xz_wrapper.c
--- a/fs/squashfs/xz_wrapper.c~fs-squashfs-xz_wrapperc-dont-use-uninitialized-variable-in-squashfs_xz_uncompress
+++ a/fs/squashfs/xz_wrapper.c
@@ -74,7 +74,7 @@ static int squashfs_xz_uncompress(struct
 	struct buffer_head **bh, int b, int offset, int length, int srclength,
 	int pages)
 {
-	enum xz_ret xz_err;
+	enum xz_ret xz_err = XZ_OK;
 	int avail, total = 0, k = 0, page = 0;
 	struct squashfs_xz *stream = msblk->stream;
 
_

Patches currently in -mm which might be from jj@chaosbits.net are

origin.patch
mm-memcontrolc-fix-uninitialized-variable-use-in-mem_cgroup_move_parent.patch
linux-next.patch
fs-squashfs-zlib_wrapperc-dont-use-uninitialized-variable-in-zlib_uncompress.patch
squashfs-fix-use-of-uninitialised-variable-in-zlib-xz-decompressors.patch
x86-numa-add-error-handling-for-bad-cpu-to-node-mappings.patch
audit-always-follow-va_copy-with-va_end.patch

