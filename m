From: akpm@linux-foundation.org
Subject: + vfs-add-missing-unlock-in-sget.patch added to -mm tree
Date: Tue, 10 Feb 2009 15:01:19 -0800
Message-ID: <200902102301.n1AN1J13011610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757516AbZBJXCB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 18:02:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, a.p.zijlstra@chello.nl, menage@google.com, viro@ZenIV.linux.org.uk


The patch titled
     vfs: add missing unlock in sget()
has been added to the -mm tree.  Its filename is
     vfs-add-missing-unlock-in-sget.patch

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
Subject: vfs: add missing unlock in sget()
From: Li Zefan <lizf@cn.fujitsu.com>

In sget(), destroy_super(s) is called with s->s_umount held, which makes
lockdep unhappy.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/super.c~vfs-add-missing-unlock-in-sget fs/super.c
--- a/fs/super.c~vfs-add-missing-unlock-in-sget
+++ a/fs/super.c
@@ -357,8 +357,10 @@ retry:
 				continue;
 			if (!grab_super(old))
 				goto retry;
-			if (s)
+			if (s) {
+				up_write(&s->s_umount);
 				destroy_super(s);
+			}
 			return old;
 		}
 	}
@@ -373,6 +375,7 @@ retry:
 	err = set(s, data);
 	if (err) {
 		spin_unlock(&sb_lock);
+		up_write(&s->s_umount);
 		destroy_super(s);
 		return ERR_PTR(err);
 	}
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
cgroups-fix-lockdep-subclasses-overflow.patch
vfs-add-missing-unlock-in-sget.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
cpuset-fix-possible-races-in-cpu-memory-hotplug.patch

