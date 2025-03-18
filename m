Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A011C1F05
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274540; cv=none; b=gYqiLysXQJsUVxt1DH3PIIRAIY/dvaaZmxsaLqfwtuRR5ftgOZDoagTkGRADw8lVwaR2B8aWbQ+rktRKattXv5TdzhtcWWVw6MjPdeKVGOUkWVCa6Xb6PRIU+zchTe1nmy+GHapsOjozm6AJ3sJyvtvRx3WwFDJisHqSQIuC/pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274540; c=relaxed/simple;
	bh=85Zy0m0qsgroTPACH6YPFYz9FTCyxzTOdsKmR28LBYQ=;
	h=Date:To:From:Subject:Message-Id; b=oLL2WPq4K9kawGP6D2JVHU5oz2Lg1nfLfI5X4fvcSkk6dGrJkIo9E6oZYprim6XZgEdIZ+LFR4IOv/kQux08NVnmje2zO6p/GNHGdJyGWTUEYbFB9/9s2P+u+0jOcYjrwc0Xxe6gMxHhXR0e0vBVbTb4f6eQl7aVuzJQ4MHNbD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1vJslc4j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1vJslc4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8719C4CEDD;
	Tue, 18 Mar 2025 05:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274539;
	bh=85Zy0m0qsgroTPACH6YPFYz9FTCyxzTOdsKmR28LBYQ=;
	h=Date:To:From:Subject:From;
	b=1vJslc4jVUXBbae5Z1YH2I2ZQWKC18uQvI1JK+Sn8hiKDED5IwM+L7dQ1q6MIL/Ft
	 2sTkZFN3FT4mHiZO4W91G+g1QRHKFeXm/cwhCFt6SBMvSMuYKpyx5/+8aIw7IjVhN/
	 KOrmdfjQOzADXW4fJ6KBaAEfDxa/qSWNh/L6qFSg=
Date: Mon, 17 Mar 2025 22:08:59 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizefan.x@bytedance.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jannh@google.com,ioworker0@gmail.com,hannes@cmpxchg.org,dave.hansen@linux.intel.com,corbet@lwn.net,bp@alien8.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] bit_spinlock-__always_inline-unlock-functions.patch removed from -mm tree
Message-Id: <20250318050859.D8719C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bit_spinlock: __always_inline (un)lock functions
has been removed from the -mm tree.  Its filename was
     bit_spinlock-__always_inline-unlock-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: bit_spinlock: __always_inline (un)lock functions
Date: Mon, 3 Mar 2025 17:30:03 +0100

The compiler might decide that it is a smart idea to not inline
bit_spin_lock(), primarily when a couple of functions in the same file end
up calling it.  Especially when used in RMAP map/unmap code next, the
compiler sometimes decides to not inline, which is then observable in some
micro-benchmarks.

Let's simply flag all lock/unlock functions as __always_inline;
arch_test_and_set_bit_lock() and friends are already tagged like that (but
not test_and_set_bit_lock() for some reason).

If ever a problem, we could split it into a fast and a slow path, and only
force the fast path to be inlined.  But there is nothing particularly
"big" here.

Link: https://lkml.kernel.org/r/20250303163014.1128035-11-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirks^H^Hski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michal Koutn <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: tejun heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bit_spinlock.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/bit_spinlock.h~bit_spinlock-__always_inline-unlock-functions
+++ a/include/linux/bit_spinlock.h
@@ -13,7 +13,7 @@
  * Don't use this unless you really need to: spin_lock() and spin_unlock()
  * are significantly faster.
  */
-static inline void bit_spin_lock(int bitnum, unsigned long *addr)
+static __always_inline void bit_spin_lock(int bitnum, unsigned long *addr)
 {
 	/*
 	 * Assuming the lock is uncontended, this never enters
@@ -38,7 +38,7 @@ static inline void bit_spin_lock(int bit
 /*
  * Return true if it was acquired
  */
-static inline int bit_spin_trylock(int bitnum, unsigned long *addr)
+static __always_inline int bit_spin_trylock(int bitnum, unsigned long *addr)
 {
 	preempt_disable();
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
@@ -54,7 +54,7 @@ static inline int bit_spin_trylock(int b
 /*
  *  bit-based spin_unlock()
  */
-static inline void bit_spin_unlock(int bitnum, unsigned long *addr)
+static __always_inline void bit_spin_unlock(int bitnum, unsigned long *addr)
 {
 #ifdef CONFIG_DEBUG_SPINLOCK
 	BUG_ON(!test_bit(bitnum, addr));
@@ -71,7 +71,7 @@ static inline void bit_spin_unlock(int b
  *  non-atomic version, which can be used eg. if the bit lock itself is
  *  protecting the rest of the flags in the word.
  */
-static inline void __bit_spin_unlock(int bitnum, unsigned long *addr)
+static __always_inline void __bit_spin_unlock(int bitnum, unsigned long *addr)
 {
 #ifdef CONFIG_DEBUG_SPINLOCK
 	BUG_ON(!test_bit(bitnum, addr));
_

Patches currently in -mm which might be from david@redhat.com are


