From: akpm@linux-foundation.org
Subject: + sys_personality-remove-the-bogus-checks-in-sys_personality-__set_personality-path.patch added to -mm tree
Date: Tue, 01 Jun 2010 23:03:10 -0700
Message-ID: <201006020603.o52637nD008191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957Ab0FBGDT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 02:03:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, hpa@zytor.com, torvalds@linux-foundation.org, wezhang@redhat.com


The patch titled
     sys_personality: remove the bogus checks in sys_personality()->__set_personality() path
has been added to the -mm tree.  Its filename is
     sys_personality-remove-the-bogus-checks-in-sys_personality-__set_personality-path.patch

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
Subject: sys_personality: remove the bogus checks in sys_personality()->__set_personality() path
From: Oleg Nesterov <oleg@redhat.com>

Cleanup, no functional changes.

- __set_personality() always changes ->exec_domain/personality, the
  special case when ->exec_domain remains the same buys nothing but
  complicates the code. Unify both cases to simplify the code.

- The -EINVAL check in sys_personality() was never right. If we assume
  that set_personality() can fail we should check the value it returns
  instead of verifying that task->personality was actually changed.

  Remove it. Before the previous patch it was possible to hit this case
  due to overflow problems, but this -EINVAL just indicated the kernel
  bug.

OTOH, probably it makes sense to change lookup_exec_domain() to return
ERR_PTR() instead of default_exec_domain if the search in exec_domains
list fails, and report this error to the user-space.  But this means
another user-space change, and we have in-kernel users which need fixes. 
For example, PER_OSF4 falls into PER_MASK for unkown reason and nobody
cares to register this domain.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Wenming Zhang <wezhang@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exec_domain.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff -puN kernel/exec_domain.c~sys_personality-remove-the-bogus-checks-in-sys_personality-__set_personality-path kernel/exec_domain.c
--- a/kernel/exec_domain.c~sys_personality-remove-the-bogus-checks-in-sys_personality-__set_personality-path
+++ a/kernel/exec_domain.c
@@ -134,23 +134,14 @@ unregister:
 	return 0;
 }
 
-int
-__set_personality(unsigned int personality)
+int __set_personality(unsigned int personality)
 {
-	struct exec_domain	*ep, *oep;
-
-	ep = lookup_exec_domain(personality);
-	if (ep == current_thread_info()->exec_domain) {
-		current->personality = personality;
-		module_put(ep->module);
-		return 0;
-	}
+	struct exec_domain *oep = current_thread_info()->exec_domain;
 
+	current_thread_info()->exec_domain = lookup_exec_domain(personality);
 	current->personality = personality;
-	oep = current_thread_info()->exec_domain;
-	current_thread_info()->exec_domain = ep;
-
 	module_put(oep->module);
+
 	return 0;
 }
 
@@ -192,11 +183,8 @@ SYSCALL_DEFINE1(personality, unsigned in
 {
 	unsigned int old = current->personality;
 
-	if (personality != 0xffffffff) {
+	if (personality != 0xffffffff)
 		set_personality(personality);
-		if (current->personality != personality)
-			return -EINVAL;
-	}
 
 	return old;
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

sys_personality-change-sys_personality-to-accept-unsigned-int-instead-of-u_long.patch
sys_personality-remove-the-bogus-checks-in-sys_personality-__set_personality-path.patch

