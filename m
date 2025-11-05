Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39404256C70
	for <mm-commits@vger.kernel.org>; Wed,  5 Nov 2025 22:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762382082; cv=none; b=WE9AeLmGI/vsjRD6PJbh9+QGoQ8O+jqWTIpyhbw7FILwMDe2vYPV9BuKeX6/IxlXUDFSx4lUQYlNsOuHOoWU+wd/ztGERhHuynvLCTV8DJ/3TmCGorVTJ7u4202AF6FhYyhX68Qco0nBBpLNd+GcDl19lSqiTFe9DgtZglmjuu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762382082; c=relaxed/simple;
	bh=XW9X0NrkDxwVVQYRRgTFfQ6cR5w8lFi/tiOoUg3xtag=;
	h=Date:To:From:Subject:Message-Id; b=o0lcVm23hZPcmgZPHWfGYZ31hMl9hUhu1fWrMTJAewHw8xE9z0Nw9tTfGCR9LJpQunEVJKP87a/C8DwXp3F9561twjopFHinRnztBzOkfdpNzyMn8dHM65Qpx9TQCUSim6/rilPq0I2ZrjuScgNWx7CyqOz7DNonWnjVl5is/44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rQqubFEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rQqubFEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9696CC4CEFB;
	Wed,  5 Nov 2025 22:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762382081;
	bh=XW9X0NrkDxwVVQYRRgTFfQ6cR5w8lFi/tiOoUg3xtag=;
	h=Date:To:From:Subject:From;
	b=rQqubFEFwtbjvq60osUDYKRNpHqjuY+e21nvuOFzlsK7Xk8a1T1so+aOc6Z/uS8cd
	 rMS3A5v4R781YDSxALQ77ovVOfA8k7IdBMAjQfZFIFo8LzjfVYJLqD1zAGO7/blFvN
	 sehWTtIo/S7MEG+Hd96JzhmZUhwvu+Crg/AC9bEQ=
Date: Wed, 05 Nov 2025 14:34:41 -0800
To: mm-commits@vger.kernel.org,thomas.weissschuh@linutronix.de,david@kernel.org,zhangchujun@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] selftest-vm_util-remove-unused-variables.patch removed from -mm tree
Message-Id: <20251105223441.9696CC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest/vm_util: remove unused variables
has been removed from the -mm tree.  Its filename was
     selftest-vm_util-remove-unused-variables.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Zhang Chujun <zhangchujun@cmss.chinamobile.com>
Subject: selftest/vm_util: remove unused variables
Date: Tue, 4 Nov 2025 14:28:55 +0800

The global variables __page_size and __page_shift are declared in
vm_util.c, but they are never used anywhere in the codebase.  This patch
removes them to clean up the source and eliminate dead code.

Link: https://lkml.kernel.org/r/20251104062855.2468-1-zhangchujun@cmss.chinamobile.com
Signed-off-by: Zhang Chujun <zhangchujun@cmss.chinamobile.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftest-vm_util-remove-unused-variables
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -17,9 +17,6 @@
 #define STATUS_FILE_PATH "/proc/self/status"
 #define MAX_LINE_LENGTH 500
 
-unsigned int __page_size;
-unsigned int __page_shift;
-
 uint64_t pagemap_get_entry(int fd, char *start)
 {
 	const unsigned long pfn = (unsigned long)start / getpagesize();
_

Patches currently in -mm which might be from zhangchujun@cmss.chinamobile.com are

mm-debug-fix-missing-space-in-case-statement.patch

