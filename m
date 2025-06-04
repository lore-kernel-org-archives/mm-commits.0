Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278CA27462
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 02:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749003860; cv=none; b=RmA1mp17T/V1UxUUkPtEHLfDN156zjUAO0kA0rWhJtiCLD0tMlM8EkAseWbmUH3mi6v3hdMdRM6Ao5/aNiOzihgA9XTItMaxwGv6VLmcH6qYNQdd4PeKlcex6rys+s0rUxyXynYxEzSXB6IaP7UCRCCvr1sZqAsTV30C+ZuygXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749003860; c=relaxed/simple;
	bh=ofyh0PopQ7vAO58Goc7+Mr98F4tifQ3QhCWls8acjyA=;
	h=Date:To:From:Subject:Message-Id; b=aWfnIYWWB9i1yIFf2IDT08rd5AGv/cDQyNjomo4YFqlfyEhsSipigFijeu35RCmHnbzNPbZHd+5ybPgGRmdZkGKEms0G4Jld0kuyawcXRjHg2vtFVCLZtvfkT+abUVLB0CFH4RGNYAyVg7qLoh5pL36ZyCRgJNjkPthZ92EEPCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=136gziaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="136gziaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C143C4CEED;
	Wed,  4 Jun 2025 02:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749003857;
	bh=ofyh0PopQ7vAO58Goc7+Mr98F4tifQ3QhCWls8acjyA=;
	h=Date:To:From:Subject:From;
	b=136gziaT6SnyeNeGBhkp0OlgUSHj+DolBkX7DTHfQw7Mr96N/rQ6cSD9qGEq8qwyo
	 g3/NEyl5Mz9Zoakor8UFLQKPzFGjMSc0FKSx1nq7Puteg/yqVvvYUn1j157U54/BK5
	 US9oAr80dgKqHYRpCNEqipTawBxhjYopaNsQOiB0=
Date: Tue, 03 Jun 2025 19:24:16 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,hughd@google.com,rostedt@goodmis.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-fix-compile-error-when-config_shmem-is-not-set.patch removed from -mm tree
Message-Id: <20250604022417.6C143C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix compile error when CONFIG_SHMEM is not set
has been removed from the -mm tree.  Its filename was
     mm-fix-compile-error-when-config_shmem-is-not-set.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Steven Rostedt <rostedt@goodmis.org>
Subject: mm: fix compile error when CONFIG_SHMEM is not set
Date: Mon, 2 Jun 2025 17:05:00 -0400

When CONFIG_SHMEM is not set, the following compiler error occurs:

ld: vmlinux.o: in function `ttm_backup_backup_page':
(.text+0x10363bc): undefined reference to `shmem_writeout'
make[3]: *** [/work/build/trace/nobackup/linux-test.git/scripts/Makefile.vmlinux:91: vmlinux.unstripped] Error 1
make[2]: *** [/work/build/trace/nobackup/linux-test.git/Makefile:1241: vmlinux] Error 2
make[1]: *** [/work/build/trace/nobackup/linux-test.git/Makefile:248: __sub-make] Error 2
make[1]: Leaving directory '/work/build/nobackup/tracetest'
make: *** [Makefile:248: __sub-make] Error 2

This is due to the replacement of writepage and calling swap_writepage()
and shmem_writepage() directly.  The issue is that when CONFIG_SHMEM is
not defined, shmem_writepage() is also not defined.  Add it as a stub, and
it should also never be called when CONFIG_SHMEM is undefined.

Link: https://lkml.kernel.org/r/20250602170500.48713a2b@gandalf.local.home
Fixes: 84798514db50 ("mm: Remove swap_writepage() and shmem_writepage()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/shmem.c~mm-fix-compile-error-when-config_shmem-is-not-set
+++ a/mm/shmem.c
@@ -5763,6 +5763,11 @@ void shmem_unlock_mapping(struct address
 {
 }
 
+int shmem_writeout(struct folio *folio, struct writeback_control *wbc)
+{
+	return 0;
+}
+
 #ifdef CONFIG_MMU
 unsigned long shmem_get_unmapped_area(struct file *file,
 				      unsigned long addr, unsigned long len,
_

Patches currently in -mm which might be from rostedt@goodmis.org are


