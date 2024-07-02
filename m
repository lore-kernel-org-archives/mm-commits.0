Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C153C38
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 02:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719886010; cv=none; b=mRYtzaUA98kWx9oPb6d2Bl7aJ/pXCbGIDc0sRVVtVcu32QnnmYP2fNj51mcdzJDwtg+MBq2qtlUc+gOv+a8Ni9BivA7JTuTjLVdOfh59cEZDamBoo/SEQO1KC1aW/UF5wtXv7GsqlDENUMwvss1gadQkstH1zbXVgvYlrr/sPKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719886010; c=relaxed/simple;
	bh=S1qFswsa7VMSo5lZ9aWoieGxf+4zw34TPeNCMHj9M9s=;
	h=Date:To:From:Subject:Message-Id; b=TmkqKZ/tohJM3iwDs7hoiT+xLP4kbbyIwOx1yE0ICzBbsJuz/ClMd0YALiPKKO3qHMnutZ1tSFUfiRP1TxUJl4+MoxctiZ3jxng6krrG4OucGebv/ofltjpOCciiTmAOU4jhXrMQx7zkI4J5SFWDTlKWqSiASyWnuttPX8+uPDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mi8O9WZ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mi8O9WZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDE1C116B1;
	Tue,  2 Jul 2024 02:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719886009;
	bh=S1qFswsa7VMSo5lZ9aWoieGxf+4zw34TPeNCMHj9M9s=;
	h=Date:To:From:Subject:From;
	b=mi8O9WZ1nUhA+NFfHMy57uHI5cKfTuJMLBlCTy7xlHO+ogm89X3D3nWOUYH3EeZMf
	 8cA4nGyC+8rjaY2m938rv4VE/s28pCTdcyOeqSS8Rgbpw+q/xRzg79+MB8rggjva16
	 unNuFxuoBTKkNFTIBUG5MbTeSpmuzfWyiHOOZjJM=
Date: Mon, 01 Jul 2024 19:06:49 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-add-links-to-sections-of-damon-sysfs-interface-usage-doc.patch added to mm-unstable branch
Message-Id: <20240702020649.ACDE1C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: add links to sections of DAMON sysfs interface usage doc
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-add-links-to-sections-of-damon-sysfs-interface-usage-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-add-links-to-sections-of-damon-sysfs-interface-usage-doc.patch

This patch will later appear in the mm-unstable branch at
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

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2.patch
docs-mm-damon-design-fix-two-typos.patch
docs-mm-damon-design-clarify-regions-merging-operation.patch
docs-admin-guide-mm-damon-start-add-access-pattern-snapshot-example.patch
docs-mm-damon-design-add-links-from-overall-architecture-to-sections-of-details.patch
docs-mm-damon-design-move-configurable-operations-set-section-into-operations-set-layer-section.patch
docs-mm-damon-design-remove-programmable-modules-section-in-favor-of-modules-section.patch
docs-mm-damon-design-add-links-to-sections-of-damon-sysfs-interface-usage-doc.patch
docs-mm-damon-index-add-links-to-design.patch
docs-mm-damon-index-add-links-to-admin-guide-doc.patch

