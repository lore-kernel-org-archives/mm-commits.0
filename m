Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91B115E7F0
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 16:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714667348; cv=none; b=trwvElQfjnELGsRSd3tu3Oo3stYV66MQ5gvDYL55LoZp5Kny2U4vG6carABb/YHlUh7r+sGIYNgSj4qnCkTuoeHPVrXhxKk0qA+abkVoO8Ok/k4FkOEx+TPxm/ZqTqFyYoUhXT4EUbu1NNh2GbbZYoizR2Iljz2KRsij/hFUBYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714667348; c=relaxed/simple;
	bh=RZ9WYOunJ9vZ2o0HpSI2qs+GU2Bza7ZxVeyhZVucFnY=;
	h=Date:To:From:Subject:Message-Id; b=agueUtRxuz90fWrFWfuX+Rpmr3z7lDbRrAkb2ccOFl7qWiNN8L6MFWJilR0tziPt6b/C3W70BZh3OkN1eAAv1SjRAfncfdVVLRDFQR/gyKgMqvDUh0TbDeSDAIiIaJzq/j0WjY7Hg8xsZvlxtygyMF5Mxmka2xMEnPwVo9W8AxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ppyEeqdk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ppyEeqdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF38C113CC;
	Thu,  2 May 2024 16:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714667348;
	bh=RZ9WYOunJ9vZ2o0HpSI2qs+GU2Bza7ZxVeyhZVucFnY=;
	h=Date:To:From:Subject:From;
	b=ppyEeqdkIYQR2mnuZRuR09lx8ROqgwE+9EvhyQEqPvAz2PtJZDLknGJ6z/+GgeWNu
	 EpoZ9Emx1gXSBs/HkC6a7J5v/3QkBD8RtxiV2xf+vD0iz/nJwcFS5VzYE1TuQoZoX/
	 NoUKT2ehJtQXG5j1+cAAOwO2hmqZehYpCQiCkFwg=
Date: Thu, 02 May 2024 09:29:06 -0700
To: mm-commits@vger.kernel.org,dave.jiang@intel.com,dan.j.williams@intel.com,alison.schofield@intel.com,vishal.l.verma@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-busc-fix-locking-for-unregister_dax_dev-unregister_dax_mapping-paths.patch added to mm-unstable branch
Message-Id: <20240502162908.1AF38C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dax/bus.c: fix locking for unregister_dax_dev / unregister_dax_mapping paths
has been added to the -mm mm-unstable branch.  Its filename is
     dax-busc-fix-locking-for-unregister_dax_dev-unregister_dax_mapping-paths.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dax-busc-fix-locking-for-unregister_dax_dev-unregister_dax_mapping-paths.patch

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
Subject: dax/bus.c: fix locking for unregister_dax_dev / unregister_dax_mapping paths
Date: Tue, 30 Apr 2024 11:44:24 -0600

Commit c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local
rwsem") aimed to undo device_lock() abuses for protecting changes to
dax-driver internal data-structures like the dax_region resource tree to
device-dax-instance range structures.  However, the device_lock() was
legitimately enforcing that devices to be deleted were not current
actively attached to any driver nor assigned any capacity from the region.

As a result of the device_lock restoration in delete_store(), the
conditional locking in unregister_dev_dax() and unregister_dax_mapping()
can be removed.

Link: https://lkml.kernel.org/r/20240430-vv-dax_abi_fixes-v3-2-e3dcd755774c@intel.com
Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Reported-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c |   42 ++++++++----------------------------------
 1 file changed, 8 insertions(+), 34 deletions(-)

--- a/drivers/dax/bus.c~dax-busc-fix-locking-for-unregister_dax_dev-unregister_dax_mapping-paths
+++ a/drivers/dax/bus.c
@@ -465,26 +465,17 @@ static void free_dev_dax_ranges(struct d
 		trim_dev_dax_range(dev_dax);
 }
 
-static void __unregister_dev_dax(void *dev)
+static void unregister_dev_dax(void *dev)
 {
 	struct dev_dax *dev_dax = to_dev_dax(dev);
 
 	dev_dbg(dev, "%s\n", __func__);
 
+	down_write(&dax_region_rwsem);
 	kill_dev_dax(dev_dax);
 	device_del(dev);
 	free_dev_dax_ranges(dev_dax);
 	put_device(dev);
-}
-
-static void unregister_dev_dax(void *dev)
-{
-	if (rwsem_is_locked(&dax_region_rwsem))
-		return __unregister_dev_dax(dev);
-
-	if (WARN_ON_ONCE(down_write_killable(&dax_region_rwsem) != 0))
-		return;
-	__unregister_dev_dax(dev);
 	up_write(&dax_region_rwsem);
 }
 
@@ -560,15 +551,10 @@ static ssize_t delete_store(struct devic
 	if (!victim)
 		return -ENXIO;
 
-	rc = down_write_killable(&dax_region_rwsem);
-	if (rc)
-		return rc;
-	rc = down_write_killable(&dax_dev_rwsem);
-	if (rc) {
-		up_write(&dax_region_rwsem);
-		return rc;
-	}
+	device_lock(dev);
+	device_lock(victim);
 	dev_dax = to_dev_dax(victim);
+	down_write(&dax_dev_rwsem);
 	if (victim->driver || dev_dax_size(dev_dax))
 		rc = -EBUSY;
 	else {
@@ -589,11 +575,12 @@ static ssize_t delete_store(struct devic
 			rc = -EBUSY;
 	}
 	up_write(&dax_dev_rwsem);
+	device_unlock(victim);
 
 	/* won the race to invalidate the device, clean it up */
 	if (do_del)
 		devm_release_action(dev, unregister_dev_dax, victim);
-	up_write(&dax_region_rwsem);
+	device_unlock(dev);
 	put_device(victim);
 
 	return rc;
@@ -705,7 +692,7 @@ static void dax_mapping_release(struct d
 	put_device(parent);
 }
 
-static void __unregister_dax_mapping(void *data)
+static void unregister_dax_mapping(void *data)
 {
 	struct device *dev = data;
 	struct dax_mapping *mapping = to_dax_mapping(dev);
@@ -713,25 +700,12 @@ static void __unregister_dax_mapping(voi
 
 	dev_dbg(dev, "%s\n", __func__);
 
-	lockdep_assert_held_write(&dax_region_rwsem);
-
 	dev_dax->ranges[mapping->range_id].mapping = NULL;
 	mapping->range_id = -1;
 
 	device_unregister(dev);
 }
 
-static void unregister_dax_mapping(void *data)
-{
-	if (rwsem_is_locked(&dax_region_rwsem))
-		return __unregister_dax_mapping(data);
-
-	if (WARN_ON_ONCE(down_write_killable(&dax_region_rwsem) != 0))
-		return;
-	__unregister_dax_mapping(data);
-	up_write(&dax_region_rwsem);
-}
-
 static struct dev_dax_range *get_dax_range(struct device *dev)
 {
 	struct dax_mapping *mapping = to_dax_mapping(dev);
_

Patches currently in -mm which might be from vishal.l.verma@intel.com are

dax-busc-replace-warn_on_once-with-lockdep-asserts.patch
dax-busc-fix-locking-for-unregister_dax_dev-unregister_dax_mapping-paths.patch
dax-busc-dont-use-down_write_killable-for-non-user-processes.patch
dax-busc-use-the-right-locking-mode-read-vs-write-in-size_show.patch

