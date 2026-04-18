Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B350287510
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498770; cv=none; b=qCDAcvKuKnQptbhBz1MVPd9CFfMCxMMFa8RF4UMl0VbpGWzjVA5w+RBCrrM8vYQrwyTvraSrC5QI0XqvesNZupMSCcEby9Q00PDBPRhW23egAIq+LPOLkUVZ2uR93NPuGhHGyFPf3whhYTkVfr6QJXkssibIsjmMcF7dvq8F8BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498770; c=relaxed/simple;
	bh=JGdiyy7ux5N1GqyOIfRTAf2v6jFB5mWl6ROOn5g0nnA=;
	h=Date:To:From:Subject:Message-Id; b=bYii+4F3yy53hUEp9ARjTtxxcgW8K48Nkm4knrCBbpgRPIHNBBSI367XSLb/qMBceJcmCbeDaH22qWoT9uf7BNZnyMHLrBnUFRpY8++qVMRAglC53pb9xSh2zks4TgqWznRm8jHhpiIgLyD0ypyOiPJHs8lOPjjH8E9MeBTYNgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BuPH0MhJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BuPH0MhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7AFC19424;
	Sat, 18 Apr 2026 07:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498770;
	bh=JGdiyy7ux5N1GqyOIfRTAf2v6jFB5mWl6ROOn5g0nnA=;
	h=Date:To:From:Subject:From;
	b=BuPH0MhJ/0SYuxQ/VhaVGM+ssjx/uNBuDG6/7rXSItqc/jtzYF9CgZFMyka/F3C/q
	 LXWlZyAXlNerr+ELIOTJKnn4g810yahD3aH8kYQxmailxdSO6twTOn3lpXxceSBAuO
	 SQFflMGiOkBejedKLw8sevihpmHaKOfAYHxtyE7k=
Date: Sat, 18 Apr 2026 00:52:44 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] liveupdate-safely-print-untrusted-strings.patch removed from -mm tree
Message-Id: <20260418075249.8F7AFC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: safely print untrusted strings
has been removed from the -mm tree.  Its filename was
     liveupdate-safely-print-untrusted-strings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: liveupdate: safely print untrusted strings
Date: Fri, 27 Mar 2026 03:33:25 +0000

Patch series "liveupdate: Fix module unloading and unregister API", v3.

This patch series addresses an issue with how LUO handles module reference
counting and unregistration during a module unload (e.g., via rmmod).

Currently, modules that register live update file handlers are pinned for
the entire duration they are registered.  This prevents the modules from
being unloaded gracefully, even when no live update session is in
progress.

Furthermore, if a module is forcefully unloaded, the unregistration
functions return an error (e.g.  -EBUSY) if a session is active, which is
ignored by the kernel's module unload path, leaving dangling pointers in
the LUO global lists.

To resolve these issues, this series introduces the following changes:
1. Adds a global read-write semaphore (luo_register_rwlock) to protect
   the registration lists for both file handlers and FLBs.
2. Reduces the scope of module reference counting for file handlers and
   FLBs. Instead of pinning modules indefinitely upon registration,
   references are now taken only when they are actively used in a live
   update session (e.g., during preservation, retrieval, or
   deserialization).
3. Removes the global luo_session_quiesce() mechanism since module
   unload behavior now handles active sessions implicitly.
4. Introduces auto-unregistration of FLBs during file handler
   unregistration to prevent leaving dangling resources.
5. Changes the unregistration functions to return void instead of
   an error code.
6. Fixes a data race in luo_flb_get_private() by introducing a spinlock
   for thread-safe lazy initialization.
7. Strengthens security by using %.*s when printing untrusted deserialized
   compatible strings and session names to prevent out-of-bounds reads.


This patch (of 10):

Deserialized strings from KHO data (such as file handler compatible
strings and session names) are provided by the previous kernel and might
not be null-terminated if the data is corrupted or maliciously crafted.

When printing these strings in error messages, use the %.*s format
specifier with the maximum buffer size to prevent out-of-bounds reads into
adjacent kernel memory.

Link: https://lore.kernel.org/20260327033335.696621-1-pasha.tatashin@soleen.com
Link: https://lore.kernel.org/20260327033335.696621-2-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_file.c    |    3 ++-
 kernel/liveupdate/luo_session.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/liveupdate/luo_file.c~liveupdate-safely-print-untrusted-strings
+++ a/kernel/liveupdate/luo_file.c
@@ -813,7 +813,8 @@ int luo_file_deserialize(struct luo_file
 		}
 
 		if (!handler_found) {
-			pr_warn("No registered handler for compatible '%s'\n",
+			pr_warn("No registered handler for compatible '%.*s'\n",
+				(int)sizeof(file_ser[i].compatible),
 				file_ser[i].compatible);
 			return -ENOENT;
 		}
--- a/kernel/liveupdate/luo_session.c~liveupdate-safely-print-untrusted-strings
+++ a/kernel/liveupdate/luo_session.c
@@ -544,7 +544,8 @@ int luo_session_deserialize(void)
 
 		session = luo_session_alloc(sh->ser[i].name);
 		if (IS_ERR(session)) {
-			pr_warn("Failed to allocate session [%s] during deserialization %pe\n",
+			pr_warn("Failed to allocate session [%.*s] during deserialization %pe\n",
+				(int)sizeof(sh->ser[i].name),
 				sh->ser[i].name, session);
 			return PTR_ERR(session);
 		}
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-fix-return-value-on-session-allocation-failure.patch

