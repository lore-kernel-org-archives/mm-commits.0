From: akpm@linux-foundation.org
Subject: + xattr-zero-out-memory-copied-to-userspace-in-getxattr.patch
 added to -mm tree
Date: Mon, 06 Mar 2017 13:48:03 -0800
Message-ID: <58bdd913.RgQAcZqcwcU/CCF6%akpm__10883.6201522083$1488840106$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58076 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753136AbdCFWll (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2017 17:41:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, keescook@chromium.org, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/xattr.c: zero out memory copied to userspace in getxattr
has been added to the -mm tree.  Its filename is
     xattr-zero-out-memory-copied-to-userspace-in-getxattr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/xattr-zero-out-memory-copied-to-userspace-in-getxattr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/xattr-zero-out-memory-copied-to-userspace-in-getxattr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: fs/xattr.c: zero out memory copied to userspace in getxattr

getxattr uses vmalloc to allocate memory if kzalloc fails.  This is filled
by vfs_getxattr and then copied to the userspace.  vmalloc, however,
doesn't zero out the memory so if the specific implementation of the xattr
handler is sloppy we can theoretically expose a kernel memory.  There is
no real sign this is really the case but let's make sure this will not
happen and use vzalloc instead.

Fixes: 779302e67835 ("fs/xattr.c:getxattr(): improve handling of allocation failures")
Link: http://lkml.kernel.org/r/20170306103327.2766-1-mhocko@kernel.org
Acked-by: Kees Cook <keescook@chromium.org>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>	[3.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/xattr.c~xattr-zero-out-memory-copied-to-userspace-in-getxattr fs/xattr.c
--- a/fs/xattr.c~xattr-zero-out-memory-copied-to-userspace-in-getxattr
+++ a/fs/xattr.c
@@ -530,7 +530,7 @@ getxattr(struct dentry *d, const char __
 			size = XATTR_SIZE_MAX;
 		kvalue = kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
 		if (!kvalue) {
-			kvalue = vmalloc(size);
+			kvalue = vzalloc(size);
 			if (!kvalue)
 				return -ENOMEM;
 		}
_

Patches currently in -mm which might be from mhocko@suse.com are

lockdep-allow-to-disable-reclaim-lockup-detection.patch
xfs-abstract-pf_fstrans-to-pf_memalloc_nofs.patch
mm-introduce-memalloc_nofs_saverestore-api.patch
xfs-use-memalloc_nofs_saverestore-instead-of-memalloc_noio.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe.patch
mm-introduce-kvalloc-helpers.patch
mm-support-__gfp_repeat-in-kvmalloc_node-for-32kb.patch
rhashtable-simplify-a-strange-allocation-pattern.patch
ila-simplify-a-strange-allocation-pattern.patch
xattr-zero-out-memory-copied-to-userspace-in-getxattr.patch
treewide-use-kvalloc-rather-than-opencoded-variants.patch
net-use-kvmalloc-with-__gfp_repeat-rather-than-open-coded-variant.patch
md-use-kvmalloc-rather-than-opencoded-variant.patch
bcache-use-kvmalloc.patch

