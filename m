From: akpm@linux-foundation.org
Subject: + include-linux-credh-work-around-gcc-424-warning-in-get_cred.patch added to -mm tree
Date: Fri, 17 Jul 2009 16:16:18 -0700
Message-ID: <200907172316.n6HNGIND019356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754624AbZGQXQj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jul 2009 19:16:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, dhowells@redhat.com, jmorris@namei.org


The patch titled
     include/linux/cred.h: work around gcc-4.2.4 warning in get_cred()
has been added to the -mm tree.  Its filename is
     include-linux-credh-work-around-gcc-424-warning-in-get_cred.patch

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
Subject: include/linux/cred.h: work around gcc-4.2.4 warning in get_cred()
From: Paul Menage <menage@google.com>

With gcc 4.2.4 (building UML) I get the warning

include/linux/cred.h: In function 'get_cred':
include/linux/cred.h:189: warning: passing argument 1 of
'get_new_cred' discards qualifiers from pointer target type

Inserting an additional local variable appears to keep the compiler happy,
although it's not clear to me why this should be needed.

Signed-off-by: Paul Menage <menage@google.com>
Cc: James Morris <jmorris@namei.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cred.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/cred.h~include-linux-credh-work-around-gcc-424-warning-in-get_cred include/linux/cred.h
--- a/include/linux/cred.h~include-linux-credh-work-around-gcc-424-warning-in-get_cred
+++ a/include/linux/cred.h
@@ -186,7 +186,8 @@ static inline struct cred *get_new_cred(
  */
 static inline const struct cred *get_cred(const struct cred *cred)
 {
-	return get_new_cred((struct cred *) cred);
+	struct cred *nonconst_cred = (struct cred *) cred;
+	return get_new_cred(nonconst_cred);
 }
 
 /**
_

Patches currently in -mm which might be from menage@google.com are

cgroups-fix-pid-namespace-bug.patch
cgroups-fix-pid-namespace-bug-fix.patch
cgroup-avoid-permanent-sleep-at-rmdir-v7.patch
mm-remove-obsoleted-alloc_pages-cpuset-comment.patch
include-linux-credh-work-around-gcc-424-warning-in-get_cred.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
add-a-refcount-check-in-dput.patch

