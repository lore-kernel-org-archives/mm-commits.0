Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BB2393DDC
	for <mm-commits@vger.kernel.org>; Fri, 22 Aug 2025 23:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755903663; cv=none; b=rxP9xe1XyE/2Jf9qyFuR96hHxczOLMvTJsJ+XLaztOfOoSRpYCyQjsejRVk6/bBusiWVZTsfBQcYm0cQ+c4vroAt+pZGsW9YJJq+ac1BHLXJjkNwaUGsAzbEMetRme2kYqcX4fVBOzbZpHRMZ+R3wBEQ26nj/UAfEQD7DVwQe7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755903663; c=relaxed/simple;
	bh=w3WwT4XZpMBxSfy/Ce4diTFJ1DaXYGmKfresIx6xdc0=;
	h=Date:To:From:Subject:Message-Id; b=CXlXZp013t6Hep07PRADTdXxaTt+3P6D6muiC4VQcVL8IM15o04mynlixfFYq878P/dRWXfdUmElieXTZwlm1YBOGVgYJEjIucZC9jcnt9WOYGYwnXFtYU17AchOtkDNuzfXlnQ/qDKhzfGeRfCEaP759gGaCA0rFWYZ8oIQtII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W/LuT7tb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W/LuT7tb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86782C4CEED;
	Fri, 22 Aug 2025 23:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755903662;
	bh=w3WwT4XZpMBxSfy/Ce4diTFJ1DaXYGmKfresIx6xdc0=;
	h=Date:To:From:Subject:From;
	b=W/LuT7tbvhqPUPsD8aLtrL0rkh3U8eSnCLT/6HKTEtT8flNkjR9+vuwlJnHpEuwpN
	 XRvJTXgBjiGZ8aCU1HwqRem9bWHO+27fz0/0gAULfT6SXsqJ7BU6sCG9TVPMgccnRT
	 8BlqjOtkoxOlUknfrH8axNrTS4/7sE1aQ36jEXTg=
Date: Fri, 22 Aug 2025 16:01:01 -0700
To: mm-commits@vger.kernel.org,yebin10@huawei.com,wangzijie1@honor.com,viro@zeniv.linux.org.uk,rick.p.edgecombe@intel.com,kirill.shutemov@linux.intel.com,brauner@kernel.org,ast@kernel.org,adobriyan@gmail.com,sbrivio@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-bring-back-lseek-operations-for-proc-net-entries.patch added to mm-hotfixes-unstable branch
Message-Id: <20250822230102.86782C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: bring back lseek() operations for /proc/net entries
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     proc-bring-back-lseek-operations-for-proc-net-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-bring-back-lseek-operations-for-proc-net-entries.patch

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
From: Stefano Brivio <sbrivio@redhat.com>
Subject: proc: bring back lseek() operations for /proc/net entries
Date: Fri, 22 Aug 2025 19:23:35 +0200

Commit ff7ec8dc1b64 ("proc: use the same treatment to check proc_lseek as
ones for proc_read_iter et.al") breaks lseek() for all /proc/net entries,
as shown for instance by pasta(1), a user-mode network implementation
using those entries to scan for bound ports:

  $ strace -e openat,lseek -e s=none pasta -- true
  [...]
  openat(AT_FDCWD, "/proc/net/tcp", O_RDONLY|O_CLOEXEC) = 12
  openat(AT_FDCWD, "/proc/net/tcp6", O_RDONLY|O_CLOEXEC) = 13
  lseek(12, 0, SEEK_SET)                  = -1 ESPIPE (Illegal seek)
  lseek() failed on /proc/net file: Illegal seek
  lseek(13, 0, SEEK_SET)                  = -1 ESPIPE (Illegal seek)
  lseek() failed on /proc/net file: Illegal seek
  openat(AT_FDCWD, "/proc/net/udp", O_RDONLY|O_CLOEXEC) = 14
  openat(AT_FDCWD, "/proc/net/udp6", O_RDONLY|O_CLOEXEC) = 15
  lseek(14, 0, SEEK_SET)                  = -1 ESPIPE (Illegal seek)
  lseek() failed on /proc/net file: Illegal seek
  lseek(15, 0, SEEK_SET)                  = -1 ESPIPE (Illegal seek)
  lseek() failed on /proc/net file: Illegal seek
  [...]

That's because PROC_ENTRY_proc_lseek isn't set for /proc/net entries, and
it's now mandatory for lseek().  In fact, flags aren't set at all for
those entries because pde_set_flags() isn't called for them.

As commit d919b33dafb3 ("proc: faster open/read/close with "permanent"
files") introduced flags for procfs directory entries, along with the
pde_set_flags() helper, they weren't relevant for /proc/net entries, so
the lack of pde_set_flags() calls in proc_create_net_*() functions was
harmless.

Now that the calls are strictly needed for lseek() functionality, add
them.

Link: https://lkml.kernel.org/r/20250822172335.3187858-1-sbrivio@redhat.com
Fixes: ff7ec8dc1b64 ("proc: use the same treatment to check proc_lseek as ones for proc_read_iter et.al")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: wangzijie <wangzijie1@honor.com>
Cc: Ye Bin <yebin10@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c  |    2 +-
 fs/proc/internal.h |    1 +
 fs/proc/proc_net.c |    4 ++++
 3 files changed, 6 insertions(+), 1 deletion(-)

--- a/fs/proc/generic.c~proc-bring-back-lseek-operations-for-proc-net-entries
+++ a/fs/proc/generic.c
@@ -561,7 +561,7 @@ struct proc_dir_entry *proc_create_reg(c
 	return p;
 }
 
-static void pde_set_flags(struct proc_dir_entry *pde)
+void pde_set_flags(struct proc_dir_entry *pde)
 {
 	if (pde->proc_ops->proc_flags & PROC_ENTRY_PERMANENT)
 		pde->flags |= PROC_ENTRY_PERMANENT;
--- a/fs/proc/internal.h~proc-bring-back-lseek-operations-for-proc-net-entries
+++ a/fs/proc/internal.h
@@ -284,6 +284,7 @@ extern struct dentry *proc_lookup(struct
 struct dentry *proc_lookup_de(struct inode *, struct dentry *, struct proc_dir_entry *);
 extern int proc_readdir(struct file *, struct dir_context *);
 int proc_readdir_de(struct file *, struct dir_context *, struct proc_dir_entry *);
+void pde_set_flags(struct proc_dir_entry *pde);
 
 static inline void pde_get(struct proc_dir_entry *pde)
 {
--- a/fs/proc/proc_net.c~proc-bring-back-lseek-operations-for-proc-net-entries
+++ a/fs/proc/proc_net.c
@@ -124,6 +124,7 @@ struct proc_dir_entry *proc_create_net_d
 	p->proc_ops = &proc_net_seq_ops;
 	p->seq_ops = ops;
 	p->state_size = state_size;
+	pde_set_flags(p);
 	return proc_register(parent, p);
 }
 EXPORT_SYMBOL_GPL(proc_create_net_data);
@@ -170,6 +171,7 @@ struct proc_dir_entry *proc_create_net_d
 	p->seq_ops = ops;
 	p->state_size = state_size;
 	p->write = write;
+	pde_set_flags(p);
 	return proc_register(parent, p);
 }
 EXPORT_SYMBOL_GPL(proc_create_net_data_write);
@@ -217,6 +219,7 @@ struct proc_dir_entry *proc_create_net_s
 	pde_force_lookup(p);
 	p->proc_ops = &proc_net_single_ops;
 	p->single_show = show;
+	pde_set_flags(p);
 	return proc_register(parent, p);
 }
 EXPORT_SYMBOL_GPL(proc_create_net_single);
@@ -261,6 +264,7 @@ struct proc_dir_entry *proc_create_net_s
 	p->proc_ops = &proc_net_single_ops;
 	p->single_show = show;
 	p->write = write;
+	pde_set_flags(p);
 	return proc_register(parent, p);
 }
 EXPORT_SYMBOL_GPL(proc_create_net_single_write);
_

Patches currently in -mm which might be from sbrivio@redhat.com are

proc-bring-back-lseek-operations-for-proc-net-entries.patch

