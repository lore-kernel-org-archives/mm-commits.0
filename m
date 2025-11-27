Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E868331ED92
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282388; cv=none; b=krLz+chSxBdYtBXNChXKR6Tha9Q6X7vEvw/K/FLUBhsKJIMOQLGfTSHy3U2P5pSMjzfheX4e1GtqWJXAyn5j98ftnuKPSyAYFFNhIQ2FieCsH3IdMCuTi5nff9NSdzvCyQqz0uRyuKJmA/h0cBsrBi69E+WGjm8dKogzlqiFGRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282388; c=relaxed/simple;
	bh=u4zSFu+6dafa9HfoYuGi7xugydf8yNXBNGuHHTQZteo=;
	h=Date:To:From:Subject:Message-Id; b=WqzKiKrRnFig9VZvmx9hmfM43KZ5LnR8qRNPbYYPeS6J1rBFlTvdXwBceEc6ckBN7kKav20D1qudGnCUWDU+quqDN0Wo+ajYUh5+ffEWlxbx1+Ug6Ytcrn1L9WdGZ2cWNVLluUlAtdTzSCDAJX2XiZYGNeVoBmbGDzMyuvWt2Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QFjmFybX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QFjmFybX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D151C4CEF8;
	Thu, 27 Nov 2025 22:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282387;
	bh=u4zSFu+6dafa9HfoYuGi7xugydf8yNXBNGuHHTQZteo=;
	h=Date:To:From:Subject:From;
	b=QFjmFybXDzAy2NuycwfMxlLhIDOefF6AxCQ9F/1ybTDYftj/IrOv8g7dU4tbfHS9+
	 jpksIEInoWDjLVY+5GzSLfRnzV/3hv29cgatp7hbPBAqBzVliE9zrDhl7dWqgc5gxO
	 gKKhwwCC1amTshyMI3HXG6zMcN4Jf+mGsb8ohy1c=
Date: Thu, 27 Nov 2025 14:26:26 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-add-kconfig-option-to-enable-kho-by-default.patch removed from -mm tree
Message-Id: <20251127222627.6D151C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: add Kconfig option to enable KHO by default
has been removed from the -mm tree.  Its filename was
     kho-add-kconfig-option-to-enable-kho-by-default.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: add Kconfig option to enable KHO by default
Date: Fri, 14 Nov 2025 14:00:02 -0500

Currently, Kexec Handover must be explicitly enabled via the kernel
command line parameter `kho=on`.

For workloads that rely on KHO as a foundational requirement (such as the
upcoming Live Update Orchestrator), requiring an explicit boot parameter
adds redundant configuration steps.

Introduce CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT.  When selected, KHO
defaults to enabled.  This is equivalent to passing kho=on at boot.  The
behavior can still be disabled at runtime by passing kho=off.

Link: https://lkml.kernel.org/r/20251114190002.3311679-14-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/Kconfig          |   14 ++++++++++++++
 kernel/liveupdate/kexec_handover.c |    2 +-
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/kernel/liveupdate/Kconfig~kho-add-kconfig-option-to-enable-kho-by-default
+++ a/kernel/liveupdate/Kconfig
@@ -37,4 +37,18 @@ config KEXEC_HANDOVER_DEBUGFS
 	  Also, enables inspecting the KHO fdt trees with the debugfs binary
 	  blobs.
 
+config KEXEC_HANDOVER_ENABLE_DEFAULT
+	bool "Enable kexec handover by default"
+	depends on KEXEC_HANDOVER
+	help
+	  Enable Kexec Handover by default. This avoids the need to
+	  explicitly pass 'kho=on' on the kernel command line.
+
+	  This is useful for systems where KHO is a prerequisite for other
+	  features, such as Live Update, ensuring the mechanism is always
+	  active.
+
+	  The default behavior can still be overridden at boot time by
+	  passing 'kho=off'.
+
 endmenu
--- a/kernel/liveupdate/kexec_handover.c~kho-add-kconfig-option-to-enable-kho-by-default
+++ a/kernel/liveupdate/kexec_handover.c
@@ -52,7 +52,7 @@ union kho_page_info {
 
 static_assert(sizeof(union kho_page_info) == sizeof(((struct page *)0)->private));
 
-static bool kho_enable __ro_after_init;
+static bool kho_enable __ro_after_init = IS_ENABLED(CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT);
 
 bool kho_is_enabled(void)
 {
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

