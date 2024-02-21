Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E3C12A16B
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 23:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708559130; cv=none; b=GKV3dral6tctA4qjeZNGTAvyKrlvvJrEEmVZSLd+/7AuCFiRv+pW+rFpa3ZlbWxB03LdAPttXXYevQdWqq86HjDsFh7eVEuSqdTHAbBr9QBdr4Ey7GjG0rwcdOVblEAnwpgOy2kdjzSzruZxLGQe8S3KI8/TANxsZdd00xf/RAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708559130; c=relaxed/simple;
	bh=+Jcxbxj0J4CJKiTjz+gyMAIRPw+ck814Uog5tkVsHSg=;
	h=Date:To:From:Subject:Message-Id; b=oU0HtSnITCaVp5nZ6HLDOwSlJi6o055UrBCI3lemCIAXE1mgFPqFVo8TTn+/EE3J0paBjXP4BAyP/FtJDJMXvxCMMYQ0cckuY0tkVf6fFq9P0EbteWUJlGUG1wfvKjDJFN7pIGBMSuVmD9woU0xFCeYvjUJ+K1fhWDGSNkCvQiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xQjh6+VQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xQjh6+VQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD175C433F1;
	Wed, 21 Feb 2024 23:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708559130;
	bh=+Jcxbxj0J4CJKiTjz+gyMAIRPw+ck814Uog5tkVsHSg=;
	h=Date:To:From:Subject:From;
	b=xQjh6+VQEOOpUj9Ru0fY7hjwThqodNQJ4W4Gbq9N/p0arF2UVJDXcDU+X8KqmUGZv
	 cUUMizCZTSQ16HsvRDN8YMcDt2ofeSNX0i/kcftfzEm3gxpHqbIXGc0EyzM62S5r1y
	 VexAhpPin3+s3I4B511L4nThdQf8Qyz4Led0GMvo=
Date: Wed, 21 Feb 2024 15:45:29 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,p.raghav@samsung.com,mcgrof@kernel.org,da.gomez@samsung.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] test_xarray-add-tests-for-advanced-multi-index-use-fix-fix-fix.patch removed from -mm tree
Message-Id: <20240221234529.DD175C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: test_xarray-add-tests-for-advanced-multi-index-use-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     test_xarray-add-tests-for-advanced-multi-index-use-fix-fix-fix.patch

This patch was dropped because it was folded into test_xarray-add-tests-for-advanced-multi-index-use.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: test_xarray-add-tests-for-advanced-multi-index-use-fix-fix-fix
Date: Tue Feb 20 10:59:48 AM PST 2024

restore static storage for loop counter

Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_xarray.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_xarray.c~test_xarray-add-tests-for-advanced-multi-index-use-fix-fix-fix
+++ a/lib/test_xarray.c
@@ -728,7 +728,7 @@ static noinline void *test_get_entry(str
 {
 	XA_STATE(xas, xa, index);
 	void *p;
-	unsigned int loops = 0;
+	static unsigned int loops = 0;
 
 	rcu_read_lock();
 repeat:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

test_xarray-add-tests-for-advanced-multi-index-use.patch
kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix.patch
mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch
panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch

