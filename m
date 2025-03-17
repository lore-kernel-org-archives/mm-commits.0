Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075DC215F43
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188325; cv=none; b=qLPvwD6jz54cnhadqwotxBncQEi55RQXxQZrO3AAPDj6ihkBu6SMwpHarxVAKm95fLzah5hYFAfVlIgJvtGHC9/ctAe4QsUCGT7XXEt0UZv43eeDPy6oUfPeY6YCBC9foQHAyNXKcZ4XsB+ItiAMKBHUmbeUV40+f7b88w3bNf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188325; c=relaxed/simple;
	bh=x5vMUDDeZWmrxQcriQ/lvI+Y7nhRB0+TG/1jXkdsLcM=;
	h=Date:To:From:Subject:Message-Id; b=rtg8233C06L4r4qxvY9AR1wRhFDJWaj32BBC1NtQUEPJTFvBNYAb7P50293oF2X2Z5oExqmAFY6ow5CrwfSv4JL4aajT4QOKJMsj3hxohxrmbCGk0xvDct7635TFmVb3Zc+SKEcRgM+e+t3uRsJo0/RtBgWeRHyYqNSTTJLfm4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=He5lw8wC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="He5lw8wC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB411C4CEEC;
	Mon, 17 Mar 2025 05:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188324;
	bh=x5vMUDDeZWmrxQcriQ/lvI+Y7nhRB0+TG/1jXkdsLcM=;
	h=Date:To:From:Subject:From;
	b=He5lw8wCldAlqlRpDEYhBRtiI8OZW8mLJZZWy2MXrhBXCFZPZ9Jzm2KiSjaEF7ynJ
	 oe3A3PJNy4M6uxulPzN2u3YVeEnyuaRfkwVYBLv8XFZkX3rOlnzJF2lS1QI/9cU+vV
	 7qrZYVT36EMn94criX5vHohO0Pqtnt61pv7XMJfk=
Date: Sun, 16 Mar 2025 22:12:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,souravpanda@google.com,shivankg@amd.com,shakeel.butt@linux.dev,sfr@canb.auug.org.au,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hca@linux.ibm.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] refcount-introduce-__refcount_addinc_not_zero_limited_acquire.patch removed from -mm tree
Message-Id: <20250317051204.CB411C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: refcount: introduce __refcount_{add|inc}_not_zero_limited_acquire
has been removed from the -mm tree.  Its filename was
     refcount-introduce-__refcount_addinc_not_zero_limited_acquire.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: refcount: introduce __refcount_{add|inc}_not_zero_limited_acquire
Date: Thu, 13 Feb 2025 14:46:48 -0800

Introduce functions to increase refcount but with a top limit above which
they will fail to increase (the limit is inclusive).  Setting the limit to
INT_MAX indicates no limit.

Link: https://lkml.kernel.org/r/20250213224655.1680278-12-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
  Link: https://lkml.kernel.org/r/5e19ec93-8307-47c2-bb13-3ddf7150624e@amd.com
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
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/refcount.h |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/include/linux/refcount.h~refcount-introduce-__refcount_addinc_not_zero_limited_acquire
+++ a/include/linux/refcount.h
@@ -213,13 +213,20 @@ static inline __must_check bool refcount
 }
 
 static inline __must_check __signed_wrap
-bool __refcount_add_not_zero_acquire(int i, refcount_t *r, int *oldp)
+bool __refcount_add_not_zero_limited_acquire(int i, refcount_t *r, int *oldp,
+					     int limit)
 {
 	int old = refcount_read(r);
 
 	do {
 		if (!old)
 			break;
+
+		if (i > limit - old) {
+			if (oldp)
+				*oldp = old;
+			return false;
+		}
 	} while (!atomic_try_cmpxchg_acquire(&r->refs, &old, old + i));
 
 	if (oldp)
@@ -231,6 +238,18 @@ bool __refcount_add_not_zero_acquire(int
 	return old;
 }
 
+static inline __must_check bool
+__refcount_inc_not_zero_limited_acquire(refcount_t *r, int *oldp, int limit)
+{
+	return __refcount_add_not_zero_limited_acquire(1, r, oldp, limit);
+}
+
+static inline __must_check __signed_wrap
+bool __refcount_add_not_zero_acquire(int i, refcount_t *r, int *oldp)
+{
+	return __refcount_add_not_zero_limited_acquire(i, r, oldp, INT_MAX);
+}
+
 /**
  * refcount_add_not_zero_acquire - add a value to a refcount with acquire ordering unless it is 0
  *
_

Patches currently in -mm which might be from surenb@google.com are


