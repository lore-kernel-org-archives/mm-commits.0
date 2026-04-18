Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE8E33C53F
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498732; cv=none; b=u5fZj99WrR1ma2erG4WB80fQ7N0v1XodA3nv88NHt+WX5XSp2ruLO+DQAgR1jS2ExGB7M0/gXMaSxmGhG3i+YKtORh+Vxi3SzQmpMtaICGvQL/19/KR4G8WfYBtL85+ojOtWkY33gRf07a+7uh9eTaqz9hzniz6R9IdvYoVUuI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498732; c=relaxed/simple;
	bh=Bjgk+Y91USSxP+b2X0VTBgNb1n9tNaErXilDB2H8tvU=;
	h=Date:To:From:Subject:Message-Id; b=nnMIa5W60bv/PhaGxlwIduK2Lef2KA10oD9n5umKrLjc5Y8Otn0e++Eu4MOMpNa2K0jeySr6BI6YjIQffQ7ZHl7hMkPE2MluaTTPcoh9Qel2ChBkRoM49fEZdom0HZJIlPCOV6YrXuHgmNbSESKtbennj35a08sBeIMHEMw91fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xc0Eq5lU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xc0Eq5lU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC88C19424;
	Sat, 18 Apr 2026 07:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498732;
	bh=Bjgk+Y91USSxP+b2X0VTBgNb1n9tNaErXilDB2H8tvU=;
	h=Date:To:From:Subject:From;
	b=Xc0Eq5lUVM//dw/dwPzE+09sFwqnjOW8riwpC1+FzWB0v3T4i7vuJtG06PhlKjHwx
	 5VnP+UG5FhCOazdx0humU4s5fHarq2jenBGmVxuZ4df8KXjQE/AP3p+9SK/naT0IEs
	 eqS2FvvuwN4asSpRF/Qyt4xBqhuakBDZXLpBOzQo=
Date: Sat, 18 Apr 2026 00:52:07 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,graf@amazon.com,david@kernel.org,corbet@lwn.net,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kho-document-kexec-metadata-tracking-feature.patch removed from -mm tree
Message-Id: <20260418075211.1EC88C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: document kexec-metadata tracking feature
has been removed from the -mm tree.  Its filename was
     kho-document-kexec-metadata-tracking-feature.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: kho: document kexec-metadata tracking feature
Date: Mon, 16 Mar 2026 04:54:36 -0700

Add documentation for the kexec-metadata feature that tracks the previous
kernel version and kexec boot count across kexec reboots.  This helps
diagnose bugs that only reproduce when kexecing from specific kernel
versions.

Link: https://lore.kernel.org/20260316-kho-v9-6-ed6dcd951988@debian.org
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

mm-blk-cgroup-fix-use-after-free-in-cgwb_release_workfn.patch
kho-fix-error-handling-in-kho_add_subtree.patch
mm-vmstat-spread-vmstat_update-requeue-across-the-stat-interval.patch

