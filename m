Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A3682886
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824851; cv=none; b=eXkThBKTmIXDXxL9QPkEg99utU7S6/IP/mUZ2ZIvLr5b7myB6KFYsK/COfPsOjYROpHDjdkH0U3zzYBjMH+JisGlBM22bv+/4zZyRcCqClQ/yDfCaTzrWzY6P//WzwOeizP3wqI3zVbJPzS0YIP0IFB/uAje041QS7R6OQyKHSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824851; c=relaxed/simple;
	bh=AzDEL8bB6VK12xH2gSyx6WElk5twQ2cEsP2k16in/kA=;
	h=Date:To:From:Subject:Message-Id; b=Z9rBIHcl/iEkTJRiUychzgNxFXicLWn+MWjvJYaadkbhI/ACuHfud0n3HOqvLOkXqTaplg1WKT9qYE+xBJTXypQmfyxX3eBK35kdroUV9xdjY0+vYVrpONJXfmraMXCCjIiVtsWsRd+FXF2yevES7PET9uCaOuXW7LalGolDm/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u7giqISt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u7giqISt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504FBC32782;
	Fri, 12 Jul 2024 22:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824851;
	bh=AzDEL8bB6VK12xH2gSyx6WElk5twQ2cEsP2k16in/kA=;
	h=Date:To:From:Subject:From;
	b=u7giqIStk/hgslhJCfIR824i3cSUxGNEFWpG6WPUdKv0BTGx3gO2gQCc/+ykbP2Qt
	 Tcxkh8bV07jmVB1dlBlhk+Tm7FiQJsavsvwPnud7Kut94+IW8dECt8T4P5vokeY0X5
	 nl8eqJlghl2MWDniIlQw8Uyvn64A1tgsK0WYTAEg=
Date: Fri, 12 Jul 2024 15:54:10 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,surenb@google.com,sfr@canb.auug.org.au,rppt@kernel.org,Liam.Howlett@Oracle.com,gregkh@linuxfoundation.org,brauner@kernel.org,arnd@arndb.de,ak@linux.intel.com,adobriyan@gmail.com,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-procfs-call-out-ioctl-based-procmap_query-command-existence.patch removed from -mm tree
Message-Id: <20240712225411.504FBC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs/procfs: call out ioctl()-based PROCMAP_QUERY command existence
has been removed from the -mm tree.  Its filename was
     docs-procfs-call-out-ioctl-based-procmap_query-command-existence.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrii Nakryiko <andrii@kernel.org>
Subject: docs/procfs: call out ioctl()-based PROCMAP_QUERY command existence
Date: Thu, 27 Jun 2024 10:08:56 -0700

Call out PROCMAP_QUERY ioctl() existence in the section describing
/proc/PID/maps file in documentation.  We refer user to UAPI header for
low-level details of this programmatic interface.

Link: https://lkml.kernel.org/r/20240627170900.1672542-5-andrii@kernel.org
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
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


