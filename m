Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C40367B78
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067135; cv=none; b=fs8JCsTWgxc5Z9edWTO9b7pep8WkdDlDoIW1VhOWA3j431eOdttyGHfCOQyucinktsDcYKZrdx+T70aOHJOgQVYY0/KcrvLM7uWCzE1vJLSHowzWe26I4H/rjOKvgtkMm72ADME0qBaWnquRNYCfbQ4wR2Swh8XNdAk2PH6qvvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067135; c=relaxed/simple;
	bh=0U5JZuIcuDf4OS5xFtYxh0DX+cxt5DokKQgikaJTucY=;
	h=Date:To:From:Subject:Message-Id; b=bq3VR2+x64soHgr3kdYho0t9qKX6OD94fLNyDk9Kv7NVwPjXSgo+5ujHhYQpnqHqQQrub6meKYNG+Isn1kXfMkF7GiXrvXPaPBBZt7uuP9EgC+tW32uk2mMFteyqws0JA3/10O4LH8/aF5ZFpusGgO7zbUDPCtQS6JGFtynwphs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uF3WmKaG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uF3WmKaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36B51F00A3A;
	Sun, 21 Jun 2026 18:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067134;
	bh=4+bJ4a2vE9VHRZTqVBOqxZBALRImc2MEEHuKxYX76Mc=;
	h=Date:To:From:Subject;
	b=uF3WmKaGq4UAxoGYbs0hlGrJEmZAjBN4jZ2JP/J1UOjhXQqYcDCrbXHdB5XG74L9Z
	 jwImf38VG8Vs7uGcSZYgJkEGaqsqMfKlx+WVpK6Htz0PyWh+3VvdgA6VY4HaHDcldr
	 8w6YfIs1OfwitRZWcE4zjxArCYFLCOaHYUUgIMoo=
Date: Sun, 21 Jun 2026 11:38:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-khugepaged-group-tests-in-an-array.patch removed from -mm tree
Message-Id: <20260621183853.E36B51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: khugepaged: group tests in an array
has been removed from the -mm tree.  Its filename was
     selftests-mm-khugepaged-group-tests-in-an-array.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: khugepaged: group tests in an array
Date: Mon, 11 May 2026 19:27:57 +0300

Currently khugepaged decides if a test can run using TEST() macro that
checks what mem_ops and collapse_context are set by the command line
arguments.

For better compatibility with ksefltest framework, add an array of 'struct
test_case's and redefine TEST() macro to conditionally add enabled tests
to that array.

Then execute the enabled test by looping the test_case's array.

Link: https://lore.kernel.org/20260511162840.375890-14-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |   43 ++++++++++++++++++----
 1 file changed, 36 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-khugepaged-group-tests-in-an-array
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -1265,6 +1265,34 @@ static void parse_test_type(int argc, ch
 	get_finfo(argv[1]);
 }
 
+typedef void (*test_fn)(struct collapse_context *c, struct mem_ops *ops);
+
+struct test_case {
+	struct collapse_context *ctx;
+	struct mem_ops *ops;
+	const char *desc;
+	test_fn fn;
+};
+
+#define MAX_TEST_CASES 64
+static struct test_case test_cases[MAX_TEST_CASES];
+static int nr_test_cases;
+
+#define TEST(t, c, o) do {						\
+	if (c && o) {							\
+		if (nr_test_cases >= MAX_TEST_CASES) {			\
+			printf("MAX_TEST_CASES is too small\n");	\
+			exit(EXIT_FAILURE);				\
+		}							\
+		test_cases[nr_test_cases++] = (struct test_case){	\
+			.ctx	= c,					\
+			.ops	= o,					\
+			.desc	= #t,					\
+			.fn	= t,					\
+		};							\
+	}								\
+	} while (0)
+
 int main(int argc, char **argv)
 {
 	int hpage_pmd_order;
@@ -1320,13 +1348,6 @@ int main(int argc, char **argv)
 
 	alloc_at_fault();
 
-#define TEST(t, c, o) do { \
-	if (c && o) { \
-		printf("\nRun test: " #t " (%s:%s)\n", c->name, o->name); \
-		t(c, o); \
-	} \
-	} while (0)
-
 	TEST(collapse_full, khugepaged_context, anon_ops);
 	TEST(collapse_full, khugepaged_context, read_only_file_ops);
 	TEST(collapse_full, khugepaged_context, read_write_file_read_ops);
@@ -1404,5 +1425,13 @@ int main(int argc, char **argv)
 	TEST(madvise_retracted_page_tables, madvise_context, read_write_file_read_ops);
 	TEST(madvise_retracted_page_tables, madvise_context, shmem_ops);
 
+	exit_status = KSFT_PASS;
+	for (int i = 0; i < nr_test_cases; i++) {
+		struct test_case *t = &test_cases[i];
+
+		printf("\nRun test: %s (%s:%s)\n", t->desc, t->ctx->name, t->ops->name);
+		t->fn(t->ctx, t->ops);
+	}
+
 	restore_settings(0);
 }
_

Patches currently in -mm which might be from rppt@kernel.org are


