Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F16240DFB5
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 20:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775075343; cv=none; b=miC9oXYbXjSX6Yt7kLP55lgTFo4jnDyb4l4Gb2ZiPBpmV1kPuD4mr38QVYmFZLExAw4PPlib/cH/3OPvA4yxSVyWRSyAznQIIyyXxGCdf2uLslAFcRbKFl3kVM/f6KzmMW2Jbs2M5JrQv8LxIQJiY9erfxnS4aXPOs8D62teWfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775075343; c=relaxed/simple;
	bh=cyVloOKlBhCnDRhPi410B9NBk2S3LXefMOQx82ut78I=;
	h=Date:To:From:Subject:Message-Id; b=VZcHabPAvcfLzi5HdmS+vlOCtX62CpPAlYBYDn+boOCeIktCJ1BwQw5KGM+PSeKAIce4lhWkRLaF1NXmPTcNHUiuucstnnNaFYwXkPC9/MXAJqR+RYTDMt4SOlEBzf/icGrzT/e1aqWDnCmZyOs8pmH+c1ACqE0a4Hg17MaE4vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZknOV4KW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZknOV4KW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D5BC4CEF7;
	Wed,  1 Apr 2026 20:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775075343;
	bh=cyVloOKlBhCnDRhPi410B9NBk2S3LXefMOQx82ut78I=;
	h=Date:To:From:Subject:From;
	b=ZknOV4KW9UMm3aWRFsql0fmoPHmrW4iQc42o5vSC/E/U6AnyVG/gmBTjTMqsPFj7J
	 BDLRpYvyM7zh3joFUOF+qMIDlWBiczFcm/vXnJEpTwMZlLp7xdq4ACl9nSrp0pbDKm
	 diUSFlkjkrWox16RPCIsDIpP5NRw03aRXl8qkbb0=
Date: Wed, 01 Apr 2026 13:29:02 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,devnexen@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops-fix-fix.patch removed from -mm tree
Message-Id: <20260401202902.F0D5BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops-fix-fix
has been removed from the -mm tree.  Its filename was
     shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops-fix-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops-fix-fix
Date: Tue Mar 31 09:04:03 PM PDT 2026

include file.h for fput()

Cc: David Carlier <devnexen@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/userfaultfd.c~shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops-fix-fix
+++ a/mm/userfaultfd.c
@@ -11,6 +11,7 @@
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/leafops.h>
+#include <linux/file.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/mmu_notifier.h>
 #include <linux/hugetlb.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

liveupdate-initialize-incoming-flb-state-before-finish-fix.patch
selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible-checkpatch-fixes.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

