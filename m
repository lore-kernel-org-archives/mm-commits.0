From: akpm@linux-foundation.org
Subject: +
 include-linux-dcacheh-use-unsigned-chars-in-struct-name_snapshot.patch
 added to -mm tree
Date: Mon, 10 Jul 2017 12:57:45 -0700
Message-ID: <5963dc39.ey6oOGCq3rFJJCuu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51320 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754183AbdGJT5r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 15:57:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/dcache.h: use unsigned chars in struct name_snapshot
has been added to the -mm tree.  Its filename is
     include-linux-dcacheh-use-unsigned-chars-in-struct-name_snapshot.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-dcacheh-use-unsigned-chars-in-struct-name_snapshot.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-dcacheh-use-unsigned-chars-in-struct-name_snapshot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -597,8 +597,8 @@ static inline struct inode *d_real_inode
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

include-linux-dcacheh-use-unsigned-chars-in-struct-name_snapshot.patch

