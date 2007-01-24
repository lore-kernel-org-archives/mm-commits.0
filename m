From: akpm@osdl.org
Subject: + remove-the-last-reference-to-rwlock_is_locked-macro.patch added to -mm tree
Date: Tue, 23 Jan 2007 19:55:47 -0800
Message-ID: <200701240355.l0O3tliZ007762@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50029 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965646AbXAXDzt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 22:55:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com


The patch titled
     Remove the last reference to rwlock_is_locked() macro.
has been added to the -mm tree.  Its filename is
     remove-the-last-reference-to-rwlock_is_locked-macro.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove the last reference to rwlock_is_locked() macro.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the lone, remaining reference to the long-deceased
rwlock_is_locked() macro.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-arm/spinlock.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/asm-arm/spinlock.h~remove-the-last-reference-to-rwlock_is_locked-macro include/asm-arm/spinlock.h
--- a/include/asm-arm/spinlock.h~remove-the-last-reference-to-rwlock_is_locked-macro
+++ a/include/asm-arm/spinlock.h
@@ -86,7 +86,6 @@ static inline void __raw_spin_unlock(raw
  * Write locks are easy - we just set bit 31.  When unlocking, we can
  * just write zero since the lock is exclusively held.
  */
-#define rwlock_is_locked(x)	(*((volatile unsigned int *)(x)) != 0)
 
 static inline void __raw_write_lock(raw_rwlock_t *rw)
 {
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
numerous-fixes-to-kernel-doc-info-in-source-files.patch
remove-a-couple-final-references-to-obsolete-verify_area.patch
remove-the-last-reference-to-rwlock_is_locked-macro.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
