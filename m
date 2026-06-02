Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271143C81B2
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439225; cv=none; b=bgJ6trQ2DXV8ovL2I0BiOA/JDZhJaKISR3Bzewk7j5UpnxH7cIM7kcL90bPFYEQDh7rfNk+XsGp0SCvU8ScTK382yyJkalZCkc4lKmn0BS/czInqd74E794QNuQxp199hagnSaXwMPlU9F6ACQPEKDyegblpoumH+9Tz+ZK/v2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439225; c=relaxed/simple;
	bh=D9v9ZjtTAeuDf3SmuUSSQ+Whh4i5ZLUQgRrim4ddGEQ=;
	h=Date:To:From:Subject:Message-Id; b=XoRm6Ty2GdPN7EOO+HFOMoPrl0VAXtPkB3wX8bn5OoQyJYQopBhFwMqRM62OOayYqEk326lPnjjNVDLuc2Osfw+RONVD0I1jHLrRCBwtKH+m5YSCuUoJ1geXlyrh0jKuIDj8CmRijtdAiykE18RhPjX/vo1igb+EOG3QHRnvnYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nY3HvxdI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nY3HvxdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10321F00898;
	Tue,  2 Jun 2026 22:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439224;
	bh=4iu0EtMtE2pH0WRoyYkbt7qRPVgY73A6ONUO9dxDalU=;
	h=Date:To:From:Subject;
	b=nY3HvxdIpKqh58cjSLUTYlFeke6JdhTM15LX1MdIdsZp1ipd1yn8cX+KVVz462rvz
	 IXsMItZNE0amecRX760o5Hs5LkVID+ciSyPzxQXuiWWLeRFGTFQ//JSR1AL2rygBSb
	 5e4LDmBXI8x6bWVt99yuXIbX8GPNvZmn5BbhlbKY=
Date: Tue, 02 Jun 2026 15:27:03 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,skhan@linuxfoundation.org,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,bmasney@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-clarify-that-user_reserve_kbytes-has-no-effect-when-overcommit_memory-is-set-to-0-or-1.patch removed from -mm tree
Message-Id: <20260602222703.F10321F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: mm: clarify that user_reserve_kbytes has no effect when overcommit_memory is set to 0 or 1
has been removed from the -mm tree.  Its filename was
     docs-mm-clarify-that-user_reserve_kbytes-has-no-effect-when-overcommit_memory-is-set-to-0-or-1.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brian Masney <bmasney@redhat.com>
Subject: docs: mm: clarify that user_reserve_kbytes has no effect when overcommit_memory is set to 0 or 1
Date: Thu, 28 May 2026 09:45:10 -0400

Looking at __vm_enough_memory() in mm/util.c, user_reserve_kbytes has no
effect when overcommit_memory is set to 0 or 1. The documentation for
overcommit_memory already references user_reserve_kbytes when the flag
is set to 2.

Let's go ahead and add a clarification to user_reserve_kbytes in vm.rst
that it has no effect when overcommit_memory is set to 0 or 1.

Link: https://lore.kernel.org/20260528-mm-clarify-docs-v1-1-aa88e83b4bfd@redhat.com
Signed-off-by: Brian Masney <bmasney@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/vm.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/admin-guide/sysctl/vm.rst~docs-mm-clarify-that-user_reserve_kbytes-has-no-effect-when-overcommit_memory-is-set-to-0-or-1
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -1034,6 +1034,8 @@ min(3% of current process size, user_res
 This is intended to prevent a user from starting a single memory hogging
 process, such that they cannot recover (kill the hog).
 
+This setting has no effect when overcommit_memory is set to 0 or 1.
+
 user_reserve_kbytes defaults to min(3% of the current process size, 128MB).
 
 If this is reduced to zero, then the user will be allowed to allocate
_

Patches currently in -mm which might be from bmasney@redhat.com are


