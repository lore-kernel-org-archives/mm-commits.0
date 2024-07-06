Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA1C13CA8C
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292052; cv=none; b=L4PqjE40oOSas11kJkBWluCB10KDfA8Hrz0AVB5qgjljGUfNQ02R2mrI/hRaIIABBGVrE9oWlxSn4X6NqGWY/fTaCUCHWS8QTj/t86KDgewa48I3KdLqnL4GUvm1oDRRUzogloVW+pFb+To4j0jINTNR59PghiVSoDuA+6KbxPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292052; c=relaxed/simple;
	bh=krTWKxnWyAaSIzmmJT+mM0Avvm6Re3IgFij7uLst11U=;
	h=Date:To:From:Subject:Message-Id; b=r0Zpa0vSuJuj7qB5GY3fhReoqnfmFmm4kRD4Ix+m36KB7Z/r1UCBYGjsEgmTqe2H8U32KcKhbhMlgP1NQlVDXiL8ZhbIZgqer85seljhawRCk6kx1nX14U2+c7P/KOk4aIinxY2U/+kPbeQFUL7lvo+2gvIZuOJmq2mszzAlRRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jCUnN3+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jCUnN3+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E32C4AF0A;
	Sat,  6 Jul 2024 18:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292051;
	bh=krTWKxnWyAaSIzmmJT+mM0Avvm6Re3IgFij7uLst11U=;
	h=Date:To:From:Subject:From;
	b=jCUnN3+xa+X/qplkij4ZWHDyCLkW8NtKcvLv2bjFT2q1yNih5a4zzAwkOA8zrBznx
	 wAoSIkJ7wr3DBbAq/o82yAnk54IPngpTIa1aWiLpQMMYWn1hYcwzcS2PygsTJsICih
	 LTaH8JJObHZqxprh2t79TEPxe7MWqT2EQgkTOM2U=
Date: Sat, 06 Jul 2024 11:54:11 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-add-links-to-sections-of-damon-sysfs-interface-usage-doc.patch removed from -mm tree
Message-Id: <20240706185411.D6E32C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: add links to sections of DAMON sysfs interface usage doc
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-add-links-to-sections-of-damon-sysfs-interface-usage-doc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: add links to sections of DAMON sysfs interface usage doc
Date: Mon, 1 Jul 2024 12:27:04 -0700

Readers of the design document would wonder how they can configure and use
specific DAMON features.  Add links to sections of DAMON sysfs interface
usage document that provides the answers for easier browsing.

Link: https://lkml.kernel.org/r/20240701192706.51415-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   48 ++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-add-links-to-sections-of-damon-sysfs-interface-usage-doc
+++ a/Documentation/mm/damon/design.rst
@@ -16,6 +16,9 @@ called DAMON ``context``.  DAMON execute
 called ``kdamond``.  Multiple kdamonds could run in parallel, for different
 types of monitoring.
 
+To know how user-space can do the configurations and start/stop DAMON, refer to
+:ref:`DAMON sysfs interface <sysfs_interface>` documentation.
+
 
 Overall Architecture
 ====================
@@ -71,6 +74,10 @@ describe how those work.
  - fvaddr: Monitor fixed virtual address ranges
  - paddr: Monitor the physical address space of the system
 
+To know how user-space can do the configuration via :ref:`DAMON sysfs interface
+<sysfs_interface>`, refer to :ref:`operations <sysfs_context>` file part of the
+documentation.
+
 
  .. _damon_design_vaddr_target_regions_construction:
 
@@ -143,6 +150,10 @@ monitoring attributes, ``sampling interv
 ``update interval``, ``minimum number of regions``, and ``maximum number of
 regions``.
 
+To know how user-space can set the attributes via :ref:`DAMON sysfs interface
+<sysfs_interface>`, refer to :ref:`monitoring_attrs <sysfs_monitoring_attrs>`
+part of the documentation.
+
 
 Access Frequency Monitoring
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~
@@ -246,6 +257,11 @@ and applies it to monitoring operations-
 abstracted monitoring target memory area only for each of a user-specified time
 interval (``update interval``).
 
+User-space can get the monitoring results via DAMON sysfs interface and/or
+tracepoints.  For more details, please refer to the documentations for
+:ref:`DAMOS tried regions <sysfs_schemes_tried_regions>` and :ref:`tracepoint`,
+respectively.
+
 
 .. _damon_design_damos:
 
@@ -286,6 +302,10 @@ the access pattern of interest, and appl
 to the regions, for every user-specified time interval called
 ``apply_interval``.
 
+To know how user-space can set ``apply_interval`` via :ref:`DAMON sysfs
+interface <sysfs_interface>`, refer to :ref:`apply_interval_us <sysfs_scheme>`
+part of the documentation.
+
 
 .. _damon_design_damos_action:
 
@@ -334,6 +354,10 @@ Applying the actions except ``stat`` to
 region's characteristics.  Hence, DAMOS resets the age of regions when any such
 actions are applied to those.
 
+To know how user-space can set the action via :ref:`DAMON sysfs interface
+<sysfs_interface>`, refer to :ref:`action <sysfs_scheme>` part of the
+documentation.
+
 
 .. _damon_design_damos_access_pattern:
 
@@ -347,6 +371,10 @@ interest by setting minimum and maximum
 region's three properties are in the ranges, DAMOS classifies it as one of the
 regions that the scheme is having an interest in.
 
+To know how user-space can set the access pattern via :ref:`DAMON sysfs
+interface <sysfs_interface>`, refer to :ref:`access_pattern
+<sysfs_access_pattern>` part of the documentation.
+
 
 .. _damon_design_damos_quotas:
 
@@ -366,6 +394,10 @@ feature called quotas.  It lets users sp
 can use for applying the action, and/or a maximum bytes of memory regions that
 the action can be applied within a user-specified time duration.
 
+To know how user-space can set the basic quotas via :ref:`DAMON sysfs interface
+<sysfs_interface>`, refer to :ref:`quotas <sysfs_quotas>` part of the
+documentation.
+
 
 .. _damon_design_damos_quotas_prioritization:
 
@@ -393,6 +425,10 @@ information to the underlying mechanism.
 the weight will be respected are up to the underlying prioritization mechanism
 implementation.
 
+To know how user-space can set the prioritization weights via :ref:`DAMON sysfs
+interface <sysfs_interface>`, refer to :ref:`weights <sysfs_quotas>` part of
+the documentation.
+
 
 .. _damon_design_damos_quotas_auto_tuning:
 
@@ -422,6 +458,10 @@ Currently, two ``target_metric`` are pro
   DAMOS does the measurement on its own, so only ``target_value`` need to be
   set by users at the initial time.  In other words, DAMOS does self-feedback.
 
+To know how user-space can set the tuning goal metric, the target value, and/or
+the current value via :ref:`DAMON sysfs interface <sysfs_interface>`, refer to
+:ref:`quota goals <sysfs_schemes_quota_goals>` part of the documentation.
+
 
 .. _damon_design_damos_watermarks:
 
@@ -444,6 +484,10 @@ is activated.  If all schemes are deacti
 is also deactivated.  In this case, the DAMON worker thread only periodically
 checks the watermarks and therefore incurs nearly zero overhead.
 
+To know how user-space can set the watermarks via :ref:`DAMON sysfs interface
+<sysfs_interface>`, refer to :ref:`watermarks <sysfs_watermarks>` part of the
+documentation.
+
 
 .. _damon_design_damos_filters:
 
@@ -490,6 +534,10 @@ Below types of filters are currently sup
     - Applied to pages that belonging to a given DAMON monitoring target.
     - Handled by the core logic.
 
+To know how user-space can set the watermarks via :ref:`DAMON sysfs interface
+<sysfs_interface>`, refer to :ref:`filters <sysfs_filters>` part of the
+documentation.
+
 
 Application Programming Interface
 ---------------------------------
_

Patches currently in -mm which might be from sj@kernel.org are


