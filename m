Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40FD143C56
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291706; cv=none; b=nmAvo6wILWHwz36iZKCySxEnG8fcNuuugr0aE8EWOroSFar+gP+MzepMjnx+kvh0bFMatNVq9ddmUGuufz4n+1upiC/yGhVFzO9xCWAumx0bX1QIB2kJssO1Zmy7thA5sV7R0r7Xh1KUhXf8amNRgxnvRBbugqWsdZxZq6yWB1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291706; c=relaxed/simple;
	bh=4YYNfGcMCLCLL9GS5trM33L3Khp1GDOPnqfmz6U1b+I=;
	h=Date:To:From:Subject:Message-Id; b=TRqZqFMs2MtS6TMI30kZcNs4stHRxMBrGNU0yUH+YY3L+IbrgdVtie7E2GP2tD3zB4qlWoNbh9RRY+vkqfMy5E3Y6SLHaLe2u5a/Cd5ZAPS1k+E4gX4a4la5EFVOWvK1Z8PfYYgX9doa460LeTylPTc8JlX39fNaVWt08acDYGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0T6x47Qz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0T6x47Qz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284C0C32782;
	Tue, 25 Jun 2024 05:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291706;
	bh=4YYNfGcMCLCLL9GS5trM33L3Khp1GDOPnqfmz6U1b+I=;
	h=Date:To:From:Subject:From;
	b=0T6x47QzEUJeFeh50wAAi+mp3kPy+jnhynLs4wU1g+4Oo1GMntR/t7/L1sAW9R0G7
	 QEpJPIYjY5DrKS7M45Ivuu93crQcbGl5F+VWjH+kTtwNuCwVHaXoKGHfe3mC4CLnqm
	 sZqEjFRRvxRj7pPUpJWhdGimTsFjjvGeZOxdkMfg=
Date: Mon, 24 Jun 2024 22:01:45 -0700
To: mm-commits@vger.kernel.org,tony.luck@intel.com,nao.horiguchi@gmail.com,lkp@intel.com,david@redhat.com,bp@alien8.de,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-remove-mf_msg_slab.patch removed from -mm tree
Message-Id: <20240625050146.284C0C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: remove MF_MSG_SLAB
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-remove-mf_msg_slab.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure: remove MF_MSG_SLAB
Date: Wed, 12 Jun 2024 15:18:24 +0800

Since commit 46df8e73a4a3 ("mm: free up PG_slab"), MF_MSG_SLAB becomes
unused.  Remove it.  No functional change intended.

Link: https://lkml.kernel.org/r/20240612071835.157004-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    1 -
 include/ras/ras_event.h |    1 -
 mm/memory-failure.c     |    1 -
 3 files changed, 3 deletions(-)

--- a/include/linux/mm.h~mm-memory-failure-remove-mf_msg_slab
+++ a/include/linux/mm.h
@@ -4062,7 +4062,6 @@ enum mf_result {
 enum mf_action_page_type {
 	MF_MSG_KERNEL,
 	MF_MSG_KERNEL_HIGH_ORDER,
-	MF_MSG_SLAB,
 	MF_MSG_DIFFERENT_COMPOUND,
 	MF_MSG_HUGE,
 	MF_MSG_FREE_HUGE,
--- a/include/ras/ras_event.h~mm-memory-failure-remove-mf_msg_slab
+++ a/include/ras/ras_event.h
@@ -356,7 +356,6 @@ TRACE_EVENT(aer_event,
 #define MF_PAGE_TYPE		\
 	EM ( MF_MSG_KERNEL, "reserved kernel page" )			\
 	EM ( MF_MSG_KERNEL_HIGH_ORDER, "high-order kernel page" )	\
-	EM ( MF_MSG_SLAB, "kernel slab page" )				\
 	EM ( MF_MSG_DIFFERENT_COMPOUND, "different compound page after locking" ) \
 	EM ( MF_MSG_HUGE, "huge page" )					\
 	EM ( MF_MSG_FREE_HUGE, "free huge page" )			\
--- a/mm/memory-failure.c~mm-memory-failure-remove-mf_msg_slab
+++ a/mm/memory-failure.c
@@ -911,7 +911,6 @@ static const char *action_name[] = {
 static const char * const action_page_types[] = {
 	[MF_MSG_KERNEL]			= "reserved kernel page",
 	[MF_MSG_KERNEL_HIGH_ORDER]	= "high-order kernel page",
-	[MF_MSG_SLAB]			= "kernel slab page",
 	[MF_MSG_DIFFERENT_COMPOUND]	= "different compound page after locking",
 	[MF_MSG_HUGE]			= "huge page",
 	[MF_MSG_FREE_HUGE]		= "free huge page",
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


