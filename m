Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFA5165FC1
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 16:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714667346; cv=none; b=JtFIzrBlxsjiMhIdyNMcifcDy5EvcuLjW8xrA+u5urMlk7qV1RdugrBSsf6Khb25QxK66twvcN6RE/VnuXvPMWtfsgZjndItppreBT9hFcfwnn0Acri9gc90fX7xvhaFT5W6c+U+awZHP554gTk1/k7EgTTjvCJGWR+Jo+wydTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714667346; c=relaxed/simple;
	bh=YtNzQ0jniRy4LTtKpvbN7qqahg29ACbAO+iO9OZv114=;
	h=Date:To:From:Subject:Message-Id; b=uTlkV+CD8lywZNdrj0bPJhX3SCuPaISfgCKqVv9Gv6OBZ4wWPEvrui7l5+G5SV0kyKeZgHrLmbXqT7vQR2tY6PBQZpPAeVBuUliQQQkM+O6minnlAtEuWp+qITgR3RppYN2VUKW03gBRVqKApr2Jg2uqabGGbgq+qQGaB7Aypq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lw4gDWd6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lw4gDWd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952DEC32789;
	Thu,  2 May 2024 16:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714667345;
	bh=YtNzQ0jniRy4LTtKpvbN7qqahg29ACbAO+iO9OZv114=;
	h=Date:To:From:Subject:From;
	b=Lw4gDWd6OjXtM7gX2YJlH/dzgRH9bkigkzF45R5uyQ7HkBi8iMLtdYoiDXbZXy2Jo
	 YppUyjfawAJB47bcekqYqzvKh7x5mahpDWbPvtO24cnPDz08rpK9P85TCRWYPK96VB
	 fzWbu1Cf/ZHk7loPPZC0zz4Nl17haXvQq0UJ8lbE=
Date: Thu, 02 May 2024 09:29:04 -0700
To: mm-commits@vger.kernel.org,dave.jiang@intel.com,dan.j.williams@intel.com,alison.schofield@intel.com,vishal.l.verma@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-busc-replace-warn_on_once-with-lockdep-asserts.patch added to mm-unstable branch
Message-Id: <20240502162905.952DEC32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dax/bus.c: replace WARN_ON_ONCE() with lockdep asserts
has been added to the -mm mm-unstable branch.  Its filename is
     dax-busc-replace-warn_on_once-with-lockdep-asserts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dax-busc-replace-warn_on_once-with-lockdep-asserts.patch

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
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: dax/bus.c: replace WARN_ON_ONCE() with lockdep asserts
Date: Tue, 30 Apr 2024 11:44:23 -0600

Patch series "dax/bus.c: Fixups for dax-bus locking", v3.

Commit Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by
a local rwsem") introduced a few problems that this series aims to fix. 
Add back device_lock() where it was correctly used (during device
manipulation operations), remove conditional locking in
unregister_dax_dev() and unregister_dax_mapping(), use non-interruptible
versions of rwsem locks when not called from a user process, and fix up a
write vs.  read usage of an rwsem.


This patch (of 4):

In [1], Dan points out that all of the WARN_ON_ONCE() usage in the
referenced patch should be replaced with lockdep_assert_held, or
lockdep_held_assert_write().  Replace these as appropriate.

Link: https://lkml.kernel.org/r/20240430-vv-dax_abi_fixes-v3-0-e3dcd755774c@intel.com
Link: https://lore.kernel.org/r/65f0b5ef41817_aa222941a@dwillia2-mobl3.amr.corp.intel.com.notmuch [1]
Link: https://lkml.kernel.org/r/20240430-vv-dax_abi_fixes-v3-1-e3dcd755774c@intel.com
Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Reported-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/dax/bus.c~dax-busc-replace-warn_on_once-with-lockdep-asserts
+++ a/drivers/dax/bus.c
@@ -192,7 +192,7 @@ static u64 dev_dax_size(struct dev_dax *
 	u64 size = 0;
 	int i;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_dev_rwsem));
+	lockdep_assert_held(&dax_dev_rwsem);
 
 	for (i = 0; i < dev_dax->nr_range; i++)
 		size += range_len(&dev_dax->ranges[i].range);
@@ -302,7 +302,7 @@ static unsigned long long dax_region_ava
 	resource_size_t size = resource_size(&dax_region->res);
 	struct resource *res;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held(&dax_region_rwsem);
 
 	for_each_dax_region_resource(dax_region, res)
 		size -= resource_size(res);
@@ -447,7 +447,7 @@ static void trim_dev_dax_range(struct de
 	struct range *range = &dev_dax->ranges[i].range;
 	struct dax_region *dax_region = dev_dax->region;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 	dev_dbg(&dev_dax->dev, "delete range[%d]: %#llx:%#llx\n", i,
 		(unsigned long long)range->start,
 		(unsigned long long)range->end);
@@ -507,7 +507,7 @@ static int __free_dev_dax_id(struct dev_
 	struct dax_region *dax_region;
 	int rc = dev_dax->id;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_dev_rwsem));
+	lockdep_assert_held_write(&dax_dev_rwsem);
 
 	if (!dev_dax->dyn_id || dev_dax->id < 0)
 		return -1;
@@ -713,7 +713,7 @@ static void __unregister_dax_mapping(voi
 
 	dev_dbg(dev, "%s\n", __func__);
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 
 	dev_dax->ranges[mapping->range_id].mapping = NULL;
 	mapping->range_id = -1;
@@ -830,7 +830,7 @@ static int devm_register_dax_mapping(str
 	struct device *dev;
 	int rc;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 
 	if (dev_WARN_ONCE(&dev_dax->dev, !dax_region->dev->driver,
 				"region disabled\n"))
@@ -876,7 +876,7 @@ static int alloc_dev_dax_range(struct de
 	struct resource *alloc;
 	int i, rc;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 
 	/* handle the seed alloc special case */
 	if (!size) {
@@ -935,7 +935,7 @@ static int adjust_dev_dax_range(struct d
 	struct device *dev = &dev_dax->dev;
 	int rc;
 
-	WARN_ON_ONCE(!rwsem_is_locked(&dax_region_rwsem));
+	lockdep_assert_held_write(&dax_region_rwsem);
 
 	if (dev_WARN_ONCE(dev, !size, "deletion is handled by dev_dax_shrink\n"))
 		return -EINVAL;
_

Patches currently in -mm which might be from vishal.l.verma@intel.com are

dax-busc-replace-warn_on_once-with-lockdep-asserts.patch
dax-busc-fix-locking-for-unregister_dax_dev-unregister_dax_mapping-paths.patch
dax-busc-dont-use-down_write_killable-for-non-user-processes.patch
dax-busc-use-the-right-locking-mode-read-vs-write-in-size_show.patch

