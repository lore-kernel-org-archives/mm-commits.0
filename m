Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DD548E0CF
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 19:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788897039; cv=none; b=LcVkxyNWvrV2hHGx+pJl3QvtGD3D9D3YBgLklduU5RVf01zy/ecoL3CZLRdC6eaFlRRGMArc5tlafow1RFyi7GHoFKGRQRHOzED1V/NDjJMc7Y3kn4AERr45FjIZfnZigfb8TWmbll64292eS8spzwMGGo3lNVTL2Nd1/13WQxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788897039; c=relaxed/simple;
	bh=E8b9T+b5iAyb6Elp30FeRhgkL9J0LmTW3hYXw5IIu5g=;
	h=Date:To:From:Subject:Message-Id; b=R3Os0vP1RQxp63Zb5e4/IvSIOsoo9THuibXjCmtS+mlL5lTrEKn6jVERg4B/zaDf0z6+RZRMMdXIWr9QS1Up4X6o8gtZwdG43U0nZgVPY1t4AQ86UYN/yAYOZMoFqL3akQoYOU0qx7eo1r0Xf2t+g4eZI7k6uLS/tYKdAiIxSJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BzEIb7EU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BzEIb7EU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388691F00A3D;
	Tue,  8 Sep 2026 19:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788897037;
	bh=JjwXymZfp59eHkJWPLdj2VKSd4JnQEX9GcO402uyGmg=;
	h=Date:To:From:Subject;
	b=BzEIb7EUL4gMQZJH3FMv8F1hTx7qkRwK9/pyi3aVn0gy4qUF/SL+fD5Bg5PguYQ/+
	 Xe2D3hICKQvFJ0Wl9pl8rprOnPFSFivhhtFyILSmwt1lx3ZHv4YAWVc6S+GyqSG36E
	 WZ1SGA38xmKlff/tzvejNMvjBT/lMmF0GDfObZO4=
Date: Tue, 08 Sep 2026 12:50:36 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-run-every-supported-collapse-order-by-default.patch added to mm-new branch
Message-Id: <20260908195037.388691F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: run every supported collapse order by default
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-run-every-supported-collapse-order-by-default.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-run-every-supported-collapse-order-by-default.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: selftests/mm: run every supported collapse order by default
Date: Tue, 8 Sep 2026 13:51:00 +0100

The mTHP collapse cases only run when the caller names both the context
and an order, so a plain ./khugepaged covers the PMD contexts on anon and
nothing else.  run_vmtests.sh pinned order 4 and covered no other.

Run the mTHP cases once per supported anon THP order below the PMD when -c
is absent, and pull that context into both the no-argument invocation and
"all".  Also:

  - -c still pins one order, and now says what is wrong instead of
    printing the usage text.  An order at or below the -s source order is
    skipped: the sources would already be the size being asked for.

  - Both orders end up as array indices and shift counts, so -s and -c
    are range-checked before they get there.

  - The mTHP context has only anon cases, so a run that names a different
    mem_type -- "all:shmem", say -- drops it again rather than refusing
    to start.  Naming both explicitly still refuses.

  - A case carries the order it was registered at, so a result names it:

      # Run test: collapse_single_mthp (mthp_khugepaged:anon, order 6)

On x86-64 with 4K pages that is orders 2 through 8, and ./khugepaged goes
from 29 results in 17 seconds to 77 in 29, so run_vmtests.sh can drop its
pinned order-4 line.

Assisted-by: LLM
Link: https://lore.kernel.org/20260908125105.1510704-15-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c   |   98 +++++++++++++++-----
 tools/testing/selftests/mm/run_vmtests.sh |    2 
 2 files changed, 78 insertions(+), 22 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-run-every-supported-collapse-order-by-default
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -30,6 +30,9 @@ static unsigned long page_size;
 static int hpage_pmd_nr;
 static int anon_order;
 static int collapse_order;
+static bool collapse_order_set;
+static int collapse_orders[NR_ORDERS];
+static int nr_collapse_orders;
 static int pagemap_fd = -1;
 static int kpageflags_fd = -1;
 
@@ -1522,12 +1525,14 @@ static void usage(void)
 	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
 	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon or shmem allocations.\n");
 	fprintf(stderr,	"\t\t-c: collapse order for mTHP collapse, expressed as page order.\n");
+	fprintf(stderr,	"\t\t    Defaults to every supported order below the PMD.\n");
 	fprintf(stderr,	"\t\t    -s, if set, is the source order for the mixed-source case.\n");
 	exit(1);
 }
 
 static void parse_test_type(int argc, char **argv)
 {
+	bool mthp_context_implied = false;
 	int opt;
 	char *buf;
 	const char *token;
@@ -1539,6 +1544,7 @@ static void parse_test_type(int argc, ch
 			break;
 		case 'c':
 			collapse_order = atoi(optarg);
+			collapse_order_set = true;
 			break;
 		case 'h':
 		default:
@@ -1546,12 +1552,25 @@ static void parse_test_type(int argc, ch
 		}
 	}
 
+	/*
+	 * Both orders end up as array indices and shift counts, so neither
+	 * can be negative, and a zero collapse order asks for base pages.
+	 */
+	if (anon_order < 0 || anon_order > hpage_pmd_order)
+		ksft_exit_fail_msg("-s takes an order in 0..%d, not %d\n",
+				   hpage_pmd_order, anon_order);
+	if (collapse_order_set &&
+	    (collapse_order <= 0 || collapse_order >= hpage_pmd_order))
+		ksft_exit_fail_msg("-c takes an order in 1..%d, not %d\n",
+				   hpage_pmd_order - 1, collapse_order);
+
 	argv += optind;
 	argc -= optind;
 
 	if (argc == 0) {
-		/* Backwards compatibility */
+		/* No arguments: anon under every context */
 		khugepaged_context =  &__khugepaged_context;
+		mthp_khugepaged_context =  &__mthp_khugepaged_context;
 		madvise_context =  &__madvise_context;
 		anon_ops = &__anon_ops;
 		return;
@@ -1562,13 +1581,14 @@ static void parse_test_type(int argc, ch
 
 	if (!strcmp(token, "all")) {
 		khugepaged_context =  &__khugepaged_context;
+		mthp_khugepaged_context =  &__mthp_khugepaged_context;
 		madvise_context =  &__madvise_context;
+		/* The mTHP context has only anon cases; let other mem_types drop it */
+		mthp_context_implied = true;
 	} else if (!strcmp(token, "khugepaged")) {
 		khugepaged_context =  &__khugepaged_context;
 	} else if (!strcmp(token, "mthp_khugepaged")) {
 		mthp_khugepaged_context =  &__mthp_khugepaged_context;
-		if (collapse_order <= 0 || collapse_order >= hpage_pmd_order)
-			usage();
 	} else if (!strcmp(token, "madvise")) {
 		madvise_context =  &__madvise_context;
 	} else {
@@ -1584,20 +1604,20 @@ static void parse_test_type(int argc, ch
 		read_write_file_write_ops =  &__read_write_file_write_ops;
 		anon_ops = &__anon_ops;
 		shmem_ops = &__shmem_ops;
-		if (mthp_khugepaged_context)
-			usage();
 	} else if (!strcmp(buf, "anon")) {
 		anon_ops = &__anon_ops;
 	} else if (!strcmp(buf, "file")) {
 		read_only_file_ops =  &__read_only_file_ops;
 		read_write_file_read_ops =  &__read_write_file_read_ops;
 		read_write_file_write_ops =  &__read_write_file_write_ops;
-		if (mthp_khugepaged_context)
+		if (mthp_khugepaged_context && !mthp_context_implied)
 			usage();
+		mthp_khugepaged_context = NULL;
 	} else if (!strcmp(buf, "shmem")) {
 		shmem_ops = &__shmem_ops;
-		if (mthp_khugepaged_context)
+		if (mthp_khugepaged_context && !mthp_context_implied)
 			usage();
+		mthp_khugepaged_context = NULL;
 	} else {
 		usage();
 	}
@@ -1619,6 +1639,7 @@ struct test_case {
 	struct mem_ops *ops;
 	const char *desc;
 	test_fn fn;
+	int order;		/* mTHP contexts: the collapse order */
 };
 
 #define MAX_TEST_CASES 256
@@ -1634,6 +1655,7 @@ static int nr_test_cases;
 			.ops	= o,					\
 			.desc	= #t,					\
 			.fn	= t,					\
+			.order	= collapse_order,			\
 		};							\
 	}								\
 	} while (0)
@@ -1674,10 +1696,35 @@ int main(int argc, char **argv)
 
 	parse_test_type(argc, argv);
 
-	if (mthp_khugepaged_context &&
-	    !(thp_supported_orders() & (1UL << collapse_order)))
-		ksft_exit_skip("Order %d is not a supported anon THP order\n",
-			       collapse_order);
+	if (mthp_khugepaged_context) {
+		unsigned long orders = thp_supported_orders();
+
+		if (collapse_order_set) {
+			if (!(orders & (1UL << collapse_order)))
+				ksft_exit_skip("Order %d is not a supported anon THP order\n",
+					       collapse_order);
+			if (collapse_order <= anon_order)
+				ksft_exit_skip("-c %d needs a source order below it, -s says %d\n",
+					       collapse_order, anon_order);
+			collapse_orders[nr_collapse_orders++] = collapse_order;
+		} else {
+			/*
+			 * Every supported order above the source: -s makes the
+			 * fault path hand out folios of that order, so a target
+			 * at or below it has nothing to collapse.
+			 */
+			int first = anon_order + 1;
+
+			if (first < MIN_MTHP_ORDER)
+				first = MIN_MTHP_ORDER;
+			for (int i = first; i < hpage_pmd_order; i++) {
+				if (orders & (1UL << i))
+					collapse_orders[nr_collapse_orders++] = i;
+			}
+			if (!nr_collapse_orders)
+				ksft_print_msg("mTHP cases skipped: no order above the source\n");
+		}
+	}
 
 	if (mthp_khugepaged_context) {
 		pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
@@ -1726,7 +1773,17 @@ int main(int argc, char **argv)
 	TEST(collapse_full, khugepaged_context, read_write_file_read_ops);
 	TEST(collapse_full, khugepaged_context, read_write_file_write_ops);
 	TEST(collapse_full, khugepaged_context, shmem_ops);
-	TEST(collapse_full, mthp_khugepaged_context, anon_ops);
+	for (int i = 0; i < nr_collapse_orders; i++) {
+		collapse_order = collapse_orders[i];
+		TEST(collapse_full, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_empty, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_single_mthp, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_order_single_window, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_order_partial_window, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_order_max_ptes_none, mthp_khugepaged_context, anon_ops);
+		TEST(collapse_order_mixed_sources, mthp_khugepaged_context, anon_ops);
+	}
+
 	TEST(collapse_full, madvise_context, anon_ops);
 	TEST(collapse_full, madvise_context, read_only_file_ops);
 	TEST(collapse_full, madvise_context, read_write_file_read_ops);
@@ -1734,15 +1791,8 @@ int main(int argc, char **argv)
 	TEST(collapse_full, madvise_context, shmem_ops);
 
 	TEST(collapse_empty, khugepaged_context, anon_ops);
-	TEST(collapse_empty, mthp_khugepaged_context, anon_ops);
 	TEST(collapse_empty, madvise_context, anon_ops);
 
-	TEST(collapse_single_mthp, mthp_khugepaged_context, anon_ops);
-	TEST(collapse_order_single_window, mthp_khugepaged_context, anon_ops);
-	TEST(collapse_order_partial_window, mthp_khugepaged_context, anon_ops);
-	TEST(collapse_order_max_ptes_none, mthp_khugepaged_context, anon_ops);
-	TEST(collapse_order_mixed_sources, mthp_khugepaged_context, anon_ops);
-
 	TEST(collapse_single_pte_entry, khugepaged_context, anon_ops);
 	TEST(collapse_single_pte_entry, khugepaged_context, read_only_file_ops);
 	TEST(collapse_single_pte_entry, khugepaged_context, read_write_file_read_ops);
@@ -1815,7 +1865,15 @@ int main(int argc, char **argv)
 	for (int i = 0; i < nr_test_cases; i++) {
 		struct test_case *t = &test_cases[i];
 
-		ksft_print_msg("\n# Run test: %s (%s:%s)\n", t->desc, t->ctx->name, t->ops->name);
+		if (t->ctx == &__mthp_khugepaged_context) {
+			collapse_order = t->order;
+			ksft_print_msg("\n# Run test: %s (%s:%s, order %d)\n",
+				       t->desc, t->ctx->name, t->ops->name,
+				       t->order);
+		} else {
+			ksft_print_msg("\n# Run test: %s (%s:%s)\n", t->desc,
+				       t->ctx->name, t->ops->name);
+		}
 		t->fn(t->ctx, t->ops);
 	}
 
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run-every-supported-collapse-order-by-default
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -377,8 +377,6 @@ CATEGORY="thp" run_test ./khugepaged all
 
 CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
 
-CATEGORY="thp" run_test ./khugepaged -c 4 mthp_khugepaged:anon
-
 # Try to create XFS if not provided
 if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
     if test_selected "thp"; then
_

Patches currently in -mm which might be from kas@kernel.org are

mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch
mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch
selftests-mm-raise-the-khugepaged-test-case-cap.patch
selftests-mm-skip-collapse_compound_extreme-where-the-pmd-is-too-large.patch
selftests-mm-scale-khugepageds-collapse-wait-with-the-pmd-size.patch
selftests-mm-skip-khugepaged-page-cache-cases-without-a-pmd-folio.patch
selftests-mm-make-the-swap-cases-swapout-reliable.patch
selftests-mm-stop-khugepaged-during-the-madv_collapse-cases.patch
selftests-mm-move-is_backed_by_folio-into-vm_util.patch
selftests-mm-add-folio-order-check-for-address-ranges.patch
selftests-mm-add-folio-order-detection-self-check.patch
selftests-mm-add-khugepaged-completion-barrier-helper.patch
selftests-mm-add-order-parameterized-khugepaged-collapse-cases.patch
selftests-mm-parameterize-the-mixed-source-collapse-case-by-source-order.patch
selftests-mm-cover-a-shared-source-collapse-write-race.patch
selftests-mm-run-every-supported-collapse-order-by-default.patch
selftests-mm-check-that-one-khugepaged-pass-collapses-one-window.patch
selftests-mm-add-khugepaged-race-harness.patch
selftests-mm-race-the-collapse-of-windows-with-holes.patch
selftests-mm-add-memory-pressure-threads-to-the-khugepaged-race-harness.patch
selftests-mm-zap-whole-pte-tables-in-the-khugepaged-race-harness.patch

