From: akpm@linux-foundation.org
Subject: + adfs-use-unsigned-types-for-memcpy-length.patch added to -mm
 tree
Date: Tue, 01 Aug 2017 14:46:30 -0700
Message-ID: <5980f6b6.R+03xm1n1WXlaDDt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60332 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751981AbdHAVqb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2017 17:46:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, keescook@chromium.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: adfs: use 'unsigned' types for memcpy length
has been added to the -mm tree.  Its filename is
     adfs-use-unsigned-types-for-memcpy-length.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/adfs-use-unsigned-types-for-memcpy-length.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/adfs-use-unsigned-types-for-memcpy-length.patch

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

Patches currently in -mm which might be from arnd@arndb.de are

kasan-avoid-wmaybe-uninitialized-warning-v3.patch
adfs-use-unsigned-types-for-memcpy-length.patch
nvdimm-avoid-bogus-wmaybe-uninitialized-warning.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch
iopoll-avoid-wint-in-bool-context-warning.patch
kbuild-use-fshort-wchar-globally.patch

