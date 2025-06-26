Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365CEC8EB
	for <mm-commits@vger.kernel.org>; Thu, 26 Jun 2025 22:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750978770; cv=none; b=qqorWCtzWfJIFkrFUIrNw+ql97HYCWL+Pw2cPkZ+YxG0LvHrtRhpeFxBWzJCnyh3YmSysk6p6EWvYwSB5SNFXrdnMd85HPKmqipiD7bMDkGHClMkXBSP2yb8M0vPElWfUJ6SuKwln5+XoYk7+KPJHke24EuVtMFeKeyv+/U0HZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750978770; c=relaxed/simple;
	bh=OBhL0V4tNmmsz7bVybzeNCW8y5JIdYSF++eFhmLpTqw=;
	h=Date:To:From:Subject:Message-Id; b=iewz1oZOuFAXJEqXVnjBjazJIosxbp8qlfJb3WxIhjjaAG5djm00P1hEVIPtaF5S4bAe+el4/OK5XfXSvJzbfU9+hBEdPIeUgheLFHZs+AveD4wzCwt1INtvvx8Nx8K5eo+hQnSsVCtvNl3a/MFedUFZQ7kpEPObaDFXgRK4f6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kOJrDM3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kOJrDM3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B5DC4CEEB;
	Thu, 26 Jun 2025 22:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750978769;
	bh=OBhL0V4tNmmsz7bVybzeNCW8y5JIdYSF++eFhmLpTqw=;
	h=Date:To:From:Subject:From;
	b=kOJrDM3Tn82f6TOmBdXd1Xkrk3lcOQNb+KQhWwkf58U1CqjwEW05sHhYJEXb4V/8m
	 ljYhUmGW1v0JV5IN+HSI30yfI++DOmcpBXGtcut0rAeRT1ryOzP2/nRX0eXbFCv4P0
	 2QxzYiCK138vJ75l6qzUU5vFyaZ+Z5QHtxekjIck=
Date: Thu, 26 Jun 2025 15:59:29 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,dan.carpenter@linaro.org,bhe@redhat.com,suhui@nfschina.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-vmcore-a-few-cleanups-for-vmcore_add_device_dump.patch added to mm-nonmm-unstable branch
Message-Id: <20250626225929.A2B5DC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/vmcore: a few cleanups for vmcore_add_device_dump()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-proc-vmcore-a-few-cleanups-for-vmcore_add_device_dump.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-vmcore-a-few-cleanups-for-vmcore_add_device_dump.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Su Hui <suhui@nfschina.com>
Subject: fs/proc/vmcore: a few cleanups for vmcore_add_device_dump()
Date: Thu, 26 Jun 2025 18:54:41 +0800

There are two cleanups for vmcore_add_device_dump().  Return -ENOMEM
directly rather than goto the label to simplify the code and use
scoped_guard() to simplify the lock/unlock code.

Link: https://lkml.kernel.org/r/20250626105440.1053139-1-suhui@nfschina.com
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Suhui <suhui@nfschina.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

--- a/fs/proc/vmcore.c~fs-proc-vmcore-a-few-cleanups-for-vmcore_add_device_dump
+++ a/fs/proc/vmcore.c
@@ -1490,10 +1490,8 @@ int vmcore_add_device_dump(struct vmcore
 		return -EINVAL;
 
 	dump = vzalloc(sizeof(*dump));
-	if (!dump) {
-		ret = -ENOMEM;
-		goto out_err;
-	}
+	if (!dump)
+		return -ENOMEM;
 
 	/* Keep size of the buffer page aligned so that it can be mmaped */
 	data_size = roundup(sizeof(struct vmcoredd_header) + data->size,
@@ -1519,22 +1517,19 @@ int vmcore_add_device_dump(struct vmcore
 	dump->size = data_size;
 
 	/* Add the dump to driver sysfs list and update the elfcore hdr */
-	mutex_lock(&vmcore_mutex);
-	if (vmcore_opened)
-		pr_warn_once("Unexpected adding of device dump\n");
-	if (vmcore_open) {
-		ret = -EBUSY;
-		goto unlock;
-	}
+	scoped_guard(mutex, &vmcore_mutex) {
+		if (vmcore_opened)
+			pr_warn_once("Unexpected adding of device dump\n");
+		if (vmcore_open) {
+			ret = -EBUSY;
+			goto out_err;
+		}
 
-	list_add_tail(&dump->list, &vmcoredd_list);
-	vmcoredd_update_size(data_size);
-	mutex_unlock(&vmcore_mutex);
+		list_add_tail(&dump->list, &vmcoredd_list);
+		vmcoredd_update_size(data_size);
+	}
 	return 0;
 
-unlock:
-	mutex_unlock(&vmcore_mutex);
-
 out_err:
 	vfree(buf);
 	vfree(dump);
_

Patches currently in -mm which might be from suhui@nfschina.com are

ocfs2-replace-simple_strtol-with-kstrtol.patch
fs-proc-vmcore-a-few-cleanups-for-vmcore_add_device_dump.patch

