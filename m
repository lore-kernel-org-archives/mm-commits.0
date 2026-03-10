Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10303A9D8E
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 18:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773168627; cv=none; b=cRFIH3O9Lvxxk6KADCl2RysD1UJJ1S4g9gXC58I3ADA2duNwyvdqrawsIzEgYnkTbTsiwlzyGK5Hz7jN1dnpVmcfeddBioGbK8cHQpSAC+KTNgVbXdmfhMlXlIMOi1Fae+CQtr452Tuk1qB/adPvLjl8olewykPecuzlffoOQx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773168627; c=relaxed/simple;
	bh=7TqiyGhZKoSeUJRfnTm2DpMuU9pMNzdCaaMV9C/ZVjA=;
	h=Date:To:From:Subject:Message-Id; b=oiqnY5EAiYdLDhwNO4e7bySEVLf8mbqJ/2Qu2onvRgH9uMSfiDy3hFKVETDEf61mazqMp32rnST4Bva61Tm76v0xRqnbh8T4WMat51a6kLg+n+ipj/xbpuY5mXC/759d/tlXoGA3z+OVymwbzlK8PBybPw/p026pGVsMi/tnS3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E/v1IuQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E/v1IuQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722D3C19423;
	Tue, 10 Mar 2026 18:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773168626;
	bh=7TqiyGhZKoSeUJRfnTm2DpMuU9pMNzdCaaMV9C/ZVjA=;
	h=Date:To:From:Subject:From;
	b=E/v1IuQnUURsXtzUT1AA/HG044bh/PD6p2xHoxcwZXh0Cgq+9bJrWBLp8YQwzVCFH
	 kxIgOU7XWzqkbwoHErLgNy4kLyW9YkO7EvQwyC+zPUQqYo43vJ/4MklPzcAOB3xWR6
	 sue9iwVpUgmANoY1MDl+ZdZwrDm3xXyKsJmvHEu8=
Date: Tue, 10 Mar 2026 11:50:25 -0700
To: mm-commits@vger.kernel.org,mhiramat@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + decode_stacktrace-decode-caller-address-checkpatch-fixes.patch added to mm-nonmm-unstable branch
Message-Id: <20260310185026.722D3C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: decode_stacktrace-decode-caller-address-checkpatch-fixes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     decode_stacktrace-decode-caller-address-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/decode_stacktrace-decode-caller-address-checkpatch-fixes.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: decode_stacktrace-decode-caller-address-checkpatch-fixes
Date: Tue Mar 10 11:48:47 AM PDT 2026

WARNING: 'substract' may be misspelled - perhaps 'subtract'?
#106: FILE: scripts/decode_stacktrace.sh:198:
+	# symbol, substract one from that to point the call instruction.
 	          ^^^^^^^^^

Please run checkpatch prior to sending patches

Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/decode_stacktrace.sh~decode_stacktrace-decode-caller-address-checkpatch-fixes
+++ a/scripts/decode_stacktrace.sh
@@ -195,7 +195,7 @@ parse_symbol() {
 	# Evaluate it to find the actual address
 	# The stack trace shows the return address, which is the next
 	# instruction after the actual call, so as long as it's in the same
-	# symbol, substract one from that to point the call instruction.
+	# symbol, subtract one from that to point the call instruction.
 	if [[ $decode_retaddr == false && $offset != 0 ]]; then
 		expr=$((expr-1))
 	else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch
mm-rename-zone-lock-to-zone-_lock-fix.patch
mm-page_reporting-add-page_reporting_order_unspecified-fix.patch
mm-huge_memory-refactor-enabled_store-with-change_enabled-checkpatch-fixes.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch
decode_stacktrace-decode-caller-address-checkpatch-fixes.patch

