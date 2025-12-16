Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D7A2C21FA
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 18:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765909453; cv=none; b=Mrztv6XQltD8PFOP6YsqdeDirJg6e9CiZ0XaRB9OlHWoLebm156L5GMpm5uGFml6d7vFhoyhKJ7gjqDLJrlV+XT0b4gn749NjhvOm39+ZRKtFKBBMU8IQPl3CrpwLjnvxBxKvkCzJC4yItwdX7VpkjijbG4l8+CIkOQy+mIsV8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765909453; c=relaxed/simple;
	bh=Z2OTk8uHDDONgDOra3H+m5h/Yuw64bTdaRANimxpQ7U=;
	h=Date:To:From:Subject:Message-Id; b=Iy5UdZY7gyAz2p5DuT7pIP6OxaWu7U5gL7QeEIYteQBE8Ia/KnWUnqMfTT/BcpZEQCGLnf6+uR52kLu0hYpAMZ58COXXCw3XkudX+1ylEPSV80lf9xfwmc0ZjUUkQ+zqbtKIu6DKI+m1LkUP4mAnDsGjUtoMh/7tgrft09p5Xwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=thNsreZu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="thNsreZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A24EC4CEF1;
	Tue, 16 Dec 2025 18:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765909453;
	bh=Z2OTk8uHDDONgDOra3H+m5h/Yuw64bTdaRANimxpQ7U=;
	h=Date:To:From:Subject:From;
	b=thNsreZu5KQTywRd/4qOQBv0NpZL1ol+/VB2VeK09MNWHTeEFwU9m4IPsLENS1V8V
	 q8/OIqpB/ICRjaKGWdge0a+0dyRA+VJxIc5Ob/CJoTbzwL22tt/a3Y7YBZ7SwWZ4zD
	 +kFRtIRS3G/CoJfXkgan+RZl0Np5mvjiisXEWMEA=
Date: Tue, 16 Dec 2025 10:24:12 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,pnina.feder@mobileye.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-vmcoreinfo-allocate-vmcoreinfo_data-based-on-vmcoreinfo_bytes.patch added to mm-nonmm-unstable branch
Message-Id: <20251216182413.0A24EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel: vmcoreinfo: allocate vmcoreinfo_data based on VMCOREINFO_BYTES
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-vmcoreinfo-allocate-vmcoreinfo_data-based-on-vmcoreinfo_bytes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-vmcoreinfo-allocate-vmcoreinfo_data-based-on-vmcoreinfo_bytes.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Pnina Feder <pnina.feder@mobileye.com>
Subject: kernel: vmcoreinfo: allocate vmcoreinfo_data based on VMCOREINFO_BYTES
Date: Tue, 16 Dec 2025 15:28:00 +0200

Patch series "vmcoreinfo: support VMCOREINFO_BYTES larger than PAGE_SIZE".

VMCOREINFO_BYTES is defined as a configurable size, but multiple
code paths implicitly assume it always fits into a single page.

This series removes that assumption by allocating and mapping
vmcoreinfo based on its actual size.

Patch 1 updates vmcoreinfo allocation to use get_order(VMCOREINFO_BYTES).
Patch 2 updates crash kernel handling to correctly allocate and map
multiple pages when copying vmcoreinfo.

This makes vmcoreinfo size consistent across the kernel and avoids
future breakage if VMCOREINFO_BYTES grows.

(No functional change when VMCOREINFO_BYTES == PAGE_SIZE.)


This patch (of 2):

VMCOREINFO_BYTES defines the size of vmcoreinfo data, but the current
implementation assumes a single page allocation.

Allocate vmcoreinfo_data using get_order(VMCOREINFO_BYTES) so that
vmcoreinfo can safely grow beyond PAGE_SIZE.

This avoids hidden assumptions and keeps vmcoreinfo size consistent across
the kernel.

Link: https://lkml.kernel.org/r/20251216132801.807260-1-pnina.feder@mobileye.com
Link: https://lkml.kernel.org/r/20251216132801.807260-2-pnina.feder@mobileye.com
Signed-off-by: Pnina Feder <pnina.feder@mobileye.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/vmcore_info.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/vmcore_info.c~kernel-vmcoreinfo-allocate-vmcoreinfo_data-based-on-vmcoreinfo_bytes
+++ a/kernel/vmcore_info.c
@@ -137,7 +137,9 @@ EXPORT_SYMBOL_GPL(hwerr_log_error_type);
 
 static int __init crash_save_vmcoreinfo_init(void)
 {
-	vmcoreinfo_data = (unsigned char *)get_zeroed_page(GFP_KERNEL);
+	int order;
+	order = get_order(VMCOREINFO_BYTES);
+	vmcoreinfo_data = (unsigned char *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
 	if (!vmcoreinfo_data) {
 		pr_warn("Memory allocation for vmcoreinfo_data failed\n");
 		return -ENOMEM;
@@ -146,7 +148,7 @@ static int __init crash_save_vmcoreinfo_
 	vmcoreinfo_note = alloc_pages_exact(VMCOREINFO_NOTE_SIZE,
 						GFP_KERNEL | __GFP_ZERO);
 	if (!vmcoreinfo_note) {
-		free_page((unsigned long)vmcoreinfo_data);
+		free_pages((unsigned long)vmcoreinfo_data, order);
 		vmcoreinfo_data = NULL;
 		pr_warn("Memory allocation for vmcoreinfo_note failed\n");
 		return -ENOMEM;
_

Patches currently in -mm which might be from pnina.feder@mobileye.com are

kernel-vmcoreinfo-allocate-vmcoreinfo_data-based-on-vmcoreinfo_bytes.patch
kernel-crash-handle-multi-page-vmcoreinfo-in-crash-kernel-copy.patch

