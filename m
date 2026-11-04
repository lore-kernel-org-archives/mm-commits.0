Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793833817;
	b=fFdhehD/Kunove6Outk22dhfyCcpafCy7qkORsYzkDS6BvdZoGbnytUG8lvthnw3RSyq
	 gb7GreTZrynr0gn3zpNWfKtib46s5jZW+mFSOQkVHYvLAMKp08eCgDDEwBYIOFxwxdODN
	 t6JrojqBCIyHHwijRlfVrD7sJod2tyaH2fnGXYyymZf7LjHQ9Xs9PI9pE3K1K4hIHdmV0
	 YB38Tn/kIJZKNLPbg88ZJegkT+Q7dO5mNRsknwJnlefNcx8v5Wbs2MjrkTBjRvHrAM/0G
	 bVUTDR/pdQsig7ijb83oZ1en8PQTJ7RcGcB6cFy0wmIwF3mOljrc1dYUrDosrGIX4/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793833817;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=YScgbNZBSMgqbf5wuxLRkBmwdAw3qjKG7/4OhnNc1tE=;
	b=hT0pS+CJdLjhsX9IVBsxcQjadxc0zNrIafokaOT1jtefv01cPsI/hTS0uayt73vxvqSM
	 piHj+LJ4SVe1CSyk2Pck0mkwRnPV/bd0DgrAHP9SkglAUs+AYbdFN/lhnWbE/hkTaFPPb
	 endPyM8toPrqHGwFp05CJufc54ofgS+v0S7IApkhbjSRMiqsa1ek52hPkPCtF2j4Hr8+0
	 pTex9hUyk2XOttXfX6fwdQ16o3NHhzwpD47ChqKGDYau8ehCmZIDqLSVXKVKYMgLupWMD
	 CnJ6KO+5Rix72v03eQ73LdshSesC6xc8PaYlhDn8uc6I9gmxKnw+GjwitQf2pBKZgQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hrwtkDW7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410CA606A326
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 23:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hrwtkDW7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA561F000C1;
	Wed,  4 Nov 2026 23:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793833817;
	bh=YScgbNZBSMgqbf5wuxLRkBmwdAw3qjKG7/4OhnNc1tE=;
	h=Date:To:From:Subject;
	b=hrwtkDW7lzsHkrPSSfMe5tfIyOGUmF0cCE2BO5cMED9hRDUUXuKlKCRLQukKprbKt
	 LoB8SNOcAEMG0ghdqvAcL+kbK9NTkp/YOm62EzFVqzhYQjKcPLoonFEjsWT1e0GsDM
	 86VBFcAKQEJ+GEiPzAnYCfqdg5Gok2BkXbqf7TSM=
Date: Wed, 04 Nov 2026 15:10:16 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,hao.ge@linux.dev,
	akpm@linux-foundation.org,abhishekbapat@google.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-add-a-test-for-trace-state-toggle-and-filtering.patch added to mm-new branch
Message-Id: <20261104231016.EDA561F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: alloc_tag: add a test for trace state toggle and filtering
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-add-a-test-for-trace-state-toggle-and-filtering.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-add-a-test-for-trace-state-toggle-and-filtering.patch

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
From: Abhishek Bapat <abhishekbapat@google.com>
Subject: alloc_tag: add a test for trace state toggle and filtering
Date: Wed, 04 Nov 2026 19:03:40 +0000

Following the introduction of the ALLOCINFO_IOC_TOGGLE_TRACE IOCTL and
ALLOCINFO_FILTER_MASK_TRACE_ON filters for selective memory allocation
tracing, update the kselftests to validate this behaviour.

Introduce `test_tracing_toggle_and_filter`, which validates the
architecture by:
1. Dynamically flipping trace execution state for a designated allocation.
2. Query the same tag again, and check that the returned tag reports the
   new state in its `trace_on` field.
3. Restore the tag's original trace state, also on failure, so the test
   does not leave tracing changed on the system.

The test uses `dup_mm()` function name with the function filter in the
IOCTL to run the above steps.  If the `dup_mm()` tag is not found, the
test is skipped.

Link: https://lore.kernel.org/14ace814ca8c05196ebecb150cf710399a040b59.1793818636.git.abhishekbapat@google.com
Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Ge <hao.ge@linux.dev>
---

 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c |  114 +++++++++-
 1 file changed, 111 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c~alloc_tag-add-a-test-for-trace-state-toggle-and-filtering
+++ a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
@@ -48,6 +48,11 @@ static inline int __allocinfo_get_next(i
 	return ioctl(dev_fd, ALLOCINFO_IOC_GET_NEXT, params);
 }
 
+static inline int __allocinfo_toggle_trace(int dev_fd, struct allocinfo_toggle_traces *params)
+{
+	return ioctl(dev_fd, ALLOCINFO_IOC_TOGGLE_TRACE, params);
+}
+
 static bool match_entry(const struct allocinfo_tag_data *procfs_entry,
 			const struct allocinfo_tag_data *tag_data,
 			bool match_bytes, bool match_calls, bool match_lineno,
@@ -289,6 +294,8 @@ exit:
 	return ret;
 }
 
+static const char *target_test_function = "dup_mm";
+
 static int test_filename_filter(void)
 {
 	struct allocinfo_filter filter;
@@ -304,11 +311,10 @@ static int test_filename_filter(void)
 static int test_function_filter(void)
 {
 	struct allocinfo_filter filter;
-	const char *target_function = "dup_mm";
 
 	memset(&filter, 0, sizeof(filter));
 	filter.mask |= ALLOCINFO_FILTER_MASK_FUNCTION;
-	strncpy(filter.fields.function, target_function, ALLOCINFO_STR_SIZE);
+	strncpy(filter.fields.function, target_test_function, ALLOCINFO_STR_SIZE);
 
 	return run_filter_test(&filter);
 }
@@ -514,11 +520,107 @@ exit:
 	return ret;
 }
 
+static enum ioctl_ret toggle_trace(struct allocinfo_tag *target_tag,
+				   bool enable)
+{
+	int fd;
+	struct allocinfo_toggle_traces toggle_params;
+
+	fd = open(ALLOCINFO_PROC, O_RDONLY);
+	if (fd < 0) {
+		ksft_print_msg("Failed to open " ALLOCINFO_PROC ": %s\n", strerror(errno));
+		return IOCTL_FAILURE;
+	}
+
+	memset(&toggle_params, 0, sizeof(toggle_params));
+	toggle_params.filter.mask = ALLOCINFO_FILTER_MASK_MODNAME | ALLOCINFO_FILTER_MASK_FUNCTION |
+				    ALLOCINFO_FILTER_MASK_FILENAME | ALLOCINFO_FILTER_MASK_LINENO;
+	toggle_params.filter.fields = *target_tag;
+	toggle_params.enable = enable;
+
+	if (__allocinfo_toggle_trace(fd, &toggle_params)) {
+		close(fd);
+		return IOCTL_FAILURE;
+	}
+
+	close(fd);
+	return IOCTL_SUCCESS;
+}
+
+static int test_tracing_toggle_and_filter(void)
+{
+	struct allocinfo_filter filter = { 0 };
+	enum ioctl_ret ioctl_status;
+	int ret = KSFT_PASS;
+	bool initial_state, target_state;
+	struct allocinfo_tag target_tag;
+	struct allocinfo_tag_data_vec *tags = calloc(1, sizeof(*tags));
+
+	if (!tags) {
+		ksft_print_msg("Memory allocation failed.\n");
+		return KSFT_FAIL;
+	}
+
+	filter.mask |= ALLOCINFO_FILTER_MASK_FUNCTION;
+	strncpy(filter.fields.function, target_test_function, ALLOCINFO_STR_SIZE);
+
+	ioctl_status = get_filtered_ioctl_entries(tags, &filter, 0);
+	if (ioctl_status != IOCTL_SUCCESS || tags->count == 0) {
+		ksft_print_msg("Could not retrieve IOCTL entries for %s\n", target_test_function);
+		ret = KSFT_SKIP;
+		goto exit;
+	}
+
+	target_tag = tags->tag[0].tag;
+	initial_state = tags->tag[0].counter.trace_on;
+	target_state = !initial_state;
+
+	ioctl_status = toggle_trace(&target_tag, target_state);
+	if (ioctl_status != IOCTL_SUCCESS) {
+		ksft_print_msg("Failed to toggle tracing\n");
+		ret = KSFT_FAIL;
+		goto exit;
+	}
+
+	filter.mask |= ALLOCINFO_FILTER_MASK_TRACE_ON;
+	if (target_state)
+		filter.flags |= ALLOCINFO_FILTER_FLAG_TRACE_ON;
+
+	ioctl_status = get_filtered_ioctl_entries(tags, &filter, 0);
+	if (ioctl_status != IOCTL_SUCCESS) {
+		ksft_print_msg("Error retrieving IOCTL entries with trace filter.\n");
+		ret = KSFT_FAIL;
+		goto exit_revert;
+	}
+
+	if (tags->count != 1) {
+		ksft_print_msg("Expected exactly 1 entry, but got %llu\n", tags->count);
+		ret = KSFT_FAIL;
+		goto exit_revert;
+	}
+
+	if (tags->tag[0].counter.trace_on != target_state) {
+		ksft_print_msg("Entry returned by trace filter does not match target state\n");
+		ret = KSFT_FAIL;
+	}
+
+exit_revert:
+	ioctl_status = toggle_trace(&target_tag, initial_state);
+	if (ioctl_status != IOCTL_SUCCESS) {
+		ksft_print_msg("Failed to revert tracing to initial state\n");
+		ret = KSFT_FAIL;
+	}
+
+exit:
+	free(tags);
+	return ret;
+}
+
 int main(int argc, char *argv[])
 {
 	int ret;
 
-	ksft_set_plan(4);
+	ksft_set_plan(5);
 
 	ret = test_filename_filter();
 	if (ret == KSFT_SKIP)
@@ -526,6 +628,12 @@ int main(int argc, char *argv[])
 	else
 		ksft_test_result(ret == KSFT_PASS, "test_filename_filter\n");
 
+	ret = test_tracing_toggle_and_filter();
+	if (ret == KSFT_SKIP)
+		ksft_test_result_skip("Skipping test_tracing_toggle_and_filter\n");
+	else
+		ksft_test_result(ret == KSFT_PASS, "test_tracing_toggle_and_filter\n");
+
 	ret = test_function_filter();
 	if (ret == KSFT_SKIP)
 		ksft_test_result_skip("Skipping test_function_filter\n");
_

Patches currently in -mm which might be from abhishekbapat@google.com are

alloc_tag-add-trace-events-for-tracing-allocations.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints.patch
alloc_tag-add-a-flags-field-to-allocinfo_filter.patch
alloc_tag-extend-allocinfo_filter-to-support-tracing-queries.patch
alloc_tag-add-a-test-for-trace-state-toggle-and-filtering.patch

