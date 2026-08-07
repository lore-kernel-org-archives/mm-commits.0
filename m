Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6246B3A9850
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068099; cv=none; b=Fx43fzAjDaJ95aof95gZRBGdnOgZtWd8sDxmEo+i9fFiv28tk+36xmXVMY9AMOO1bJha8WSnsvmnc7A21lHiDdu8w/TWXJYL5ZSCvYEB1z+/xusye9mpWVGYgudCkBXeNNaNEuy1Bm35lTTnen4xKBRxPs8O7esDFQtjf0n9PZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068099; c=relaxed/simple;
	bh=yjMTGtortU6D2NaAGcx7hhMFTqlzD9EqZfNGqETORA0=;
	h=Date:To:From:Subject:Message-Id; b=oeWkHQGcpoinczLRcsWMcFR8/D9QNbPMVrXK1O3BpVhNN6+ALVOG94MMsEOix3mtD1GVqkuZuBNUk8ixmYQeVD2rkKonFbzYDKxXv6RhEHOnDuMabOfr/ThPibR/YolroolnDVUn1nMDhPILRL8UJiCPbSFRrf05KHLWBwJJtaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZZryspcj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZZryspcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB521F00A3A;
	Fri,  7 Aug 2026 02:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068098;
	bh=rd0ej7nwIunAa2TKPlK0VTItK7LyotYNQenH0vT324I=;
	h=Date:To:From:Subject;
	b=ZZryspcjjeMt22tcch1G7m31Hh8jljB4m6eCCtOiyM7+14yBkAGIo0kx+Wp8+c3Ya
	 UdIvhfr+F7k39IzDS2QteUVQ4ZevM8DF9DpH7BFQhjvaUuesfeXeAYly+qkOgQNTld
	 FrebCsSa2mWHKXs8ZpAznAjouj7S1yigW5akLl3g=
Date: Thu, 06 Aug 2026 19:01:37 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,thomas.weissschuh@linutronix.de,rdunlap@infradead.org,pfalcato@suse.de,peterz@infradead.org,ojeda@kernel.org,nathan@kernel.org,ljs@kernel.org,linux.amoon@gmail.com,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,gary@garyguo.net,dianders@chromium.org,corbet@lwn.net,aliceryhl@google.com,leon.hwang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mseal-fix-mseal-documentation-for-32-bit-kernels.patch removed from -mm tree
Message-Id: <20260807020137.EAB521F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mseal: fix mseal documentation for 32-bit kernels
has been removed from the -mm tree.  Its filename was
     mm-mseal-fix-mseal-documentation-for-32-bit-kernels.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Leon Hwang <leon.hwang@linux.dev>
Subject: mm/mseal: fix mseal documentation for 32-bit kernels
Date: Wed, 15 Jul 2026 21:12:58 +0800

mseal.o is built only for 64-bit kernels, so 32-bit kernels fall back to
sys_ni_syscall() and return -ENOSYS rather than -EPERM.

Drop architecture description in mseal.rst, since the arch feature doc has
the latest state of mseal for each architecture.

Fix the CONFIG_MSEAL_SYSTEM_MAPPINGS typo in init/Kconfig.

Link: https://lore.kernel.org/20260715131258.55499-1-leon.hwang@linux.dev
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Acked-by: Lance Yang <lance.yang@linux.dev>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Anand Moon <linux.amoon@gmail.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leon Hwang <leon.hwang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/userspace-api/mseal.rst |   14 ++++++--------
 init/Kconfig                          |    2 +-
 2 files changed, 7 insertions(+), 9 deletions(-)

--- a/Documentation/userspace-api/mseal.rst~mm-mseal-fix-mseal-documentation-for-32-bit-kernels
+++ a/Documentation/userspace-api/mseal.rst
@@ -50,8 +50,8 @@ mseal syscall signature
          * The start address (``addr``) is not allocated.
          * The end address (``addr`` + ``len``) is not allocated.
          * A gap (unallocated memory) between start and end address.
-      - **-EPERM**:
-         * sealing is supported only on 64-bit CPUs, 32-bit is not supported.
+      - **-ENOSYS**:
+         * The kernel does not implement ``mseal()``.
 
    **Note about error return**:
       - For above error cases, users can expect the given memory range is
@@ -62,7 +62,8 @@ mseal syscall signature
         memory range could happen. However, those cases should be rare.
 
    **Architecture support**:
-      mseal only works on 64-bit CPUs, not 32-bit CPUs.
+      mseal is built only for 64-bit kernels. 32-bit kernels return
+      ``-ENOSYS``.
 
    **Idempotent**:
       users can call mseal multiple times. mseal on an already sealed memory
@@ -131,11 +132,11 @@ Use cases
 - Chrome browser: protect some security sensitive data structures.
 
 - System mappings:
-  The system mappings are created by the kernel and includes vdso, vvar,
+  The system mappings are created by the kernel and include vdso, vvar,
   vvar_vclock, vectors (arm compat-mode), sigpage (arm compat-mode), uprobes.
 
   Those system mappings are readonly only or execute only, memory sealing can
-  protect them from ever changing to writable or unmmap/remapped as different
+  protect them from ever changing to writable or unmapped/remapped as different
   attributes. This is useful to mitigate memory corruption issues where a
   corrupted pointer is passed to a memory management system.
 
@@ -143,9 +144,6 @@ Use cases
   the CONFIG_MSEAL_SYSTEM_MAPPINGS seals all system mappings of this
   architecture.
 
-  The following architectures currently support this feature: x86-64, arm64,
-  loongarch and s390.
-
   WARNING: This feature breaks programs which rely on relocating
   or unmapping system mappings. Known broken software at the time
   of writing includes CHECKPOINT_RESTORE, UML, gVisor, rr. Therefore
--- a/init/Kconfig~mm-mseal-fix-mseal-documentation-for-32-bit-kernels
+++ a/init/Kconfig
@@ -2123,7 +2123,7 @@ config ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPIN
 	  from a kernel perspective.
 
 	  After the architecture enables this, a distribution can set
-	  CONFIG_MSEAL_SYSTEM_MAPPING to manage access to the feature.
+	  CONFIG_MSEAL_SYSTEM_MAPPINGS to manage access to the feature.
 
 	  For complete descriptions of memory sealing, please see
 	  Documentation/userspace-api/mseal.rst
_

Patches currently in -mm which might be from leon.hwang@linux.dev are


