Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26F12676D3
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 20:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749588781; cv=none; b=tblge1AJp2sQuvFOrZodTFBce8orzb4IiDWA5i0N+Q/6Z6VkkA6+e3A5DpgkzeR+FF9NCbsRksOunK5F6lbfhK0Y2nQIzM43yWRJRuRSZxKx4jrsDemURo36dzD4IsW/TI4hC04BzdCEXr5grAZKj73nXccmzWR1s44VwWfkdB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749588781; c=relaxed/simple;
	bh=uXRaAcbafFrFmaHPNpHp71G98gxMoGacC3ewhZXowSI=;
	h=Date:To:From:Subject:Message-Id; b=dFBchmVzr2ommyLV7woHlH7FBp5wg03mS8N2T3AkZfOWhE1d1RqkI7dTdCTCxnWjTBWyfCdiNOXHH37uVBWgJZ+RCZyUVqA6gzQ0OHuhCNkFkQrm/wGNyCEqNPH270tRcUFhqUPDRBkZAIturqmTtEzdvTQ3QqQfnxgyd3w6aDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cCFNc5Y7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cCFNc5Y7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBDFC4CEED;
	Tue, 10 Jun 2025 20:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749588781;
	bh=uXRaAcbafFrFmaHPNpHp71G98gxMoGacC3ewhZXowSI=;
	h=Date:To:From:Subject:From;
	b=cCFNc5Y7HOn8BowhLNIjUv68GXwyrOc2SAtoTkwsVT1hzrWn0JM4DNIrWboaoxZNs
	 BMgUHb7G0HzSEDvcirlErwaYVhzME3YuEH35jPKNNSaDMdXQ0ZVTqK0NlZ6C8Ja36w
	 NpJt28KK/x1D8vtpi/3Qj4nru8zVypfNKVKvIl40=
Date: Tue, 10 Jun 2025 13:53:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,riel@surriel.com,richard.weiyang@gmail.com,npache@redhat.com,matenajakub@gmail.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch added to mm-new branch
Message-Id: <20250610205301.8CBDFC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/selftests: add MREMAP_RELOCATE_ANON fork tests
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools/testing/selftests: add MREMAP_RELOCATE_ANON fork tests
Date: Mon, 9 Jun 2025 14:26:45 +0100

Add tests explicitly asserting that mremap() fails on forked VMAs whether
they have parent anon_vma's or whether they have child ones, as these are
cases where the folio might be mapped by multiple processes - in this case
we don't even try to relocate folio metadata, but rather simply disallow
the operation.

The tests use MREMAP_MUST_RELOCATE_ANON so we can detect the failure
correctly.

Were the mremap()'s to succeed, a merge would occur, so it remains
appropriate to keep these in the merge test suite.

We also explicitly test the anon_vma reuse case.  This is one where a
munmap() occurs on a parent anon_vma which still has children.  We keep
the empty anon_vma around, and then attempt to reuse it on the next fork
of a VMA whose anon_vma references this empty anon_vma.

Consider the first case over 3 forks:

FORK 3 TIMES ONE AFTER ANOTHER
==============================

Process 1

     |-------------|
     | avc*        v
  |-----|   vma |-----|
  |  A  |<------| avc |
  |-----|       |-----|
     | anon_vma    ^
     |             |
     v     rb_root |
  |---------------------|
  | refcount = 1        |<--|
  | num_children = 1    |   |
  | num_active_vmas = 1 |---| parent
  |---------------------|

FORK

Process 1

     |-------------|
     | avc         v
  |-----|   vma |-----|
  |  A  |<------| avc |
  |-----|       |-----|
     | anon_vma    ^
     |             |--------------------|
     v     rb_root |                    |
  |---------------------|               |
  | refcount = 2        | (self-parent) |
  | num_children = 2    |<--------------x----|
  | num_active_vmas = 1 |               |    |
  |---------------------|               |    |
                           |------------|    |
Process 2                  |                 |
                           |                 |
     |-------------|       |                 |
     | avc         v       v                 |
  |-----|   vma |-----| |-----|              |
  |  B  |<------| avc |.| avc |              |
  |-----|       |-----| |-----|              |
     | anon_vma    ^                         |
     |             |                         |
     v     rb_root |                         |
  |---------------------|                    |
  | refcount = 1        |                    |
  | num_children = 0    |--------------------|
  | num_active_vmas = 1 | parent
  |---------------------|

FORK

Process 1

     |-------------|
     | avc         v
  |-----|   vma |-----|
  |  A  |<------| avc |
  |-----|       |-----|        |--------------------------|
     | anon_vma    ^           |                          |
     |             |--------------------|                 |
     v     rb_root |                    |                 |
  |---------------------|               |                 |
  | refcount = 3        | (self-parent) |                 |
  | num_children = 2    |<--------------x----|            |
  | num_active_vmas = 1 |               |    |            |
  |---------------------|               |    |            |
                           |------------|    |            |
Process 2                  |                 |            |
                           |                 |            |
     |-------------|       |                 |            |
     | avc         v       v                 |            |
  |-----|   vma |-----| |-----|              |            |
  |  B  |<------| avc |.| avc |              |            |
  |-----|       |-----| |-----|              |            |
     | anon_vma    ^                         |            |
     |             |-------------------------x--------|   |
     v     rb_root |                         |        |   |
  |---------------------|                    |        |   |
  | refcount = 1        |<-------------------x----|   |   |
  | num_children = 1    |--------------------|    |   |   |
  | num_active_vmas = 1 | parent                  |   |   |
  |---------------------|                         |   |   |
                                                  |   |   |
Process 3                                         |   |   |
                           |----------------------x---|   |
     |-------------|       |       |--------------x-------|
     | avc         v       v       v              |
  |-----|   vma |-----| |-----| |-----|           |
  |  C  |<------| avc |.| avc |.| avc |           |
  |-----|       |-----| |-----| |-----|           |
     | anon_vma    ^                              |
     |             |                              |
     v     rb_root |                              |
  |---------------------|                         |
  | refcount = 1        |                         |
  | num_children = 0    |-------------------------|
  | num_active_vmas = 1 | parent
  |---------------------|

FORK

Process 1

     |-------------|
     | avc         v
  |-----|   vma |-----|             |---------------------------------|
  |  A  |<------| avc |             |                                 |
  |-----|       |-----|        |--------------------------|           |
     | anon_vma    ^           |                          |           |
     |             |--------------------|                 |           |
     v     rb_root |                    |                 |           |
  |---------------------|               |                 |           |
  | refcount = 4        | (self-parent) |                 |           |
  | num_children = 2    |<--------------x----|            |           |
  | num_active_vmas = 1 |               |    |            |           |
  |---------------------|               |    |            |           |
                           |------------|    |            |           |
Process 2                  |                 |            |           |
                           |                 |            |           |
     |-------------|       |                 |            |           |
     | avc         v       v                 |            |           |
  |-----|   vma |-----| |-----|              |            |           |
  |  B  |<------| avc |.| avc |              |            |           |
  |-----|       |-----| |-----|     |--------x------------x-------|   |
     | anon_vma    ^                |        |            |       |   |
     |             |-------------------------x--------|   |       |   |
     v     rb_root |                         |        |   |       |   |
  |---------------------|                    |        |   |       |   |
  | refcount = 1        |<-------------------x----|   |   |       |   |
  | num_children = 1    |--------------------|    |   |   |       |   |
  | num_active_vmas = 1 | parent                  |   |   |       |   |
  |---------------------|                         |   |   |       |   |
                                                  |   |   |       |   |
Process 3                                         |   |   |       |   |
                           |----------------------x---|   |       |   |
     |-------------|       |       |--------------x-------|       |   |
     | avc         v       v       v              |               |   |
  |-----|   vma |-----| |-----| |-----|           |               |   |
  |  C  |<------| avc |.| avc |.| avc |           |               |   |
  |-----|       |-----| |-----| |-----|           |               |   |
     | anon_vma    ^                              |               |   |
     |             |------------------------------x-----------|   |   |
     v     rb_root |                              |           |   |   |
  |---------------------|                         |           |   |   |
  | refcount = 1        |<------------------------x---|       |   |   |
  | num_children = 1    |-------------------------|   |       |   |   |
  | num_active_vmas = 1 | parent                      |       |   |   |
  |---------------------|                             |       |   |   |
                                                      |       |   |   |
Process 4                                             |       |   |   |
                           |--------------------------x-------|   |   |
     |-------------|       |       |------------------x-----------|   |
     | avc         v       v       v       v----------x---------------|
  |-----|   vma |-----| |-----| |-----| |-----|       |
  |  D  |<------| avc |.| avc |.| avc |.| avc |       |
  |-----|       |-----| |-----| |-----| |-----|       |
     | anon_vma    ^                                  |
     |             |                                  |
     v     rb_root |                                  |
  |---------------------|                             |
  | refcount = 1        |                             |
  | num_children = 0    |-----------------------------|
  | num_active_vmas = 1 | parent
  |---------------------|

We can see that at no point do we lack either a raised num_children count
or anon_vma_chain list count.

Equally with anon_vma reuse:

FORK 3 TIMES ONE AFTER ANOTHER, UNMAPPING AFTER FORK FOR ANON_VMA REUSE
=======================================================================

Process 1

     |-------------|
     | avc*        v
  |-----|   vma |-----|
  |  A  |<------| avc |
  |-----|       |-----|
     | anon_vma    ^
     |             |
     v     rb_root |
  |---------------------|
  | refcount = 1        |<--|
  | num_children = 1    |   |
  | num_active_vmas = 1 |---| parent
  |---------------------|

FORK

Process 1

     |-------------|
     | avc         v
  |-----|   vma |-----|
  |  A  |<------| avc |
  |-----|       |-----|
     | anon_vma    ^
     |             |--------------------|
     v     rb_root |                    |
  |---------------------|               |
  | refcount = 2        | (self-parent) |
  | num_children = 2    |<--------------x----|
  | num_active_vmas = 1 |               |    |
  |---------------------|               |    |
                           |------------|    |
Process 2                  |                 |
                           |                 |
     |-------------|       |                 |
     | avc         v       v                 |
  |-----|   vma |-----| |-----|              |
  |  B  |<------| avc |.| avc |              |
  |-----|       |-----| |-----|              |
     | anon_vma    ^                         |
     |             |                         |
     v     rb_root |                         |
  |---------------------|                    |
  | refcount = 1        |                    |
  | num_children = 0    |--------------------|
  | num_active_vmas = 1 | parent
  |---------------------|

FORK

Process 1

     |-------------|
     | avc         v
  |-----|   vma |-----|
  |  A  |<------| avc |
  |-----|       |-----|        |--------------------------|
     | anon_vma    ^           |                          |
     |             |--------------------|                 |
     v     rb_root |                    |                 |
  |---------------------|               |                 |
  | refcount = 3        | (self-parent) |                 |
  | num_children = 2    |<--------------x----|            |
  | num_active_vmas = 1 |               |    |            |
  |---------------------|               |    |            |
                           |------------|    |            |
Process 2                  |                 |            |
                           |                 |            |
     |-------------|       |                 |            |
     | avc         v       v                 |            |
  |-----|   vma |-----| |-----|              |            |
  |  B  |<------| avc |.| avc |              |            |
  |-----|       |-----| |-----|              |            |
     | anon_vma    ^                         |            |
     |             |-------------------------x--------|   |
     v     rb_root |                         |        |   |
  |---------------------|                    |        |   |
  | refcount = 1        |<-------------------x----|   |   |
  | num_children = 1    |--------------------|    |   |   |
  | num_active_vmas = 1 | parent                  |   |   |
  |---------------------|                         |   |   |
                                                  |   |   |
Process 3                                         |   |   |
                           |----------------------x---|   |
     |-------------|       |       |--------------x-------|
     | avc         v       v       v              |
  |-----|   vma |-----| |-----| |-----|           |
  |  C  |<------| avc |.| avc |.| avc |           |
  |-----|       |-----| |-----| |-----|           |
     | anon_vma    ^                              |
     |             |                              |
     v     rb_root |                              |
  |---------------------|                         |
  | refcount = 1        |                         |
  | num_children = 0    |-------------------------|
  | num_active_vmas = 1 | parent
  |---------------------|

UNMAP B

Process 1

     |-------------|
     | avc         v
  |-----|   vma |-----|
  |  A  |<------| avc |
  |-----|       |-----|        |--------------------------|
     | anon_vma    ^           |                          |
     |             |------------                          |
     v     rb_root |                                      |
  |---------------------|                                 |
  | refcount = 3        | (self-parent)                   |
  | num_children = 2    |<-------------------|            |
  | num_active_vmas = 1 |                    |            |
  |---------------------|                    |            |
                                             |            |
Process 2                                    |            |
                                             |            |
                   |-------------------------x--------|   |
           rb_root |                         |        |   |
  |---------------------|                    |        |   |
  | refcount = 1        |<-------------------x----|   |   | We keep empty
  | num_children = 1    |--------------------|    |   |   | anon_vma round.
  | num_active_vmas = 0 | parent                  |   |   |
  |---------------------|                         |   |   |
                                                  |   |   |
Process 3                                         |   |   |
                           |----------------------x---|   |
     |-------------|       |       |--------------x-------|
     | avc         v       v       v              |
  |-----|   vma |-----| |-----| |-----|           |
  |  C  |<------| avc |.| avc |.| avc |           |
  |-----|       |-----| |-----| |-----|           |
     | anon_vma    ^                              |
     |             |                              |
     v     rb_root |                              |
  |---------------------|                         |
  | refcount = 1        |                         |
  | num_children = 0    |-------------------------|
  | num_active_vmas = 1 | parent
  |---------------------|

FORK

Process 1

     |-------------|
     | avc         v
  |-----|   vma |-----|             |-----------------------------|
  |  A  |<------| avc |             |                             |
  |-----|       |-----|        |--------------------------|       |
     | anon_vma    ^           |                          |       |
     |             |-----------|                          |       |
     v     rb_root |                                      |       |
  |---------------------|                                 |       |
  | refcount = 3        | (self-parent)                   |       |
  | num_children = 2    |<-------------------|            |       |
  | num_active_vmas = 1 |                    |            |       |
  |---------------------|                    |            |       |
                                             |            |       |
Process 2               |--------------------x------------x-------x-------|
                        |                    |            |       |       |
                   |-------------------------x--------|   |       |       |
           rb_root |                         |        |   |       |       |
  |---------------------|<-------------------x--------x---x-------x---|   |
  | refcount = 1        |<-------------------x----|   |   |       |   |   |
  | num_children = 1    |--------------------|    |   |   |       |   |   |
  | num_active_vmas = 1 | parent                  |   |   |       |   |   |
  |---------------------|                         |   |   |       |   |   |
                                                  |   |   |       |   |   |
Process 3                                         |   |   |       |   |   |
                           |----------------------x---|   |       |   |   |
     |-------------|       |       |--------------x-------|       |   |   |
     | avc         v       v       v              |               |   |   |
  |-----|   vma |-----| |-----| |-----|           |               |   |   |
  |  C  |<------| avc |.| avc |.| avc |           |               |   |   |
  |-----|       |-----| |-----| |-----|           |               |   |   |
     | anon_vma    ^                              |               |   |   |
     |             |------------------------------x-----------|   |   |   |
     v     rb_root |                              |           |   |   |   |
  |---------------------|                         |           |   |   |   |
  | refcount = 1        |                         |           |   |   |   |
  | num_children = 0    |-------------------------|           |   |   |   |
  | num_active_vmas = 1 | parent                              |   |   |   |
  |---------------------|                                     |   |   |   |
                                                              |   |   |   |
Process 4                                                     |   |   |   |
                           |----------------------------------|   |   |   |
     |-------------|       |       |------------------------------|   |   |
     | avc         v       v       v                                  |   |
  |-----|   vma |-----| |-----| |-----|                               |   |
  |  D  |<------| avc |.| avc |.| avc |                               |   |
  |-----|       |-----| |-----| |-----|                               |   |
     | anon_vma    ^                                                  |   |
     |             |--------------------------------------------------x---|
     |                                                                |
     |----------------------------------------------------------------|

We reuse the empty anon_vma from VMA B.  Note that process 3 is now
parented to process 4's (and 2's) anon_vma.

Link: https://lkml.kernel.org/r/d52a781999622ed2f1de073d72ea4d9debbfe198.1749473726.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/merge.c |  361 +++++++++++++++++++++++++++
 1 file changed, 361 insertions(+)

--- a/tools/testing/selftests/mm/merge.c~tools-testing-selftests-add-mremap_relocate_anon-fork-tests
+++ a/tools/testing/selftests/mm/merge.c
@@ -4,6 +4,7 @@
 #include "../kselftest_harness.h"
 #include <linux/prctl.h>
 #include <fcntl.h>
+#include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -15,11 +16,18 @@
 #include "vm_util.h"
 #include <linux/mman.h>
 
+enum poll_action {
+	POLL_TASK_RUN,
+	POLL_TASK_WAIT,
+	POLL_TASK_EXIT,
+};
+
 FIXTURE(merge)
 {
 	unsigned int page_size;
 	char *carveout;
 	struct procmap_fd procmap;
+	volatile enum poll_action *ipc;
 };
 
 FIXTURE_SETUP(merge)
@@ -31,6 +39,11 @@ FIXTURE_SETUP(merge)
 	ASSERT_NE(self->carveout, MAP_FAILED);
 	/* Setup PROCMAP_QUERY interface. */
 	ASSERT_EQ(open_self_procmap(&self->procmap), 0);
+
+	/* Quick and dirty IPC. */
+	self->ipc = (volatile enum poll_action *)mmap(NULL, self->page_size,
+			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANON, -1, 0);
+	ASSERT_NE(self->ipc, MAP_FAILED);
 }
 
 FIXTURE_TEARDOWN(merge)
@@ -42,6 +55,7 @@ FIXTURE_TEARDOWN(merge)
 	 * fails (KSM may be disabled for instance).
 	 */
 	prctl(PR_SET_MEMORY_MERGE, 0, 0, 0, 0);
+	ASSERT_EQ(munmap((void *)self->ipc, self->page_size), 0);
 }
 
 TEST_F(merge, mprotect_unfaulted_left)
@@ -1901,4 +1915,351 @@ TEST_F(merge, mremap_relocate_anon_mprot
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
 }
 
+TEST_F(merge, mremap_relocate_anon_single_fork)
+{
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	volatile enum poll_action *poll = self->ipc;
+	char *ptr, *ptr2;
+	pid_t pid2;
+	int err;
+
+	/*
+	 * .           .           .
+	 * . |-------| .           .  Map A, fault in and
+	 * . |   A   |-.-----|     .  fork process 1 to
+	 * . |-------| .     |     .  process 2.
+	 * .           .     v     .
+	 * .           . |-------| .
+	 * .           . |   B   | .
+	 * .           . |-------| .
+	 * .           .           .
+	 * . Process 1 . Process 2 .
+	 */
+	ptr = mmap(carveout, 3 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	/* Fault it in. */
+	ptr[0] = 'x';
+
+	pid2 = fork();
+	ASSERT_NE(pid2, -1);
+	/* Parent process. */
+	if (pid2 != 0) {
+		/* mremap() fails due to forked children. */
+		ptr2 = sys_mremap(ptr, page_size, page_size,
+				  MREMAP_MAYMOVE | MREMAP_FIXED | MREMAP_MUST_RELOCATE_ANON,
+				  &carveout[3 * page_size]);
+		err = errno;
+		ASSERT_EQ(ptr2, MAP_FAILED);
+		ASSERT_EQ(err, EFAULT);
+
+		poll[0] = POLL_TASK_EXIT;
+
+		wait(NULL);
+		return;
+	}
+
+	/* This is process 2. */
+
+	/* mremap() fails due to forked parents. */
+	ptr2 = sys_mremap(ptr, page_size, page_size,
+		MREMAP_MAYMOVE | MREMAP_FIXED | MREMAP_MUST_RELOCATE_ANON,
+		&carveout[3 * page_size]);
+	err = errno;
+	ASSERT_EQ(ptr2, MAP_FAILED);
+	ASSERT_EQ(err, EFAULT);
+
+	/* Wait for parent to finish. */
+	while (poll[0] == POLL_TASK_RUN)
+		;
+}
+
+TEST_F(merge, mremap_relocate_anon_fork_twice)
+{
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	volatile enum poll_action *poll = self->ipc;
+	char *ptr, *ptr2;
+	pid_t pid2, pid3;
+	int err;
+
+	/*
+	 * .           .           .
+	 * . |-------| .           .  Map A, fault in and
+	 * . |   A   |-.-----|     .  fork process 1 to
+	 * . |-------| .     |     .  process 2.
+	 * .           .     v     .
+	 * .           . |-------| .
+	 * .           . |   B   | .
+	 * .           . |-------| .
+	 * .           .           .
+	 * . Process 1 . Process 2 .
+	 */
+	ptr = mmap(carveout, 3 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	/* Fault it in. */
+	ptr[0] = 'x';
+	pid2 = fork();
+	ASSERT_NE(pid2, -1);
+	/* If parent process, simply wait. */
+	if (pid2 != 0) {
+		while (true) {
+			if (poll[0] == POLL_TASK_EXIT)
+				break;
+			if (poll[0] == POLL_TASK_WAIT)
+				continue;
+
+			/* mremap() fails due to forked children. */
+			ptr2 = sys_mremap(ptr, page_size, page_size,
+					  MREMAP_MAYMOVE | MREMAP_FIXED |
+					  MREMAP_MUST_RELOCATE_ANON,
+					  &carveout[3 * page_size]);
+			err = errno;
+			ASSERT_EQ(ptr2, MAP_FAILED);
+			ASSERT_EQ(err, EFAULT);
+
+			/* Strictly, should be atomic. */
+			if (poll[0] == POLL_TASK_RUN)
+				poll[0] = POLL_TASK_WAIT;
+		}
+
+		wait(NULL);
+		return;
+	}
+
+	/* This is process 2. */
+
+	/* Wait for parent to finish. */
+	while (poll[0] == POLL_TASK_RUN)
+		;
+
+	/*
+	 * .           .           .           .
+	 * . |-------| .           .           .
+	 * . |   A   | .           .           .
+	 * . |-------| .           .           .
+	 * .           .           .           .
+	 * .           . |-------| .           . Fork process 2 to
+	 * .           . |   B   |-.-----|     . process 3.
+	 * .           . |-------| .     |     .
+	 * .           .           .     v     .
+	 * .           .           . |-------| .
+	 * .           .           . |   C   | .
+	 * .           .           . |-------| .
+	 * .           .           .           .
+	 * . Process 1 . Process 2 . Process 3 .
+	 */
+	pid3 = fork();
+	ASSERT_NE(pid3, -1);
+	/* If parent process, simply wait. */
+	if (pid3 != 0) {
+		/* mremap() fails due to forked children. */
+		ptr2 = sys_mremap(ptr, page_size, page_size,
+				  MREMAP_MAYMOVE | MREMAP_FIXED |
+				  MREMAP_MUST_RELOCATE_ANON,
+				  &carveout[3 * page_size]);
+		err = errno;
+		ASSERT_EQ(ptr2, MAP_FAILED);
+		ASSERT_EQ(err, EFAULT);
+
+		/* We don't retrigger, so just indicate we're done. */
+		poll[1] = POLL_TASK_EXIT;
+
+		wait(NULL);
+		return;
+	}
+
+	/* This is process 3. */
+
+	/* Trigger root mremap(). */
+	poll[0] = POLL_TASK_RUN;
+	/* Wait for parents to finish. */
+
+	while (poll[0] == POLL_TASK_RUN)
+		;
+	while (poll[1] == POLL_TASK_RUN)
+		;
+
+	/* mremap() fails due to forked parents. */
+	ptr2 = sys_mremap(ptr, page_size, page_size,
+		MREMAP_MAYMOVE | MREMAP_FIXED | MREMAP_MUST_RELOCATE_ANON,
+		&carveout[3 * page_size]);
+	err = errno;
+	ASSERT_EQ(ptr2, MAP_FAILED);
+	ASSERT_EQ(err, EFAULT);
+	/* Kill waiting parent. */
+	poll[0] = POLL_TASK_EXIT;
+}
+
+TEST_F(merge, mremap_relocate_anon_3_times_reuse_anon_vma)
+{
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	volatile enum poll_action *poll = self->ipc;
+	char *ptr, *ptr2;
+	pid_t pid2, pid3, pid4;
+	int err;
+
+	/*
+	 * .           .           .
+	 * . |-------| .           .  Map A, fault in and
+	 * . |   A   |-.-----|     .  fork process 1 to
+	 * . |-------| .     |     .  process 2.
+	 * .           .     v     .
+	 * .           . |-------| .
+	 * .           . |   B   | .
+	 * .           . |-------| .
+	 * .           .           .
+	 * . Process 1 . Process 2 .
+	 */
+	ptr = mmap(carveout, 3 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	/* Fault it in. */
+	ptr[0] = 'x';
+	pid2 = fork();
+	ASSERT_NE(pid2, -1);
+	/* If parent process, simply wait. */
+	if (pid2 != 0) {
+		while (true) {
+			if (poll[0] == POLL_TASK_EXIT)
+				break;
+			if (poll[0] == POLL_TASK_WAIT)
+				continue;
+
+			/* mremap() fails due to forked children. */
+			ptr2 = sys_mremap(ptr, page_size, page_size,
+					  MREMAP_MAYMOVE | MREMAP_FIXED |
+					  MREMAP_MUST_RELOCATE_ANON,
+					  &carveout[3 * page_size]);
+			err = errno;
+			ASSERT_EQ(ptr2, MAP_FAILED);
+			ASSERT_EQ(err, EFAULT);
+
+			if (poll[0] == POLL_TASK_RUN)
+				poll[0] = POLL_TASK_WAIT;
+		}
+
+		wait(NULL);
+		return;
+	}
+
+	/* This is process 2. */
+
+	/* Wait for parent to finish. */
+	while (poll[0] == POLL_TASK_RUN)
+		;
+
+	/*
+	 * .           .           .           .
+	 * . |-------| .           .           .
+	 * . |   A   | .           .           .
+	 * . |-------| .           .           .
+	 * .           .           .           .
+	 * .           . |-------| .           . Fork process 2 to
+	 * .           . |   B   |-.-----|     . process 3.
+	 * .           . |-------| .     |     .
+	 * .           .           .     v     .
+	 * .           .           . |-------| .
+	 * .           .           . |   C   | .
+	 * .           .           . |-------| .
+	 * .           .           .           .
+	 * . Process 1 . Process 2 . Process 3 .
+	 */
+	pid3 = fork();
+	ASSERT_NE(pid3, -1);
+	/* If parent process, simply wait. */
+	if (pid3 != 0) {
+		/*
+		 * We only try to mremap once, before unmapping so we can
+		 * trigger reuse of B's anon_vma.
+		 */
+		/* mremap() fails due to forked children. */
+		ptr2 = sys_mremap(ptr, page_size, page_size,
+				  MREMAP_MAYMOVE | MREMAP_FIXED |
+				  MREMAP_MUST_RELOCATE_ANON,
+				  &carveout[3 * page_size]);
+		err = errno;
+		ASSERT_EQ(ptr2, MAP_FAILED);
+		ASSERT_EQ(err, EFAULT);
+
+		/*
+		 * .           .           .           .
+		 * . |-------| .           .           .
+		 * . |   A   | .           .           .
+		 * . |-------| .           .           .
+		 * .           .           .           .
+		 * .           .           .           . Unmap VMA B, but
+		 * .           .           .           . anon_vma is left
+		 * .           .           .           . around.
+		 * .           .           .           .
+		 * .           .           . |-------| .
+		 * .           .           . |   C   | .
+		 * .           .           . |-------| .
+		 * .           .           .           .
+		 * . Process 1 . Process 2 . Process 3 .
+		 */
+		munmap(ptr, 3 * page_size);
+
+		/* We indicate we're done so child waits for */
+		poll[1] = POLL_TASK_EXIT;
+
+		wait(NULL);
+		return;
+	}
+
+	/* This is process 3. */
+
+	/* Trigger root mremap(). */
+	poll[0] = POLL_TASK_RUN;
+	/* Wait for parents to finish. */
+	while (poll[0] == POLL_TASK_RUN)
+		;
+	while (poll[1] == POLL_TASK_RUN)
+		;
+
+	pid4 = fork();
+	ASSERT_NE(pid4, -1);
+
+	if (pid4 != 0) {
+		/* mremap() fails due to forked children. */
+		ptr2 = sys_mremap(ptr, page_size, page_size,
+				  MREMAP_MAYMOVE | MREMAP_FIXED |
+				  MREMAP_MUST_RELOCATE_ANON,
+				  &carveout[3 * page_size]);
+		err = errno;
+		ASSERT_EQ(ptr2, MAP_FAILED);
+		ASSERT_EQ(err, EFAULT);
+
+		/* We don't retrigger, so just indicate we're done. */
+		poll[2] = POLL_TASK_EXIT;
+
+		wait(NULL);
+		return;
+	}
+
+	/* This is process 4. */
+
+	/* Trigger root mremap(). */
+	poll[0] = POLL_TASK_RUN;
+	/* We unmapped VMA B, so nothing to trigger there. */
+	/* Wait for parents to finish. */
+	while (poll[0] == POLL_TASK_RUN)
+		;
+	while (poll[2] == POLL_TASK_RUN)
+		;
+
+	/* mremap() fails due to forked parents. */
+	ptr2 = sys_mremap(ptr, page_size, page_size,
+		MREMAP_MAYMOVE | MREMAP_FIXED | MREMAP_MUST_RELOCATE_ANON,
+		&carveout[3 * page_size]);
+	err = errno;
+	ASSERT_EQ(ptr2, MAP_FAILED);
+	ASSERT_EQ(err, EFAULT);
+	/* Kill waiting parent. */
+	poll[0] = POLL_TASK_EXIT;
+}
+
 TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-reset-vma-iterator-on-commit_merge-oom-failure.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix-2.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-add-mremap_must_relocate_anon.patch
mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch
tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch
tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch
tools-testing-selftests-add-mremap-cases-that-merge-normally.patch
tools-testing-selftests-add-mremap_relocate_anon-merge-test-cases.patch
tools-testing-selftests-expand-mremap-tests-for-mremap_relocate_anon.patch
tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch
tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch
tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch

