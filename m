Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9B835CBBF
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966091; cv=none; b=sQlxHjluJ7QT+uCFVwWrrogK15sIn8eIjPyDSp6BzVYLT6y/1BlpY2IZwg1j3k1IDgKP3vtuPobL9vbEqlTJ+VjYeY9mktjcjTwQJtwbe8clSM0hYbycnKjiuaLmAUScVohhWVWn7jijZV0RWTfcBzJUYZ8XmKTN7anSZBWgWy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966091; c=relaxed/simple;
	bh=l18rYf0Q73J77Ircjha+BlqzMYWjGpweWkczuJ8KJd0=;
	h=Date:To:From:Subject:Message-Id; b=sPpEbtISKUIDTl0pnTedU/3vFxgtaj+axAUk3xcenAbbsKLwsCI+IB8KrrLU6KQydjPKGx1bWvX+FYfRsOmSVjxfAOWBm++8B0yzV8tG/2IbX0/vAORdoVMxeplDE1IoPaE2k46WB+iQa9/I/+Thakj+mv0/TzcZQocDgTLEvb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BJCaWvE2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BJCaWvE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71878C19424;
	Wed, 21 Jan 2026 03:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966091;
	bh=l18rYf0Q73J77Ircjha+BlqzMYWjGpweWkczuJ8KJd0=;
	h=Date:To:From:Subject:From;
	b=BJCaWvE2BSSsSBvTW8XHcRJT6zou8j0qxFxKnkOn7fbP0wXazYTQtJrsDN7r2T6/6
	 hsVjj4BTEVEbfDE1Lq4UqbYC87Kg1pmbY6PqErdbNaMjQizPZ6TD823pjbJtF6Yit9
	 WtrZYw7gQso+287UApUcTCKJR8SGOZpkBGfcddyI=
Date: Tue, 20 Jan 2026 19:28:10 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,rppt@kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_init-replace-simple_strtoul-with-kstrtobool-in-set_hashdist.patch removed from -mm tree
Message-Id: <20260121032811.71878C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: replace simple_strtoul with kstrtobool in set_hashdist
has been removed from the -mm tree.  Its filename was
     mm-mm_init-replace-simple_strtoul-with-kstrtobool-in-set_hashdist.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: mm/mm_init: replace simple_strtoul with kstrtobool in set_hashdist
Date: Wed, 17 Dec 2025 12:02:13 +0100

Use bool for 'hashdist' and replace simple_strtoul() with kstrtobool() for
parsing the 'hashdist=' boot parameter.  Unlike simple_strtoul(), which
returns an unsigned long, kstrtobool() converts the string directly to
bool and avoids implicit casting.

Check the return value of kstrtobool() and reject invalid values.  This
adds error handling while preserving behavior for existing values, and
removes use of the deprecated simple_strtoul() helper.  The current code
silently sets 'hashdist = 0' if parsing fails, instead of leaving the
default value (HASHDIST_DEFAULT) unchanged.

Additionally, kstrtobool() accepts common boolean strings such as "on" and
"off".

Link: https://lkml.kernel.org/r/20251217110214.50807-1-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    4 ++--
 mm/mm_init.c             |    9 +++------
 2 files changed, 5 insertions(+), 8 deletions(-)

--- a/include/linux/memblock.h~mm-mm_init-replace-simple_strtoul-with-kstrtobool-in-set_hashdist
+++ a/include/linux/memblock.h
@@ -598,9 +598,9 @@ extern void *alloc_large_system_hash(con
  */
 #ifdef CONFIG_NUMA
 #define HASHDIST_DEFAULT IS_ENABLED(CONFIG_64BIT)
-extern int hashdist;		/* Distribute hashes across NUMA nodes? */
+extern bool hashdist;		/* Distribute hashes across NUMA nodes? */
 #else
-#define hashdist (0)
+#define hashdist (false)
 #endif
 
 #ifdef CONFIG_MEMTEST
--- a/mm/mm_init.c~mm-mm_init-replace-simple_strtoul-with-kstrtobool-in-set_hashdist
+++ a/mm/mm_init.c
@@ -646,21 +646,18 @@ int __meminit early_pfn_to_nid(unsigned
 	return nid;
 }
 
-int hashdist = HASHDIST_DEFAULT;
+bool hashdist = HASHDIST_DEFAULT;
 
 static int __init set_hashdist(char *str)
 {
-	if (!str)
-		return 0;
-	hashdist = simple_strtoul(str, &str, 0);
-	return 1;
+	return kstrtobool(str, &hashdist) == 0;
 }
 __setup("hashdist=", set_hashdist);
 
 static inline void fixup_hashdist(void)
 {
 	if (num_node_state(N_MEMORY) == 1)
-		hashdist = 0;
+		hashdist = false;
 }
 #else
 static inline void fixup_hashdist(void) {}
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are


