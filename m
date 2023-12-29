Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A923212E46
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YzpMuKc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B00C433C7;
	Fri, 29 Dec 2023 19:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879993;
	bh=8KlZCulwxVD4WBCembHbvGhtX5xUIHjvFdgbSrZD55o=;
	h=Date:To:From:Subject:From;
	b=YzpMuKc2BNP99jSwy1B+yPYvGrvX1p16OvrUGP+c0L5llR9TB4uBFldlZKP7Js4g1
	 JKVrBMT1I/tZYtUYmBm+NE5LUasjQn2gUhMoZn598sHMyYbrLR14+U0x1gutaaI2yq
	 qxGSbnjI30Dv03d1BUV7HD4SvoKOKr+ZZQd65DsE=
Date: Fri, 29 Dec 2023 11:59:52 -0800
To: mm-commits@vger.kernel.org,riel@surriel.com,hannes@cmpxchg.org,david@redhat.com,shr@devkernel.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-document-ksm-advisor-and-its-sysfs-knobs.patch removed from -mm tree
Message-Id: <20231229195953.74B00C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: document ksm advisor and its sysfs knobs
has been removed from the -mm tree.  Its filename was
     mm-ksm-document-ksm-advisor-and-its-sysfs-knobs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm/ksm: document ksm advisor and its sysfs knobs
Date: Mon, 18 Dec 2023 15:10:54 -0800

This documents the KSM advisor and its new knobs in /sys/fs/kernel/mm.

Link: https://lkml.kernel.org/r/20231218231054.1625219-5-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/ksm.rst |   55 +++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

--- a/Documentation/admin-guide/mm/ksm.rst~mm-ksm-document-ksm-advisor-and-its-sysfs-knobs
+++ a/Documentation/admin-guide/mm/ksm.rst
@@ -80,6 +80,9 @@ pages_to_scan
         how many pages to scan before ksmd goes to sleep
         e.g. ``echo 100 > /sys/kernel/mm/ksm/pages_to_scan``.
 
+        The pages_to_scan value cannot be changed if ``advisor_mode`` has
+        been set to scan-time.
+
         Default: 100 (chosen for demonstration purposes)
 
 sleep_millisecs
@@ -164,6 +167,29 @@ smart_scan
         optimization is enabled.  The ``pages_skipped`` metric shows how
         effective the setting is.
 
+advisor_mode
+        The ``advisor_mode`` selects the current advisor. Two modes are
+        supported: none and scan-time. The default is none. By setting
+        ``advisor_mode`` to scan-time, the scan time advisor is enabled.
+        The section about ``advisor`` explains in detail how the scan time
+        advisor works.
+
+adivsor_max_cpu
+        specifies the upper limit of the cpu percent usage of the ksmd
+        background thread. The default is 70.
+
+advisor_target_scan_time
+        specifies the target scan time in seconds to scan all the candidate
+        pages. The default value is 200 seconds.
+
+advisor_min_pages_to_scan
+        specifies the lower limit of the ``pages_to_scan`` parameter of the
+        scan time advisor. The default is 500.
+
+adivsor_max_pages_to_scan
+        specifies the upper limit of the ``pages_to_scan`` parameter of the
+        scan time advisor. The default is 30000.
+
 The effectiveness of KSM and MADV_MERGEABLE is shown in ``/sys/kernel/mm/ksm/``:
 
 general_profit
@@ -263,6 +289,35 @@ ksm_swpin_copy
 	note that KSM page might be copied when swapping in because do_swap_page()
 	cannot do all the locking needed to reconstitute a cross-anon_vma KSM page.
 
+Advisor
+=======
+
+The number of candidate pages for KSM is dynamic. It can be often observed
+that during the startup of an application more candidate pages need to be
+processed. Without an advisor the ``pages_to_scan`` parameter needs to be
+sized for the maximum number of candidate pages. The scan time advisor can
+changes the ``pages_to_scan`` parameter based on demand.
+
+The advisor can be enabled, so KSM can automatically adapt to changes in the
+number of candidate pages to scan. Two advisors are implemented: none and
+scan-time. With none, no advisor is enabled. The default is none.
+
+The scan time advisor changes the ``pages_to_scan`` parameter based on the
+observed scan times. The possible values for the ``pages_to_scan`` parameter is
+limited by the ``advisor_max_cpu`` parameter. In addition there is also the
+``advisor_target_scan_time`` parameter. This parameter sets the target time to
+scan all the KSM candidate pages. The parameter ``advisor_target_scan_time``
+decides how aggressive the scan time advisor scans candidate pages. Lower
+values make the scan time advisor to scan more aggresively. This is the most
+important parameter for the configuration of the scan time advisor.
+
+The initial value and the maximum value can be changed with
+``advisor_min_pages_to_scan`` and ``advisor_max_pages_to_scan``. The default
+values are sufficient for most workloads and use cases.
+
+The ``pages_to_scan`` parameter is re-calculated after a scan has been completed.
+
+
 --
 Izik Eidus,
 Hugh Dickins, 17 Nov 2009
_

Patches currently in -mm which might be from shr@devkernel.io are


