Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B16019CD0E
	for <mm-commits@vger.kernel.org>; Thu, 27 Jun 2024 20:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719518400; cv=none; b=ItAKBx2b5VCn9EHWdN4z84tE9enI8wFIGkzlMVBcOwAiIuwNveR6VB4Y0ZKFO3fYd5tvdEC9SRu/mKVPTVIVjazaeg77rmANKWE7i0PsvsZdYYnmPIamx49q9pLMDF93ADuO87qbsJrx4atRImuufpF8y+I7byiv9TzwydAPNVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719518400; c=relaxed/simple;
	bh=B6Gka+vasX4jn9B206bo+LCrdDxR8urw+eYcEgzfklE=;
	h=Date:To:From:Subject:Message-Id; b=ZhqQPlst2yb92l5pXc6yzSFLQ8dX3/73IWfIlrDlqZnOllihkTUTjKqEiLDnrpus7iBZQqXNmOs/iefUYcT1clBrf6SzAu80zsMJFPAhOj2qmv2N+OJo+ZSHi3SXCctx2ECQiNF7rwCZqD9p9NavWRnVN3jRKLs2bLpx7K9NH/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yv4p52QF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yv4p52QF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68AEBC2BBFC;
	Thu, 27 Jun 2024 20:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719518400;
	bh=B6Gka+vasX4jn9B206bo+LCrdDxR8urw+eYcEgzfklE=;
	h=Date:To:From:Subject:From;
	b=Yv4p52QFplZMpVGBL5Jqt5EEcqza67tp0MOdt28W+JogekRUtLks4xlVrrYqWv6qA
	 ZV8PpG4/1jooMRz5X3GXlJ4L7URQ5o1pzJE7Eb86042vRiKSYu/t28IfucN7T9RgIr
	 ugkVptuQeNTmsZbOGNAT9QBRgMfqJX0zZFdobJcU=
Date: Thu, 27 Jun 2024 12:59:59 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,surenb@google.com,rppt@kernel.org,Liam.Howlett@oracle.com,gregkh@linuxfoundation.org,brauner@kernel.org,adobriyan@gmail.com,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-procfs-call-out-ioctl-based-procmap_query-command-existence.patch added to mm-unstable branch
Message-Id: <20240627200000.68AEBC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs/procfs: call out ioctl()-based PROCMAP_QUERY command existence
has been added to the -mm mm-unstable branch.  Its filename is
     docs-procfs-call-out-ioctl-based-procmap_query-command-existence.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-procfs-call-out-ioctl-based-procmap_query-command-existence.patch

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
From: Andrii Nakryiko <andrii@kernel.org>
Subject: docs/procfs: call out ioctl()-based PROCMAP_QUERY command existence
Date: Thu, 27 Jun 2024 10:08:56 -0700

Call out PROCMAP_QUERY ioctl() existence in the section describing
/proc/PID/maps file in documentation.  We refer user to UAPI header for
low-level details of this programmatic interface.

Link: https://lkml.kernel.org/r/20240627170900.1672542-5-andrii@kernel.org
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/Documentation/filesystems/proc.rst~docs-procfs-call-out-ioctl-based-procmap_query-command-existence
+++ a/Documentation/filesystems/proc.rst
@@ -443,6 +443,15 @@ is not associated with a file:
 
  or if empty, the mapping is anonymous.
 
+Starting with 6.11 kernel, /proc/PID/maps provides an alternative
+ioctl()-based API that gives ability to flexibly and efficiently query and
+filter individual VMAs. This interface is binary and is meant for more
+efficient and easy programmatic use. `struct procmap_query`, defined in
+linux/fs.h UAPI header, serves as an input/output argument to the
+`PROCMAP_QUERY` ioctl() command. See comments in linus/fs.h UAPI header for
+details on query semantics, supported flags, data returned, and general API
+usage information.
+
 The /proc/PID/smaps is an extension based on maps, showing the memory
 consumption for each of the process's mappings. For each mapping (aka Virtual
 Memory Area, or VMA) there is a series of lines such as the following::
_

Patches currently in -mm which might be from andrii@kernel.org are

fs-procfs-extract-logic-for-getting-vma-name-constituents.patch
fs-procfs-implement-efficient-vma-querying-api-for-proc-pid-maps.patch
fs-procfs-add-build-id-fetching-to-procmap_query-api.patch
docs-procfs-call-out-ioctl-based-procmap_query-command-existence.patch
tools-sync-uapi-linux-fsh-header-into-tools-subdir.patch
selftests-proc-add-procmap_query-ioctl-tests.patch

