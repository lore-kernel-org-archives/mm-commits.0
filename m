Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1698C5240
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 02:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714012093; cv=none; b=QSV+zu8LDMSvS0K2zDq1lmJslaLO+XzDiWfjnUjePPgWAvkIV8KL6GLf5lRssItH6mCHMDyeZjRtb8oe2zipVt0Fqw23xSSQ+nros6hjFvAcqlQSBGLqCRekluR1fkO3M2GG5ALfILSJ9nooW5xW/zuWotOTr4P5IaaKqb4npvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714012093; c=relaxed/simple;
	bh=muU6bs6VYIL7j38JdI/mUsItdr/xiAR0SLQkQXUGD2E=;
	h=Date:To:From:Subject:Message-Id; b=biUlSt/6XrWTC8iBa4q6UI6MeQkG86udCVvHPBeB+oLkltDZu7PKhV6WW+GTPXhABasijmasMSOGsqmoQTCofVABuB2P2qGwE/rp8kDgSEnhSQH0pDbEpSmhx+CzUoEZx6RlBCpclRrZD4QwBmDAOzgmMKiBiEAHLYv/+RNgk6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RSZTFzZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RSZTFzZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A0DC113CD;
	Thu, 25 Apr 2024 02:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714012092;
	bh=muU6bs6VYIL7j38JdI/mUsItdr/xiAR0SLQkQXUGD2E=;
	h=Date:To:From:Subject:From;
	b=RSZTFzZPEDV318upja2V0Q2nHgGZCNQruy/W3GTT7Qy2e69R5wktOkdvLcyDgp+PB
	 WzAULCSnfPBuPuO50AMt6XOFuqWEOU1pg1aCgfILYM5qhomXSw7BfjB2LTEQRoUFpo
	 D/WoKg8b4jmbz8ELxmHynrRIqHdu43YrRTfl+/Lk=
Date: Wed, 24 Apr 2024 19:28:11 -0700
To: mm-commits@vger.kernel.org,yujie.liu@intel.com,wad@chromium.org,usama.anjum@collabora.com,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,luto@amacapital.net,keescook@chromium.org,justinstitt@google.com,edliaw@google.com,david@redhat.com,axelrasmussen@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-harness-remove-use-of-line_max-fix-fix.patch removed from -mm tree
Message-Id: <20240425022812.72A0DC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-harness-remove-use-of-line_max-fix-fix
has been removed from the -mm tree.  Its filename was
     selftests-harness-remove-use-of-line_max-fix-fix.patch

This patch was dropped because it was folded into selftests-harness-remove-use-of-line_max.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-harness-remove-use-of-line_max-fix-fix
Date: Tue Apr 16 11:39:55 AM PDT 2024

check asprintf() return

Reviewed-by: Edward Liaw <edliaw@google.com>
Tested-by: Yujie Liu <yujie.liu@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
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

selftests-harness-remove-use-of-line_max.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch
binfmt_elf_fdpic-fix-proc-pid-auxv-checkpatch-fixes.patch

