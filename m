Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D43C4B1E74;
	Wed,  7 May 2025 22:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746657747; cv=none; b=ggvKyZaxk9G3FjWUGEUYFpWlJ0cgJ2CBNKuJtGvSmxCJvPUbeh9uXGYGuCWOsMrg4LIH7ghTaSB5a7Z5ISTJQ7s5KITpGeNUeSlCZJ3YcF10ecp0ezAL7L6eWqTc/Fn19kFnqlFWTdEGKekkjWSEQHB5VdIiPdE5/jV6IBaSdzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746657747; c=relaxed/simple;
	bh=fg2PAE2ekeo321a9d69zV9FpPzlg99TlqM6ImeaQViw=;
	h=Date:To:From:Subject:Message-Id; b=eQQ3HqeBSaaQqwZnGUQzHSZq8LyRn+xsvuiMBeHaZKoMqI/BmlQ7O1GWHI/HaGUlEl0bD1ip+LbtF+UpNT+Skx9ANfWDY2Zjl1HDCdk8xAhnNFSdH35FIgElw7mTgrROy4EEsOdRijyD6MJEnj2LuwkrQZDnfUUA044lcktrYR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MJZydtHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MJZydtHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8702AC4CEE2;
	Wed,  7 May 2025 22:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746657746;
	bh=fg2PAE2ekeo321a9d69zV9FpPzlg99TlqM6ImeaQViw=;
	h=Date:To:From:Subject:From;
	b=MJZydtHaPHix/u+an9ROhgp87392hY3Bg0+i7/gqtC0DBtXefkWOkdGNRqpvNkPGr
	 0c632acJZTe2y3mJe1dGpO6r0+I9JhuE0TS+3fvh17ogD8T8T3woSoQWQhSbgy101J
	 tbE3jl699B/AcEZXu8uyIKbKdnDVkvUdudALVIFs=
Date: Wed, 07 May 2025 15:42:25 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,stable@vger.kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@redhat.com,Ignacio.MorenoGonzalez@kuka.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-map-map_stack-to-vm_nohugepage-only-if-thp-is-enabled.patch added to mm-hotfixes-unstable branch
Message-Id: <20250507224226.8702AC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mmap: map MAP_STACK to VM_NOHUGEPAGE only if THP is enabled
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mmap-map-map_stack-to-vm_nohugepage-only-if-thp-is-enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-map-map_stack-to-vm_nohugepage-only-if-thp-is-enabled.patch

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
From: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
Subject: mm: mmap: map MAP_STACK to VM_NOHUGEPAGE only if THP is enabled
Date: Wed, 07 May 2025 15:28:06 +0200

commit c4608d1bf7c6 ("mm: mmap: map MAP_STACK to VM_NOHUGEPAGE") maps the
mmap option MAP_STACK to VM_NOHUGEPAGE.  This is also done if
CONFIG_TRANSPARENT_HUGEPAGE is not defined.  But in that case, the
VM_NOHUGEPAGE does not make sense.

I discovered this issue when trying to use the tool CRIU to checkpoint and
restore a container.  Our running kernel is compiled without
CONFIG_TRANSPARENT_HUGEPAGE.  CRIU parses the output of /proc/<pid>/smaps
and saves the "nh" flag.  When trying to restore the container, CRIU fails
to restore the "nh" mappings, since madvise() MADV_NOHUGEPAGE always
returns an error because CONFIG_TRANSPARENT_HUGEPAGE is not defined.

Link: https://lkml.kernel.org/r/20250507-map-map_stack-to-vm_nohugepage-only-if-thp-is-enabled-v5-1-c6c38cfefd6e@kuka.com
Fixes: c4608d1bf7c6 ("mm: mmap: map MAP_STACK to VM_NOHUGEPAGE")
Signed-off-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mman.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/mman.h~mm-mmap-map-map_stack-to-vm_nohugepage-only-if-thp-is-enabled
+++ a/include/linux/mman.h
@@ -155,7 +155,9 @@ calc_vm_flag_bits(struct file *file, uns
 	return _calc_vm_trans(flags, MAP_GROWSDOWN,  VM_GROWSDOWN ) |
 	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    ) |
 	       _calc_vm_trans(flags, MAP_SYNC,	     VM_SYNC      ) |
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	       _calc_vm_trans(flags, MAP_STACK,	     VM_NOHUGEPAGE) |
+#endif
 	       arch_calc_vm_flag_bits(file, flags);
 }
 
_

Patches currently in -mm which might be from Ignacio.MorenoGonzalez@kuka.com are

mm-mmap-map-map_stack-to-vm_nohugepage-only-if-thp-is-enabled.patch

