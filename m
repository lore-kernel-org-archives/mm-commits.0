Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E9BFC0B
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 01:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735610388; cv=none; b=e57yLq6EHmQV/G+lgWCMwi2ILttbC9sIrCMnPh1tMfuY/nkmSc4/dC55HPrWFau/HmzrHCsQHwB2sKXZANGyNY0IUcdKpNkmmvkUt34VZnlgtZKEHYHD9XvrIssHxvbAkIgJjwkV7P1guY3FA/u2s/1tonkGqebzMAhZdCqmmUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735610388; c=relaxed/simple;
	bh=JEgBG9k260NvBegGhHb7hoP5eRaktmUNRIvsOB2IlkY=;
	h=Date:To:From:Subject:Message-Id; b=rxXHhYTK+FFY7np6FS/D7Kd5zcZfAMMPUeIqq4LfbzKbKUtMk0GNjEKnanxIFNQA+xhmLqXcKeGeeNDnG3ojVTk20GXzM6TQHiWXWlscwV6NiGXweYCfRugd/az8pINic3UK7tx4wSbaDaBJ/bEY+lY0UPIajqfiID7pjR5QhHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pRf5iF7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pRf5iF7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FCCC4CED2;
	Tue, 31 Dec 2024 01:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735610388;
	bh=JEgBG9k260NvBegGhHb7hoP5eRaktmUNRIvsOB2IlkY=;
	h=Date:To:From:Subject:From;
	b=pRf5iF7Az6Z3bQeJuOaEFWKYIOeDu798K0bR+dLTVrVhBlU/dmoa94F5E0jXfppDH
	 0A/X6jS0FWMDKr8n+nGClknTVW2lL76wjKrnLslKAkD2aww6KQLcMgKESGAoosTR8+
	 BneIStnNaaiLH+svynYIi1qFgTaH40uyBz98JKpw=
Date: Mon, 30 Dec 2024 17:59:47 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shuah@kernel.org,Liam.Howlett@Oracle.com,ju.orth@gmail.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch removed from -mm tree
Message-Id: <20241231015947.E4FCCC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/memfd: add test for mapping write-sealed memfd read-only
has been removed from the -mm tree.  Its filename was
     selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: selftests/memfd: add test for mapping write-sealed memfd read-only
Date: Thu, 28 Nov 2024 15:06:18 +0000

Now we have reinstated the ability to map F_SEAL_WRITE mappings read-only,
assert that we are able to do this in a test to ensure that we do not
regress this again.

Link: https://lkml.kernel.org/r/a6377ec470b14c0539b4600cf8fa24bf2e4858ae.1732804776.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Julian Orth <ju.orth@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/memfd_test.c |   43 +++++++++++++++++++
 1 file changed, 43 insertions(+)

--- a/tools/testing/selftests/memfd/memfd_test.c~selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -282,6 +282,24 @@ static void *mfd_assert_mmap_shared(int
 	return p;
 }
 
+static void *mfd_assert_mmap_read_shared(int fd)
+{
+	void *p;
+
+	p = mmap(NULL,
+		 mfd_def_size,
+		 PROT_READ,
+		 MAP_SHARED,
+		 fd,
+		 0);
+	if (p == MAP_FAILED) {
+		printf("mmap() failed: %m\n");
+		abort();
+	}
+
+	return p;
+}
+
 static void *mfd_assert_mmap_private(int fd)
 {
 	void *p;
@@ -980,6 +998,30 @@ static void test_seal_future_write(void)
 	close(fd);
 }
 
+static void test_seal_write_map_read_shared(void)
+{
+	int fd;
+	void *p;
+
+	printf("%s SEAL-WRITE-MAP-READ\n", memfd_str);
+
+	fd = mfd_assert_new("kern_memfd_seal_write_map_read",
+			    mfd_def_size,
+			    MFD_CLOEXEC | MFD_ALLOW_SEALING);
+
+	mfd_assert_add_seals(fd, F_SEAL_WRITE);
+	mfd_assert_has_seals(fd, F_SEAL_WRITE);
+
+	p = mfd_assert_mmap_read_shared(fd);
+
+	mfd_assert_read(fd);
+	mfd_assert_read_shared(fd);
+	mfd_fail_write(fd);
+
+	munmap(p, mfd_def_size);
+	close(fd);
+}
+
 /*
  * Test SEAL_SHRINK
  * Test whether SEAL_SHRINK actually prevents shrinking
@@ -1593,6 +1635,7 @@ int main(int argc, char **argv)
 
 	test_seal_write();
 	test_seal_future_write();
+	test_seal_write_map_read_shared();
 	test_seal_shrink();
 	test_seal_grow();
 	test_seal_resize();
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-brk-internals-to-mm-vmac-fix.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch
selftests-mm-add-fork-cow-guard-page-test.patch
mm-enforce-__must_check-on-vma-merge-and-split.patch
mm-perform-all-memfd-seal-checks-in-a-single-place.patch
mm-perform-all-memfd-seal-checks-in-a-single-place-fix.patch
maintainers-update-memory-mapping-section.patch
mm-assert-mmap-write-lock-held-on-do_mmap-mmap_region.patch
mm-add-comments-to-do_mmap-mmap_region-and-vm_mmap.patch
tools-testing-add-simple-__mmap_region-userland-test.patch

