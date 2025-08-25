Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A002E274B48
	for <mm-commits@vger.kernel.org>; Mon, 25 Aug 2025 23:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756162984; cv=none; b=lSfaW31nURHiungeEJ/xmjR61UIEx3Yfihz4S2Kf6mIDJf1NfRn+nMhbm8C+G+aDgD6Vw2yfIBBQbXU9VhfcXhPqTe2APwMDbNlUAf1rhC7mWusxeNUgLclaQGLuMNoGcQih2RpKBrp6mMpvuW0ZuTAdtlYfS+1KoWvZ3SVNJEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756162984; c=relaxed/simple;
	bh=QUY2+ODTvw5KRyd3fBKPcoGB4KgGOYW7PnnCpJEd4T4=;
	h=Date:To:From:Subject:Message-Id; b=ejvVakHsBdMcdg6nKSrNDOHIFpHhpuek9f5GJL9FplFesk/cyTPbYldifnQBjanmtw7JGSozjKzAkBOMLKkCkLJgNu1AkWbf/TYo+QlobVNPpicjPttQ0tLh5cnDeJPqHh0EPmg3dwHLYar78iLfgAeEZijH91KTWsNDZ+FUIIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gnqDmD1+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gnqDmD1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D31C4CEED;
	Mon, 25 Aug 2025 23:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756162984;
	bh=QUY2+ODTvw5KRyd3fBKPcoGB4KgGOYW7PnnCpJEd4T4=;
	h=Date:To:From:Subject:From;
	b=gnqDmD1+rPd4Kyv3O6Lszj36ORvHOIV7/yJxeZxwpe3+VRG5JjBBs/aYb6nue/Pha
	 kx3ckM/fBan7OsynMBQtaODumSDXANV5bmcL+LHoYZ5J2aSDhhAFd5eZaz5UHxct8r
	 gcUSLA6boAnlnsjcj5O0CRzrJsWekpuDoLyGRqtM=
Date: Mon, 25 Aug 2025 16:03:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,rostedt@goodmis.org,rientjes@google.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,liumartin@google.com,david@redhat.com,wander@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmem-tracing-add-kmem-name-to-kmem_cache_alloc-tracepoint.patch added to mm-new branch
Message-Id: <20250825230304.05D31C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmem/tracing: add kmem name to kmem_cache_alloc tracepoint
has been added to the -mm mm-new branch.  Its filename is
     kmem-tracing-add-kmem-name-to-kmem_cache_alloc-tracepoint.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmem-tracing-add-kmem-name-to-kmem_cache_alloc-tracepoint.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Wander Lairson Costa <wander@redhat.com>
Subject: kmem/tracing: add kmem name to kmem_cache_alloc tracepoint
Date: Mon, 25 Aug 2025 09:59:26 -0300

The kmem_cache_free tracepoint includes a "name" field, which allows for
easy identification and filtering of specific kmem's.  However, the
kmem_cache_alloc tracepoint lacks this field, making it difficult to pair
corresponding alloc and free events for analysis.

Add the "name" field to kmem_cache_alloc to enable consistent tracking and
correlation of kmem alloc and free events.

Link: https://lkml.kernel.org/r/20250825125927.59816-1-wander@redhat.com
Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Martin Liu <liumartin@google.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/kmem.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/trace/events/kmem.h~kmem-tracing-add-kmem-name-to-kmem_cache_alloc-tracepoint
+++ a/include/trace/events/kmem.h
@@ -22,6 +22,7 @@ TRACE_EVENT(kmem_cache_alloc,
 	TP_STRUCT__entry(
 		__field(	unsigned long,	call_site	)
 		__field(	const void *,	ptr		)
+		__string(	name,		s->name		)
 		__field(	size_t,		bytes_req	)
 		__field(	size_t,		bytes_alloc	)
 		__field(	unsigned long,	gfp_flags	)
@@ -32,6 +33,7 @@ TRACE_EVENT(kmem_cache_alloc,
 	TP_fast_assign(
 		__entry->call_site	= call_site;
 		__entry->ptr		= ptr;
+		__assign_str(name);
 		__entry->bytes_req	= s->object_size;
 		__entry->bytes_alloc	= s->size;
 		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
@@ -41,9 +43,10 @@ TRACE_EVENT(kmem_cache_alloc,
 					  (s->flags & SLAB_ACCOUNT)) : false;
 	),
 
-	TP_printk("call_site=%pS ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s node=%d accounted=%s",
+	TP_printk("call_site=%pS ptr=%p name=%s bytes_req=%zu bytes_alloc=%zu gfp_flags=%s node=%d accounted=%s",
 		(void *)__entry->call_site,
 		__entry->ptr,
+		__get_str(name),
 		__entry->bytes_req,
 		__entry->bytes_alloc,
 		show_gfp_flags(__entry->gfp_flags),
_

Patches currently in -mm which might be from wander@redhat.com are

kmem-tracing-add-kmem-name-to-kmem_cache_alloc-tracepoint.patch

