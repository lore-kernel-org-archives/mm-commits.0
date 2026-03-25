Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B89B3043C8
	for <mm-commits@vger.kernel.org>; Wed, 25 Mar 2026 04:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774413261; cv=none; b=iB/E8Lh7xaQfRADtUTLN70yQgeFCdnhYpft/7NEqo7nTgQvw1gO9NJAnYy0fOTIHc3yZyLdn22N4TNwvuF66qWvZ1y8eYToMc1qz4w6l2KYX5CODvc5lNm+m/2wVnY9mvdO9Mbc+KRBoFsiZ/JEKP/jLvOuu5lZBcVZKMz8lb6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774413261; c=relaxed/simple;
	bh=Fo2h8Bl9odYW8VSNxoY1x5oMz55Mas/474ADDk8kmRA=;
	h=Date:To:From:Subject:Message-Id; b=kBZXWX0K1Z+bpjcf2Uxefo+wKMo9RfXmDZ5mJ9tDU3+aUGeArI2NwIbhLZFZPfURDXvDP3QU84hNYh2PHknN3/B/3xq/XIz+07t5FsGaLvX9sRS8l1MLT0WwYtptaPsxEX30xAiIj7X6npHlbX2rvCrky52ZoceFNIIAT/BBLq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0tUAmncN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0tUAmncN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD46C4CEF7;
	Wed, 25 Mar 2026 04:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774413260;
	bh=Fo2h8Bl9odYW8VSNxoY1x5oMz55Mas/474ADDk8kmRA=;
	h=Date:To:From:Subject:From;
	b=0tUAmncNk0uyALBi3Ccf4joot7Gr2Bs281aAvXz0rTgtHKft8/xLDcToNMIO5p0IF
	 +KJUmMJU2CprVVAW5c7BZCoo0dZMoFxWHSsAQcm1e/HABSC+DNEysRmsMZdvkt3wZx
	 OCtZ+s1sXTi3BQ1AVf+E5i8+Ih4y9+DCuTBgwnh0=
Date: Tue, 24 Mar 2026 21:34:19 -0700
To: mm-commits@vger.kernel.org,mhiramat@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] decode_stacktrace-decode-caller-address-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20260325043420.8AD46C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: decode_stacktrace-decode-caller-address-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     decode_stacktrace-decode-caller-address-checkpatch-fixes.patch

This patch was dropped because it was folded into decode_stacktrace-decode-caller-address.patch

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

selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported-fix.patch
mm-switch-the-rmap-lock-held-option-off-in-compat-layer-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
decode_stacktrace-decode-caller-address.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

