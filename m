From: akpm@linux-foundation.org
Subject: [to-be-updated] fs-squashfs-zlib_wrapperc-dont-use-uninitialized-variable-in-zlib_uncompress.patch removed from -mm tree
Date: Tue, 25 Jan 2011 12:58:16 -0800
Message-ID: <201101252058.p0PKwGSb007575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773Ab1AYU6u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Jan 2011 15:58:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jj@chaosbits.net, mm-commits@vger.kernel.org


The patch titled
     fs/squashfs/zlib_wrapper.c: don't use uninitialized variable in zlib_uncompress()
has been removed from the -mm tree.  Its filename was
     fs-squashfs-zlib_wrapperc-dont-use-uninitialized-variable-in-zlib_uncompress.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/squashfs/zlib_wrapper.c: don't use uninitialized variable in zlib_uncompress()
From: Jesper Juhl <jj@chaosbits.net>

In fs/squashfs/zlib_wrapper.c::zlib_uncompress() we have this code:

	int zlib_err, zlib_init = 0;
	...
	do {
		if (stream->avail_in == 0 && k < b) {
		... [no code that assigns to 'zlib_err'] ...
			if (avail == 0) {
				offset = 0;
				put_bh(bh[k++]);
				continue;
			}
		...
	} while (zlib_err == Z_OK);

If we hit that 'continue' statement the first time through, then the
'while' condition will be testing an uninitialized 'zlib_err' - not what
we want.

This patch should take care of the problem by making sure that 'zlib_err'
is initialized to 'Z_OK' at the start of the function.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/zlib_wrapper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/squashfs/zlib_wrapper.c~fs-squashfs-zlib_wrapperc-dont-use-uninitialized-variable-in-zlib_uncompress fs/squashfs/zlib_wrapper.c
--- a/fs/squashfs/zlib_wrapper.c~fs-squashfs-zlib_wrapperc-dont-use-uninitialized-variable-in-zlib_uncompress
+++ a/fs/squashfs/zlib_wrapper.c
@@ -65,7 +65,7 @@ static int zlib_uncompress(struct squash
 	struct buffer_head **bh, int b, int offset, int length, int srclength,
 	int pages)
 {
-	int zlib_err, zlib_init = 0;
+	int zlib_err = Z_OK, zlib_init = 0;
 	int k = 0, page = 0;
 	z_stream *stream = msblk->stream;
 
_

Patches currently in -mm which might be from jj@chaosbits.net are

origin.patch
mm-memcontrolc-fix-uninitialized-variable-use-in-mem_cgroup_move_parent.patch
linux-next.patch
squashfs-fix-use-of-uninitialised-variable-in-zlib-xz-decompressors.patch
x86-numa-add-error-handling-for-bad-cpu-to-node-mappings.patch
audit-always-follow-va_copy-with-va_end.patch

