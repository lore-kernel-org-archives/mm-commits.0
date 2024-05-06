Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08D63A1B6
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957164; cv=none; b=Fh59e7hs9OV6Oa7RlclF/wdayegAHAPs9wAeaLK5InrsaeYZ3J7fUzvG/ZvHlicoZnuj8KyfN2gfs+TFJJYSxr5edeK6CVYMmUH30K5c6BO/GQQH2Nedvw/N2iGJDKWH0Fx04cmJZCSCkl6/JwDL/gmxGU5gsx0mKEIAJ9sr2eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957164; c=relaxed/simple;
	bh=z12+6ZCyBpshAwfrktwpcFxovXEmOrS8oKEXoxipSLA=;
	h=Date:To:From:Subject:Message-Id; b=Dsr4kK91ynLmiRJT3VRuz1gXh/bLP2/50SyaJEofKkbuiJX9FnpXWr4gZCObxHpKx23p2m+o0vZVq8VGkxt/QP3F/p2hVYZi5+SksTAUvLMsuwt7hgcYQkaTx6Ipg+aVTyQoUlebIVrfCM+L7H/NH/Pa6gr3XWcL/QS9IzOumug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LUWcDtCA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LUWcDtCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9B8C116B1;
	Mon,  6 May 2024 00:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957163;
	bh=z12+6ZCyBpshAwfrktwpcFxovXEmOrS8oKEXoxipSLA=;
	h=Date:To:From:Subject:From;
	b=LUWcDtCAsiv45pg4+rHeGVZo6mYkloNKoDAidTJ4sy+QqdoxdZk+pG2DIo5Lc1Vb5
	 Dy+g0TiMWz7ceDB4Xw8E8iOLbl6/T69Zjr5a3pfe/DcCCYNaPz0aM01+hej+EvTDYw
	 fO+nYi1lAKnZxBxP2en+IjgG7rn6PfgeMO9tpi54=
Date: Sun, 05 May 2024 17:59:23 -0700
To: mm-commits@vger.kernel.org,dave.jiang@intel.com,dan.j.williams@intel.com,alison.schofield@intel.com,vishal.l.verma@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dax-busc-dont-use-down_write_killable-for-non-user-processes.patch removed from -mm tree
Message-Id: <20240506005923.BB9B8C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dax/bus.c: don't use down_write_killable for non-user processes
has been removed from the -mm tree.  Its filename was
     dax-busc-dont-use-down_write_killable-for-non-user-processes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: dax/bus.c: don't use down_write_killable for non-user processes
Date: Tue, 30 Apr 2024 11:44:25 -0600

Change an instance of down_write_killable() to a simple down_write() where
there is no user process that might want to interrupt the operation.

Link: https://lkml.kernel.org/r/20240430-vv-dax_abi_fixes-v3-3-e3dcd755774c@intel.com
Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Reported-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/dax/bus.c~dax-busc-dont-use-down_write_killable-for-non-user-processes
+++ a/drivers/dax/bus.c
@@ -1540,12 +1540,8 @@ err_id:
 struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
 {
 	struct dev_dax *dev_dax;
-	int rc;
-
-	rc = down_write_killable(&dax_region_rwsem);
-	if (rc)
-		return ERR_PTR(rc);
 
+	down_write(&dax_region_rwsem);
 	dev_dax = __devm_create_dev_dax(data);
 	up_write(&dax_region_rwsem);
 
_

Patches currently in -mm which might be from vishal.l.verma@intel.com are


