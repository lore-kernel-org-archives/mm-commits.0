From: akpm@linux-foundation.org
Subject: + lib-export-generic-atomic64_t-functions.patch added to -mm tree
Date: Tue, 21 Jul 2009 16:34:21 -0700
Message-ID: <200907212334.n6LNYLpW017576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753974AbZGUXfB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 19:35:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdreier@cisco.com, paulus@samba.org, rolandd@cisco.com


The patch titled
     lib: export generic atomic64_t functions
has been added to the -mm tree.  Its filename is
     lib-export-generic-atomic64_t-functions.patch

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
Subject: lib: export generic atomic64_t functions
From: Roland Dreier <rdreier@cisco.com>

The generic atomic64_t implementation in lib/ did not export the functions
it defined, which means that modules that use atomic64_t would not link on
platforms (such as 32-bit powerpc).  For example, trying to build a kernel
with CONFIG_NET_RDS on such a platform would fail with:

    ERROR: "atomic64_read" [net/rds/rds.ko] undefined!
    ERROR: "atomic64_set" [net/rds/rds.ko] undefined!

Fix this by exporting the atomic64_t functions to modules.  (I export the
entire API even if it's not all currently used by in-tree modules to avoid
having to continue fixing this in dribs and drabs)

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Acked-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/atomic64.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN lib/atomic64.c~lib-export-generic-atomic64_t-functions lib/atomic64.c
--- a/lib/atomic64.c~lib-export-generic-atomic64_t-functions
+++ a/lib/atomic64.c
@@ -13,6 +13,7 @@
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <asm/atomic.h>
 
 /*
@@ -52,6 +53,7 @@ long long atomic64_read(const atomic64_t
 	spin_unlock_irqrestore(lock, flags);
 	return val;
 }
+EXPORT_SYMBOL(atomic64_read);
 
 void atomic64_set(atomic64_t *v, long long i)
 {
@@ -62,6 +64,7 @@ void atomic64_set(atomic64_t *v, long lo
 	v->counter = i;
 	spin_unlock_irqrestore(lock, flags);
 }
+EXPORT_SYMBOL(atomic64_set);
 
 void atomic64_add(long long a, atomic64_t *v)
 {
@@ -72,6 +75,7 @@ void atomic64_add(long long a, atomic64_
 	v->counter += a;
 	spin_unlock_irqrestore(lock, flags);
 }
+EXPORT_SYMBOL(atomic64_add);
 
 long long atomic64_add_return(long long a, atomic64_t *v)
 {
@@ -84,6 +88,7 @@ long long atomic64_add_return(long long 
 	spin_unlock_irqrestore(lock, flags);
 	return val;
 }
+EXPORT_SYMBOL(atomic64_add_return);
 
 void atomic64_sub(long long a, atomic64_t *v)
 {
@@ -94,6 +99,7 @@ void atomic64_sub(long long a, atomic64_
 	v->counter -= a;
 	spin_unlock_irqrestore(lock, flags);
 }
+EXPORT_SYMBOL(atomic64_sub);
 
 long long atomic64_sub_return(long long a, atomic64_t *v)
 {
@@ -106,6 +112,7 @@ long long atomic64_sub_return(long long 
 	spin_unlock_irqrestore(lock, flags);
 	return val;
 }
+EXPORT_SYMBOL(atomic64_sub_return);
 
 long long atomic64_dec_if_positive(atomic64_t *v)
 {
@@ -120,6 +127,7 @@ long long atomic64_dec_if_positive(atomi
 	spin_unlock_irqrestore(lock, flags);
 	return val;
 }
+EXPORT_SYMBOL(atomic64_dec_if_positive);
 
 long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n)
 {
@@ -134,6 +142,7 @@ long long atomic64_cmpxchg(atomic64_t *v
 	spin_unlock_irqrestore(lock, flags);
 	return val;
 }
+EXPORT_SYMBOL(atomic64_cmpxchg);
 
 long long atomic64_xchg(atomic64_t *v, long long new)
 {
@@ -147,6 +156,7 @@ long long atomic64_xchg(atomic64_t *v, l
 	spin_unlock_irqrestore(lock, flags);
 	return val;
 }
+EXPORT_SYMBOL(atomic64_xchg);
 
 int atomic64_add_unless(atomic64_t *v, long long a, long long u)
 {
@@ -162,6 +172,7 @@ int atomic64_add_unless(atomic64_t *v, l
 	spin_unlock_irqrestore(lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL(atomic64_add_unless);
 
 static int init_atomic64_lock(void)
 {
_

Patches currently in -mm which might be from rdreier@cisco.com are

linux-next.patch
ecryptfs-another-lockdep-issue.patch
lib-export-generic-atomic64_t-functions.patch

