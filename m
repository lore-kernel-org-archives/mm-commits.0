Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EF0215F58
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188322; cv=none; b=FLSIANxgoJgTjQOryaXmvTrSNJfjQqO3Mj3349C68GgklghUOwgjtmUY+VNnMCW0ADzjlGxiLgp2kbD6y6Scw8wz0lt2NZK0XKeMK4sonYhyrxrDR5OuOd3QOS8QNIbkSb4fXcylDCYmXpY/S/0e7jgVmiUUj94ohSHIN+lC9j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188322; c=relaxed/simple;
	bh=pIGpUVxydeYQ3uamnLNJVbTOV6DWhijJ/Frcnoaezs4=;
	h=Date:To:From:Subject:Message-Id; b=N64kPfCE6F5ff4qKQkV95KcQ6ytTy/TnqwSAbKPwDaQ5fscxQdzuJ3JHJy5VIhpvNTXYO3w6kKEPXXDKieAMp17pq8wdveljHMCU77V7E4eGcxltzClTnVWjTXF9rqOoSNMQyCOxZQDxjcifXs/WDUIT8wZ5+LD8fa3BpeOf6SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=If40iWVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="If40iWVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5739C4CEEC;
	Mon, 17 Mar 2025 05:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188321;
	bh=pIGpUVxydeYQ3uamnLNJVbTOV6DWhijJ/Frcnoaezs4=;
	h=Date:To:From:Subject:From;
	b=If40iWVdQw8qdeHOBx0eq+w61bo0FwG4iyYiHw6oR9z6NbxCJPKr3qHoT0WJyBlyK
	 SKFchdOjvZhlpyxYJ+a7onsI+DfdLfpQ5aCx8y7+irtcIOsbuCtXY7BEpBVF7G51d+
	 uq48fuKxPq8NgTe1vhNI9h2/pL5n+cNeiTV4cpGo=
Date: Sun, 16 Mar 2025 22:12:01 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,souravpanda@google.com,shivankg@amd.com,shakeel.butt@linux.dev,sfr@canb.auug.org.au,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hca@linux.ibm.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] refcount-provide-ops-for-cases-when-objects-memory-can-be-reused.patch removed from -mm tree
Message-Id: <20250317051201.C5739C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: refcount: provide ops for cases when object's memory can be reused
has been removed from the -mm tree.  Its filename was
     refcount-provide-ops-for-cases-when-objects-memory-can-be-reused.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: refcount: provide ops for cases when object's memory can be reused
Date: Thu, 13 Feb 2025 14:46:47 -0800

For speculative lookups where a successful inc_not_zero() pins the object,
but where we still need to double check if the object acquired is indeed
the one we set out to acquire (identity check), needs this validation to
happen *after* the increment.  Similarly, when a new object is initialized
and its memory might have been previously occupied by another object, all
stores to initialize the object should happen *before* refcount
initialization.

Notably SLAB_TYPESAFE_BY_RCU is one such an example when this ordering is
required for reference counting.

Add refcount_{add|inc}_not_zero_acquire() to guarantee the proper ordering
between acquiring a reference count on an object and performing the
identity check for that object.

Add refcount_set_release() to guarantee proper ordering between stores
initializing object attributes and the store initializing the refcount. 
refcount_set_release() should be done after all other object attributes
are initialized.  Once refcount_set_release() is called, the object should
be considered visible to other tasks even if it was not yet added into an
object collection normally used to discover it.  This is because other
tasks might have discovered the object previously occupying the same
memory and after memory reuse they can succeed in taking refcount for the
new object and start using it.

Object reuse example to consider:

consumer:
    obj = lookup(collection, key);
    if (!refcount_inc_not_zero_acquire(&obj->ref))
        return;
    if (READ_ONCE(obj->key) != key) { /* identity check */
        put_ref(obj);
        return;
    }
    use(obj->value);

                 producer:
                     remove(collection, obj->key);
                     if (!refcount_dec_and_test(&obj->ref))
                         return;
                     obj->key = KEY_INVALID;
                     free(obj);
                     obj = malloc(); /* obj is reused */
                     obj->key = new_key;
                     obj->value = new_value;
                     refcount_set_release(obj->ref, 1);
                     add(collection, new_key, obj);

refcount_{add|inc}_not_zero_acquire() is required to prevent the following
reordering when refcount_inc_not_zero() is used instead:

consumer:
    obj = lookup(collection, key);
    if (READ_ONCE(obj->key) != key) { /* reordered identity check */
        put_ref(obj);
        return;
    }
                 producer:
                     remove(collection, obj->key);
                     if (!refcount_dec_and_test(&obj->ref))
                         return;
                     obj->key = KEY_INVALID;
                     free(obj);
                     obj = malloc(); /* obj is reused */
                     obj->key = new_key;
                     obj->value = new_value;
                     refcount_set_release(obj->ref, 1);
                     add(collection, new_key, obj);

    if (!refcount_inc_not_zero(&obj->ref))
        return;
    use(obj->value); /* USING WRONG OBJECT */

refcount_set_release() is required to prevent the following reordering
when refcount_set() is used instead:

consumer:
    obj = lookup(collection, key);

                 producer:
                     remove(collection, obj->key);
                     if (!refcount_dec_and_test(&obj->ref))
                         return;
                     obj->key = KEY_INVALID;
                     free(obj);
                     obj = malloc(); /* obj is reused */
                     obj->key = new_key; /* new_key == old_key */
                     refcount_set(obj->ref, 1);

    if (!refcount_inc_not_zero_acquire(&obj->ref))
        return;
    if (READ_ONCE(obj->key) != key) { /* pass since new_key == old_key */
        put_ref(obj);
        return;
    }
    use(obj->value); /* USING STALE obj->value */

                     obj->value = new_value; /* reordered store */
                     add(collection, key, obj);

[surenb@google.com: fix title underlines in refcount-vs-atomic.rst]
  Link: https://lkml.kernel.org/r/20250217161645.3137927-1-surenb@google.com
Link: https://lkml.kernel.org/r/20250213224655.1680278-11-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>	[slab]
Tested-by: Shivank Garg <shivankg@amd.com>
  Link: https://lkml.kernel.org/r/5e19ec93-8307-47c2-bb13-3ddf7150624e@amd.com
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/RCU/whatisRCU.rst               |   10 +
 Documentation/core-api/refcount-vs-atomic.rst |   37 ++++-
 include/linux/refcount.h                      |  106 ++++++++++++++++
 include/linux/slab.h                          |    9 +
 4 files changed, 156 insertions(+), 6 deletions(-)

--- a/Documentation/core-api/refcount-vs-atomic.rst~refcount-provide-ops-for-cases-when-objects-memory-can-be-reused
+++ a/Documentation/core-api/refcount-vs-atomic.rst
@@ -86,7 +86,19 @@ Memory ordering guarantee changes:
  * none (both fully unordered)
 
 
-case 2) - increment-based ops that return no value
+case 2) - non-"Read/Modify/Write" (RMW) ops with release ordering
+-----------------------------------------------------------------
+
+Function changes:
+
+ * atomic_set_release() --> refcount_set_release()
+
+Memory ordering guarantee changes:
+
+ * none (both provide RELEASE ordering)
+
+
+case 3) - increment-based ops that return no value
 --------------------------------------------------
 
 Function changes:
@@ -98,7 +110,7 @@ Memory ordering guarantee changes:
 
  * none (both fully unordered)
 
-case 3) - decrement-based RMW ops that return no value
+case 4) - decrement-based RMW ops that return no value
 ------------------------------------------------------
 
 Function changes:
@@ -110,7 +122,7 @@ Memory ordering guarantee changes:
  * fully unordered --> RELEASE ordering
 
 
-case 4) - increment-based RMW ops that return a value
+case 5) - increment-based RMW ops that return a value
 -----------------------------------------------------
 
 Function changes:
@@ -126,7 +138,20 @@ Memory ordering guarantees changes:
    result of obtaining pointer to the object!
 
 
-case 5) - generic dec/sub decrement-based RMW ops that return a value
+case 6) - increment-based RMW ops with acquire ordering that return a value
+---------------------------------------------------------------------------
+
+Function changes:
+
+ * atomic_inc_not_zero() --> refcount_inc_not_zero_acquire()
+ * no atomic counterpart --> refcount_add_not_zero_acquire()
+
+Memory ordering guarantees changes:
+
+ * fully ordered --> ACQUIRE ordering on success
+
+
+case 7) - generic dec/sub decrement-based RMW ops that return a value
 ---------------------------------------------------------------------
 
 Function changes:
@@ -139,7 +164,7 @@ Memory ordering guarantees changes:
  * fully ordered --> RELEASE ordering + ACQUIRE ordering on success
 
 
-case 6) other decrement-based RMW ops that return a value
+case 8) other decrement-based RMW ops that return a value
 ---------------------------------------------------------
 
 Function changes:
@@ -154,7 +179,7 @@ Memory ordering guarantees changes:
 .. note:: atomic_add_unless() only provides full order on success.
 
 
-case 7) - lock-based RMW
+case 9) - lock-based RMW
 ------------------------
 
 Function changes:
--- a/Documentation/RCU/whatisRCU.rst~refcount-provide-ops-for-cases-when-objects-memory-can-be-reused
+++ a/Documentation/RCU/whatisRCU.rst
@@ -971,6 +971,16 @@ unfortunately any spinlock in a ``SLAB_T
 initialized after each and every call to kmem_cache_alloc(), which renders
 reference-free spinlock acquisition completely unsafe.  Therefore, when
 using ``SLAB_TYPESAFE_BY_RCU``, make proper use of a reference counter.
+If using refcount_t, the specialized refcount_{add|inc}_not_zero_acquire()
+and refcount_set_release() APIs should be used to ensure correct operation
+ordering when verifying object identity and when initializing newly
+allocated objects. Acquire fence in refcount_{add|inc}_not_zero_acquire()
+ensures that identity checks happen *after* reference count is taken.
+refcount_set_release() should be called after a newly allocated object is
+fully initialized and release fence ensures that new values are visible
+*before* refcount can be successfully taken by other users. Once
+refcount_set_release() is called, the object should be considered visible
+by other tasks.
 (Those willing to initialize their locks in a kmem_cache constructor
 may also use locking, including cache-friendly sequence locking.)
 
--- a/include/linux/refcount.h~refcount-provide-ops-for-cases-when-objects-memory-can-be-reused
+++ a/include/linux/refcount.h
@@ -87,6 +87,15 @@
  * The decrements dec_and_test() and sub_and_test() also provide acquire
  * ordering on success.
  *
+ * refcount_{add|inc}_not_zero_acquire() and refcount_set_release() provide
+ * acquire and release ordering for cases when the memory occupied by the
+ * object might be reused to store another object. This is important for the
+ * cases where secondary validation is required to detect such reuse, e.g.
+ * SLAB_TYPESAFE_BY_RCU. The secondary validation checks have to happen after
+ * the refcount is taken, hence acquire order is necessary. Similarly, when the
+ * object is initialized, all stores to its attributes should be visible before
+ * the refcount is set, otherwise a stale attribute value might be used by
+ * another task which succeeds in taking a refcount to the new object.
  */
 
 #ifndef _LINUX_REFCOUNT_H
@@ -126,6 +135,31 @@ static inline void refcount_set(refcount
 }
 
 /**
+ * refcount_set_release - set a refcount's value with release ordering
+ * @r: the refcount
+ * @n: value to which the refcount will be set
+ *
+ * This function should be used when memory occupied by the object might be
+ * reused to store another object -- consider SLAB_TYPESAFE_BY_RCU.
+ *
+ * Provides release memory ordering which will order previous memory operations
+ * against this store. This ensures all updates to this object are visible
+ * once the refcount is set and stale values from the object previously
+ * occupying this memory are overwritten with new ones.
+ *
+ * This function should be called only after new object is fully initialized.
+ * After this call the object should be considered visible to other tasks even
+ * if it was not yet added into an object collection normally used to discover
+ * it. This is because other tasks might have discovered the object previously
+ * occupying the same memory and after memory reuse they can succeed in taking
+ * refcount to the new object and start using it.
+ */
+static inline void refcount_set_release(refcount_t *r, int n)
+{
+	atomic_set_release(&r->refs, n);
+}
+
+/**
  * refcount_read - get a refcount's value
  * @r: the refcount
  *
@@ -178,6 +212,52 @@ static inline __must_check bool refcount
 	return __refcount_add_not_zero(i, r, NULL);
 }
 
+static inline __must_check __signed_wrap
+bool __refcount_add_not_zero_acquire(int i, refcount_t *r, int *oldp)
+{
+	int old = refcount_read(r);
+
+	do {
+		if (!old)
+			break;
+	} while (!atomic_try_cmpxchg_acquire(&r->refs, &old, old + i));
+
+	if (oldp)
+		*oldp = old;
+
+	if (unlikely(old < 0 || old + i < 0))
+		refcount_warn_saturate(r, REFCOUNT_ADD_NOT_ZERO_OVF);
+
+	return old;
+}
+
+/**
+ * refcount_add_not_zero_acquire - add a value to a refcount with acquire ordering unless it is 0
+ *
+ * @i: the value to add to the refcount
+ * @r: the refcount
+ *
+ * Will saturate at REFCOUNT_SATURATED and WARN.
+ *
+ * This function should be used when memory occupied by the object might be
+ * reused to store another object -- consider SLAB_TYPESAFE_BY_RCU.
+ *
+ * Provides acquire memory ordering on success, it is assumed the caller has
+ * guaranteed the object memory to be stable (RCU, etc.). It does provide a
+ * control dependency and thereby orders future stores. See the comment on top.
+ *
+ * Use of this function is not recommended for the normal reference counting
+ * use case in which references are taken and released one at a time.  In these
+ * cases, refcount_inc_not_zero_acquire() should instead be used to increment a
+ * reference count.
+ *
+ * Return: false if the passed refcount is 0, true otherwise
+ */
+static inline __must_check bool refcount_add_not_zero_acquire(int i, refcount_t *r)
+{
+	return __refcount_add_not_zero_acquire(i, r, NULL);
+}
+
 static inline __signed_wrap
 void __refcount_add(int i, refcount_t *r, int *oldp)
 {
@@ -236,6 +316,32 @@ static inline __must_check bool refcount
 	return __refcount_inc_not_zero(r, NULL);
 }
 
+static inline __must_check bool __refcount_inc_not_zero_acquire(refcount_t *r, int *oldp)
+{
+	return __refcount_add_not_zero_acquire(1, r, oldp);
+}
+
+/**
+ * refcount_inc_not_zero_acquire - increment a refcount with acquire ordering unless it is 0
+ * @r: the refcount to increment
+ *
+ * Similar to refcount_inc_not_zero(), but provides acquire memory ordering on
+ * success.
+ *
+ * This function should be used when memory occupied by the object might be
+ * reused to store another object -- consider SLAB_TYPESAFE_BY_RCU.
+ *
+ * Provides acquire memory ordering on success, it is assumed the caller has
+ * guaranteed the object memory to be stable (RCU, etc.). It does provide a
+ * control dependency and thereby orders future stores. See the comment on top.
+ *
+ * Return: true if the increment was successful, false otherwise
+ */
+static inline __must_check bool refcount_inc_not_zero_acquire(refcount_t *r)
+{
+	return __refcount_inc_not_zero_acquire(r, NULL);
+}
+
 static inline void __refcount_inc(refcount_t *r, int *oldp)
 {
 	__refcount_add(1, r, oldp);
--- a/include/linux/slab.h~refcount-provide-ops-for-cases-when-objects-memory-can-be-reused
+++ a/include/linux/slab.h
@@ -136,6 +136,15 @@ enum _slab_flag_bits {
  * rcu_read_lock before reading the address, then rcu_read_unlock after
  * taking the spinlock within the structure expected at that address.
  *
+ * Note that object identity check has to be done *after* acquiring a
+ * reference, therefore user has to ensure proper ordering for loads.
+ * Similarly, when initializing objects allocated with SLAB_TYPESAFE_BY_RCU,
+ * the newly allocated object has to be fully initialized *before* its
+ * refcount gets initialized and proper ordering for stores is required.
+ * refcount_{add|inc}_not_zero_acquire() and refcount_set_release() are
+ * designed with the proper fences required for reference counting objects
+ * allocated with SLAB_TYPESAFE_BY_RCU.
+ *
  * Note that it is not possible to acquire a lock within a structure
  * allocated with SLAB_TYPESAFE_BY_RCU without first acquiring a reference
  * as described above.  The reason is that SLAB_TYPESAFE_BY_RCU pages
_

Patches currently in -mm which might be from surenb@google.com are


