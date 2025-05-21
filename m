Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0129E17A310
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846636; cv=none; b=jkC2G2CwaDocFL8a+c736tZZoG9RAfwUvIdl8otsz8ucA4RxvvdCeafw0kTXF7aefPSI4gx8O62oc+y69PtJHYQjPyA9FByM1fVM3RZK0OCR2hYOVAqV3tQy8LWZvVet51w5Kp1AVZP5z5RBC+rAF5rpLommCIj3VEQkTAkFo1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846636; c=relaxed/simple;
	bh=5T8o9Mnv8om8VK/v8/JV5nhZP+tCSEo5tR44KnqhBk8=;
	h=Date:To:From:Subject:Message-Id; b=AyV9nNDLpqShDS17xFokvXNRA5At+AVWj3HUsiyD1NSHkkWY38aKiYXOc0SU8UuJ7QlnY602aW0D4FBJ5m7XyEhCwW/7ePj9p/astQ2tLJqjpmlmP803zu1CN1p74LycYOGyMQ835emR/cpjZiogkDaGSIBkjGpqrM4ACdic4rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=APdcg4dT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="APdcg4dT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC455C4CEE4;
	Wed, 21 May 2025 16:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846635;
	bh=5T8o9Mnv8om8VK/v8/JV5nhZP+tCSEo5tR44KnqhBk8=;
	h=Date:To:From:Subject:From;
	b=APdcg4dTYDI5oY5AZpGg4vgE0Rvz638+9w9DJLBIoNt586wXTVtjh2SZCoiaa11B8
	 ZLXc8Qcp8d7EeF9W0SkNoxd0TUIU9qqJVT6+rkbYAIKipTUy60zYmXUbXUgCxH03iS
	 9aT1lbhNGd43SsTcmKJeTkjtXyX0Z9sXPz9D69Zs=
Date: Wed, 21 May 2025 09:57:15 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tursulin@ursulin.net,tglx@linutronix.de,rostedt@goodmis.org,rodrigo.vivi@intel.com,peterz@infradead.org,peterx@redhat.com,mingo@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,luto@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,joonas.lahtinen@linux.intel.com,jannh@google.com,jani.nikula@linux.intel.com,hpa@zytor.com,bp@alien8.de,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-mm-pat-inline-memtype_match-into-memtype_erase.patch removed from -mm tree
Message-Id: <20250521165715.AC455C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/mm/pat: inline memtype_match() into memtype_erase()
has been removed from the -mm tree.  Its filename was
     x86-mm-pat-inline-memtype_match-into-memtype_erase.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: x86/mm/pat: inline memtype_match() into memtype_erase()
Date: Mon, 12 May 2025 14:34:22 +0200

Let's just have it in a single function.  The resulting function is
certainly small enough and readable.

Link: https://lkml.kernel.org/r/20250512123424.637989-10-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Airlie <airlied@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat/memtype_interval.c |   31 +++++++--------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

--- a/arch/x86/mm/pat/memtype_interval.c~x86-mm-pat-inline-memtype_match-into-memtype_erase
+++ a/arch/x86/mm/pat/memtype_interval.c
@@ -49,21 +49,6 @@ INTERVAL_TREE_DEFINE(struct memtype, rb,
 
 static struct rb_root_cached memtype_rbroot = RB_ROOT_CACHED;
 
-static struct memtype *memtype_match(u64 start, u64 end)
-{
-	struct memtype *entry_match;
-
-	entry_match = interval_iter_first(&memtype_rbroot, start, end-1);
-
-	while (entry_match != NULL && entry_match->start < end) {
-		if (entry_match->start == start && entry_match->end == end)
-			return entry_match;
-		entry_match = interval_iter_next(entry_match, start, end-1);
-	}
-
-	return NULL; /* Returns NULL if there is no match */
-}
-
 static int memtype_check_conflict(u64 start, u64 end,
 				  enum page_cache_mode reqtype,
 				  enum page_cache_mode *newtype)
@@ -119,14 +104,16 @@ int memtype_check_insert(struct memtype
 
 struct memtype *memtype_erase(u64 start, u64 end)
 {
-	struct memtype *entry_old;
-
-	entry_old = memtype_match(start, end);
-	if (!entry_old)
-		return ERR_PTR(-EINVAL);
+	struct memtype *entry = interval_iter_first(&memtype_rbroot, start, end - 1);
 
-	interval_remove(entry_old, &memtype_rbroot);
-	return entry_old;
+	while (entry && entry->start < end) {
+		if (entry->start == start && entry->end == end) {
+			interval_remove(entry, &memtype_rbroot);
+			return entry;
+		}
+		entry = interval_iter_next(entry, start, end - 1);
+	}
+	return ERR_PTR(-EINVAL);
 }
 
 struct memtype *memtype_lookup(u64 addr)
_

Patches currently in -mm which might be from david@redhat.com are


