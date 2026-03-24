Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAD235C185
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 23:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774394301; cv=none; b=su5rBIjTQ/Hm5bnRGveuNZ3uHTfHZFEpeXgquG1D49oNyIHFlpluqyWtdzFM3GQU2xGmB5PQU8wiYVGw16TOdYcz5ROKnxExPptYFHCRpcBFbuZZFi0+iEGVMkXveOTp7dU+AUTKwdkfRBTp2c0VgKrkJ2cXicU6zdHCzS0Wv2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774394301; c=relaxed/simple;
	bh=xGILtIlB7oS8jUbp8gVUH7XTYpqfaxGstaHR434TS64=;
	h=Date:To:From:Subject:Message-Id; b=mLAyKo1CtjQ3myrdLN++mEhQ/qc9r9j2L3LZMqBeae9CgPMs2B9QPqKJGtTnVKuTixfq6lxLCf+desgP4W9lb5YJJ0WROiE5UbSIu1zm1647QZXk/tAj7MRAkBju8RY6/GuySQD4Cb//NPyKCQvgICGR+569iw4ytMEJuHxdPEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vEn4yor8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vEn4yor8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9297FC19424;
	Tue, 24 Mar 2026 23:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774394301;
	bh=xGILtIlB7oS8jUbp8gVUH7XTYpqfaxGstaHR434TS64=;
	h=Date:To:From:Subject:From;
	b=vEn4yor8JNf4dXyI5PWRPInfu4UXIkgoUmnRUtKxDZo5Lsif9OJJkBhGTZkxqZxwg
	 xd339Ns63WFRfEgn/1VC/OH/i7aPAnJYJmM83HDC99kvXYg+iQpiszySKj4PMXVzZv
	 XTIcYhALZzP7g0xr2bFz5OlgCEwUa0tc+aROmVWQ=
Date: Tue, 24 Mar 2026 16:18:20 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuvraj.sakshith@oss.qualcomm.com,xuanzhuo@linux.alibaba.com,wei.liu@kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mst@redhat.com,mhocko@suse.com,mhklinux@outlook.com,lorenzo.stoakes@oracle.com,longli@microsoft.com,liam.howlett@oracle.com,kys@microsoft.com,jasowang@redhat.com,jackmanb@google.com,hannes@cmpxchg.org,haiyangz@microsoft.com,eperezma@redhat.com,decui@microsoft.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_reporting-add-page_reporting_order_unspecified-fix.patch removed from -mm tree
Message-Id: <20260324231821.9297FC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_reporting-add-page_reporting_order_unspecified-fix
has been removed from the -mm tree.  Its filename was
     mm-page_reporting-add-page_reporting_order_unspecified-fix.patch

This patch was dropped because it was folded into mm-page_reporting-add-page_reporting_order_unspecified.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_reporting-add-page_reporting_order_unspecified-fix
Date: Tue Mar  3 02:33:57 PM PST 2026

tweak whitespace, per David

Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Long Li <longli@microsoft.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michael Kelley <mhklinux@outlook.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_reporting.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_reporting.c~mm-page_reporting-add-page_reporting_order_unspecified-fix
+++ a/mm/page_reporting.c
@@ -371,7 +371,7 @@ int page_reporting_register(struct page_
 
 	if (page_reporting_order == -1) {
 		if (prdev->order != PAGE_REPORTING_ORDER_UNSPECIFIED &&
-			prdev->order <= MAX_PAGE_ORDER)
+		    prdev->order <= MAX_PAGE_ORDER)
 			page_reporting_order = prdev->order;
 		else
 			page_reporting_order = pageblock_order;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_reporting-add-page_reporting_order_unspecified.patch
mm-rename-zone-lock-to-zone-_lock-fix.patch
mm-switch-the-rmap-lock-held-option-off-in-compat-layer-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch
decode_stacktrace-decode-caller-address-checkpatch-fixes.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

