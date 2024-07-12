Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BC31BDC3
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824227; cv=none; b=iui9fdgBlUHkGAt6BM7YiLfcaWf/1NtWLFUFoVM47IkhlXzLu6MPogPqx0ak5ZMNB2UOviGBC2dOas0zq85HwdhvRHlrqkwuNORcHLflUpcu0dA6eodIb0rHi2BP9jfZr3oF5TxUL9gZvnxU2+JNWYKS5vAKokm3ILpjMfQiMiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824227; c=relaxed/simple;
	bh=MM4YfWJzHU3/heBUx6rnxFCSTgMThkslAFmh+bLfqiw=;
	h=Date:To:From:Subject:Message-Id; b=bc1+Ae6LV1Pru2dm3BxYGlw+caKVK3SqiFsb1n9gN1BBt5z2Jf8lghJdHd9EvLzjdix0bFTColqxo79F7Z2nvK38OzM8wF9FMyk/Zc7Nx/AAl8TMojQmJPR7+PgBfFnIunrbsXpsBhjO6E266I8Dah4vD5imFqnyDp16JvLqVY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jkHymNeK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jkHymNeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E7DC32782;
	Fri, 12 Jul 2024 22:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824227;
	bh=MM4YfWJzHU3/heBUx6rnxFCSTgMThkslAFmh+bLfqiw=;
	h=Date:To:From:Subject:From;
	b=jkHymNeKNB1fKVX2tJ+Wu5iMxKwMEA0QOR2M9uCUf97r2YlHuJdcr33w50gvA4QBf
	 05PyfVFwW36D2eafG5Xua4JBB7KDqlLNPCIQ7/ieccJ2c8LibNwTcK1u3RLc0Z42Y4
	 mixAF/A42wdURVoz4n2gx508lUNFWSvR4b7IGpQU=
Date: Fri, 12 Jul 2024 15:43:46 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,surenb@google.com,sfr@canb.auug.org.au,rppt@kernel.org,Liam.Howlett@Oracle.com,gregkh@linuxfoundation.org,brauner@kernel.org,arnd@arndb.de,ak@linux.intel.com,adobriyan@gmail.com,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fs-procfs-implement-efficient-vma-querying-api-for-proc-pid-maps-fix.patch removed from -mm tree
Message-Id: <20240712224347.30E7DC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/procfs: improve PROCMAP_QUERY's compat mode handling
has been removed from the -mm tree.  Its filename was
     fs-procfs-implement-efficient-vma-querying-api-for-proc-pid-maps-fix.patch

This patch was dropped because it was folded into fs-procfs-implement-efficient-vma-querying-api-for-proc-pid-maps.patch

------------------------------------------------------
From: Andrii Nakryiko <andrii@kernel.org>
Subject: fs/procfs: improve PROCMAP_QUERY's compat mode handling
Date: Mon, 1 Jul 2024 10:48:05 -0700

Kernel provides compat_ptr_ioctl() wrapper to sanitize pointers for 32-bit
processes on 64-bit host architectures.  Given procfs_procmap_ioctl()
always expects pointer argument, this is exactly what we need.

This has any effect only on 32-bit processes on s390 architecture.

Link: https://lkml.kernel.org/r/20240701174805.1897344-2-andrii@kernel.org
Fixes: 3757be498749 ("fs/procfs: implement efficient VMA querying API for /proc/<pid>/maps")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-procfs-implement-efficient-vma-querying-api-for-proc-pid-maps-fix
+++ a/fs/proc/task_mmu.c
@@ -614,7 +614,7 @@ const struct file_operations proc_pid_ma
 	.llseek		= seq_lseek,
 	.release	= proc_map_release,
 	.unlocked_ioctl = procfs_procmap_ioctl,
-	.compat_ioctl	= procfs_procmap_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
 };
 
 /*
_

Patches currently in -mm which might be from andrii@kernel.org are

fs-procfs-extract-logic-for-getting-vma-name-constituents.patch
fs-procfs-implement-efficient-vma-querying-api-for-proc-pid-maps.patch
fs-procfs-add-build-id-fetching-to-procmap_query-api.patch
fs-procfs-add-build-id-fetching-to-procmap_query-api-fix.patch
docs-procfs-call-out-ioctl-based-procmap_query-command-existence.patch
tools-sync-uapi-linux-fsh-header-into-tools-subdir.patch
selftests-proc-add-procmap_query-ioctl-tests.patch

