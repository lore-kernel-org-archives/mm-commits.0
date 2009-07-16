From: akpm@linux-foundation.org
Subject: + vm-document-that-setting-vfs_cache_pressure-to-0-isnt-a-good-idea.patch added to -mm tree
Date: Thu, 16 Jul 2009 14:37:28 -0700
Message-ID: <200907162137.n6GLbS8d025170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932869AbZGPViH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Jul 2009 17:38:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, ct@pipapo.org


The patch titled
     vm: document that setting vfs_cache_pressure to 0 isn't a good idea
has been added to the -mm tree.  Its filename is
     vm-document-that-setting-vfs_cache_pressure-to-0-isnt-a-good-idea.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vm: document that setting vfs_cache_pressure to 0 isn't a good idea
From: Jan Kara <jack@suse.cz>

Reported-by: Christian Thaeter <ct@pipapo.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN Documentation/sysctl/vm.txt~vm-document-that-setting-vfs_cache_pressure-to-0-isnt-a-good-idea Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~vm-document-that-setting-vfs_cache_pressure-to-0-isnt-a-good-idea
+++ a/Documentation/sysctl/vm.txt
@@ -585,7 +585,9 @@ caching of directory and inode objects.
 At the default value of vfs_cache_pressure=100 the kernel will attempt to
 reclaim dentries and inodes at a "fair" rate with respect to pagecache and
 swapcache reclaim.  Decreasing vfs_cache_pressure causes the kernel to prefer
-to retain dentry and inode caches.  Increasing vfs_cache_pressure beyond 100
+to retain dentry and inode caches. When vfs_cache_pressure=0, the kernel will
+never reclaim dentries and inodes due to memory pressure and this can easily
+lead to out-of-memory conditions. Increasing vfs_cache_pressure beyond 100
 causes the kernel to prefer to reclaim dentries and inodes.
 
 ==============================================================
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch
vm-document-that-setting-vfs_cache_pressure-to-0-isnt-a-good-idea.patch
reiser4-update-names-of-quota-methods.patch

