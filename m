Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159897493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="STjF/onO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4463C433C9;
	Mon, 11 Dec 2023 01:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257782;
	bh=nhoLbvHjkYFaSaE7aETpwjM5Obc7VbU5ZihJS4zwzN4=;
	h=Date:To:From:Subject:From;
	b=STjF/onOSGfFQN3y5AdFoVHocFUyXlwbpSwwEmUOkwQKpWVP+3zmTsJFo67+44c78
	 hRVinN0pdZUGaj5h6mrNTmQYKxsk7QEfX2PIYDnRZmQAZYwxEjjcipIDmrazG7IrqV
	 K0HDrPrhXo8/I3TIUqL3alGG7HEOm7JXgi2lpP34=
Date: Sun, 10 Dec 2023 17:23:02 -0800
To: mm-commits@vger.kernel.org,serge@hallyn.com,phillip@squashfs.org.uk,corbet@lwn.net,bagasdotme@gmail.com,amiculas@cisco.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] docs-filesystems-document-the-squashfs-specific-mount-options.patch removed from -mm tree
Message-Id: <20231211012302.D4463C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: filesystems: document the squashfs specific mount options
has been removed from the -mm tree.  Its filename was
     docs-filesystems-document-the-squashfs-specific-mount-options.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ariel Miculas <amiculas@cisco.com>
Subject: docs: filesystems: document the squashfs specific mount options
Date: Fri, 17 Nov 2023 18:12:14 +0200

When SQUASHFS_CHOICE_DECOMP_BY_MOUNT is set, the "threads" mount option
can be used to specify the decompression mode: single-threaded,
multi-threaded, percpu or the number of threads used for decompression. 
When SQUASHFS_CHOICE_DECOMP_BY_MOUNT is not set, SQUASHFS_DECOMP_MULTI and
SQUASHFS_MOUNT_DECOMP_THREADS are both set, the "threads" option can also
be used to specify the number of threads used for decompression.  This
mount option is only mentioned in fs/squashfs/Kconfig, which makes it
difficult to find.

Another mount option available is "errors", which can be configured to
panic the kernel when squashfs errors are encountered.

Add both these options to the squashfs documentation, making them more
noticeable.

Link: https://lkml.kernel.org/r/20231117161215.140282-1-amiculas@cisco.com
Signed-off-by: Ariel Miculas <amiculas@cisco.com>
Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Serge Hallyn <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/squashfs.rst |   60 +++++++++++++++++++++++
 1 file changed, 60 insertions(+)

--- a/Documentation/filesystems/squashfs.rst~docs-filesystems-document-the-squashfs-specific-mount-options
+++ a/Documentation/filesystems/squashfs.rst
@@ -64,6 +64,66 @@ obtained from this site also.
 The squashfs-tools development tree is now located on kernel.org
 	git://git.kernel.org/pub/scm/fs/squashfs/squashfs-tools.git
 
+2.1 Mount options
+-----------------
+===================    =========================================================
+errors=%s              Specify whether squashfs errors trigger a kernel panic
+                       or not
+
+		       ==========  =============================================
+                         continue  errors don't trigger a panic (default)
+                            panic  trigger a panic when errors are encountered,
+                                   similar to several other filesystems (e.g.
+                                   btrfs, ext4, f2fs, GFS2, jfs, ntfs, ubifs)
+
+                                   This allows a kernel dump to be saved,
+                                   useful for analyzing and debugging the
+                                   corruption.
+                       ==========  =============================================
+threads=%s             Select the decompression mode or the number of threads
+
+                       If SQUASHFS_CHOICE_DECOMP_BY_MOUNT is set:
+
+		       ==========  =============================================
+                           single  use single-threaded decompression (default)
+
+                                   Only one block (data or metadata) can be
+                                   decompressed at any one time. This limits
+                                   CPU and memory usage to a minimum, but it
+                                   also gives poor performance on parallel I/O
+                                   workloads when using multiple CPU machines
+                                   due to waiting on decompressor availability.
+                            multi  use up to two parallel decompressors per core
+
+                                   If you have a parallel I/O workload and your
+                                   system has enough memory, using this option
+                                   may improve overall I/O performance. It
+                                   dynamically allocates decompressors on a
+                                   demand basis.
+                           percpu  use a maximum of one decompressor per core
+
+                                   It uses percpu variables to ensure
+                                   decompression is load-balanced across the
+                                   cores.
+                        1|2|3|...  configure the number of threads used for
+                                   decompression
+
+                                   The upper limit is num_online_cpus() * 2.
+                       ==========  =============================================
+
+                       If SQUASHFS_CHOICE_DECOMP_BY_MOUNT is **not** set and
+                       SQUASHFS_DECOMP_MULTI, SQUASHFS_MOUNT_DECOMP_THREADS are
+                       both set:
+
+		       ==========  =============================================
+                          2|3|...  configure the number of threads used for
+                                   decompression
+
+                                   The upper limit is num_online_cpus() * 2.
+                       ==========  =============================================
+
+===================    =========================================================
+
 3. Squashfs Filesystem Design
 -----------------------------
 
_

Patches currently in -mm which might be from amiculas@cisco.com are


