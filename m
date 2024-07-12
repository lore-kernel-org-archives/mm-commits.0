Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C9F6CDB3
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824847; cv=none; b=WL6uLc9R9TtMO90qiy0WgTu0+5dpPw0VdJbatcyVPoXEqXOhs03LeR0GEfyy4y9cuYsxCtaiBkYsNFQxc2slC0q3+//ZW3iaqOb0Dlf3qeK89X/t2xxhoR0W7FYjfr8fBBbvb3BReHtNXsIW8vZPMAE2sX97nxEt+Ibi5ihXONM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824847; c=relaxed/simple;
	bh=r28GkkxBNUuxOGCV6nWEMbIiO44mTSieyHKDVR5HWlE=;
	h=Date:To:From:Subject:Message-Id; b=eiOz1HG7dGfX+k4VynXWm+9YplqGvyVdxeW1yjlFi1yXDxJODzU+AajC4PaMhFl8aS6lQ9hPq/QdXawSreLjwGVrZLIlClke5cdViA/wOEdt6A5lqeeAxf5hwor1puAaqDCUc1BcsH3YxXtsjvnXJrygPVq/JoWZIBaOxJb5TMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bev9l8Ej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bev9l8Ej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD35C32782;
	Fri, 12 Jul 2024 22:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824847;
	bh=r28GkkxBNUuxOGCV6nWEMbIiO44mTSieyHKDVR5HWlE=;
	h=Date:To:From:Subject:From;
	b=bev9l8EjIo3QuE8VjFK3zc4Oy6C4y2Rd4LdDOAuhos6WuB++NLJAyop9dEFja9FXo
	 qM2gfn+aHxk1hdV0GTrxtPUaD4XbkzLDENS1N2y6E6CXnA+IGpQN8U/07GActzxLEU
	 UlYufB+nW7l6kssg+GL22FNhpEeb9Bjl6ANZeZf8=
Date: Fri, 12 Jul 2024 15:54:07 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,surenb@google.com,sfr@canb.auug.org.au,rppt@kernel.org,Liam.Howlett@Oracle.com,gregkh@linuxfoundation.org,brauner@kernel.org,arnd@arndb.de,ak@linux.intel.com,adobriyan@gmail.com,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-procfs-extract-logic-for-getting-vma-name-constituents.patch removed from -mm tree
Message-Id: <20240712225407.8FD35C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/procfs: extract logic for getting VMA name constituents
has been removed from the -mm tree.  Its filename was
     fs-procfs-extract-logic-for-getting-vma-name-constituents.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrii Nakryiko <andrii@kernel.org>
Subject: fs/procfs: extract logic for getting VMA name constituents
Date: Thu, 27 Jun 2024 10:08:53 -0700

Patch series "ioctl()-based API to query VMAs from /proc/<pid>/maps", v6.

Implement binary ioctl()-based interface to /proc/<pid>/maps file to allow
applications to query VMA information more efficiently than reading *all*
VMAs nonselectively through text-based interface of /proc/<pid>/maps file.

Patch #2 goes into a lot of details and background on some common patterns
of using /proc/<pid>/maps in the area of performance profiling and
subsequent symbolization of captured stack traces.  As mentioned in that
patch, patterns of VMA querying can differ depending on specific use case,
but can generally be grouped into two main categories: the need to query a
small subset of VMAs covering a given batch of addresses, or
reading/storing/caching all (typically, executable) VMAs upfront for later
processing.

The new PROCMAP_QUERY ioctl() API added in this patch set was motivated by
the former pattern of usage.  Earlier revisions had a patch adding a tool
that faithfully reproduces an efficient VMA matching pass of a symbolizer,
collecting a subset of covering VMAs for a given set of addresses as
efficiently as possible.  This tool served both as a testing ground, as
well as a benchmarking tool.  It implements everything both for currently
existing text-based /proc/<pid>/maps interface, as well as for newly-added
PROCMAP_QUERY ioctl().  This revision dropped the tool from the patch set
and, once the API lands upstream, this tool might be added separately on
Github as an example.

Based on discussion on earlier revisions of this patch set, it turned out
that this ioctl() API is competitive with highly-optimized text-based
pre-processing pattern that perf tool is using.  Based on perf discussion,
this revision adds more flexibility in specifying a subset of VMAs that
are of interest.  Now it's possible to specify desired permissions of VMAs
(e.g., request only executable ones) and/or restrict to only a subset of
VMAs that have file backing.  This further improves the efficiency when
using this new API thanks to more selective (executable VMAs only)
querying.

In addition to a custom benchmarking tool, and experimental perf
integration (available at [0]), Daniel Mueller has since also implemented
an experimental integration into blazesym (see [1]), a library used for
stack trace symbolization by our server fleet-wide profiler and another
on-device profiler agent that runs on weaker ARM devices.  The latter
ARM-based device profiler is especially sensitive to performance, and so
we benchmarked and compared text-based /proc/<pid>/maps solution to the
equivalent one using PROCMAP_QUERY ioctl().

Results are very encouraging, giving us 5x improvement for end-to-end
so-called "address normalization" pass, which is the part of the
symbolization process that happens locally on ARM device, before being
sent out for further heavier-weight processing on more powerful remote
server.  Note that this is not an artificial microbenchmark.  It's a full
end-to-end API call being measured with real-world data on real-world
device.

  TEXT-BASED
  ==========
  Benchmarking main/normalize_process_no_build_ids_uncached_maps
  main/normalize_process_no_build_ids_uncached_maps
	  time:   [49.777 µs 49.982 µs 50.250 µs]

  IOCTL-BASED
  ===========
  Benchmarking main/normalize_process_no_build_ids_uncached_maps
  main/normalize_process_no_build_ids_uncached_maps
	  time:   [10.328 µs 10.391 µs 10.457 µs]
	  change: [−79.453% −79.304% −79.166%] (p = 0.00 < 0.02)
	  Performance has improved.

You can see above that we see the drop from 50µs down to 10µs for
exactly the same amount of work, with the same data and target process.

With the aforementioned custom tool, we see about ~40x improvement (it
might vary a bit, depending on a specific captured set of addresses).  And
even for perf-based benchmark it's on par or slightly ahead when using
permission-based filtering (fetching only executable VMAs).

Earlier revisions attempted to use per-VMA locking, if kernel was compiled
with CONFIG_PER_VMA_LOCK=y, but it turned out that anon_vma_name() is not
yet compatible with per-VMA locking and assumes mmap_lock to be taken,
which makes the use of per-VMA locking for this API premature.  It was
agreed ([2]) to continue for now with just mmap_lock, but the code
structure is such that it should be easy to add per-VMA locking support
once all the pieces are ready.

One thing that did not change was basing this new API as an ioctl()
command on /proc/<pid>/maps file.  An ioctl-based API on top of pidfd was
considered, but has its own downsides.  Implementing ioctl() directly on
pidfd will cause access permission checks on every single ioctl(), which
leads to performance concerns and potential spam of capable() audit
messages.  It also prevents a nice pattern, possible with
/proc/<pid>/maps, in which application opens /proc/self/maps FD (requiring
no additional capabilities) and passed this FD to profiling agent for
querying.  To achieve similar pattern, a new file would have to be created
from pidf just for VMA querying, which is considered to be inferior to
just querying /proc/<pid>/maps FD as proposed in current approach.  These
aspects were discussed in the hallway track at recent LSF/MM/BPF 2024 and
sticking to procfs ioctl() was the final agreement we arrived at.

  [0] https://github.com/anakryiko/linux/commits/procfs-proc-maps-ioctl-v2/
  [1] https://github.com/libbpf/blazesym/pull/675
  [2] https://lore.kernel.org/bpf/7rm3izyq2vjp5evdjc7c6z4crdd3oerpiknumdnmmemwyiwx7t@hleldw7iozi3/


This patch (of 6):

Extract generic logic to fetch relevant pieces of data to describe VMA
name.  This could be just some string (either special constant or
user-provided), or a string with some formatted wrapping text (e.g.,
"[anon_shmem:<something>]"), or, commonly, file path.  seq_file-based
logic has different methods to handle all three cases, but they are
currently mixed in with extracting underlying sources of data.

This patch splits this into data fetching and data formatting, so that
data fetching can be reused later on.

There should be no functional changes.

Link: https://lkml.kernel.org/r/20240627170900.1672542-1-andrii@kernel.org
Link: https://lkml.kernel.org/r/20240627170900.1672542-2-andrii@kernel.org
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

 fs/proc/task_mmu.c |  125 ++++++++++++++++++++++++-------------------
 1 file changed, 71 insertions(+), 54 deletions(-)

--- a/fs/proc/task_mmu.c~fs-procfs-extract-logic-for-getting-vma-name-constituents
+++ a/fs/proc/task_mmu.c
@@ -239,6 +239,67 @@ static int do_maps_open(struct inode *in
 				sizeof(struct proc_maps_private));
 }
 
+static void get_vma_name(struct vm_area_struct *vma,
+			 const struct path **path,
+			 const char **name,
+			 const char **name_fmt)
+{
+	struct anon_vma_name *anon_name = vma->vm_mm ? anon_vma_name(vma) : NULL;
+
+	*name = NULL;
+	*path = NULL;
+	*name_fmt = NULL;
+
+	/*
+	 * Print the dentry name for named mappings, and a
+	 * special [heap] marker for the heap:
+	 */
+	if (vma->vm_file) {
+		/*
+		 * If user named this anon shared memory via
+		 * prctl(PR_SET_VMA ..., use the provided name.
+		 */
+		if (anon_name) {
+			*name_fmt = "[anon_shmem:%s]";
+			*name = anon_name->name;
+		} else {
+			*path = file_user_path(vma->vm_file);
+		}
+		return;
+	}
+
+	if (vma->vm_ops && vma->vm_ops->name) {
+		*name = vma->vm_ops->name(vma);
+		if (*name)
+			return;
+	}
+
+	*name = arch_vma_name(vma);
+	if (*name)
+		return;
+
+	if (!vma->vm_mm) {
+		*name = "[vdso]";
+		return;
+	}
+
+	if (vma_is_initial_heap(vma)) {
+		*name = "[heap]";
+		return;
+	}
+
+	if (vma_is_initial_stack(vma)) {
+		*name = "[stack]";
+		return;
+	}
+
+	if (anon_name) {
+		*name_fmt = "[anon:%s]";
+		*name = anon_name->name;
+		return;
+	}
+}
+
 static void show_vma_header_prefix(struct seq_file *m,
 				   unsigned long start, unsigned long end,
 				   vm_flags_t flags, unsigned long long pgoff,
@@ -262,17 +323,15 @@ static void show_vma_header_prefix(struc
 static void
 show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 {
-	struct anon_vma_name *anon_name = NULL;
-	struct mm_struct *mm = vma->vm_mm;
-	struct file *file = vma->vm_file;
+	const struct path *path;
+	const char *name_fmt, *name;
 	vm_flags_t flags = vma->vm_flags;
 	unsigned long ino = 0;
 	unsigned long long pgoff = 0;
 	unsigned long start, end;
 	dev_t dev = 0;
-	const char *name = NULL;
 
-	if (file) {
+	if (vma->vm_file) {
 		const struct inode *inode = file_user_inode(vma->vm_file);
 
 		dev = inode->i_sb->s_dev;
@@ -283,57 +342,15 @@ show_map_vma(struct seq_file *m, struct
 	start = vma->vm_start;
 	end = vma->vm_end;
 	show_vma_header_prefix(m, start, end, flags, pgoff, dev, ino);
-	if (mm)
-		anon_name = anon_vma_name(vma);
 
-	/*
-	 * Print the dentry name for named mappings, and a
-	 * special [heap] marker for the heap:
-	 */
-	if (file) {
+	get_vma_name(vma, &path, &name, &name_fmt);
+	if (path) {
 		seq_pad(m, ' ');
-		/*
-		 * If user named this anon shared memory via
-		 * prctl(PR_SET_VMA ..., use the provided name.
-		 */
-		if (anon_name)
-			seq_printf(m, "[anon_shmem:%s]", anon_name->name);
-		else
-			seq_path(m, file_user_path(file), "\n");
-		goto done;
-	}
-
-	if (vma->vm_ops && vma->vm_ops->name) {
-		name = vma->vm_ops->name(vma);
-		if (name)
-			goto done;
-	}
-
-	name = arch_vma_name(vma);
-	if (!name) {
-		if (!mm) {
-			name = "[vdso]";
-			goto done;
-		}
-
-		if (vma_is_initial_heap(vma)) {
-			name = "[heap]";
-			goto done;
-		}
-
-		if (vma_is_initial_stack(vma)) {
-			name = "[stack]";
-			goto done;
-		}
-
-		if (anon_name) {
-			seq_pad(m, ' ');
-			seq_printf(m, "[anon:%s]", anon_name->name);
-		}
-	}
-
-done:
-	if (name) {
+		seq_path(m, path, "\n");
+	} else if (name_fmt) {
+		seq_pad(m, ' ');
+		seq_printf(m, name_fmt, name);
+	} else if (name) {
 		seq_pad(m, ' ');
 		seq_puts(m, name);
 	}
_

Patches currently in -mm which might be from andrii@kernel.org are


