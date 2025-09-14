Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22DD156C6A
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810162; cv=none; b=rK4vOFxgtbcZyYs0+zbR/O1jhnkjrRvvnCPDZp1oomPwBofpekAdKA54ZpOEa2K3Mp5iy22QNXm+M1+R7W6wXBM6Wrv/pNH872GXl226iUcgQCbUzNucI/jZ8A+b/EQbugvWooOdU7R2M76cR4Hn7iYCyiTnel21WxCaWsEC0v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810162; c=relaxed/simple;
	bh=aqCeh8M9dXlVzOuZiVMx0AbVIQpTa9K+lkq2+LrA5kU=;
	h=Date:To:From:Subject:Message-Id; b=gwUvCqSkCSst08CpecI9gVcI65DPtUdZY/R93nLvNbesTAmxdCFHaMaz9Zf7N5woexZy9pyNHeveRaBXStGlrP6my055b4TDj3aui9u/+Cv9LxGOUw7IJNeuDEx3zvOAbjZYF/H9DCZw/ydqup8+eg8xpN3WwWzz/ikRV0chkNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tOyjyhtP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tOyjyhtP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFA0C4CEEB;
	Sun, 14 Sep 2025 00:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810162;
	bh=aqCeh8M9dXlVzOuZiVMx0AbVIQpTa9K+lkq2+LrA5kU=;
	h=Date:To:From:Subject:From;
	b=tOyjyhtPnOqHKXIRWBsOSLaELHv7tPaL5IwhL93bWXcj1MBrSUs8aZ/YdJtt+n0u+
	 3GAa5kvWW8g38EisPhrMCA9VHpsJfGiupRL+NOipZqA1h95QpbADbeNc7kOWGu9hJ+
	 vSaMD3IOgqJbsxL4AxZdHyiWJaZFCuTmlSRCLQnA=
Date: Sat, 13 Sep 2025 17:36:01 -0700
To: mm-commits@vger.kernel.org,rafael@kernel.org,pavel@ucw.cz,mchehab@kernel.org,mchehab+huawei@kernel.org,len.brown@intel.com,jani.nikula@linux.intel.com,james.bottomley@HansenPartnership.com,gregkh@linuxfoundation.org,corbet@lwn.net,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernelh-add-comments-for-enum-system_states.patch removed from -mm tree
Message-Id: <20250914003602.6FFA0C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel.h: add comments for enum system_states
has been removed from the -mm tree.  Its filename was
     kernelh-add-comments-for-enum-system_states.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: kernel.h: add comments for enum system_states
Date: Sat, 6 Sep 2025 21:38:57 -0700

Provide some basic comments about the system_states and what they imply. 
Also convert the comments to kernel-doc format.

Split the enum declaration from the definition of the system_state
variable so that kernel-doc notation works cleanly with it.  This is
picked up by Documentation/driver-api/basics.rst so it does not need
further inclusion in the kernel docbooks.

Link: https://lkml.kernel.org/r/20250907043857.2941203-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Rafael J. Wysocki <rafael@kernel.org> # v1
Reviewed-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>	[v5]
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/include/linux/kernel.h~kernelh-add-comments-for-enum-system_states
+++ a/include/linux/kernel.h
@@ -164,11 +164,23 @@ extern int root_mountflags;
 
 extern bool early_boot_irqs_disabled;
 
-/*
- * Values used for system_state. Ordering of the states must not be changed
+/**
+ * enum system_states - Values used for system_state.
+ *
+ * @SYSTEM_BOOTING:	%0, no init needed
+ * @SYSTEM_SCHEDULING: system is ready for scheduling; OK to use RCU
+ * @SYSTEM_FREEING_INITMEM: system is freeing all of initmem; almost running
+ * @SYSTEM_RUNNING:	system is up and running
+ * @SYSTEM_HALT:	system entered clean system halt state
+ * @SYSTEM_POWER_OFF:	system entered shutdown/clean power off state
+ * @SYSTEM_RESTART:	system entered emergency power off or normal restart
+ * @SYSTEM_SUSPEND:	system entered suspend or hibernate state
+ *
+ * Note:
+ * Ordering of the states must not be changed
  * as code checks for <, <=, >, >= STATE.
  */
-extern enum system_states {
+enum system_states {
 	SYSTEM_BOOTING,
 	SYSTEM_SCHEDULING,
 	SYSTEM_FREEING_INITMEM,
@@ -177,7 +189,8 @@ extern enum system_states {
 	SYSTEM_POWER_OFF,
 	SYSTEM_RESTART,
 	SYSTEM_SUSPEND,
-} system_state;
+};
+extern enum system_states system_state;
 
 /*
  * General tracing related utility functions - trace_printk(),
_

Patches currently in -mm which might be from rdunlap@infradead.org are


