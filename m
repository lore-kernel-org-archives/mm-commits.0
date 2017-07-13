From: akpm@linux-foundation.org
Subject: [merged]
 include-linux-dcacheh-use-unsigned-chars-in-struct-name_snapshot.patch
 removed from -mm tree
Date: Thu, 13 Jul 2017 13:39:52 -0700
Message-ID: <20170713203952.hCZqOVAMv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58730 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753424AbdGMUj6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:39:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, viro@zeniv.linux.org.uk


The patch titled
     Subject: include/linux/dcache.h: use unsigned chars in struct name_snapshot
has been removed from the -mm tree.  Its filename was
     include-linux-dcacheh-use-unsigned-chars-in-struct-name_snapshot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: include/linux/dcache.h: use unsigned chars in struct name_snapshot

"kernel.h: handle pointers to arrays better in container_of()" triggers:

In file included from include/uapi/linux/stddef.h:1:0,
                 from include/linux/stddef.h:4,
                 from include/uapi/linux/posix_types.h:4,
                 from include/uapi/linux/types.h:13,
                 from include/linux/types.h:5,
                 from include/linux/syscalls.h:71,
                 from fs/dcache.c:17:
fs/dcache.c: In function 'release_dentry_name_snapshot':
include/linux/compiler.h:542:38: error: call to '__compiletime_assert_305' declared with attribute error: pointer type mismatch in container_of()
  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
                                      ^
include/linux/compiler.h:525:4: note: in definition of macro '__compiletime_assert'
    prefix ## suffix();    \
    ^
include/linux/compiler.h:542:2: note: in expansion of macro '_compiletime_assert'
  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
  ^
include/linux/build_bug.h:46:37: note: in expansion of macro 'compiletime_assert'
 #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                     ^
include/linux/kernel.h:860:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
  ^
fs/dcache.c:305:7: note: in expansion of macro 'container_of'
   p = container_of(name->name, struct external_name, name[0]);

Switch name_snapshot to use unsigned chars, matching struct qstr and
struct external_name.

Link: http://lkml.kernel.org/r/20170710152134.0f78c1e6@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dcache.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/dcache.h~include-linux-dcacheh-use-unsigned-chars-in-struct-name_snapshot include/linux/dcache.h
--- a/include/linux/dcache.h~include-linux-dcacheh-use-unsigned-chars-in-struct-name_snapshot
+++ a/include/linux/dcache.h
@@ -592,8 +592,8 @@ static inline struct inode *d_real_inode
 }
 
 struct name_snapshot {
-	const char *name;
-	char inline_name[DNAME_INLINE_LEN];
+	const unsigned char *name;
+	unsigned char inline_name[DNAME_INLINE_LEN];
 };
 void take_dentry_name_snapshot(struct name_snapshot *, struct dentry *);
 void release_dentry_name_snapshot(struct name_snapshot *);
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are


