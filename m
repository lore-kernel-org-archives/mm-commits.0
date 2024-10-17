Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C3217965E
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 07:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729149585; cv=none; b=gHps29hJC7U2309IsftDThRUnUSj2J72wJUmwbhtCB6fbmeNlC1am80LU6Y/htSeyopdCDM22Bn5ujX7jNVHlblIV+CdCkC4WJ4c3D4G18NuukqrxvpDbi5sHmjn/a3BRyCGXGa8eYOUwOfR8gmpnScSDTbOfuIZIpQ4BI66SzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729149585; c=relaxed/simple;
	bh=tho3a9pInj68x4rk+JNy2scUY382NuU6Fnk94+MHgJk=;
	h=Date:To:From:Subject:Message-Id; b=RxmvXFTFroTl3X8tIzgHNWvGaLSFy3ZoEPCEMuPQy+WJt9+g9Fo8tD3/JN41mR5BZ0A8Q+9shC9cxTs9957/8bhEfjWEtP+0nClURpl1rfstBEhXv4QtiXL8WmJiHrAGcGyFHFlRuaAcHX7uM5UKv3jFhL8g8oXDD/DY+ZHb82M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hvjReOba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hvjReOba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67C2C4CEC5;
	Thu, 17 Oct 2024 07:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729149583;
	bh=tho3a9pInj68x4rk+JNy2scUY382NuU6Fnk94+MHgJk=;
	h=Date:To:From:Subject:From;
	b=hvjReObayKHi59CqwiXzGjp/zP05Ri2ASAAtIc3cZYVSoiVk73Y76pxe/sr9TOgxn
	 r3c4fzn1nt9+LdzuXyq5WynSrhX4FxS7R97Z9lckNeLfq50W9CXWF2Nl3GKEGF0SnR
	 IcWNprGzCHWfL1WVxpIPHoTPuIN5P6g8mRa5BIcU=
Date: Thu, 17 Oct 2024 00:19:42 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,surenb@google.com,kent.overstreet@linux.dev,greearb@candelatech.com,fw@strlen.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls-fix.patch removed from -mm tree
Message-Id: <20241017071943.A67C2C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls-fix
has been removed from the -mm tree.  Its filename was
     lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls-fix.patch

This patch was dropped because it was folded into lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls-fix
Date: Mon Oct  7 06:06:19 PM PDT 2024

add comment

Cc: Ben Greear <greearb@candelatech.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/codetag.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/codetag.c~lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls-fix
+++ a/lib/codetag.c
@@ -228,6 +228,7 @@ bool codetag_unload_module(struct module
 	if (!mod)
 		return true;
 
+	/* await any module's kfree_rcu() operations to complete */
 	kvfree_rcu_barrier();
 
 	mutex_lock(&codetag_lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-alloc_tag_module_unload-must-wait-for-pending-kfree_rcu-calls.patch
mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
bootmem-stop-using-page-index-fix.patch
mm-kasan-kmsan-copy_from-to_kernel_nofault-fix.patch

