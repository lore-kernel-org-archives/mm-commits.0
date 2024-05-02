Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958BC15DBA2
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 16:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714667351; cv=none; b=umfb0GuyjoadkqF0FJ/XlEJd2OlCjPh52QQRc00x5Y1MazdbDsR7Q7leTkdf/I9Dut5ABFK6joCvZFMXm+XpJ3Gj93QNF8Vz1hv/KJj8CzlYmg0C3U1Ej43ORqkaZeCxL/NG887k4qQd95NHiMNOx3hcKqZ+B10Q44ucNAm/TRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714667351; c=relaxed/simple;
	bh=x8ZB4GQFuXua4qgUeaMPJffJFT+3kwt+rWdxIMOxwVk=;
	h=Date:To:From:Subject:Message-Id; b=c8hoawEo4Fi0E3peMdWBKy2UGHuYzedQQeDsPRi6FkndLcYJnd6B5DUtZaU6DCQ4N2i+PwF4kM6JT5Rd+skLV4PJ8L319cZhyXmmRc2Gcvj7DPzUmViHaNmS2Vjko4K4+S1ObCWmbnAqx3fovE36l/8yTunwOPeCKCWkF/0kOnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lhZWCREn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lhZWCREn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D534BC113CC;
	Thu,  2 May 2024 16:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714667351;
	bh=x8ZB4GQFuXua4qgUeaMPJffJFT+3kwt+rWdxIMOxwVk=;
	h=Date:To:From:Subject:From;
	b=lhZWCREns/gp3+lSO5NxnAduFZRdmqPhhKXt63iIENbie3swrzUbMPUB0LbMnZpbZ
	 fpOKvdfwJpD1IBNPq8QAiQYXpnohUemwlQLKqCzMbAn3cZi351JyBxvQKkCew+YByE
	 2C5sHRsFaz0rGwmRoGyYfZBkS/PMCH/yfjW3Mtl0=
Date: Thu, 02 May 2024 09:29:09 -0700
To: mm-commits@vger.kernel.org,dave.jiang@intel.com,dan.j.williams@intel.com,alison.schofield@intel.com,vishal.l.verma@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-busc-dont-use-down_write_killable-for-non-user-processes.patch added to mm-unstable branch
Message-Id: <20240502162910.D534BC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dax/bus.c: don't use down_write_killable for non-user processes
has been added to the -mm mm-unstable branch.  Its filename is
     dax-busc-dont-use-down_write_killable-for-non-user-processes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dax-busc-dont-use-down_write_killable-for-non-user-processes.patch

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

dax-busc-replace-warn_on_once-with-lockdep-asserts.patch
dax-busc-fix-locking-for-unregister_dax_dev-unregister_dax_mapping-paths.patch
dax-busc-dont-use-down_write_killable-for-non-user-processes.patch
dax-busc-use-the-right-locking-mode-read-vs-write-in-size_show.patch

