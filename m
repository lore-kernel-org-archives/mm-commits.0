Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4A21B218A
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 06:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739860843; cv=none; b=u89LvRPJqfcFVUi8O+Xb+3Q5RY+k4Vcz3FDgZ7qDi6V7pa65VUsNYChXSJjPDK8YoUunAWnboOSe1jFRfwyRZUTyFntWUwRPpjHsr2Vu18vyw0paAfVtieeRFM15uj100vmnDiFEExjZTJ4OHjeot0S00nFJNv9lgfxX+7JQzbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739860843; c=relaxed/simple;
	bh=Jz0pKFUHdQaxF4phaHJd32vHv2pSaFC7mpb7Iys//Wo=;
	h=Date:To:From:Subject:Message-Id; b=eZUXQmyA46EH4WG5NwqZU6B8qrYKr3/rhzLH5bzCfk7DO6zAFEtC6L/jQihy4rUH6vjEB7ZcXqV/Ad5/DaV2MFbDpgj4B2tzlEJuqPG9G6+uXh475HedU5DaeuyzSDM61kQ6CgAsR2p85gEIXl0VphAsG1wI75hAnR47sc0Gq6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uuYomBe6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uuYomBe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA3CC4CEE2;
	Tue, 18 Feb 2025 06:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739860843;
	bh=Jz0pKFUHdQaxF4phaHJd32vHv2pSaFC7mpb7Iys//Wo=;
	h=Date:To:From:Subject:From;
	b=uuYomBe6e9zd+nV7+91isTZuVeFqqkSqpfMnhTMzBq5ChNjkE43VGNnxVpuddzOEH
	 wb5ZIFcJNto9UKcZXB2fIMzpdghFInHXtVuLxDMy6kmjPmQ+Co2+WXGoQTo0t/vH5G
	 omGhuf1Gm4jU4vhYkbwe/J1DZxbcvvpd+RiK+T9E=
Date: Mon, 17 Feb 2025 22:40:42 -0800
To: mm-commits@vger.kernel.org,mst@redhat.com,david@redhat.com,bhe@redhat.com,bvanassche@acm.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] procfs-fix-a-locking-bug-in-a-vmcore_add_device_dump-error-path.patch removed from -mm tree
Message-Id: <20250218064043.2AA3CC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: procfs: fix a locking bug in a vmcore_add_device_dump() error path
has been removed from the -mm tree.  Its filename was
     procfs-fix-a-locking-bug-in-a-vmcore_add_device_dump-error-path.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-vmstat-revert-fix-a-w=1-clang-compiler-warning.patch

