Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2732D0622;
	Fri, 28 Nov 2025 18:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764356124; cv=none; b=q18Ty5FgEgTaAFLVmqCjF2y2XvwlRhxWoyerg9SFsbHrICsjVMyOImvvhw5FC8MrTiElTcORhDloqrdpdzN29wJjBAnc2jVcnbQRsGF0JvRyfGiAfAH9V0k8kjqp57dSqAQ/D25vu6nIchdZP/fCGbJXq/6f/XP7FNnZmOa7ouM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764356124; c=relaxed/simple;
	bh=bIPaIQFsV5dPVv4UUZ6HSMuS+/tihJQmcM7KGPYU09s=;
	h=Date:To:From:Subject:Message-Id; b=WtBhAbv/722cxsJUrldkE9Ui9Lf/sqfGvV3qqZbXO+6RZqWr3CEBv+LgwlbaPQewHR2PH0h9I2+/bJhAIt6IfYaVbifjrZsiT0cPYt3cp8XFj2VXfyxk+zMkOHoQy/H+XUbzAK27sMc3ftLTdGzSIrPNWW/+Obkasc8xRApmxMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cR0YtCn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cR0YtCn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B995CC4CEFB;
	Fri, 28 Nov 2025 18:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764356123;
	bh=bIPaIQFsV5dPVv4UUZ6HSMuS+/tihJQmcM7KGPYU09s=;
	h=Date:To:From:Subject:From;
	b=cR0YtCn39IZ3ttFZ4ZFWjp4ZtHlaOivISCx7OXo1P38xsKjyBFEMWHLDrQ4/vNTJb
	 BGuGJnA5MSMMfSNdu3ncY/pLw9U0/GhFdGjgqOuZQAA1ffSLhS7P5EOlOx22dn3T1D
	 CeqIyAWvxVDdtV4ro2jDN5IVLcUach/eK81OyeXc=
Date: Fri, 28 Nov 2025 10:55:23 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,urezki@gmail.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,kees@kernel.org,glider@google.com,dvyukov@google.com,dakr@kernel.org,andreyknvl@gmail.com,jiayuan.chen@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-fix-incorrect-unpoisoning-in-vrealloc-for-kasan.patch added to mm-hotfixes-unstable branch
Message-Id: <20251128185523.B995CC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kasan: fix incorrect unpoisoning in vrealloc for KASAN
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kasan-fix-incorrect-unpoisoning-in-vrealloc-for-kasan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-fix-incorrect-unpoisoning-in-vrealloc-for-kasan.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Jiayuan Chen <jiayuan.chen@linux.dev>
Subject: mm/kasan: fix incorrect unpoisoning in vrealloc for KASAN
Date: Fri, 28 Nov 2025 19:15:14 +0800

Syzkaller reported a memory out-of-bounds bug [1]. This patch fixes two
issues:

1. In vrealloc, we were missing the KASAN_VMALLOC_VM_ALLOC flag when
   unpoisoning the extended region. This flag is required to correctly
   associate the allocation with KASAN's vmalloc tracking.

   Note: In contrast, vzalloc (via __vmalloc_node_range_noprof) explicitly
   sets KASAN_VMALLOC_VM_ALLOC and calls kasan_unpoison_vmalloc() with it.
   vrealloc must behave consistently — especially when reusing existing
   vmalloc regions — to ensure KASAN can track allocations correctly.

2. When vrealloc reuses an existing vmalloc region (without allocating new
   pages), KASAN previously generated a new tag, which broke tag-based
   memory access tracking. We now add a 'reuse_tag' parameter to
   __kasan_unpoison_vmalloc() to preserve the original tag in such cases.

A new helper kasan_unpoison_vralloc() is introduced to handle this reuse
scenario, ensuring consistent tag behavior during reallocation.


Link: https://lkml.kernel.org/r/20251128111516.244497-1-jiayuan.chen@linux.dev
Link: https://syzkaller.appspot.com/bug?extid=997752115a851cb0cf36 [1]
Fixes: a0309faf1cb0 ("mm: vmalloc: support more granular vrealloc() sizing")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reported-by: syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68e243a2.050a0220.1696c6.007d.GAE@google.com/T/
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |   21 +++++++++++++++++++--
 mm/kasan/hw_tags.c    |    4 ++--
 mm/kasan/shadow.c     |    6 ++++--
 mm/vmalloc.c          |    4 ++--
 4 files changed, 27 insertions(+), 8 deletions(-)

--- a/include/linux/kasan.h~mm-kasan-fix-incorrect-unpoisoning-in-vrealloc-for-kasan
+++ a/include/linux/kasan.h
@@ -596,13 +596,23 @@ static inline void kasan_release_vmalloc
 #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
 
 void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
-			       kasan_vmalloc_flags_t flags);
+			       kasan_vmalloc_flags_t flags, bool reuse_tag);
+
+static __always_inline void *kasan_unpoison_vrealloc(const void *start,
+						     unsigned long size,
+						     kasan_vmalloc_flags_t flags)
+{
+	if (kasan_enabled())
+		return __kasan_unpoison_vmalloc(start, size, flags, true);
+	return (void *)start;
+}
+
 static __always_inline void *kasan_unpoison_vmalloc(const void *start,
 						unsigned long size,
 						kasan_vmalloc_flags_t flags)
 {
 	if (kasan_enabled())
-		return __kasan_unpoison_vmalloc(start, size, flags);
+		return __kasan_unpoison_vmalloc(start, size, flags, false);
 	return (void *)start;
 }
 
@@ -629,6 +639,13 @@ static inline void kasan_release_vmalloc
 					 unsigned long free_region_end,
 					 unsigned long flags) { }
 
+static inline void *kasan_unpoison_vrealloc(const void *start,
+					    unsigned long size,
+					    kasan_vmalloc_flags_t flags)
+{
+	return (void *)start;
+}
+
 static inline void *kasan_unpoison_vmalloc(const void *start,
 					   unsigned long size,
 					   kasan_vmalloc_flags_t flags)
--- a/mm/kasan/hw_tags.c~mm-kasan-fix-incorrect-unpoisoning-in-vrealloc-for-kasan
+++ a/mm/kasan/hw_tags.c
@@ -317,7 +317,7 @@ static void init_vmalloc_pages(const voi
 }
 
 void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
-				kasan_vmalloc_flags_t flags)
+				kasan_vmalloc_flags_t flags, bool reuse_tag)
 {
 	u8 tag;
 	unsigned long redzone_start, redzone_size;
@@ -361,7 +361,7 @@ void *__kasan_unpoison_vmalloc(const voi
 		return (void *)start;
 	}
 
-	tag = kasan_random_tag();
+	tag = reuse_tag ? get_tag(start) : kasan_random_tag();
 	start = set_tag(start, tag);
 
 	/* Unpoison and initialize memory up to size. */
--- a/mm/kasan/shadow.c~mm-kasan-fix-incorrect-unpoisoning-in-vrealloc-for-kasan
+++ a/mm/kasan/shadow.c
@@ -625,7 +625,7 @@ void kasan_release_vmalloc(unsigned long
 }
 
 void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
-			       kasan_vmalloc_flags_t flags)
+			       kasan_vmalloc_flags_t flags, bool reuse_tag)
 {
 	/*
 	 * Software KASAN modes unpoison both VM_ALLOC and non-VM_ALLOC
@@ -648,7 +648,9 @@ void *__kasan_unpoison_vmalloc(const voi
 	    !(flags & KASAN_VMALLOC_PROT_NORMAL))
 		return (void *)start;
 
-	start = set_tag(start, kasan_random_tag());
+	if (!reuse_tag)
+		start = set_tag(start, kasan_random_tag());
+
 	kasan_unpoison(start, size, false);
 	return (void *)start;
 }
--- a/mm/vmalloc.c~mm-kasan-fix-incorrect-unpoisoning-in-vrealloc-for-kasan
+++ a/mm/vmalloc.c
@@ -4175,8 +4175,8 @@ void *vrealloc_node_align_noprof(const v
 	 * We already have the bytes available in the allocation; use them.
 	 */
 	if (size <= alloced_size) {
-		kasan_unpoison_vmalloc(p + old_size, size - old_size,
-				       KASAN_VMALLOC_PROT_NORMAL);
+		kasan_unpoison_vrealloc(p, size,
+					KASAN_VMALLOC_PROT_NORMAL | KASAN_VMALLOC_VM_ALLOC);
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during
_

Patches currently in -mm which might be from jiayuan.chen@linux.dev are

mm-kasan-fix-incorrect-unpoisoning-in-vrealloc-for-kasan.patch
mm-vmscan-skip-increasing-kswapd_failures-when-reclaim-was-boosted.patch

