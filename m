Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74654502B
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247716; cv=none; b=S8xuP1gLj1rHRkX0v+lzU3O4eLV3wttc7+x1mPKC8kkpB2saHKxFC7DTMARK3xkNKG5SrFVExx7IubpueTOWcv+EqshpVhAf0WVTkOfYuXOpTLy3A6KtwMQhfNTaDDvdHLDB9DY6bBJmBGQYKD8JES11Yu4LZDSVvaSPxRpA0ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247716; c=relaxed/simple;
	bh=rxn7Hj6D7pvt6A3dTWCpHRzc4f+N8uCaaoCJAhIdDTQ=;
	h=Date:To:From:Subject:Message-Id; b=cOWWAvkIPtg33X8YQ8RjiFyu7jYEzvOEz4Y/oGij6DRBOkW0fQm94MGOE/6UcAUWqJ2HuQkAr4g3Ot2eMQJ/3mvLp86Smu5CFbU6Ljro9ZdqPGbee+pOXj+j2jSnPYjl4hzwPLXwUxRdohEaG9pLEojiUScKWMSs91W+oJLOyBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KvtAsD8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KvtAsD8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A305C4CEC7;
	Mon,  2 Sep 2024 03:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247716;
	bh=rxn7Hj6D7pvt6A3dTWCpHRzc4f+N8uCaaoCJAhIdDTQ=;
	h=Date:To:From:Subject:From;
	b=KvtAsD8NX66+gRqpEC7GdyzmTx2lyHI5GUAA9G/mEAttitMzSRnX74MGN541hqL/q
	 XmK0mFHugmLwnGHCKnKX16fMUDpirRNYyoLDAr5JWSElpmDE5xmh2debBN2X4Pe90X
	 g+cBPDEGHi765PH6gMOa9LQL0cCvISEhvosAgZgU=
Date: Sun, 01 Sep 2024 20:28:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shuah@kernel.org,rmoar@google.com,pengfei.xu@intel.com,Liam.Howlett@oracle.com,kees@kernel.org,jack@suse.cz,ebiederm@xmission.com,davidgow@google.com,brendanhiggins@google.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-entry-for-new-vma-files.patch removed from -mm tree
Message-Id: <20240902032836.8A305C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add entry for new VMA files
has been removed from the -mm tree.  Its filename was
     maintainers-add-entry-for-new-vma-files.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add entry for new VMA files
Date: Mon, 29 Jul 2024 12:50:39 +0100

The vma files contain logic split from mmap.c for the most part and are
all relevant to VMA logic, so maintain the same reviewers for both.

Link: https://lkml.kernel.org/r/bf2581cce2b4d210deabb5376c6aa0ad6facf1ff.1722251717.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Gow <davidgow@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kees Cook <kees@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rae Moar <rmoar@google.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/MAINTAINERS~maintainers-add-entry-for-new-vma-files
+++ a/MAINTAINERS
@@ -24411,6 +24411,19 @@ F:	include/uapi/linux/vsockmon.h
 F:	net/vmw_vsock/
 F:	tools/testing/vsock/
 
+VMA
+M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	https://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	mm/vma.c
+F:	mm/vma.h
+F:	mm/vma_internal.h
+
 VMALLOC
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Uladzislau Rezki <urezki@gmail.com>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

tools-improve-vma-test-makefile.patch
tools-add-vma-merge-tests.patch
mm-introduce-vma_merge_struct-and-abstract-vma_mergevma_modify.patch
mm-remove-duplicated-open-coded-vma-policy-check.patch
mm-abstract-vma_expand-to-use-vma_merge_struct.patch
mm-avoid-using-vma_merge-for-new-vmas.patch
mm-make-vma_prepare-and-friends-static-and-internal-to-vmac.patch
mm-introduce-commit_merge-abstracting-final-commit-of-merge.patch
mm-refactor-vma_merge-into-modify-only-vma_merge_existing_range.patch
mm-rework-vm_ops-close-handling-on-vma-merge.patch

