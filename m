Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EFB10FF
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235417; cv=none; b=poKiEOO8lg6O5d+GeHnJLDAPGFg8aGaoHU6l0t0lM+kVdQR+htxuPd1r2TKQrskgL3ggEAQZ4iwpZYW7ZwsIvnTSKof0f+adDj3q/qVJhnHkEsB6EgEeBjYXDtSC+NuPPbWE7rMy1ggiXTSl/kHSMQBmQovOLjrLzKTBI9ZwWII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235417; c=relaxed/simple;
	bh=vvqvyVLpqQLHeCBSpTyvKzio6wYamEqqehn6jbakQSg=;
	h=Date:To:From:Subject:Message-Id; b=JzE0FDCJOgfVHCHUnssdM7B2h13d6Th3rS+vsf7Ggz2ILaMCUSYciNu4wgALhYypPfejbRYKNJqHs2gu60zDUEWmYMKis2/UUkh2iaWYzLF2hciO2Fqvr4g0HQwE0GJz2aPnKL2VbOEkAVExFI5LhN06vOhW/efAvxifra4KVOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=00vCUZRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="00vCUZRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F37EC433F1;
	Fri, 26 Jan 2024 02:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235416;
	bh=vvqvyVLpqQLHeCBSpTyvKzio6wYamEqqehn6jbakQSg=;
	h=Date:To:From:Subject:From;
	b=00vCUZRjZJnMUjECLXZ/Wp5cQwMuDY5bmaN3u/o06zzJa8uJHAw24a8f8yWMp4Po7
	 7a6ZD1DlwqipqK9oejWGpWrYx3e5R+BYxVpEGo5kQiyKiw83CcdRgKHj5YaeSw8dE0
	 MDCeV0hrut1PEfzW0Uv1fJSSSZwrvj6kHHuZAa2w=
Date: Thu, 25 Jan 2024 18:16:53 -0800
To: mm-commits@vger.kernel.org,nicholas@linux.ibm.com,iii@linux.ibm.com,elver@google.com,dvyukov@google.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmsan-remove-runtime-checks-from-kmsan_unpoison_memory.patch added to mm-unstable branch
Message-Id: <20240126021656.6F37EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmsan: remove runtime checks from kmsan_unpoison_memory()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmsan-remove-runtime-checks-from-kmsan_unpoison_memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmsan-remove-runtime-checks-from-kmsan_unpoison_memory.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Alexander Potapenko <glider@google.com>
Subject: mm: kmsan: remove runtime checks from kmsan_unpoison_memory()
Date: Wed, 24 Jan 2024 18:31:34 +0100

Similarly to what's been done in commit 85716a80c16d ("kmsan: allow using
__msan_instrument_asm_store() inside runtime"), it should be safe to call
kmsan_unpoison_memory() from within the runtime, as it does not allocate
memory or take locks.  Remove the redundant runtime checks.

This should fix false positives seen with CONFIG_DEBUG_LIST=y when
the non-instrumented lib/stackdepot.c failed to unpoison the memory
chunks later checked by the instrumented lib/list_debug.c

Also replace the implementation of kmsan_unpoison_entry_regs() with
a call to kmsan_unpoison_memory().

Link: https://lkml.kernel.org/r/20240124173134.1165747-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Tested-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Nicholas Miehlbradt <nicholas@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/hooks.c |   36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

--- a/mm/kmsan/hooks.c~mm-kmsan-remove-runtime-checks-from-kmsan_unpoison_memory
+++ a/mm/kmsan/hooks.c
@@ -359,6 +359,12 @@ void kmsan_handle_dma_sg(struct scatterl
 }
 
 /* Functions from kmsan-checks.h follow. */
+
+/*
+ * To create an origin, kmsan_poison_memory() unwinds the stacks and stores it
+ * into the stack depot. This may cause deadlocks if done from within KMSAN
+ * runtime, therefore we bail out if kmsan_in_runtime().
+ */
 void kmsan_poison_memory(const void *address, size_t size, gfp_t flags)
 {
 	if (!kmsan_enabled || kmsan_in_runtime())
@@ -371,47 +377,31 @@ void kmsan_poison_memory(const void *add
 }
 EXPORT_SYMBOL(kmsan_poison_memory);
 
+/*
+ * Unlike kmsan_poison_memory(), this function can be used from within KMSAN
+ * runtime, because it does not trigger allocations or call instrumented code.
+ */
 void kmsan_unpoison_memory(const void *address, size_t size)
 {
 	unsigned long ua_flags;
 
-	if (!kmsan_enabled || kmsan_in_runtime())
+	if (!kmsan_enabled)
 		return;
 
 	ua_flags = user_access_save();
-	kmsan_enter_runtime();
 	/* The users may want to poison/unpoison random memory. */
 	kmsan_internal_unpoison_memory((void *)address, size,
 				       KMSAN_POISON_NOCHECK);
-	kmsan_leave_runtime();
 	user_access_restore(ua_flags);
 }
 EXPORT_SYMBOL(kmsan_unpoison_memory);
 
 /*
- * Version of kmsan_unpoison_memory() that can be called from within the KMSAN
- * runtime.
- *
- * Non-instrumented IRQ entry functions receive struct pt_regs from assembly
- * code. Those regs need to be unpoisoned, otherwise using them will result in
- * false positives.
- * Using kmsan_unpoison_memory() is not an option in entry code, because the
- * return value of in_task() is inconsistent - as a result, certain calls to
- * kmsan_unpoison_memory() are ignored. kmsan_unpoison_entry_regs() ensures that
- * the registers are unpoisoned even if kmsan_in_runtime() is true in the early
- * entry code.
+ * Version of kmsan_unpoison_memory() called from IRQ entry functions.
  */
 void kmsan_unpoison_entry_regs(const struct pt_regs *regs)
 {
-	unsigned long ua_flags;
-
-	if (!kmsan_enabled)
-		return;
-
-	ua_flags = user_access_save();
-	kmsan_internal_unpoison_memory((void *)regs, sizeof(*regs),
-				       KMSAN_POISON_NOCHECK);
-	user_access_restore(ua_flags);
+	kmsan_unpoison_memory((void *)regs, sizeof(*regs));
 }
 
 void kmsan_check_memory(const void *addr, size_t size)
_

Patches currently in -mm which might be from glider@google.com are

mm-kmsan-remove-runtime-checks-from-kmsan_unpoison_memory.patch

