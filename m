From: akpm@linux-foundation.org
Subject: [patch 1/1] adfs: use 'unsigned' types for memcpy length
Date: Wed, 02 Aug 2017 16:48:34 -0700
Message-ID: <598264d2.BDhmldxWI69AYdU6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60792 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751761AbdHBXsf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 19:48:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de, keescook@chromium.org, sfr@canb.auug.org.au

From: Arnd Bergmann <arnd@arndb.de>
Subject: adfs: use 'unsigned' types for memcpy length

After 62d1034f53e3 ("fortify: use WARN instead of BUG for now"), we get a
warning in adfs about a possible buffer overflow:

In function 'memcpy',
    inlined from '__adfs_dir_put' at fs/adfs/dir_f.c:318:2,
    inlined from 'adfs_f_update' at fs/adfs/dir_f.c:403:2:
include/linux/string.h:305:4: error: call to '__read_overflow2' declared with attribute error: detected read beyond size of object passed as 2nd parameter
    __read_overflow2();
    ^~~~~~~~~~~~~~~~~~

The warning is correct in the sense that a negative 'pos' argument to the
function would have that result.  However, this is not a bug, as we know
the position is always positive (in fact, between 5 and 2007, inclusive)
when the function gets called.

Changing the variable to a unsigned type avoids the problem.  I decided to
use 'unsigned int' for the position in the directory and the block number,
as they are both counting things, but use size_t for the offset and length
that get passed into memcpy.  This shuts up the warning.

Link: http://lkml.kernel.org/r/20170801120438.1582336-2-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/dir_f.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/adfs/dir_f.c~adfs-use-unsigned-types-for-memcpy-length fs/adfs/dir_f.c
--- a/fs/adfs/dir_f.c~adfs-use-unsigned-types-for-memcpy-length
+++ a/fs/adfs/dir_f.c
@@ -283,11 +283,12 @@ __adfs_dir_get(struct adfs_dir *dir, int
 }
 
 static int
-__adfs_dir_put(struct adfs_dir *dir, int pos, struct object_info *obj)
+__adfs_dir_put(struct adfs_dir *dir, unsigned int pos, struct object_info *obj)
 {
 	struct super_block *sb = dir->sb;
 	struct adfs_direntry de;
-	int thissize, buffer, offset;
+	unsigned int buffer;
+	size_t thissize, offset;
 
 	buffer = pos >> sb->s_blocksize_bits;
 
_
