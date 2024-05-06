Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A2026AD5
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957063; cv=none; b=T4fjXnYC90w46mqv95g4tmIWHwsMKCMtWRdWe6czxGoEQkQ+Tw33IAll4l6/C96a2sg4CuF8JetsSbnr841jTfkDU8+N2lWgqWaPJbgbQ/ExG5x/moRhBM8s6PBNs/7FxT0oG+9bk4XNcohqn/LWJXil4wa3Kqmp1Qkw1/ox8yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957063; c=relaxed/simple;
	bh=4+AD5XVtCq71Er3PsyEJTFgf/81Q+8J8qTEwb+zE7KM=;
	h=Date:To:From:Subject:Message-Id; b=Tc11E3utn9YoqMMgojOq3behDOB7KoesSL3bWHM42lMusy5RK3berfFMDGCdKNp4fjm/TLq+mgj8BMkjVLJMfY7EwmiuIWDBtGogsujRYVP9SwnQ7jNCiDUzsEqxksgOfV8T3FpKhTZipS2dVmytgQjbxQ2qAOCYPjRgfA1q5Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AWEmhkn1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AWEmhkn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C500C113CC;
	Mon,  6 May 2024 00:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957063;
	bh=4+AD5XVtCq71Er3PsyEJTFgf/81Q+8J8qTEwb+zE7KM=;
	h=Date:To:From:Subject:From;
	b=AWEmhkn1TaADADT1mY4J1K/b2e78XYOnUQgFLs3JI0BqLGnImeO3WaJOeQj3aSEg1
	 1bWD3MSX/6ZmGg9igPEI4L/IiIfxnJf+D+Ja4oSmJLTj4p3MSVoVXEHGcB7KHj2o/T
	 DNZwTqDk5AiXWCfKh5AYLZu83+hLwOcuHU+oh00M=
Date: Sun, 05 May 2024 17:57:42 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,p.raghav@samsung.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] doc-split-bufferrst-out-of-api-summaryrst.patch removed from -mm tree
Message-Id: <20240506005743.1C500C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: doc: split buffer.rst out of api-summary.rst
has been removed from the -mm tree.  Its filename was
     doc-split-bufferrst-out-of-api-summaryrst.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: doc: split buffer.rst out of api-summary.rst
Date: Tue, 16 Apr 2024 04:17:52 +0100

Buffer heads are no longer a generic filesystem API but an optional
filesystem support library.  Make the documentation structure reflect
that, and include the fine documentation kept in buffer_head.h.  We could
give a better overview of what buffer heads are all about, but my
enthusiasm for documenting it is limited.

[willy@infradead.org: fix kerneldoc warning]
  Link: https://lkml.kernel.org/r/20240417015933.453505-1-willy@infradead.org
[akpm@linux-foundation.org: remove newline at EOF]
Link: https://lkml.kernel.org/r/20240416031754.4076917-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/api-summary.rst |    3 ---
 Documentation/filesystems/buffer.rst      |   12 ++++++++++++
 Documentation/filesystems/index.rst       |    1 +
 3 files changed, 13 insertions(+), 3 deletions(-)

--- a/Documentation/filesystems/api-summary.rst~doc-split-bufferrst-out-of-api-summaryrst
+++ a/Documentation/filesystems/api-summary.rst
@@ -56,9 +56,6 @@ Other Functions
 .. kernel-doc:: fs/namei.c
    :export:
 
-.. kernel-doc:: fs/buffer.c
-   :export:
-
 .. kernel-doc:: block/bio.c
    :export:
 
--- /dev/null
+++ a/Documentation/filesystems/buffer.rst
@@ -0,0 +1,12 @@
+Buffer Heads
+============
+
+Linux uses buffer heads to maintain state about individual filesystem blocks.
+Buffer heads are deprecated and new filesystems should use iomap instead.
+
+Functions
+---------
+
+.. kernel-doc:: include/linux/buffer_head.h
+.. kernel-doc:: fs/buffer.c
+   :export:
--- a/Documentation/filesystems/index.rst~doc-split-bufferrst-out-of-api-summaryrst
+++ a/Documentation/filesystems/index.rst
@@ -50,6 +50,7 @@ filesystem implementations.
 .. toctree::
    :maxdepth: 2
 
+   buffer
    journalling
    fscrypt
    fsverity
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

