Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A333783C8
	for <mm-commits@vger.kernel.org>; Mon, 23 Mar 2026 22:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774303202; cv=none; b=hqMrclzZ/NiV8vRRE9E43n6MCuJvuMYCaVnyVMk+B6dfVqantzW3z/4HS9+guhAmka+vflMFE8tivzh25QEkoUAlUMCSc4CEZKpoXqv4YV0RP6eSuqTBiPggebIuv3nq15fuJaz8Vw4KWsKV/PM8s7WVTC/kGBa/oIAuDQ58ryM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774303202; c=relaxed/simple;
	bh=n6EBJY1LOSTGKkF/EeGoMzinOvjJ51/Rr3weer2gCRs=;
	h=Date:To:From:Subject:Message-Id; b=Cx2EWmg5vW3xAMY/drHRO4NjNZQkn84cCDuUlhM7AwUzs44o2qk+XZVa5zqUHayvnFl8XF/BGVy2QHWPZX8LrZAGOnc+gYTPV2fFj3hfTD4MxiXeBVGBG65s31FpgWkQ/zIoil5jYiKQn1q28GGeD9m/pH33EMA9cA+FmOxbjEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vrlzmDLA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vrlzmDLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE43C4CEF7;
	Mon, 23 Mar 2026 22:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774303202;
	bh=n6EBJY1LOSTGKkF/EeGoMzinOvjJ51/Rr3weer2gCRs=;
	h=Date:To:From:Subject:From;
	b=vrlzmDLAyb0VL+uloor2cqJY/xp4LlyvdNTlgYO8vr4MQ9BMtuBySyzifsM6JSN5r
	 WeA6HCe8+p0bR3pleuJWojm2nKUPYYeakiVeZs1B0M8V/qgZExnGkE3W4gf2v8QkJw
	 QFDdEll8RnCUA8XmIeoyVEUs0c3iVYLZeY2Wncgc=
Date: Mon, 23 Mar 2026 15:00:01 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,graf@amazon.com,david@kernel.org,corbet@lwn.net,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-document-kexec-metadata-tracking-feature.patch added to mm-nonmm-unstable branch
Message-Id: <20260323220001.EAE43C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: document kexec-metadata tracking feature
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-document-kexec-metadata-tracking-feature.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-document-kexec-metadata-tracking-feature.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: kho: document kexec-metadata tracking feature
Date: Mon, 16 Mar 2026 04:54:36 -0700

Add documentation for the kexec-metadata feature that tracks the previous
kernel version and kexec boot count across kexec reboots.  This helps
diagnose bugs that only reproduce when kexecing from specific kernel
versions.

Link: https://lkml.kernel.org/r/20260316-kho-v9-6-ed6dcd951988@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/kho.rst |   39 +++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/Documentation/admin-guide/mm/kho.rst~kho-document-kexec-metadata-tracking-feature
+++ a/Documentation/admin-guide/mm/kho.rst
@@ -42,6 +42,45 @@ For example, if you used ``reserve_mem``
 an early memory reservation, the new kernel will have that memory at the
 same physical address as the old kernel.
 
+Kexec Metadata
+==============
+
+KHO automatically tracks metadata about the kexec chain, passing information
+about the previous kernel to the next kernel. This feature helps diagnose
+bugs that only reproduce when kexecing from specific kernel versions.
+
+On each KHO kexec, the kernel logs the previous kernel's version and the
+number of kexec reboots since the last cold boot::
+
+    [    0.000000] KHO: exec from: 6.19.0-rc4-next-20260107 (count 1)
+
+The metadata includes:
+
+``previous_release``
+    The kernel version string (from ``uname -r``) of the kernel that
+    initiated the kexec.
+
+``kexec_count``
+    The number of kexec boots since the last cold boot. On cold boot,
+    this counter starts at 0 and increments with each kexec. This helps
+    identify issues that only manifest after multiple consecutive kexec
+    reboots.
+
+Use Cases
+---------
+
+This metadata is particularly useful for debugging kexec transition bugs,
+where a buggy kernel kexecs into a new kernel and the bug manifests only
+in the second kernel. Examples of such bugs include:
+
+- Memory corruption from the previous kernel affecting the new kernel
+- Incorrect hardware state left by the previous kernel
+- Firmware/ACPI state issues that only appear in kexec scenarios
+
+At scale, correlating crashes to the previous kernel version enables
+faster root cause analysis when issues only occur in specific kernel
+transition scenarios.
+
 debugfs Interfaces
 ==================
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-khugepaged-export-set_recommended_min_free_kbytes.patch
mm-huge_memory-refactor-anon_enabled_store-with-set_anon_enabled_mode.patch
mm-huge_memory-refactor-enabled_store-with-set_global_enabled_mode.patch
mm-ratelimit-min_free_kbytes-adjustment-messages.patch
mm-kmemleak-add-config_debug_kmemleak_verbose-build-option.patch
kho-add-size-parameter-to-kho_add_subtree.patch
kho-rename-fdt-parameter-to-blob-in-kho_add-remove_subtree.patch
kho-persist-blob-size-in-kho-fdt.patch
kho-fix-kho_in_debugfs_init-to-handle-non-fdt-blobs.patch
kho-kexec-metadata-track-previous-kernel-chain.patch
kho-document-kexec-metadata-tracking-feature.patch

