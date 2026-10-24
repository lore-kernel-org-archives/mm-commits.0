Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832452;
	b=E3NRXUxW5a/GsXRLwzSHpAai341jJNb/nefPBbu7sjr6CRe+bbnJXQVsNvvGZEBWEO93
	 h5aDZrx4WQS/PegXtPQrpGyUgrNGekPSY0/JNSjzGUsF41y9LIqkGmzQJb8r37Yv2flEe
	 RX4dtl3oOP2gLz8smsDa3qpgjjnDe2fDYlWkp/dpHgC1O87W+AFtYmfAWFME63GmyKQ4N
	 k1H167Zty/0EciqGK2OLSQQYYffLCvy4svVvc/vtTzuechamQDy0eOXgykQfHROSykHrT
	 ZP3G8PYM3wDbgHWbr/Xw1d91GEXMQ5tWF8dSyF6p6bHVY4hELBsGd9taG5Q1NXA70gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832452;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=X3CunDO5p+OxSu8p4QnpIISf24Mlp46j9aYhuUOcPsI=;
	b=VuE7tBYmWIYgY7Hyl6EH6DGuJvsVBMGGW8Q+pFNOVKCq8Mab9+K3NAZHMWSJY9YITlPn
	 8bLToZKb0o+eE8FJHGuWk3uc4woaoYyNzFSHAVw3XipYTnHSUFYWamenFdRzQoNubjkxS
	 p1OT6roIcsWhlIrxeLOHAUj9/LBPVn214w7iSofd9gKbKevN36Ke5ZxGBzPRNzE5FbRex
	 8hFUnPCSJo8CB8DhC3fuu4smSASMXgX6YQndl6F2AaaQYhCSXsg86x7IeIfrHzIGR6V8p
	 h4MmFVnsrQe9Otw5IJXVXlNo6cu4UcPg6e7P+N3kiBEP+NvlqhigpFseSrSRBC6QIjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qdIWc4Tv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B36606A31F
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qdIWc4Tv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F096E1F01825;
	Sat, 24 Oct 2026 09:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832452;
	bh=X3CunDO5p+OxSu8p4QnpIISf24Mlp46j9aYhuUOcPsI=;
	h=Date:To:From:Subject;
	b=qdIWc4TvR4naPaCa7/nBTnhidIkozfxh3lw6yEd/bp4jFMMvz3vM5MtkzSArEFaL3
	 buR0D1rKEvq0FkyOFWsEphI7qr/6uPm/zkMmNOA8hzW0ndK14NCmxKX8MRvy5JaezX
	 Sb4HiiZiykQKqFJAXKR+9FEXjE0KlCLMXEJJqVhE=
Date: Sat, 24 Oct 2026 02:00:51 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,jaeyeon.lee.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-hugetlb-read-hwpoison-add-setup-of-hugetlb-pages.patch removed from -mm tree
Message-Id: <20261024090051.F096E1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: selftests/mm: hugetlb-read-hwpoison: add setup of HugeTLB pages
has been removed from the -mm tree.  Its filename was
     selftests-mm-hugetlb-read-hwpoison-add-setup-of-hugetlb-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Subject: selftests/mm: hugetlb-read-hwpoison: add setup of HugeTLB pages
Date: Sun,  4 Oct 2026 22:54:58 +0200

Every test is expected to reserve the HugeTLB pages it needs. 
hugetlb-read-hwpoison was not converted, so on a system without
pre-reserved huge pages the MAP_POPULATE mmap() fails with ENOMEM and
every test case is skipped.

Reserve the pages with hugetlb_setup_default().  Each chunk size runs two
HWPOISON tests and a poisoned huge page can't be reused, so reserve two
pages per chunk size.  The pool size is restored on exit.  The poisoned
pages remain allocated until reboot.

With the patch, all 12 cases pass on a system with no huge pages
reserved (tested on Fedora, x86_64, CONFIG_MEMORY_FAILURE=y).

Link: https://lore.kernel.org/20261004205458.119608-1-jaeyeon.lee.dev@gmail.com
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Assisted-by: LLM
Cc: David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
---

 tools/testing/selftests/mm/hugetlb-read-hwpoison.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c~selftests-mm-hugetlb-read-hwpoison-add-setup-of-hugetlb-pages
+++ a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
@@ -13,6 +13,7 @@
 #include <signal.h>
 
 #include "kselftest.h"
+#include "vm_util.h"
 
 #define MAX_WRITE_READ_CHUNK_SIZE (getpagesize() * 16)
 #define MAX(a, b) (((a) > (b)) ? (a) : (b))
@@ -281,6 +282,13 @@ int main(void)
 	size_t i;
 
 	ksft_print_header();
+
+	if (!hugetlb_available())
+		ksft_exit_skip("HugeTLB is not available\n");
+
+	if (!hugetlb_setup_default(ARRAY_SIZE(wr_chunk_sizes) * 2))
+		ksft_exit_skip("Not enough free huge pages\n");
+
 	ksft_set_plan(ARRAY_SIZE(wr_chunk_sizes) * 3);
 
 	signal(SIGBUS, sigbus_handler);
_

Patches currently in -mm which might be from jaeyeon.lee.dev@gmail.com are


