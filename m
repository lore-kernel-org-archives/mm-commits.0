Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F76148304
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 18:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713293120; cv=none; b=mD7XVNhsM8iQXp8zH3signN/jyFj5K8lljJqvP3IpSCrdg0YEH/mBODCKaBQKNWp0ZOMjxRmtiK6R0M9LELUwCu9pxoUPkvtLSKLd3yN68dtwF72zN/Fr5nrp5NtRvqH4mvB2rDcreFGDrTur3aHRoCRnop+N+SI6jahhapI4RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713293120; c=relaxed/simple;
	bh=EljhDih2OBGz8LCF0RwfdcKOmNAU9727L5Wp6iXGP9Q=;
	h=Date:To:From:Subject:Message-Id; b=qjjSZLuOmKmpmgA2RtbNl2AFusB8Qni21A6PDxyY+zEoLfJZhBj7f1EXtR7dqRRnd2ubmPEjuhwbK2+G2OBDx+MbwhIIasGcDtPwxutxyIFw7ywqkFnvEwdS7pCNu5oLCYJhwDEPa3ypXktgOMzdOCdhQ2qFDbAMw96xRO+059I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fVvmFgY6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fVvmFgY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D587EC2BD11;
	Tue, 16 Apr 2024 18:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713293119;
	bh=EljhDih2OBGz8LCF0RwfdcKOmNAU9727L5Wp6iXGP9Q=;
	h=Date:To:From:Subject:From;
	b=fVvmFgY6QsKirmyABC5xVhOPXnHeuVBa1tG6XGEl6myTNh4d9FCOmvhH7l/72cidu
	 r9jiOwXKAHdNZavxG7VeX9abnlWL7oHYanxneS3oJ+bwLnZaFo+72BBVdzH/l8LLQ7
	 IHkxJRLwpC3xSoaOU6If/dDduBs06eyn1f4Hk9bc=
Date: Tue, 16 Apr 2024 11:45:19 -0700
To: mm-commits@vger.kernel.org,edliaw@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-harness-remove-use-of-line_max-fix-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20240416184519.D587EC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-harness-remove-use-of-line_max-fix-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-harness-remove-use-of-line_max-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-harness-remove-use-of-line_max-fix-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-harness-remove-use-of-line_max-fix-fix
Date: Tue Apr 16 11:39:55 AM PDT 2024

check asprintf() return

Cc: Edward Liaw <edliaw@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kselftest_harness.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/kselftest_harness.h~selftests-harness-remove-use-of-line_max-fix-fix
+++ a/tools/testing/selftests/kselftest_harness.h
@@ -1163,8 +1163,12 @@ void __run_test(struct __fixture_metadat
 	t->trigger = 0;
 	memset(t->results->reason, 0, sizeof(t->results->reason));
 
-	asprintf(&test_name, "%s%s%s.%s", f->name,
-	         variant->name[0] ? "." : "", variant->name, t->name);
+	if (asprintf(&test_name, "%s%s%s.%s", f->name,
+		variant->name[0] ? "." : "", variant->name, t->name) == -1) {
+		ksft_print_msg("ERROR ALLOCATING MEMORY\n");
+		t->exit_code = KSFT_FAIL;
+		_exit(t->exit_code);
+	}
 
 	ksft_print_msg(" RUN           %s ...\n", test_name);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled-v2-fix.patch
selftests-harness-remove-use-of-line_max-fix.patch
selftests-harness-remove-use-of-line_max-fix-fix.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch

