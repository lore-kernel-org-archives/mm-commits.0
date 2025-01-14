Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854D023C6F6
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837018; cv=none; b=E3X4pzvEgOwQ8v+zziSU9xJUjLR1bV/t8YZ7u+Awb4uw7MT0PkoqYMSAJJJcbB67RjvfSs3iSf47jTg+SMU4Ip6QEikoz1554fkyU316m8GaVLlov7qY/OBAf0vVeZfLH7KgDmKeTBhOpNkuhPiQ9O2EtYogIZjYCjRxoncazto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837018; c=relaxed/simple;
	bh=C0AfxqVagJyvELQyxhp2aqkKGrqIQiBypHHkyfV2Py8=;
	h=Date:To:From:Subject:Message-Id; b=rK/kBgWfcTzT+T4SlAMl6GqXd0WNxMHT7fwTyDrTms/9PcbMlcdAyBO7UNN/kMuwMbuevwD5I1PIgRoQAheIXBQKIEMII6ipxtd8J2Lt03Zh4DK980RMfFU6Ube4lCvAVe5UQ7EJ85XAyxcjULqDnhbATs25i6RsgFiSYWQ6tRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qLFP10ls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qLFP10ls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B05C4CEDD;
	Tue, 14 Jan 2025 06:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837018;
	bh=C0AfxqVagJyvELQyxhp2aqkKGrqIQiBypHHkyfV2Py8=;
	h=Date:To:From:Subject:From;
	b=qLFP10ls2rORi/PTSUlK4hxpQr2CKznASbcU8S4C2gkJxaqnNczOh4f2vSeSlCmfK
	 5hK3PiyMTerXJAjZ6ZLbUqbtZgAOsLe6VgmBlxTUxY8O0IGuMen9cBzae1Vh8lRdOs
	 dfsWaIvwGOlwHJ7HBmR8tOTVCp6SVQOfd+KmvrHY=
Date: Mon, 13 Jan 2025 22:43:37 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] seqlock-add-raw_seqcount_try_begin.patch removed from -mm tree
Message-Id: <20250114064338.55B05C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: seqlock: add raw_seqcount_try_begin
has been removed from the -mm tree.  Its filename was
     seqlock-add-raw_seqcount_try_begin.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: seqlock: add raw_seqcount_try_begin
Date: Fri, 22 Nov 2024 09:44:14 -0800

Add raw_seqcount_try_begin() to opens a read critical section of the given
seqcount_t if the counter is even. This enables eliding the critical
section entirely if the counter is odd, instead of doing the speculation
knowing it will fail.

Link: https://lkml.kernel.org/r/20241122174416.1367052-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/seqlock.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/include/linux/seqlock.h~seqlock-add-raw_seqcount_try_begin
+++ a/include/linux/seqlock.h
@@ -319,6 +319,28 @@ SEQCOUNT_LOCKNAME(mutex,        struct m
 })
 
 /**
+ * raw_seqcount_try_begin() - begin a seqcount_t read critical section
+ *                            w/o lockdep and w/o counter stabilization
+ * @s: Pointer to seqcount_t or any of the seqcount_LOCKNAME_t variants
+ *
+ * Similar to raw_seqcount_begin(), except it enables eliding the critical
+ * section entirely if odd, instead of doing the speculation knowing it will
+ * fail.
+ *
+ * Useful when counter stabilization is more or less equivalent to taking
+ * the lock and there is a slowpath that does that.
+ *
+ * If true, start will be set to the (even) sequence count read.
+ *
+ * Return: true when a read critical section is started.
+ */
+#define raw_seqcount_try_begin(s, start)				\
+({									\
+	start = raw_read_seqcount(s);					\
+	!(start & 1);							\
+})
+
+/**
  * raw_seqcount_begin() - begin a seqcount_t read critical section w/o
  *                        lockdep and w/o counter stabilization
  * @s: Pointer to seqcount_t or any of the seqcount_LOCKNAME_t variants
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-skip-pgalloc_tag_swap-if-profiling-is-disabled.patch
alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled.patch

