Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EECE158538
	for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 10:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732875808; cv=none; b=M0X1z/3h0emrpzC1qsr4n2GRzAAz+Am9geDcNqZoGJ6/FqBOWeCQtXPzojMzS9ZrhaPUHjfrMDH/ONWXjrYIg70vn/4Nz5x+8D9xdHgKFje+xaNaon+N61Cx4DbklHztVQ0AcxCm6JTJuLzREvpIyc9dMVw/OnLP7e7nhb9aINc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732875808; c=relaxed/simple;
	bh=QM+iIs9PAmaFG9Y1BnmhgVJ0k173rMThcqxEqL9+ZP0=;
	h=Date:To:From:Subject:Message-Id; b=seZ2cS3KjHKKt0u3gIBBXUkr7vj5/2qTPAUK74Hr1s8lTIGZoVxEwhD7UsYdJQYqe7Jx37hyiaWealwx9irnYYLgZCI++9oVy1I3xRCOQK8rQUBevwdLzK6t+QMjxfJjcu9+muIkgNaAi5JzIEjC926h7U9QrnKJgg2bMX6zgVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DBTQmg0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DBTQmg0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D363C4CECF;
	Fri, 29 Nov 2024 10:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732875808;
	bh=QM+iIs9PAmaFG9Y1BnmhgVJ0k173rMThcqxEqL9+ZP0=;
	h=Date:To:From:Subject:From;
	b=DBTQmg0pldVjn75KDboihdKaFKgZMYyk6TCvJhp82EHImXzisUMJTFqCR09ul+oda
	 bahjAbXUucZ/T90fy/QsoW8Yf+0R2oHyhH4GQtLmfr69i6xkB0s//AcGOP7+xmz8/N
	 XxJ7cToEvYojHB44j1Xy02GhaUmHYZzQpQd4ncd4=
Date: Fri, 29 Nov 2024 02:23:27 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shuah@kernel.org,Liam.Howlett@Oracle.com,ju.orth@gmail.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch added to mm-hotfixes-unstable branch
Message-Id: <20241129102328.5D363C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/memfd: add test for mapping write-sealed memfd read-only
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch

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
@@ -281,6 +281,24 @@ static void *mfd_assert_mmap_shared(int
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
@@ -979,6 +997,30 @@ static void test_seal_future_write(void)
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
@@ -1587,6 +1629,7 @@ int main(int argc, char **argv)
 
 	test_seal_write();
 	test_seal_future_write();
+	test_seal_write_map_read_shared();
 	test_seal_shrink();
 	test_seal_grow();
 	test_seal_resize();
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
docs-mm-add-vma-locks-documentation.patch
docs-mm-add-vma-locks-documentation-v3.patch
docs-mm-add-vma-locks-documentation-fix.patch

