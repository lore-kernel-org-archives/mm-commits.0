From: akpm@linux-foundation.org
Subject: + documentation-kernel-locking-mutex_trylock-cannot-be-used-in-interrupt-context.patch added to -mm tree
Date: Thu, 19 Aug 2010 14:06:19 -0700
Message-ID: <201008192106.o7JL6J5n008309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817Ab0HSVHF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Aug 2010 17:07:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefanr@s5r6.in-berlin.de, matthew@wil.cx, rdunlap@xenotime.net, rusty@rustcorp.com.au


The patch titled
     Documentation: kernel-locking: mutex_trylock cannot be used in interrupt context
has been added to the -mm tree.  Its filename is
     documentation-kernel-locking-mutex_trylock-cannot-be-used-in-interrupt-context.patch

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
Subject: Documentation: kernel-locking: mutex_trylock cannot be used in interrupt context
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Chapter 6 is right about mutex_trylock, but chapter 10 wasn't.  This error
was introduced during semaphore-to-mutex conversion of the Unreliable
guide.  :-)

If user context which performs mutex_lock() or mutex_trylock() is
preempted by interrupt context which performs mutex_trylock() on the same
mutex instance, a deadlock occurs.  This is because these functions do not
disable local IRQs when they operate on mutex->wait_lock.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-locking.tmpl |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN Documentation/DocBook/kernel-locking.tmpl~documentation-kernel-locking-mutex_trylock-cannot-be-used-in-interrupt-context Documentation/DocBook/kernel-locking.tmpl
--- a/Documentation/DocBook/kernel-locking.tmpl~documentation-kernel-locking-mutex_trylock-cannot-be-used-in-interrupt-context
+++ a/Documentation/DocBook/kernel-locking.tmpl
@@ -1922,9 +1922,12 @@ machines due to caching.
       <function>mutex_lock()</function>
       </para>
       <para>
-       There is a <function>mutex_trylock()</function> which can be
-       used inside interrupt context, as it will not sleep.
+       There is a <function>mutex_trylock()</function> which does not
+       sleep.  Still, it must not be used inside interrupt context since
+       its implementation is not safe for that.
        <function>mutex_unlock()</function> will also never sleep.
+       It cannot be used in interrupt context either since a mutex
+       must be released by the same task that acquired it.
       </para>
      </listitem>
     </itemizedlist>
_

Patches currently in -mm which might be from stefanr@s5r6.in-berlin.de are

documentation-kernel-locking-mutex_trylock-cannot-be-used-in-interrupt-context.patch
linux-next.patch

