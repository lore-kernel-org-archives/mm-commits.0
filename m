Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CEC4210E8
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644520; cv=none; b=Fi6r/GVbUUEc6RtBeBQyYqWylGDKMA6vePnWlGSBlPNo/NgH9V0vtIFeyN8z7jxobxTruTs/4QxwXKa7wRWqwACDQ9trSG+BxHBOLU69T00dWHq/IY+tOZskXSU9+M/ZikgetcqWJGY0dWGs2wNLQF7GSYGbzIpSX/qODnJQtJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644520; c=relaxed/simple;
	bh=mSlh55oqdY6AnC1qgrD+JebaFplId+N8ersgt2/yJMw=;
	h=Date:To:From:Subject:Message-Id; b=mKY1aM1O2/XfCBKSXBNWUyHHXfLs1dVT/UxjhUfjhNkLOzfgxhZ6Zu4Brcc9jM2tM92P+xmSJps+5pN3QUVcZoPQfofDOeqpMyGll6Tjotyk2D6TQRs79+hnQdZ1G4dYIlzqxgbvDdR3OUZlvs6IYI+c64f50iI5FeLbDriec7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tFvulY/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tFvulY/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1FBC43390;
	Thu, 22 Feb 2024 23:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644520;
	bh=mSlh55oqdY6AnC1qgrD+JebaFplId+N8ersgt2/yJMw=;
	h=Date:To:From:Subject:From;
	b=tFvulY/c9lL4sN1zMdR3XH8JHPWQi0ldEaL1wcH18SyPiWtk+yP5eFmrGGy18sW04
	 UxoDwJFlbR7aI9/icU7EMWvJuQwXeOR6+MmtxiiXqnvy58PCE8YJa9TYIsDq9dghBI
	 GVQfr5aLOksbmW4b6I91RQ/jiCK5B19km5Dqo6GY=
Date: Thu, 22 Feb 2024 15:28:39 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-move-the-list-of-damos-actions-to-design-doc.patch removed from -mm tree
Message-Id: <20240222232840.6D1FBC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon: move the list of DAMOS actions to design doc
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-move-the-list-of-damos-actions-to-design-doc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon: move the list of DAMOS actions to design doc
Date: Fri, 16 Feb 2024 16:58:39 -0800

DAMOS operation actions are explained nearly twice on the DAMON usage
document, once for the sysfs interface, and then again for the debugfs
interface.  Duplication is bad.  Also it would better to keep this kind of
concept level details in design document and keep the usage document small
and focus on only the usage.  Move the list to design document and update
usage document to reference it.

Link: https://lkml.kernel.org/r/20240217005842.87348-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   47 ++++-------------
 Documentation/mm/damon/design.rst            |   26 ++++++++-
 2 files changed, 36 insertions(+), 37 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-mm-damon-move-the-list-of-damos-actions-to-design-doc
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -302,27 +302,8 @@ In each scheme directory, five directori
 
 The ``action`` file is for setting and getting the scheme's :ref:`action
 <damon_design_damos_action>`.  The keywords that can be written to and read
-from the file and their meaning are as below.
-
-Note that support of each action depends on the running DAMON operations set
-:ref:`implementation <sysfs_context>`.
-
- - ``willneed``: Call ``madvise()`` for the region with ``MADV_WILLNEED``.
-   Supported by ``vaddr`` and ``fvaddr`` operations set.
- - ``cold``: Call ``madvise()`` for the region with ``MADV_COLD``.
-   Supported by ``vaddr`` and ``fvaddr`` operations set.
- - ``pageout``: Call ``madvise()`` for the region with ``MADV_PAGEOUT``.
-   Supported by ``vaddr``, ``fvaddr`` and ``paddr`` operations set.
- - ``hugepage``: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``.
-   Supported by ``vaddr`` and ``fvaddr`` operations set.
- - ``nohugepage``: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``.
-   Supported by ``vaddr`` and ``fvaddr`` operations set.
- - ``lru_prio``: Prioritize the region on its LRU lists.
-   Supported by ``paddr`` operations set.
- - ``lru_deprio``: Deprioritize the region on its LRU lists.
-   Supported by ``paddr`` operations set.
- - ``stat``: Do nothing but count the statistics.
-   Supported by all operations sets.
+from the file and their meaning are same to those of the list on
+:ref:`design doc <damon_design_damos_action>`.
 
 The ``apply_interval_us`` file is for setting and getting the scheme's
 :ref:`apply_interval <damon_design_damos>` in microseconds.
@@ -763,19 +744,17 @@ Action
 ~~~~~~
 
 The ``<action>`` is a predefined integer for memory management :ref:`actions
-<damon_design_damos_action>`.  The supported numbers and their meanings are as
-below.
-
- - 0: Call ``madvise()`` for the region with ``MADV_WILLNEED``.  Ignored if
-   ``target`` is ``paddr``.
- - 1: Call ``madvise()`` for the region with ``MADV_COLD``.  Ignored if
-   ``target`` is ``paddr``.
- - 2: Call ``madvise()`` for the region with ``MADV_PAGEOUT``.
- - 3: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``.  Ignored if
-   ``target`` is ``paddr``.
- - 4: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``.  Ignored if
-   ``target`` is ``paddr``.
- - 5: Do nothing but count the statistics
+<damon_design_damos_action>`.  The mapping between the ``<action>`` values and
+the memory management actions is as below.  For the detailed meaning of the
+action and DAMON operations set supporting each action, please refer to the
+list on :ref:`design doc <damon_design_damos_action>`.
+
+ - 0: ``willneed``
+ - 1: ``cold``
+ - 2: ``pageout``
+ - 3: ``hugepage``
+ - 4: ``nohugepage``
+ - 5: ``stat``
 
 Quota
 ~~~~~
--- a/Documentation/mm/damon/design.rst~docs-mm-damon-move-the-list-of-damos-actions-to-design-doc
+++ a/Documentation/mm/damon/design.rst
@@ -294,9 +294,29 @@ not mandated to support all actions of t
 specific DAMOS action depends on what operations set is selected to be used
 together.
 
-Applying an action to a region is considered as changing the region's
-characteristics.  Hence, DAMOS resets the age of regions when an action is
-applied to those.
+The list of the supported actions, their meaning, and DAMON operations sets
+that supports each action are as below.
+
+ - ``willneed``: Call ``madvise()`` for the region with ``MADV_WILLNEED``.
+   Supported by ``vaddr`` and ``fvaddr`` operations set.
+ - ``cold``: Call ``madvise()`` for the region with ``MADV_COLD``.
+   Supported by ``vaddr`` and ``fvaddr`` operations set.
+ - ``pageout``: Call ``madvise()`` for the region with ``MADV_PAGEOUT``.
+   Supported by ``vaddr``, ``fvaddr`` and ``paddr`` operations set.
+ - ``hugepage``: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``.
+   Supported by ``vaddr`` and ``fvaddr`` operations set.
+ - ``nohugepage``: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``.
+   Supported by ``vaddr`` and ``fvaddr`` operations set.
+ - ``lru_prio``: Prioritize the region on its LRU lists.
+   Supported by ``paddr`` operations set.
+ - ``lru_deprio``: Deprioritize the region on its LRU lists.
+   Supported by ``paddr`` operations set.
+ - ``stat``: Do nothing but count the statistics.
+   Supported by all operations sets.
+
+Applying the actions except ``stat`` to a region is considered as changing the
+region's characteristics.  Hence, DAMOS resets the age of regions when any such
+actions are applied to those.
 
 
 .. _damon_design_damos_access_pattern:
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-set-damos_quota-esz-as-public-field-and-document.patch
mm-damon-sysfs-schemes-implement-quota-effective_bytes-file.patch
mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas.patch
docs-abi-damon-document-effective_bytes-sysfs-file.patch
docs-admin-guide-mm-damon-usage-document-effective_bytes-file.patch
mm-damon-move-comments-and-fields-for-damos-quota-prioritization-to-the-end.patch
mm-damon-core-split-out-quota-goal-related-fields-to-a-struct.patch
mm-damon-core-add-multiple-goals-per-damos_quota-and-helpers-for-those.patch
mm-damon-sysfs-use-only-quota-goals.patch
mm-damon-core-remove-goal-field-of-damos_quota.patch
mm-damon-core-let-goal-specified-with-only-target-and-current-values.patch
mm-damon-core-support-multiple-metrics-for-quota-goal.patch
mm-damon-core-implement-psi-metric-damos-quota-goal.patch
mm-damon-sysfs-schemes-support-psi-based-quota-auto-tune.patch
docs-mm-damon-design-document-quota-goal-self-tuning.patch
docs-abi-damon-document-quota-goal-metric-file.patch
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file.patch
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file-fix.patch
mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning.patch
mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning.patch
docs-admin-guide-mm-damon-reclaim-document-auto-tuning-parameters.patch

