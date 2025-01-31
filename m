Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CAA4C9F
	for <mm-commits@vger.kernel.org>; Fri, 31 Jan 2025 01:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738286471; cv=none; b=ECs60uzycZnlk0o/IAg0INXNleCwWVtOiKjhgrPqnLb3AQMxwAUAfYmuHeCyAxkcXia4YAVNwaB8q6cXxX/MxPJPsXUziBkE2QkjJFiJqUbf4n5muG0dSDRTHLbe54bemVlavG35uVlEYeZCWISpFGobszChRQmcsz1SfgYC8g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738286471; c=relaxed/simple;
	bh=a5Zsg0D7k0IzllKX4ioYa32/RjK08INv8y/Toj5cXfc=;
	h=Date:To:From:Subject:Message-Id; b=B4HW4Y1hP5b5v0/3+tYj2CoJSoetEqVapXVLYKDPwcyIidXMg4yoMHvxuGQv8VSIp6qhNCJ0dUEBLnLeWBQ5/kOe2B/xyBGK2R+B4T674EKd6qezSRa9WRCPhHucmQb8TI6F5sQi+F4QOEfjYz45K+P60sfuZEZQ4lf3ZqH+qQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fqyWIgOx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fqyWIgOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1F6C4CEE0;
	Fri, 31 Jan 2025 01:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738286471;
	bh=a5Zsg0D7k0IzllKX4ioYa32/RjK08INv8y/Toj5cXfc=;
	h=Date:To:From:Subject:From;
	b=fqyWIgOxhSWs1AYYdthA4oC+RB+0MHmTqMGiRvbCcCSBCD1w6DFqJ3PhFVK0hFTmR
	 8jmnqRfmWg6jUb8DB8+06L+395+Yjb+aFgTUeSez+xk+MMey5KzuvWyZ6uZvkJHtO8
	 Jd/kVF/I8T066PJJ0CaOeczpSD4NdrRyMtgstJ0w=
Date: Thu, 30 Jan 2025 17:21:10 -0800
To: mm-commits@vger.kernel.org,mst@redhat.com,david@redhat.com,bhe@redhat.com,bvanassche@acm.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + procfs-fix-a-locking-bug-in-a-vmcore_add_device_dump-error-path.patch added to mm-hotfixes-unstable branch
Message-Id: <20250131012111.1D1F6C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: procfs: fix a locking bug in a vmcore_add_device_dump() error path
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     procfs-fix-a-locking-bug-in-a-vmcore_add_device_dump-error-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/procfs-fix-a-locking-bug-in-a-vmcore_add_device_dump-error-path.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Bart Van Assche <bvanassche@acm.org>
Subject: procfs: fix a locking bug in a vmcore_add_device_dump() error path
Date: Wed, 29 Jan 2025 14:20:03 -0800

Unlock vmcore_mutex when returning -EBUSY.

Link: https://lkml.kernel.org/r/20250129222003.1495713-1-bvanassche@acm.org
Fixes: 0f3b1c40c652 ("fs/proc/vmcore: disallow vmcore modifications while the vmcore is open")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baoquan he <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/proc/vmcore.c~procfs-fix-a-locking-bug-in-a-vmcore_add_device_dump-error-path
+++ a/fs/proc/vmcore.c
@@ -1524,7 +1524,7 @@ int vmcore_add_device_dump(struct vmcore
 		pr_warn_once("Unexpected adding of device dump\n");
 	if (vmcore_open) {
 		ret = -EBUSY;
-		goto out_err;
+		goto unlock;
 	}
 
 	list_add_tail(&dump->list, &vmcoredd_list);
@@ -1532,6 +1532,9 @@ int vmcore_add_device_dump(struct vmcore
 	mutex_unlock(&vmcore_mutex);
 	return 0;
 
+unlock:
+	mutex_unlock(&vmcore_mutex);
+
 out_err:
 	vfree(buf);
 	vfree(dump);
_

Patches currently in -mm which might be from bvanassche@acm.org are

procfs-fix-a-locking-bug-in-a-vmcore_add_device_dump-error-path.patch

